pro nrh_pol_images_v3

; 09-May-2009. Check to see what the NRH images look like in stokes V. Also get light curves from
;			   stokes V.
; v2 gets maximum in I and V
;
; v3 plots images and lightcurves all on one window

;------------- Define times ---------------;

t1 = anytim(file2time('20110922_103500'),/utim)
t2 = anytim(file2time('20110922_105950'),/utim)

tstart = anytim(anytim(t1,/utim),/yoh,/trun,/time_only)
tend   = anytim(anytim(t2,/utim),/yoh,/trun,/time_only)


;------------- Read the data ---------------;
freq = '1509'
;cd,'~/Data/22sep2011_event/nrh'
cd,'~/Data/22sep2011_event/NRH/hi_time_res'


files = findfile('*.fts')
read_nrh, files[0], nrh_hdr_V, nrh_data_V, $
	hbeg=tstart, hend=tend, /stokes
index2map, nrh_hdr_V, nrh_data_V, nrh_struc_V
nrh_struc_hdr_V = nrh_hdr_V
nrh_times_V = nrh_hdr_V.date_obs

print,'-----------------------'
print,'                       '
print,'Reading NRH data between times: '+tstart+' and '+ tend
print,'                       '
print,'-----------------------'



read_nrh, files[0], nrh_hdr_I, nrh_data_I, $
	hbeg=tstart, hend=tend
index2map, nrh_hdr_I, nrh_data_I, nrh_struc_I
nrh_struc_hdr_I = nrh_hdr_I
nrh_times_I = nrh_hdr_I.date_obs


;
window,0, xs=1000, ys=1000, RETAIN=2
;window,1, xs=1000, ys=600, RETAIN=2
cd,'stokes/im_and_lc'
;------------- Plot ---------------;

max_I = dblarr(n_elements(nrh_data_I[0,0,*]))
max_V_pos = dblarr(n_elements(nrh_data_I[0,0,*]))
max_V_neg = dblarr(n_elements(nrh_data_I[0,0,*]))
times = dblarr(n_elements(nrh_data_I[0,0,*]))


FOR i=0, n_elements(nrh_data_I[0,0,*])-1 DO BEGIN

	nrh_data_select_V = smooth(nrh_data_V[*,*,i] > 0, 3)
	map_nrh_V = make_map(nrh_data_select_V)
	map_nrh_V.dx = 29.9410591125
	map_nrh_V.dy = 29.9410591125
	map_nrh_V.xc = 64.0
	map_nrh_V.yc = 64.0	
	
	
	nrh_data_select_V_neg = abs( smooth(nrh_data_V[*,*,i] <(0), 3) )
	map_nrh_V_neg = make_map(nrh_data_select_V_neg)
	map_nrh_V_neg.dx = 29.9410591125
	map_nrh_V_neg.dy = 29.9410591125
	map_nrh_V_neg.xc = 64.0
	map_nrh_V_neg.yc = 64.0	
	
	
	nrh_data_select_I = smooth(nrh_data_I[*,*,i],3)
	map_nrh_I = make_map(nrh_data_select_I)
	map_nrh_I.dx = 29.9410591125
	map_nrh_I.dy = 29.9410591125
	map_nrh_I.xc = 64.0
	map_nrh_I.yc = 64.0	
	
	
	;--------------------------------------------------------;
	;					Plot Total I
	;
	wset,0
	loadct, 3
	plot_map, map_nrh_I, title='NRH 150 MHz, Stokes I ', /limb,$
	position=[0.1, 0.55, 0.5, 0.95], /normal, charsize=1.5, /noerase
	
	xyouts, 0.11, 0.92, 'Stokes I (Total Intensity)', /normal, charsize=1.5
	xyouts, 0.11, 0.57, nrh_times_I[i], /normal, charsize=1.5	

	plot_helio, nrh_times_I[i], /over, gstyle=0, gthick=1.0, gcolor=254, grid_spacing=15.0
	
	;--------------------------------------------------------;
	;				 Plot Right Circular
	;
	loadct,1
	plot_map, map_nrh_V, title='NRH 150 MHz, Stokes V', /limb, $
	position=[0.58, 0.55, 0.98, 0.95], /normal, charsize=1.5, /noerase
	

	
	;--------------------------------------------------------;
	;				  Plot Left Circular
	;
	loadct,3
	tv, bytscl( congrid(map_nrh_V_neg.data, 402, 402), -1e7, 5e7), channel=1, 0.58, 0.55, /normal
	plot_helio, nrh_times_I[i], /over, gstyle=0, gthick=1.0, gcolor=254, grid_spacing=15.0
	
	set_line_color
	xyouts, 0.6, 0.92, 'Right Circular', /normal, charsize=1.5, color=5
	xyouts, 0.6, 0.9, 'Left Circular', /normal, charsize=1.5, color=3
	xyouts, 0.6, 0.57, nrh_times_I[i], /normal, charsize=1.5, color=1
	;xyouts, 0.6, 0.80, 'Stokes V<0 (Left)', /normal, charsize=2, color=1
	
	

	;index_pos = where(map_nrh_V.data eq max(map_nrh_V.data))
	;nrh_I = map_nrh_I.data
	;xy = array_indices(nrh_I, index_pos)
	
	max_I[i] = max(map_nrh_I.data)    ;nrh_I[xy[0], xy[1]]
	max_V_pos[i] = max(map_nrh_V.data)
	max_V_neg[i] = max(map_nrh_V_neg.data)
	times[i] = anytim(nrh_times_V[i], /utim)
	
	
	
	;--------------------------------------------------------;
	;				  Plot Light Curves
	;
	!p.multi=[0,1,1]
	utplot, times, max_I, xr = [t1, t2], /xs, charsize=1.5, /ylog, yr=[1e5, 1e9], $
	position=[0.1, 0.1, 0.98, 0.45], /normal, /noerase,  ytitle='Brightness Temperature (K)'
	abline, 1.0e6, LINESTYLE=1, thick=1
	abline, 1.0e7, LINESTYLE=1, thick=1
	abline, 1.0e8, LINESTYLE=1, thick=1
	
	oplot, times, max_V_pos, color=5
	oplot, times, max_V_neg, color=3
	legend, ['Total Intensity','Right Circular','Left Circular'], linestyle=[0,0,0], color=[1,5,3], box=0,$
	charsize=1.5
x2png,nrh_times_I[i]+'LR.png'	
;stop
	
ENDFOR	

save, times, max_I, max_V_pos, max_V_neg, filename='stoke_light_curves.sav'


END
