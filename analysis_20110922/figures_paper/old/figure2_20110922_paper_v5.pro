pro figure2_20110922_paper_v5

; v4 is to attempt a ploy in the style they usually come in nature

;v5, see what the other frequencies look like

	COMMON shared,  mapc2, t1, t2, $
					nrh_hdr_150, nrh_data_150, nrh_times_150, $
		   			nrh_hdr_445, nrh_data_445, nrh_times_445, $
		   			nrh_hdr_228, nrh_data_228, nrh_times_228, $
					nrh_hdr_360, nrh_data_360, nrh_times_360, $	
					nrh_hdr_173, nrh_data_173, nrh_times_173, $	
					nrh_hdr_408, nrh_data_408, nrh_times_408, $	
		   			suncenter, pixrad, c2_data, c2_hdr_struc, f;, angstrom

;angstrom = '!sA!r!u!9 %!n'

t1 = anytim(file2time('20110922_103500'),/utim)
t2 = anytim(file2time('20110922_111000'),/utim)

cd,'/Users/eoincarley/Data/22sep2011_event/AIA'
	aia_files = findfile('aia*.fits')

	;           Read in data proper AIA         
	mreadfits_header, aia_files, ind, only_tags='exptime'
	f = aia_files[where(ind.exptime gt 1.)]

;---------------  		C2 DATA		   ----------------------;
;					  READ C2 DATA
cd,'/Users/eoincarley/Data/22sep2011_event/LASCO_C2/L0.5/L1'
files=findfile('*.fts')
file = files[4]
c2_data = readfits(file,c2_hdr) 
pre_data = readfits('24373725.fts',pre_hdr)
c2_bs_data = c2_data - pre_data
junk = lasco_readfits(file,c2_hdr_struc)
print,'C2 time: '+anytim(c2_hdr_struc.date_obs,/yoh)
c2_data = c2_bs_data
;		MASK C2 DATA
junk = lasco_readfits('24373729.fts',hdr) 
rsun = get_solar_radius(hdr)
pixrad = rsun/hdr.cdelt1
suncenter = get_sun_center(hdr)

;------------------------------------------------------------;


