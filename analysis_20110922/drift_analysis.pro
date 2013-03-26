pro drift_analysis

window,0,xs=1000,ys=500
cd,'/Users/eoincarley/Data/CALLISTO/20110922'
radio_spectro_fits_read,'BIR_20110922_104459_01.fit',data_raw,times,freq


loadct,5

t1_hb = anytim(file2time('20110922_105100'),/utim)
t2_hb = anytim(file2time('20110922_105300'),/utim)

spectro_plot, constbacksub(data_raw, /auto) > (-7.0) , times, freq, /xs, /ys,$
xr=[t1_hb,t2_hb], charsize=1.0, yr=[90,20], yticks=7, yminor=2, $
xticklen=-0.01, yticklen=-0.01, ytitle='Frequency (MHz)',$
/noerase, xtitle='Time (UT)'


point, t, f, /data

cd,'/Users/eoincarley/Data/22sep2011_event/pietro'
restore,'pietros_code_pb_euv_density.sav'
;f = 100.0
n_e = ( (f/1)*1.0e6/ ( 1.0/(2.0*!pi) * sqrt(  ( 4.0*!pi*(4.8032e-10)^2.0  )  / (!e_mass*1000.0)  ) ) )^2.0
h_est = interpol(rad_sim, ne_sim_HE_SPH, n_e)

displ = abs(h_est - h_est[0])
time_s  = t - t[0]
window,1
plot, time_s, displ, xtitle='Time (UT)', ytitle='Heliocentric Distance (Rsun)',$
psym=1, /xs, /ys

yfit = linfit(time_s, displ)
tsim = (dindgen(100)*(time_s[n_elements(t)-1] - time_s[0])/99.0 ) +time_s[0]
ysim = yfit[0]+yfit[1]*tsim
oplot,tsim, ysim

beam_speed = (yfit[1]*!Rsun)/!c_light ;c
print,'--------------------'
print,' '
print,'Speed: '+string((yfit[1]*!Rsun)/!c_light)+' c'
print,' '
print,'--------------------'

save, t, f, beam_speed, filename = 'beam10.sav'
c_all = 0.0
FOR i = 1, 10 DO BEGIN
	restore,'beam'+string(i, format='(I1)')+'.sav'
	c_all = [c_all, beam_speed]
ENDFOR	
c_mean = mean(c_all[1:10])
print,'--------------------'
print,' '
print,'Mean speed of the ten beams: '+string(c_mean)
print,' '
print,'--------------------'


END