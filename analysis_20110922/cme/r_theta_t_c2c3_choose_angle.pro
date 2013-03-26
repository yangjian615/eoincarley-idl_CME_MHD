pro r_theta_t_c2c3_choose_angle, angle

;written 27-Jan-2013
;FOR i=100, 260, 10.0 DO BEGIN
cd,'/Users/eoincarley/Data/22sep2011_event/LASCO_C2/L0.5/L1'
restore,'c2_20110922_r_theta_t.sav'
c2_data = r_theta_t

cd,'/Users/eoincarley/Data/22sep2011_event/LASCO_C3/L0.5/L1'
restore,'c3_20110922_r_theta_t.sav'
c3_data = r_theta_t


t1 = anytim(file2time('20110922_103000'),/utim)
t2 = anytim(file2time('20110922_143000'),/utim)


index = where(c2_data[2,*,0] eq angle)

times_c3 = c3_data[0,0,*]

not_zero = where(times_c3 gt 0.0)
c3_times = transpose(c3_data[0, index, 0:7])
c3_heights = transpose(c3_data[1, index, 0:7])

c2_times = transpose(c2_data[0, 11, *])
c2_heights = transpose(c2_data[1, 11, *])

;   concatenate

cme_h = [c2_heights, c3_heights]
cme_t = [c2_times, c3_times]

utplot, cme_t, cme_h, psym=1, charsize=1.5, ytitle='CME Height (R/Rsun)'

results = linfit( cme_t, cme_h)
t_sim = (dindgen(1000)*(cme_t[n_elements(cme_t)-1] - cme_t[0])/999.0)+cme_t[0]
h_sim = results[0]+results[1]*t_sim
loadct,39
oplot, t_sim, h_sim, color=(angle -100.0)*3.0


cor1_t1 = anytim(file2time('20110922_110553'), /utim)
cor1_t2 = anytim(file2time('20110922_111053'), /utim)
cor1_t3 = anytim(file2time('20110922_111553'), /utim)
cor1_t = [cor1_t1,cor1_t2,cor1_t3]
height = interpol(h_sim, t_sim, cor1_t)
print,'Heights estimate: '+string(height)
;ENDFOR
stop


END