;-----------------    Read NRH Data Cube       --------------;

	
	tstart = anytim(anytim(t1,/utim),/yoh,/trun,/time_only)
	tend   = anytim(anytim(t2,/utim),/yoh,/trun,/time_only)
	freq = '1509'
	cd,'/Users/eoincarley/data/22sep2011_event/nrh'
	print,'                       '
	print,'Reading NRH data between times: '+tstart+' and '+ tend
	print,'                       '
	read_nrh,'nrh2_'+freq+'_h70_20110922_081556c06_i.fts', nrh_hdr_150, nrh_data_150, hbeg=tstart, hend=tend
	index2map, nrh_hdr_150, nrh_data_150, nrh_struc_150  
	nrh_struc_hdr_150 = nrh_hdr_150
	nrh_times_150 = nrh_hdr_150.date_obs
	
	tstart = anytim(anytim(t1,/utim),/yoh,/trun,/time_only)
	tend   = anytim(anytim(t2,/utim),/yoh,/trun,/time_only)
	freq = '4450'
	read_nrh,'nrh2_'+freq+'_h70_20110922_081556c06_i.fts', nrh_hdr_445, nrh_data_445, hbeg=tstart, hend=tend
	index2map, nrh_hdr_445, nrh_data_445, nrh_struc_445  
	nrh_struc_hdr_445 = nrh_hdr_445
	nrh_times_445 = nrh_hdr_445.date_obs

	
	tstart = anytim(anytim(t1,/utim),/yoh,/trun,/time_only)
	tend   = anytim(anytim(t2,/utim),/yoh,/trun,/time_only)
	freq = '2280'
	read_nrh,'nrh2_'+freq+'_h70_20110922_081556c06_i.fts', nrh_hdr_228, nrh_data_228, hbeg=tstart, hend=tend
	index2map, nrh_hdr_228, nrh_data_228, nrh_struc_228  
	nrh_struc_hdr_228 = nrh_hdr_228
	nrh_times_228 = nrh_hdr_228.date_obs

	tstart = anytim(anytim(t1,/utim),/yoh,/trun,/time_only)
	tend   = anytim(anytim(t2,/utim),/yoh,/trun,/time_only)
	freq = '3608'
	read_nrh,'nrh2_'+freq+'_h70_20110922_081556c06_i.fts', nrh_hdr_360, nrh_data_360, hbeg=tstart, hend=tend
	index2map, nrh_hdr_360, nrh_data_360, nrh_struc_360  
	nrh_struc_hdr_360 = nrh_hdr_360
	nrh_times_360 = nrh_hdr_360.date_obs
	
	
	tstart = anytim(anytim(t1,/utim),/yoh,/trun,/time_only)
	tend   = anytim(anytim(t2,/utim),/yoh,/trun,/time_only)
	freq = '4080'
	read_nrh,'nrh2_'+freq+'_h70_20110922_081556c06_i.fts', nrh_hdr_408, nrh_data_408, hbeg=tstart, hend=tend
	index2map, nrh_hdr_408, nrh_data_408, nrh_struc_408  
	nrh_struc_hdr_408 = nrh_hdr_408
	nrh_times_408 = nrh_hdr_360.date_obs
	
	
	tstart = anytim(anytim(t1,/utim),/yoh,/trun,/time_only)
	tend   = anytim(anytim(t2,/utim),/yoh,/trun,/time_only)
	freq = '1732'
	read_nrh,'nrh2_'+freq+'_h70_20110922_081556c06_i.fts', nrh_hdr_173, nrh_data_173, hbeg=tstart, hend=tend
	index2map, nrh_hdr_173, nrh_data_173, nrh_struc_173  
	nrh_struc_hdr_173 = nrh_hdr_173
	nrh_times_173 = nrh_hdr_173.date_obs
	print,'                       '
	print,'Finished reading NRH data'
	print,''

;------------------------------------------------------------;


; 					 SET DEVIVCE PARAMS 

cd,'/Users/eoincarley/Data/22sep2011_event/NRH/NRH_AIA_pdf'

set_plot,'ps'
!p.font=0
device,filename = 'testing11.ps', /color, /inches, /landscape, /encapsulate,$
yoffset=13,ysize=8,xsize=13, bits_per_pixel=8, /helvetica

;------------------------------------------------------------;
;[x1,y1,x2,y2]
FOV = [40.0,40.0]
CENTER = [-1300.0, 50.0]
lasco_label=1.0
create_composite, 60, [0.64, 0.53, 0.925, 0.99], FOV, CENTER, 'c', 2.1, lasco_label
lasco_label=0.0
DISK = 2.1
create_composite, 36, [0.06, 0.53, 0.34, 0.99], FOV, CENTER, 'a', DISK, lasco_label, /yaxis

create_composite, 50, [0.345, 0.53, 0.635, 0.99], FOV, CENTER, 'b', DISK, lasco_label

create_composite, 87, [0.06, 0.065, 0.34, 0.525], FOV, CENTER, 'd', DISK, lasco_label, /yaxis, /xaxis
create_composite, 88, [0.345, 0.065, 0.635, 0.525], FOV, CENTER, 'e', DISK, lasco_label, /xaxis
create_composite, 94, [0.64, 0.065, 0.925, 0.525], FOV, CENTER, 'f', DISK, lasco_label, /xaxis


device,/close
set_plot,'x'

END



;------------------------------------------------------------;
;-------------------C2 AND AIA PLOTTER-----------------------;
;------------------------------------------------------------;

