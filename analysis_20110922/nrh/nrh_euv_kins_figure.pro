pro nrh_euv_kins_figure, aia_image = AIA_IMAGE, toggle=toggle

cd,'/Users/eoincarley/Data/22sep2011_event/NRH'


loadct,39
!p.color=0
!p.background=255
!p.thick=4
!x.thick=4
!y.thick=4
!p.charsize=1.2
plot_t1 = anytim(file2time('20110922_103500'), /utim)
plot_t2 = anytim(file2time('20110922_105500'), /utim)
CBF_color=5


IF keyword_set(toggle) THEN BEGIN
	set_plot,'ps'
	!p.font=0
	device,filename = 'Figure3_NRH_angle_time.ps',$
	/color,/inches, /encapsulate ,$
	ysize=7,xsize=6, bits_per_pixel=8, xoffset=0, yoffset=0, /helvetica
ENDIF ELSE BEGIN
	window, xs=600, ys=700
ENDELSE
	
	
;------------ Plot NRH Data -----------	
restore,'NRH_150MHz_source_angle_t.sav', /verb
set_line_color
angle_offset = 90.0
utplot, anytim(nrh_times, /utim), angle_position - angle_offset, ytitle='Postion angle ('+cgSymbol('deg')+')',$
/xs, /ys, psym=1, position=[0.14, 0.1, 0.95, 0.99], symsize=1.5, thick=1, color=0, $
xr=[plot_t1, plot_t2], tick_unit=5.0*60.0, charthick=4, yticks=9, yminor=5,$
xticklen=-0.02, yticklen=-0.02, xtitle='Time (UT)', yr=[95, 140]

plotsym,0, /fill


;-------------Instead of legend draw lines ------------------;
set_line_color
plots,[0.75,0.75],[0.4,0.53], /normal, thick=4,linestyle=0,color=CBF_color;======[x1,x2],[y1,y2]=====
xyouts, 0.75, 0.37, 'CBF', /normal, charsize=1.2, color=CBF_color, alignment=0.5
xyouts, 0.75, 0.34, '(283 '+string(177b)+' 22 km s!U-1!N)', /normal, charsize=1.2, color=CBF_color, alignment=0.5

plots,[0.8,0.7],[0.65,0.89], /normal, thick=4,linestyle=0,color=0;======[x1,x2],[y1,y2]=====
xyouts, 0.58, 0.93, '150 MHz Source', /normal, charsize=1.2, color=0
xyouts, 0.58, 0.9, '(557 '+string(177b)+' 70 km s!U-1!N)', /normal, charsize=1.2, color=0

;------------------------------------------------------------;


errors = dblarr(n_elements(nrh_times)) + 3.0 ;expected PA angular shift due to ionoshperic scattering
									 ;(see red notebook 1)
loadct,0
									 ;set_line_color
;oploterror,	anytim(nrh_times, /utim), (angle_position - 170.0), errors, $
;psym=1, symsize=1.5, thick=3, color=5, /nohat						 
									 
oband, anytim(nrh_times, /utim), (angle_position - angle_offset)+3.0, (angle_position - angle_offset)-3.0,color=180
set_line_color
oplot, anytim(nrh_times, /utim), angle_position - angle_offset,$
psym=1, symsize=1.5, thick=3, color=0


;---------------------- Plot NRH FIT --------------------------
restore,'nrh_source_motion_fit_20110922.sav'
cd,'/Users/eoincarley/Data/22sep2011_event/AIA'

restore,'CorPITA_pulse_params_211_150.sav' ,/verb
times_aia_sec = t_sec[min_val[loc[15],15]:max_val[loc[15],15]]
angle_aia = top_parameters[1, 15, min_val[loc[15],15]:max_val[loc[15],15]]/(!dtor*696.)
angle_err_aia = top_parameters[5,15, min_val[loc[15],15]:max_val[loc[15],15]]/(!dtor*696.)

 
times_aia_ut = time[0] + times_aia_sec
index1 = closest(anytim(nrh_times, /utim), time[0] + times_aia_sec[0])
outplot,anytim(nrh_times[index1],/utim)+tsim_nrh, asim_nrh+(170.0-angle_offset), thick=4  ;+
; In the fitting code -170 was originally taken off the data to fit it from 0 degrees. Add 170 back on
; To plot from solar north -90.0 degrees.



