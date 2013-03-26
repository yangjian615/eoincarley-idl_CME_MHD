pro nrh_euv_kins_figure_test, aia_image = AIA_IMAGE

cd,'/Users/eoincarley/Data/22sep2011_event/NRH'


loadct,39
;!p.color=0
;!p.background=255
!p.thick=2
!x.thick=4
!y.thick=4

set_plot,'ps'
device,filename = 'test_figure.ps',$
	/color,/inches, /encapsulate ,$
	ysize=7,xsize=6, bits_per_pixel=8, xoffset=0, yoffset=0
	
	plot_t1 = anytim(file2time('20110922_103500'), /utim)
	plot_t2 = anytim(file2time('20110922_105500'), /utim)
	;The 170 here is because the active region is located at +10 deg latitude.
	
;------------ Plot NRH Data -----------	
	restore,'NRH_150MHz_source_angle_t.sav'
	set_line_color
utplot, anytim(nrh_times, /utim), angle_position - 170.0, ytitle='Postion angle ('+cgSymbol('deg')+')',$
/xs, /ys, charsize=1.5, psym=1, position=[0.14, 0.1, 0.95, 0.99], symsize=1.5, thick=3, color=5, $
xr=[plot_t1, plot_t2], yr=[15.0, 60.0], tick_unit=5.0*60.0, charthick=4, yticks=9, yminor=5

legend,['150.9 MHz Source','EUV Wave GC','Fit 150 MHz', 'Fit EUV Wave'],$
linestyle=[0, 0, 0, 5], psym=[1, 4, 0, 0],$
charsize=1.2 ,box=0, color=[5, 4, 0, 0], /bottom, /right, charthick=3




;---------------------- Plot NRH FIT --------------------------
restore,'nrh_source_motion_fit_20110922.sav'
cd,'/Users/eoincarley/Data/22sep2011_event/AIA'

restore,'CorPITA_pulse_params_211_150.sav' 
times_aia_sec = t_sec[min_val[loc[15],15]:max_val[loc[15],15]]
angle_aia = top_parameters[1, 15, min_val[loc[15],15]:max_val[loc[15],15]]/(!dtor*696.)
stop
 
times_aia_ut = time[0] + times_aia_sec
index1 = closest(anytim(nrh_times, /utim), time[0] + times_aia_sec[0])
outplot,anytim(nrh_times[index1],/utim)+tsim_nrh, asim_nrh, thick=4



;-------------------------- Plot EUV wave stuff ---------------------------------
;plot_euv_wave_angle, '140', 2, 5
;plot_euv_wave_angle, '150', 7, 3
;plot_euv_wave_angle, '160', 4, 4
;plot_euv_wave_angle, '170', 5, 5
;plot_euv_wave_angle, '180', 6, 6


set_line_color
outplot, time[0] + times_aia_sec, angle_aia,  psym = 4, color = 4, symsize=1.5, thick=3
;FITTING NOW DONE USING THE NRH_FIT_ANGULAR_MOTION.PRO ROUTINE !!!!!!
restore,'aia_source_motion_fit_20110922.sav'
outplot,time[0]+tsim_aia, asim_aia, color=0, thick=4, linestyle=5



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
	data_aia_bs = data_aia/he_aia.exptime - data_aia_pre/he_aia_pre.exptime
	map_aia = make_map( smooth(data_aia_bs,10) )
	map_aia.dx = he_aia.CDELT1	
	map_aia.dy = he_aia.CDELT2
	map_aia.xc = he_aia.SAT_Y0
	map_aia.yc = he_aia.SAT_Z0 

	plot_map, map_aia, dmin = -10, dmax = 10, /limb, position=[0.15, 0.6, 0.58, 0.97], /normal,$
	/noerase, /noaxes, title=' '

	set_line_color
	!p.thick=2
	plots,x,y, color=4, thick=5

	;restore,'22_09_2011_xy_pulse_distance_150_arc.sav',/verb
	;plots,x,y, color=3, thick=3

	;restore,'22_09_2011_xy_pulse_distance_140_arc.sav',/verb
	;plots,x,y, color=5, thick=3

	cd,'/Users/eoincarley/Data/22sep2011_event/NRH'
ENDIF

device,/close
set_plot,'x'



END