pro create_composite, image_num, pos, FOV, CENTER, tag, occulter, lasco_label, yaxis=yaxis, xaxis=xaxis
	
	COMMON shared
	
	; Similar to create_composite_img but now with AIA. Intended use: make movie of AIA and NRH
	; create_composite_img still useful for plotting LASCO, NRH, SWAP
	; v3 the NRH map creation is functionalised in this version 

	; v4 calls plot_low_mid_20110922_v2, which doesn't plot goes

   	loadct,0
	stretch,0,170
	
	;---------------   Plot the C2 image   -------------------; 
	;	In this version (create_composite_img_v3) it doesn't matter what C2 image.
	;	It's only used as base onto which AIA and NRH can be overplot
	
	index = circle_mask(c2_data, suncenter.xcen, suncenter.ycen, 'le', pixrad*occulter)
		IF tag eq 'c' THEN BEGIN
			c2_data[index] = 0.0
			mapc2 = make_map(bytscl(c2_data,-5.0e-10,1.5e-9)  )
		ENDIF
		IF tag eq 'a' THEN BEGIN
		c2_data[*,*] = mean(c2_data/max(c2_data))-0.3
		c2_data[index]= -0.1
		mapc2 = make_map(c2_data)
		ENDIF
		

	mapc2.dx = 11.9
	mapc2.dy = 11.9
	mapc2.xc = 14.4704
	mapc2.yc = 61.2137
	axes_thickness=3
	loadct,0

	
	IF tag eq 'c' THEN BEGIN
	plot_map, mapc2,/notitle, /nolabels, fov = FOV,center = CENTER,$
	position = pos, /noerase, /noaxes, /noxticks;, dmin=-0.5,dmax=1
	ENDIF ELSE BEGIN
	plot_map, mapc2,/notitle, /nolabels,fov = FOV,center = CENTER,$
	position = pos,  /noerase, /noaxes, dmin=-0.5,dmax=1
	ENDELSE
	
	IF keyword_set(yaxis) THEN BEGIN
		axis, yaxis=0, ythick=axes_thickness, yticklen=-0.025, ytitle='';, ytitle='Y (arcsecs)'
	ENDIF
	IF keyword_set(xaxis) eq 1 THEN BEGIN
		axis, xaxis=0, xthick=axes_thickness, xticklen=-0.025, xtitle='X (arcsecs)'
	ENDIF	
	
	points = (FINDGEN(1001)*(214.5 - 142.0)/1000.0 ) + 142.0
   	x = 0.0 + 2025 * COS(points*!Dtor)
   	y = 0.0 + 2025 * SIN(points*!Dtor)
   
   	;IF tag eq 'c' THEN BEGIN
   		plots, TRANSPOSE([[x],[y]]), /data, thick=7, color=70
   	;ENDIF ELSE BEGIN
   	;	loadct,0
   	;	plots, TRANSPOSE([[x],[y]]), /data, thick=5, color=70
   	;ENDELSE
   	
   	
   	
	;---------------        Make the AIA map and plot         ---------------;
	i=image_num
	cd,'/Users/eoincarley/Data/22sep2011_event/AIA'
	
	read_sdo, f[i], he_aia, data_aia
	read_sdo, f[i-5], he_aia_pre, data_aia_pre
	
	index2map, he_aia_pre, smooth(temporary(data_aia_pre), 7)/he_aia_pre.exptime, map_aia_pre, outsize = 1024
	index2map, he_aia, smooth(temporary(data_aia), 7)/he_aia.exptime, map_aia, outsize = 1024
	
	map_aia.dx = he_aia.CDELT1*4.0	
	map_aia.dy = he_aia.CDELT2*4.0
	map_aia.xc = he_aia.SAT_Y0/4.0
	map_aia.yc = he_aia.SAT_Z0/4.0 
	
	loadct,7
	gamma_ct,2.5
	;
	plot_map, diff_map(map_aia, map_aia_pre), /composite, /average, $
	dmin = -10.0, dmax = 7.0, /noaxes

	;axis, xaxis=0, xthick=axes_thickness, ythick=axes_thickness, xticklen=-0.025, xtitle='X (arcsecs)'


	
	set_line_color
	plot_helio, he_aia.date_obs, /over, gstyle=0, gthick=0.5, gcolor=1, grid_spacing=15.0

	;-------------         NRH DATA          --------------;
	
	overplot_nrh, nrh_times_150, nrh_data_150, nrh_hdr_150, he_aia, 2, pos, tag, c2_hdr_struc, lasco_label, 0

	overplot_nrh2, nrh_times_445, nrh_data_445, nrh_hdr_445, he_aia, 5, pos, tag, c2_hdr_struc, lasco_label, 1

	overplot_nrh2, nrh_times_228, nrh_data_228, nrh_hdr_228, he_aia, 7, pos, tag, c2_hdr_struc, lasco_label, 1
	
	overplot_nrh2, nrh_times_360, nrh_data_360, nrh_hdr_360, he_aia, 4, pos, tag, c2_hdr_struc, lasco_label, 1
	
	overplot_nrh2, nrh_times_408, nrh_data_408, nrh_hdr_408, he_aia, 9, pos, tag, c2_hdr_struc, lasco_label, 1
	
	overplot_nrh2, nrh_times_173, nrh_data_173, nrh_hdr_173, he_aia, 0, pos, tag, c2_hdr_struc, lasco_label, 1



