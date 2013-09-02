pro nrh_fit_angular_motion_final


;        Written 8-aug-2013, Final version of code for radio blob velocity fit

;-----------------------------------------------------------------------------------------;
;					                 LINEAR 
;-----------------------------------------------------------------------------------------;
;                     THIS IS THE FIT USED IN THE NAT PHYS PAPER
;-----------------------------------------------------------------------------------------;
set_line_color
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
angle_nrh = angle_position - 170.0
angle_nrh = angle_nrh[index1:index2]

angle_nrh = angle_nrh 
t = t 
errors = dblarr(n_elements(t)) + 2.6 ;expected PA angular shift due to ionoshperic scattering
									 ;(see red notebook 1)

start = [0.0, 0.04]
fit =  'p[0] + p[1]*x'

fit_params = mpfitexpr(fit, t, angle_nrh, errors, start, $
						perror = perror, bestnorm = bestnorm, dof = dof)


tsim = (dindgen(1000)*(t[n_elements(t)-1] - t[0])/999.0 ) + t[0]
asim = dblarr(n_elements(tsim))
asim = fit_params[0] + fit_params[1]*tsim 

	print,' '
	print,'-----------------------------------------'
	print,'Linear Fit'
	print,'Radio Source Speed: '+ string(fit_params[1]*!DTOR*(1.27*6.955e5))+$
	' +/-'+string(perror[1]*sqrt(bestnorm)*!DTOR*(1.27*6.955e5)) +'km/s' 
	; bestnorm usually divided by dof
	
	omega = fit_params[1]*!DTOR
	del_omega = perror[1]*sqrt(bestnorm/dof)*!DTOR
	print, 'Angular velocity: ' +string(omega)
	print, 'Angular velocity uncertainty: '+string(del_omega)
	; The omega uncertainty used in the paper: perror[1]*sqrt(bestnorm/dof)
	
	print,'-----------------------------------------'
	print,' '

window,2,xs=700,ys=700
set_line_color
plot, t, angle_nrh, psym=1, xtitle='Seconds from ' + anytim(nrh_times[index1],/yoh), ytitle='Positon Angle (deg)',$
title = 'Radio blob Linear Fit', charsize=1.5, /ys, symsize=2
oploterror, t, angle_nrh, errors, psym=1
oplot, tsim, asim, thick=2

legend,['150.9 MHz Source', 'Linear fit'],$
linestyle=[0, 0], psym=[1, 0],$
charsize=2 ,box=0, color=[0, 0], /bottom, /right


tsim_nrh = tsim
asim_nrh = asim

;save,tsim_nrh,asim_nrh,filename = 'nrh_source_motion_fit_20110922.sav'

END