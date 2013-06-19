pro nrh_pol_images

; 09-May-2009. Check to see what the NRH images look like in stokes V. Also get light curves from
;			   stokes V.


;------------- Define times ---------------;

t1 = anytim(file2time('20110922_103500'),/utim)
t2 = anytim(file2time('20110922_103600'),/utim)

tstart = anytim(anytim(t1,/utim),/yoh,/trun,/time_only)
tend   = anytim(anytim(t2,/utim),/yoh,/trun,/time_only)


;------------- Read the data ---------------;
freq = '1509'
;cd,'~/Data/22sep2011_event/nrh'
cd,'~/Data/22sep2011_event/nrh/hi_time_res'


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


!p.multi = [0,2,1]
window,0, xs=1000, ys=600, RETAIN=2
cd,'stokes'
;------------- Plot ---------------;
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
	
	loadct, 3
	plot_map, map_nrh_I, title='NRH 150 MHz '+nrh_times_I[i], /limb
	xyouts, 0.1, 0.80, 'Stokes I (Total Intensity)', /normal, charsize=2
	plot_helio, nrh_times_I[i], /over, gstyle=0, gthick=1.0, gcolor=254, grid_spacing=15.0
	
	loadct,1
	plot_map, map_nrh_V, title='NRH 150 MHz '+nrh_times_V[i], /limb
	
	loadct,3
	tv, bytscl( congrid(map_nrh_V_neg.data, 400, 400), -1e7, 5e7), channel=1, 0.56, 0.165, /normal
	plot_helio, nrh_times_I[i], /over, gstyle=0, gthick=1.0, gcolor=254, grid_spacing=15.0
	stop
	;set_line_color
	;xyouts, 0.6, 0.77, 'Right Circular', /normal, charsize=2, color=5
	;xyouts, 0.6, 0.80, 'Left Circular', /normal, charsize=2, color=3
	
	xyouts, 0.6, 0.80, 'Stokes V<0 (Left)', /normal, charsize=2, color=1
	;x2png,nrh_times_I[i]+'_L.png'

	
ENDFOR	


END