END


;------------------------------------------------------------;
;------------------------NRH PLOTTER-------------------------;
;------------------------------------------------------------;



pro overplot_nrh, nrh_times, nrh_data, nrh_hdr, he_aia, c_color, pos, tag, c2_hdr_struc, lasco_label, lin
	
	index_nrh = closest(anytim(nrh_times,/utim), anytim(he_aia.date_obs,/utim)  )

	nrh_data_select = alog10( nrh_data[*,*,index_nrh] )
	map_nrh = make_map(nrh_data_select)
	map_nrh.dx = 29.9410591125
	map_nrh.dy = 29.9410591125
	map_nrh.xc = 64.0
	map_nrh.yc = 64.0
	
	max_val = max( alog10(nrh_data[*,*,*]) ,/nan)
	
	levels = (dindgen(12.0)*(max_val - max_val*0.9)/11.0) + max_val*0.9
	set_line_color 
	plot_map, map_nrh, /overlay, /cont, levels=levels, c_color=1, $
		/noxticks, /noyticks, xticklen=0.0, /noaxes, thick=5
	plot_map, map_nrh, /overlay, /cont, levels=levels, c_color=c_color, $
		/noxticks, /noyticks, xticklen=0.0, /noaxes, linestyle=lin
	angstrom='A'
	text_size=1.0
IF tag eq 'a' THEN BEGIN
	
	xyouts,pos[0]+0.005,pos[1]+0.025,'AIA  211 '+angstrom+' '+anytim(he_aia.date_obs,/yoh,/trun, /time_only)+' UT', $
		color = 0, /normal, charsize=text_size, charthick=2
	xyouts,pos[0]+0.005,pos[1]+0.025,'AIA  211 '+angstrom+' '+anytim(he_aia.date_obs,/yoh,/trun, /time_only)+' UT', $
		color = 1, /normal, charsize=text_size, charthick=1
		
		
	xyouts,pos[0]-0.04,pos[1]+0.18,'Y (arcsecs)', $
		color = 0, /normal, charsize=text_size, charthick=1, orientation=90.0
	
	xyouts,pos[0]-0.04,pos[1]-0.29,'Y (arcsecs)', $
		color = 0, /normal, charsize=text_size, charthick=1, orientation=90.0
	
	xyouts,pos[0]+0.005,pos[3]-0.03,tag, color = 1,/normal,charsize=1.5,charthick=5
	
	xyouts,pos[0]+0.005,pos[1]+0.005,'NRH 150.9 MHz '+anytim(nrh_hdr[index_nrh].date_obs,/yoh,/trun, /time_only)+' UT',$
		color = 0, /normal,charsize=text_size, charthick=2
	xyouts,pos[0]+0.005,pos[1]+0.005,'NRH 150.9 MHz '+anytim(nrh_hdr[index_nrh].date_obs,/yoh,/trun, /time_only)+' UT',$
		color = 1, /normal,charsize=text_size, charthick=1
		

	;xyouts, pos[0]+0.005, pos[1]+0.005, 'NRH 445.0 MHz', color = 5, /normal,charsize=1.2,charthick=1
