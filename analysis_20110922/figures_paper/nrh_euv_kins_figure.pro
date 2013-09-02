pro nrh_euv_kins_figure, aia_image = AIA_IMAGE, toggle=toggle

;-------------------------------------------------------------------------------------;
;	   Final version of the code to plot Figure 2 for Nat Phys paper (8-Aug-2013)	  ;
;																		     		  ;


cd,'~/Data/22sep2011_event/NRH'

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
	device,filename = 'nrh_aia_angle_time.ps',$
	/color,/inches, /encapsulate ,$
	ysize=7,xsize=6, bits_per_pixel=8, xoffset=0, yoffset=0, /helvetica
ENDIF ELSE BEGIN
	window, xs=600, ys=700
ENDELSE
	
	
;------------ Plot NRH Data -----------	
restore,'NRH_150MHz_source_angle_t.sav', /verb
set_line_color
angle_offset = 90.0
utplot, anytim(nrh_times, /utim), angle_position - angle_offset, ytitle='Position angle ('+cgSymbol('deg')+')',$
/xs, /ys, psym=1, position=[0.14, 0.1, 0.95, 0.99], symsize=1.5, thick=1, color=0, $
xr=[plot_t1, plot_t2], tick_unit=5.0*60.0, charthick=4, yticks=9, yminor=5,$
xticklen=-0.02, yticklen=-0.02, xtitle='Time (UT)', yr=[95, 140]

plotsym,0, /fill
errors = dblarr(n_elements(nrh_times)) + 3.0 ;expected PA angular shift due to ionoshperic scattering
									         ;(see red notebook 1)
loadct,0

restore,'source_fwhm.sav', /verb
badpoints = where(source_fwhm gt 20.0)
source_fwhm[badpoints] = 7.0   ;pixels
source_fwhm = source_fwhm*1.28 ;position angle, see red notebook
source_fwhm = source_fwhm/2.35 ;To get 1sigma
errors = errors + source_fwhm 

errs = dblarr(30)
errs[*] = mean(source_fwhm)+3.0
errs = [errs, errors]
			 
oband, anytim(nrh_times, /utim), (angle_position - angle_offset)+errs, (angle_position - angle_offset)-errs,color=180
set_line_color
oplot, anytim(nrh_times, /utim), angle_position - angle_offset,$
psym=1, symsize=1.5, thick=3, color=0

;-----------------------------------------;
;            Plot NRH FIT      			
; Produced using nrh_fit_angular_motion_final.pro
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
outplot,time[0]+tsim_aia, asim_aia+(angle_offset-10.0), color=10, thick=7, linestyle=0


;------------------------------------------------------------;
;------------------------------------------------------------;
cd,'~/Data/22sep2011_event/AIA/Nature_CME_pos'
restore,'flank_positions_20110922.sav'
tim = time_array[loc[0,*]] + time[28]
ang128 = abs(x_arr[loc[2,*]] - 360.0)
set_line_color
oplot, tim, ang128,  psym=4, color=7
err = dblarr(n_elements(ang128))
err[*] = 3.0 ;Dave's quote for the angular position uncertainty.
oploterror, tim, ang128, err, psym=4, color=7, /nohat


