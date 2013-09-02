pro nrh_fit_angular_motion




loadct,39
!p.color=0
!p.background=255
set_line_color
plot_t1 = anytim(file2time('20110922_103500'), /utim)
plot_t2 = anytim(file2time('20110922_105500'), /utim)
	

;--------- Read AIA Data --------------
cd,'/Users/eoincarley/Data/22sep2011_event/AIA'
 
restore,'CorPITA_pulse_params_211_150.sav' 
times_aia_sec = t_sec[min_val[loc[15],15]:max_val[loc[15],15]]
angle_aia = top_parameters[1, 15, min_val[loc[15],15]:max_val[loc[15],15]]/(!dtor*696.)
angle_err_aia = top_parameters[5,15, min_val[loc[15],15]:max_val[loc[15],15]]/(!dtor*696.)

;-----------------------------------------------------------
; 					  NRH Fitting 					  
;-----------------------------------------------------------

cd,'/Users/eoincarley/Data/22sep2011_event/NRH'
	restore,'NRH_150MHz_source_angle_t.sav'
	
;-----------------------NON-lINEAR-------------------------------

index1 = closest(anytim(nrh_times, /utim), time[0] + times_aia_sec[0])
index2 = closest(anytim(nrh_times, /utim), plot_t2)
t = anytim(nrh_times[index1:index2],/utim) - anytim(nrh_times[index1],/utim) ;seconds
angle_nrh = angle_position - 170.0 
angle_nrh = angle_nrh[index1:index2]

start = [17.0, 0.04, 0.0]
fit =  'p[0] + p[1]*x + 0.5*p[2]*(x^2.0)'
errors = dblarr(n_elements(t)) + 2.6 ;expected PA angular shift due to ionoshperic scattering
									 ;(see red notebook 1)



fit_params = mpfitexpr(fit, t, angle_nrh, errors, start, $
						perror = perror, bestnorm = bestnorm, dof = dof)

tsim = (dindgen(10000)*(t[n_elements(t)-1] - t[0])/9999.0 ) + t[0]
asim = dblarr(n_elements(tsim))
asim = fit_params[0] + fit_params[1]*tsim + 0.5*fit_params[2]*tsim^2.0

	print,' '
	print,'-----------------------------------------'
	print,'Non Linear Fit'
	print,'Radio Source Speed: '+ string(fit_params[1]*!DTOR*(1.34*6.955e5))+$
	' +/-'+string(perror[1]*sqrt(bestnorm/dof)*!DTOR*(1.34*6.955e5)) +'km/s'
	
	print,'Radio Source Acceleration: '+ string(fit_params[2]*!DTOR*(1.34*6.955e8))+$
	' +/-'+string(perror[2]*sqrt(bestnorm/dof)*!DTOR*(1.34*6.955e8)) +' m/s/s'
	print,'-----------------------------------------'
	print,' '
	
Device, RETAIN=2
window,0,xs=700,ys=700

plot, t, angle_nrh, psym=1, xtitle='Seconds from ' + anytim(nrh_times[index1],/yoh), ytitle='Positon Angle (deg)',$
title = 'Radio blob 2nd order ploynomial', charsize=1.5, yr=[15,60], /ys,symsize=2
oploterror, t, angle_nrh, errors, psym=1
oplot, tsim, asim, thick=2

legend,['150.9 MHz Source', '2nd order fit'],$
linestyle=[0, 0], psym=[1, 0],$
charsize=2 ,box=0, color=[0, 0], /bottom, /right
x2png,'fit1.png'

;save,tsim_nrh,asim_nrh,filename = 'nrh_source_motion_fit_20110922.sav'


;------------------NON-LINEAR, Minus Median-----------------------

angle_nrh = angle_nrh - median(angle_nrh)
t = t - median(t)

start = [0.0, 0.04, 0.0]
fit =  'p[0] + p[1]*x + 0.5*p[2]*(x^2.0)'