END ELSE BEGIN
;IF tag eq 'c' THEN BEGIN

	xyouts,pos[0]+0.005,pos[1]+0.025, 'AIA '+anytim(he_aia.date_obs,/yoh,/trun, /time_only)+' UT', $
		color = 0, /normal, charsize=text_size, charthick=2
	xyouts,pos[0]+0.005,pos[1]+0.025, 'AIA '+anytim(he_aia.date_obs,/yoh,/trun, /time_only)+' UT', $
		color = 1, /normal, charsize=text_size, charthick=1
	
	xyouts,pos[0]+0.005,pos[3]-0.03,tag, color = 1,/normal,charsize=1.5,charthick=5
	
	IF lasco_label eq 1 THEN BEGIN
		xyouts,pos[0]+0.005,pos[1]+0.045,'LASCO C2 '+anytim(c2_hdr_struc.date_obs,/yoh,/trun, /time_only)+$
		' UT',/normal,charsize=text_size, charthick=4, color=0
		xyouts,pos[0]+0.005,pos[1]+0.045,'LASCO C2 '+anytim(c2_hdr_struc.date_obs,/yoh,/trun, /time_only)+$
		' UT',/normal,charsize=text_size, charthick=1, color=1
	ENDIF
	
	xyouts, pos[0]+0.005,pos[1]+0.005, 'NRH '+anytim(nrh_hdr[index_nrh].date_obs,/yoh,/trun, /time_only)+' UT',$
		color = 0, /normal,charsize=text_size, charthick=2
	xyouts, pos[0]+0.005,pos[1]+0.005, 'NRH '+anytim(nrh_hdr[index_nrh].date_obs,/yoh,/trun, /time_only)+' UT',$
		color = 1, /normal,charsize=text_size, charthick=1
	
ENDELSE

;IF tag eq 'b' or tag eq 'd' or tag eq 'e' or tag eq 'f' THEN BEGIN
;	xyouts,pos[0]+0.005,pos[1]+0.025, 'AIA '+anytim(he_aia.date_obs,/yoh,/trun, /time_only)+' UT', $
;		color = 0, /normal, charsize=1.2, charthick=4

	
;	xyouts,pos[0]+0.005,pos[3]-0.04,tag, color = 1,/normal,charsize=1.5,charthick=5
	
	
;	xyouts, pos[0]+0.005,pos[1]+0.005, 'NRH '+anytim(nrh_hdr[index_nrh].date_obs,/yoh,/trun, /time_only)+' UT',$
;		color = 0, /normal,charsize=1.2,charthick=4

;ENDIF
		


END

pro overplot_nrh2, nrh_times, nrh_data, nrh_hdr, he_aia, c_color, pos, tag, c2_hdr_struc, lasco_label, lin
	
	index_nrh = closest(anytim(nrh_times,/utim), anytim(he_aia.date_obs,/utim)  )

	nrh_data_select = alog10( nrh_data[*,*,index_nrh] )
	map_nrh = make_map(nrh_data_select)
	map_nrh.dx = 29.9410591125
	map_nrh.dy = 29.9410591125
	map_nrh.xc = 64.0
	map_nrh.yc = 64.0
	
	max_val = max( alog10(nrh_data[*,*,*]) ,/nan)
	
	levels = (dindgen(15.0)*(max_val - max_val*0.90)/14.0) + max_val*0.90
	set_line_color 
	plot_map, map_nrh, /overlay, /cont, levels=levels, c_color=1, $
		/noxticks, /noyticks, xticklen=0.0, /noaxes, thick=5
	plot_map, map_nrh, /overlay, /cont, levels=levels, c_color=c_color, $
		/noxticks, /noyticks, xticklen=0.0, /noaxes, linestyle=lin


END