;-------------------------- Plot EUV wave stuff ---------------------------------
;plot_euv_wave_angle, '140', 2, 5
;plot_euv_wave_angle, '150', 7, 3
;plot_euv_wave_angle, '160', 4, 4
;plot_euv_wave_angle, '170', 5, 5
;plot_euv_wave_angle, '180', 6, 6

plotsym,0, /fill
set_line_color
outplot, time[0] + times_aia_sec, angle_aia+(angle_offset-10.0),  psym = 8, color = CBF_color, symsize=1.0, thick=3
oploterror, time[0] + times_aia_sec, angle_aia+(angle_offset-10.0), angle_err_aia, psym = 8, color = CBF_color, $
symsize=1.0, thick=3, /nohat
; -10.0 degrees to account for active region origin. +90.0 to set origin at solar north.


;FITTING NOW DONE USING THE NRH_FIT_ANGULAR_MOTION.PRO ROUTINE !!!!!!
restore,'aia_source_motion_fit_20110922.sav'
outplot,time[0]+tsim_aia, asim_aia+(angle_offset-10.0), color=0, thick=10, linestyle=4



IF keyword_set(AIA_IMAGE) THEN BEGIN
	loadct,0

	cd,'/Users/eoincarley/Data/22sep2011_event/AIA'
	aia_files = findfile('aia*.fits')
	read_sdo,aia_files[0], he_aia_pre, data_aia_pre

	;           Read in data proper AIA         
	mreadfits_header, aia_files, ind, only_tags='exptime'
	f = aia_files[where(ind.exptime gt 1.)]
	restore,'22_09_2011_xy_pulse_distance_160_arc.sav',/verb
	read_sdo, f[1], he_aia, data_aia
	read_sdo, f[0], he_aia_pre, data_aia_pre
	data_aia_bs = temporary(data_aia)/he_aia.exptime - temporary(data_aia_pre)/he_aia_pre.exptime
	map_aia = make_map( smooth(rebin(temporary(data_aia_bs), 1024, 1024), 7) )
	map_aia.dx = he_aia.CDELT1*4.0
	map_aia.dy = he_aia.CDELT2*4.0
	map_aia.xc = he_aia.SAT_Y0/4.0
	map_aia.yc = he_aia.SAT_Z0/4.0 
	
	loadct,1
	plot_map, map_aia, dmin = -10, dmax = 5, position=[0.15, 0.54, 0.50, 0.98], /normal,$
	/noerase, title=' ', xticklen=-0.03,$
	yticklen=-0.03, /xs, /ys, xr=[0,-1100.0], yr=[-1100,500], /noaxes

	set_line_color
	plot_helio, he_aia.date_obs, /over, gstyle=0, gthick=2.5, gcolor=1, grid_spacing=15.0	
	
	set_line_color
	!p.thick=2
	plots, x, y, color=1, thick=8, linestyle=0
	plots, x, y, color=0, thick=5, linestyle=2
	
	plots,[0.2,0.25],[0.57,0.68], /normal, thick=4,linestyle=0,color=1;======[x1,x2],[y1,y2]=====
	xyouts, 0.155, 0.55, 'Great Circle', /normal, charsize=1.2, color=1
	xyouts, 0.195, 0.825, '90'+cgSymbol('deg'), /normal, charsize=1.0, color=1, align=1
	xyouts, 0.235, 0.69, '120'+cgSymbol('deg'), /normal, charsize=1.0, color=1, align=1
	xyouts, 0.365, 0.588, '150'+cgSymbol('deg'), /normal, charsize=1.0, color=1, align=1
	;restore,'22_09_2011_xy_pulse_distance_150_arc.sav',/verb
	;plots,x,y, color=3, thick=3

	;restore,'22_09_2011_xy_pulse_distance_140_arc.sav',/verb
	;plots,x,y, color=5, thick=3

	cd,'/Users/eoincarley/Data/22sep2011_event/NRH'
ENDIF

IF keyword_set(toggle) THEN BEGIN
	device,/close
	set_plot,'x'
ENDIF


END