pro aia_fit_angular_motion_final

;-----------------------------------------------------------------------------;
; 		Routine to fit AIA data for Nat Phys Figure 2 final 8-Aug-2013
;-----------------------------------------------------------------------------;


plot_t1 = anytim(file2time('20110922_103500'), /utim)
plot_t2 = anytim(file2time('20110922_105500'), /utim)
	

;--------- Read AIA Data --------------
cd,'/Users/eoincarley/Data/22sep2011_event/AIA'
 
restore,'CorPITA_pulse_params_211_150.sav' 
times_aia_sec = t_sec[min_val[loc[15],15]:max_val[loc[15],15]]
angle_aia = top_parameters[1, 15, min_val[loc[15],15]:max_val[loc[15],15]]/(!dtor*696.)
angle_err_aia = top_parameters[5,15, min_val[loc[15],15]:max_val[loc[15],15]]/(!dtor*696.)


cd,'/Users/eoincarley/Data/22sep2011_event/NRH'
	restore,'NRH_150MHz_source_angle_t.sav'
	
	index1 = closest(anytim(nrh_times, /utim), time[0] + times_aia_sec[0])
index2 = closest(anytim(nrh_times, /utim), plot_t2)
t = anytim(nrh_times[index1:index2],/utim) - anytim(nrh_times[index1],/utim) ;seconds

t = times_aia_sec
angle = angle_aia

remove_nans,angle,out,pos
angle=angle[pos]
t = t[pos]

remove_nans, angle_err_aia, angle_err_aia 

start = [20.0, 0.02];, 0.0]
fit =  'p[0] + p[1]*x'; + 0.5*p[2]*(x^2.0)'
errors = angle_err_aia 
fit_params = mpfitexpr(fit, t, angle, errors, start, perror=perror, $
						bestnorm=bestnorm, dof=dof)


tsim = (dindgen(1000)*(t[n_elements(t)-1] - t[0])/999.0 ) + t[0]
asim = dblarr(n_elements(tsim))
asim = fit_params[0] + fit_params[1]*tsim ;+ 0.5*fit_params[2]*tsim^2.0
set_line_color

	print,'	'
	print,'-----------------------------'
	print,'Linear Fit'
	print,'EUV Speed: '+ string(fit_params[1]*!DTOR*(1.0*6.955e5))+$
	'+/-'+string(perror[1]*(sqrt(bestnorm))*!DTOR*(1.0*6.955e5)) +'km/s' ;bestnorm usually bestnorm/doff
	;print,'EUV Acceleration: '+ string(fit_params[2]*!DTOR*(1.0*6.955e8))+$
	;' +/-'+string(perror[2]*sqrt(bestnorm/dof)*!DTOR*(1.0*6.955e8)) +'km/s/s'
	print,'-----------------------------'
	print,'	'
	
window,4,xs=700,ys=700
set_line_color
plot, t, angle, psym=1, xtitle='Seconds from ' + anytim(nrh_times[index1],/yoh), ytitle='Positon Angle (deg)',$
title = 'EUV Wave Linear Fit', charsize=1.5, /ys, symsize=2, yr=[20,55],/xs
oplot, tsim, asim, thick=2


legend,['EUV Wave', 'Linear fit'],$
linestyle=[0, 0], psym=[1, 0],$
charsize=2 ,box=0, color=[0, 0], /bottom, /right

	

tsim_aia = tsim
asim_aia = asim
;save, tsim_aia, asim_aia, filename = 'aia_source_motion_fit_20110922.sav'
stop

END