tstart = anytim(file2time('20110922_104000'), /utim)
index_start = where(tim gt tstart)
tim = tim[index_start[0]: n_elements(tim)-6]
ang128 = ang128[index_start[0]: n_elements(ang128)-6]
result = linfit(tim, ang128)
y = result[0] + result[1]*tim
oplot, tim, y, color = 7



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
	plot_map, map_aia, dmin = -10, dmax = 5, position=[0.15, 0.59, 0.45, 0.98], /normal,$
	/noerase, title=' ', xticklen=-0.03,$
	yticklen=-0.03, /xs, /ys, xr=[0,-1100.0], yr=[-1100,500], /noaxes

	set_line_color
	plot_helio, he_aia.date_obs, /over, gstyle=0, gthick=2.5, gcolor=1, grid_spacing=15.0	
	
	set_line_color
	!p.thick=2
	plots, x, y, color=1, thick=8, linestyle=0
	plots, x, y, color=0, thick=5, linestyle=2
	
	radius=1.27
	points = (FINDGEN(1001)*(240.0 - 207.0)/1000.0 ) + 207.0 
	arcsec_per_rsun = 965.80252
	x1 = 0.0 + radius*arcsec_per_rsun*COS(points*!Dtor)
	y1 = 0.0 + radius*arcsec_per_rsun*SIN(points*!Dtor)
	x2 = 0.0 + radius*arcsec_per_rsun*COS(points*!Dtor)
	y2 = 0.0 + radius*arcsec_per_rsun*SIN(points*!Dtor)
	set_line_color
	plots, TRANSPOSE([[x1],[y1]]), /data, thick=6, color=7, linestyle=2
	plots, TRANSPOSE([[x2],[y2]]), /data, thick=6, color=7, linestyle=2
	
	plots,[0.18,0.25],[0.62,0.7], /normal, thick=4,linestyle=0,color=1;======[x1,x2],[y1,y2]=====
	xyouts, 0.159, 0.6, 'Great Circle', /normal, charsize=1.2, color=1, alignment=0
	xyouts, 0.17, 0.84, '90'+cgSymbol('deg'), /normal, charsize=1.0, color=1, alignment=0.5
	xyouts, 0.23, 0.72, '120'+cgSymbol('deg'), /normal, charsize=1.0, color=1, align=1
	xyouts, 0.34, 0.63, '150'+cgSymbol('deg'), /normal, charsize=1.0, color=1, align=1
	;restore,'22_09_2011_xy_pulse_distance_150_arc.sav',/verb
	;plots,x,y, color=3, thick=3

	;restore,'22_09_2011_xy_pulse_distance_140_arc.sav',/verb
	;plots,x,y, color=5, thick=3

	cd,'/Users/eoincarley/Data/22sep2011_event/NRH'
ENDIF

set_line_color
sun = sunsymbol()
plots, [0.72,0.8], [0.5,0.37], /normal, thick=4,linestyle=0,color=CBF_color;======[x1,x2],[y1,y2]=====


xyouts, 0.8, 0.35, 'CBF (1 R!L   !N)', /normal, charsize=1.2, color=CBF_color, alignment=0.5
xyouts, 0.8, 0.35, '       !L!9n!X!N', /normal, charsize=1.5, color=CBF_color, alignment=0.5, font=-1

xyouts, 0.8, 0.31, '(283 !9'+string(177b)+'!X 40 km s!U-1!N)', /normal, charsize=1.2, color=CBF_color, alignment=0.5

plots,[0.5,0.6],[0.35,0.2], /normal, thick=4,linestyle=0,color=0;======[x1,x2],[y1,y2]=====
xyouts, 0.6, 0.187, 'Radio Source (1.27 R!L   !N)', /normal, charsize=1.2, color=0, alignment=0.5
xyouts, 0.605, 0.187, '                !L!9n!X!N', /normal, charsize=1.5, color=0, alignment=0.5, font=-1

xyouts, 0.6, 0.15, '(548 !9'+string(177b)+'!X 48 km s!U-1!N)', /normal, charsize=1.2, color=0, alignment=0.5

plots,[0.66,0.62],[0.86,0.91], /normal, thick=4,linestyle=0,color=7;======[x1,x2],[y1,y2]=====
xyouts, 0.62, 0.955, 'CBF (1.27 R!L   !N)', /normal, charsize=1.2, color=7, alignment=0.5
xyouts, 0.615, 0.955, '          !L!9n!X!N', /normal, charsize=1.5, color=7, alignment=0.5, font=-1

xyouts, 0.62, 0.92, '(480 !9'+string(177b)+'!X 115 km s!U-1!N)', /normal, charsize=1.2, color=7, alignment=0.5

IF keyword_set(toggle) THEN BEGIN
	device,/close
	set_plot,'x'
ENDIF


END