fit_params = mpfitexpr(fit, t, angle_nrh, errors, start, $
						perror = perror, bestnorm = bestnorm, dof = dof)

tsim = (dindgen(1000)*(t[n_elements(t)-1] - t[0])/999.0 ) + t[0]
asim = dblarr(n_elements(tsim))
asim = fit_params[0] + fit_params[1]*tsim + 0.5*fit_params[2]*tsim^2.0
	
	print,' '
	print,'-----------------------------------------'
	print,'Non Linear Fit, Minus Median'
	print,'Radio Source Speed: '+ string(fit_params[1]*!DTOR*(1.34*6.955e5))+$
	' +/-'+string(perror[1]*sqrt(bestnorm/dof)*!DTOR*(1.34*6.955e5)) +'km/s'
	
	print,'Radio Source Acceleration: '+ string(fit_params[2]*!DTOR*(1.34*6.955e8))+$
	' +/-'+string(perror[2]*sqrt(bestnorm/dof)*!DTOR*(1.34*6.955e8)) +' m/s/s'
	print,'-----------------------------------------'
	print,' '
	
tsim_nrh = tsim
asim_nrh = asim

window,1,xs=700,ys=700
set_line_color
plot, t, angle_nrh, psym=1, xtitle='Seconds from ' + anytim(nrh_times[index1],/yoh), ytitle='Positon Angle (deg)',$
title = 'Radio blob 2nd order ploynomial', charsize=1.5, /ys, symsize=2, yr=[-25,25]
oploterror, t, angle_nrh, errors, psym=1
oplot, tsim, asim, thick=2

zeros = dblarr(n_elements(tsim))
a_line = (dindgen(100)*(20.0+20.0)/99.0) -20.0
oplot,zeros,a_line

oplot,tsim,zeros
legend,['150.9 MHz Source', '2nd order fit'],$
linestyle=[0, 0], psym=[1, 0],$
charsize=2 ,box=0, color=[0, 0], /bottom, /right
x2png,'fit2.png'

;-----------------------------------------------------------------------------------------;
;					                 LINEAR 
;-----------------------------------------------------------------------------------------;
;                     THIS IS THE FIT USED IN THE NAT PHYS PAPER
;-----------------------------------------------------------------------------------------;


index1 = closest(anytim(nrh_times, /utim), time[0] + times_aia_sec[0])
index2 = closest(anytim(nrh_times, /utim), plot_t2)
t = anytim(nrh_times[index1:index2],/utim) - anytim(nrh_times[index1],/utim) ;seconds
angle_nrh = angle_position - 170.0
angle_nrh = angle_nrh[index1:index2]

angle_nrh = angle_nrh 
t = t 

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
	print,'Radio Source Speed: '+ string(fit_params[1]*!DTOR*(1.28*6.955e5))+$
	' +/-'+string(perror[1]*sqrt(bestnorm/dof)*!DTOR*(1.28*6.955e5)) +'km/s' 
	; bestnorm usually divided by dof
	
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
x2png,'fit2.png'


tsim_nrh = tsim
asim_nrh = asim

;save,tsim_nrh,asim_nrh,filename = 'nrh_source_motion_fit_20110922.sav'

stop
;-------------------- LINEAR, minus median--------------------------
index1 = closest(anytim(nrh_times, /utim), time[0] + times_aia_sec[0])
index2 = closest(anytim(nrh_times, /utim), plot_t2)
t = anytim(nrh_times[index1:index2],/utim) - anytim(nrh_times[index1],/utim) ;seconds
angle_nrh = angle_position - 170.0
angle_nrh = angle_nrh[index1:index2]

angle_nrh = angle_nrh - median(angle_nrh)
t = t - median(t)

start = [0.0, 0.04]
fit =  'p[0] + p[1]*x'


fit_params = mpfitexpr(fit, t, angle_nrh, errors, start, $
						perror = perror, bestnorm = bestnorm, dof = dof)


