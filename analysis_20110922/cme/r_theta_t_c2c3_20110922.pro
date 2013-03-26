pro r_theta_t_c2c3_20110922

cd,'/Users/eoincarley/Data/22sep2011_event/LASCO_C2/L0.5/L1'
restore,'c2_20110922_r_theta_t_test.sav'
c2_data = r_theta_t

cd,'/Users/eoincarley/Data/22sep2011_event/LASCO_C3/L0.5/L1'
restore,'c3_20110922_r_theta_t.sav'
c3_data = r_theta_t


t1 = anytim(file2time('20110922_103000'),/utim)
t2 = anytim(file2time('20110922_143000'),/utim)


times_c3 = c3_data[0,0,*]

not_zero = where(times_c3 gt 0.0)
utplot,c3_data[0,0,not_zero],c3_data[1,0,not_zero],psym=6,charsize=1.5,$
		ytitle='Heliocentric Distance [R/R!Lsun!N]',xr=[t1,t2]
oplot,c3_data[0,0,not_zero],c3_data[1,0,not_zero]

loadct,39
FOR i =1,n_elements(not_zero)-1 DO BEGIN
	oplot,c3_data[0,i,not_zero],c3_data[1,i,not_zero],psym=6;,color=i*17
	oplot,c3_data[0,i,not_zero],c3_data[1,i,not_zero],color=i*17
ENDFOR


times_c2 = c2_data[0,0,*]

not_zero = where(times_c2 gt 0.0)
oplot,c2_data[0,0,not_zero],c2_data[1,0,not_zero],psym=7,symsize=2
oplot,c2_data[0,0,not_zero],c2_data[1,0,not_zero]
loadct,39
FOR i =1,n_elements(c2_data[0,*,0])-1 DO BEGIN
	oplot,c2_data[0,i,not_zero],c2_data[1,i,not_zero],psym=7,symsize=2;,color=i*17
	oplot,c2_data[0,i,not_zero],c2_data[1,i,not_zero],color=i*17
ENDFOR




stop
END