tsim = (dindgen(1000)*(t[n_elements(t)-1] - t[0])/999.0 ) + t[0]
asim = dblarr(n_elements(tsim))
asim = fit_params[0] + fit_params[1]*tsim 
	print,' '
	print,'-----------------------------------------'
	print,'Linear Fit (Minus Median)'
	print,'Radio Source Speed: '+ string(fit_params[1]*!DTOR*(1.34*6.955e5))+$
	' +/-'+string(perror[1]*sqrt(bestnorm/dof)*!DTOR*(1.34*6.955e5)) +'km/s'
	
	print,'-----------------------------------------'
	print,' '

window,3,xs=700,ys=700
set_line_color
plot, t, angle_nrh, psym=1, xtitle='Seconds from ' + anytim(nrh_times[index1],/yoh), ytitle='Positon Angle (deg)',$
title = 'Radio blob Linear Fit', charsize=1.5, /ys, symsize=2, yr=[-25,25]
oploterror, t, angle_nrh, errors, psym=1
oplot, tsim, asim, thick=2


zeros = dblarr(n_elements(tsim))
a_line = (dindgen(100)*(20.0+20.0)/99.0) - 20.0
oplot,zeros,a_line

oplot,tsim,zeros

legend,['150.9 MHz Source', 'Linear fit'],$
linestyle=[0, 0], psym=[1, 0],$
charsize=2 ,box=0, color=[0, 0], /bottom, /right
x2png,'fit2.png'


tsim_nrh = tsim
asim_nrh = asim


stop
;-----------------------------------------------------------
; 					  AIA Fitting 					  
;-----------------------------------------------------------

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
;-------------------- AIA Fitting (minus median)--------------------------


;times_aia_ut = time[0] + times_aia_sec
;;angle_aia

t = times_aia_sec
angle = angle_aia

remove_nans,angle,out,pos
angle=angle[pos]
t = t[pos]

angle = angle - median(angle)
t = t - median(t)

start = [0.0, 0.02, 0.0]
fit =  'p[0] + p[1]*x + 0.5*p[2]*(x^2.0)'
fit_params = mpfitexpr(fit, t, angle, errors, start, perror=perror)


tsim = (dindgen(1000)*(t[n_elements(t)-1] - t[0])/999.0 ) + t[0]
asim = dblarr(n_elements(tsim))
asim = fit_params[0] + fit_params[1]*tsim + 0.5*fit_params[2]*tsim^2.0
set_line_color


	print,'	'
	print,'-----------------------------'
	print,'Non Linear Fit (Minus Median) '
	print,'EUV Speed: '+ string(fit_params[1]*!DTOR*(1.0*6.955e5))+$
	'+/-'+string(perror[1]*!DTOR*(1.0*6.955e5)) +'km/s'
	print,'EUV Acceleration: '+ string(fit_params[2]*!DTOR*(1.0*6.955e8))+$
	' +/-'+string(perror[2]*!DTOR*(1.38*6.955e8)) +'km/s/s'
	print,'-----------------------------'
	print,'	'
	
window,5,xs=700,ys=700
plot, t, angle, psym=1, xtitle='Seconds from ' + anytim(nrh_times[index1],/yoh), $
ytitle='Positon Angle (deg)',$
title = 'EUV Wave Non Linear Fit', charsize=1.5, symsize=2, yr=[-25,25], /ys

oplot, tsim, asim, thick=2


zeros = dblarr(n_elements(tsim))
a_line = (dindgen(100)*(20.0+20.0)/99.0) - 20.0
oplot,zeros,a_line

oplot,tsim,zeros	
legend,['EUV Wave', 'Non Linear fit'],$
linestyle=[0, 0], psym=[1, 0],$
charsize=2 ,box=0, color=[0, 0], /bottom, /right

tsim_aia = tsim
asim_aia = asim

;save, tsim_aia, asim_aia, filename = 'aia_source_motion_fit_20110922.sav'
stop


END           