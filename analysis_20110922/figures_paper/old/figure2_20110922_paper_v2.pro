pro figure2_20110922_paper_v2

	COMMON shared, mapc2, t1, t2, nrh_hdr_150, nrh_data_150,$
		   			nrh_hdr_445, nrh_data_445, nrh_times_150,$
		   			nrh_times_445, suncenter, pixrad, c2_data, c2_hdr_struc



t1 = anytim(file2time('20110922_103500'),/utim)
t2 = anytim(file2time('20110922_111000'),/utim)

;***************  		C2 DATA		   **********************;
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

;************************************************************;


;***********    Read NRH Data Cube        *************;

	
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
	print,'                       '
	print,'Finished reading NRH data'
	print,'						  '

;************************************************************;



cd,'/Users/eoincarley/Data/22sep2011_event/NRH/NRH_AIA_pdf'
set_plot,'ps'
device,filename = 'testing11.ps',/color,/inches,/landscape,/encapsulate,$
yoffset=13,ysize=8,xsize=13, bits_per_pixel=8
lasco_label=1.0
print,'Third Image, also CME image'
create_composite,31,[0.61,0.51,0.9,0.99], [60.0,60.0], [-850.0,-40.0], '(c)', 2.1, lasco_label
lasco_label=0.0
print,'First Image'
;create_composite,19,[0.01,0.51,0.3,0.99], [35.0,35.0], [-850.0,-70.0], '(a)', 3.0, lasco_label
print,'Second Image'
;create_composite,26,[0.31,0.51,0.6,0.99], [35.0,35.0], [-850.0,-70.0], '(b)', 3.0, lasco_label

;create_composite,46,[0.01,0.01,0.3,0.49], [35.0,35.0], [-850.0,-70.0], '(d)', 3.0, lasco_label
;create_composite,47,[0.31,0.01,0.6,0.49], [35.0,35.0], [-850.0,-70.0], '(e)', 3.0, lasco_label
;create_composite,51,[0.61,0.01,0.9,0.49], [35.0,35.0], [-850.0,-70.0], '(f)', 3.0, lasco_label



END


pro create_composite, image_num, pos, FOV, CENTER, tag, occulter, lasco_label
	COMMON shared
	
; Similar to create_composite_img but now with AIA. Intended use: make movie of AIA and NRH
; create_composite_img still useful for plotting LASCO, NRH, SWAP
; v3 the NRH map creation is functionalised in this version 

; v4 calls plot_low_mid_20110922_v2, which doesn't plot goes

   	loadct,0
	stretch,0,170
	
	;*****************   Plot the C2 image   ******************; 
	;	In this version (create_composite_img_v3) it doesn't matter what C2 image.
	;	It's only used as base onto which AIA and NRH can be overplot
	
	
	print,'Occulter size: '+string(occulter,format = '(I2.2)')
	index = circle_mask(c2_data, suncenter.xcen, suncenter.ycen, 'le', pixrad*occulter)
	c2_data[index] = 0.0
	; 	    MAKE C2 MAP
	mapc2 = make_map(bytscl(c2_data,-5.0e-10,1.5e-9)  )
	mapc2.dx = 11.9
	mapc2.dy = 11.9
	mapc2.xc = 14.4704
	mapc2.yc = 61.2137
	
	print,'TEST!!!!!!!'
	plot_map,mapc2,/notitle,/nolabels,fov = FOV,center = CENTER,$
	position = pos, /isotropic, /noerase, /noxticks, /noyticks, xticklen=0.0, /noaxes
	;[0.5,0.08,0.97,0.97]
	;xyouts,pos[0]+0.01,pos[3]-0.01, tag
	
	
	;***********        Make the AIA map and plot         *********
	i=image_num
	cd,'/Users/eoincarley/Data/22sep2011_event/AIA'
	aia_files = findfile('aia*.fits')
	;read_sdo,aia_files[0], he_aia_pre, data_aia_pre

	;           Read in data proper AIA         
	mreadfits_header, aia_files, ind, only_tags='exptime'
	f = aia_files[where(ind.exptime gt 1.)]
	
	read_sdo, f[i], he_aia, data_aia
	read_sdo, f[i-1], he_aia_pre, data_aia_pre
	data_aia_bs = data_aia/he_aia.exptime - data_aia_pre/he_aia_pre.exptime

	map_aia = make_map( smooth(data_aia_bs,10) )
	map_aia.dx = he_aia.CDELT1	
	map_aia.dy = he_aia.CDELT2
	map_aia.xc = he_aia.SAT_Y0
	map_aia.yc = he_aia.SAT_Z0 
	plot_map, map_aia, /composite, /average, dmin = -9, dmax = 9, /noxticks, /noyticks, xticklen=0.0, /noaxes
	plot_helio, he_aia.date_obs, /over, gstyle=0, gthick=0.5, gcolor=0, grid_spacing=15.0

	;*********             NRH DATA           *************;
	;***********   Obtain closest NRH image  **************;
	
	overplot_nrh, nrh_times_150, nrh_data_150, nrh_hdr_150, he_aia, 3, pos, tag, c2_hdr_struc, lasco_label

	overplot_nrh, nrh_times_445, nrh_data_445, nrh_hdr_445, he_aia, 5, pos, tag, c2_hdr_struc, lasco_label




END

pro overplot_nrh, nrh_times, nrh_data, nrh_hdr, he_aia, c_color, pos, tag, c2_hdr_struc, lasco_label
	
	index_nrh = closest(anytim(nrh_times,/utim), anytim(he_aia.date_obs,/utim)  )

	nrh_data_select = alog10( nrh_data[*,*,index_nrh] )
	map_nrh = make_map(nrh_data_select)
	map_nrh.dx = 29.9410591125
	map_nrh.dy = 29.9410591125
	map_nrh.xc = 64.0
	map_nrh.yc = 64.0
	
	max_val = max( alog10(nrh_data[*,*,*]) ,/nan)
	
	levels = (dindgen(15.0)*(max_val - max_val*0.9)/14.0) + max_val*0.9
	set_line_color 
	plot_map, map_nrh, /overlay, /cont, levels=levels, c_color=c_color, /noxticks, /noyticks, xticklen=0.0, /noaxes
	angstrom = '!6!sA!r!u!9 %!6!n'
	
	xyouts,pos[0]+0.005,pos[1]+0.045,'AIA 193 '+angstrom+' '+anytim(he_aia.date_obs,/yoh,/trun)+' UT', color = 0,/normal,charsize=1.0,charthick=1
	xyouts,pos[0]+0.005,pos[3]-0.04,tag, color = 1,/normal,charsize=1.5,charthick=1
	;xyouts,pos[0]+0.01, pos[1]+0.05, '(a)',  color = 0,/normal,charsize=1.0,charthick=1
	IF lasco_label eq 1.0 THEN BEGIN
		xyouts,pos[0]+0.005,pos[1]+0.07,'LASCO C2 '+anytim(c2_hdr_struc.date_obs,/yoh,/trun)+' UT',/normal,charsize=1.0,charthick=1
	ENDIF
	xyouts,pos[0]+0.005,pos[1]+0.025,'NRH 150.9 MHz '+anytim(nrh_hdr[index_nrh].date_obs,/yoh,/trun)+' UT', color = 3, /normal,charsize=1.0,charthick=1
	;'AIA 193 '+angstrom+' '+anytim(he_aia.date_obs,/yoh,/trun)+' UT'
	xyouts,pos[0]+0.005,pos[1]+0.005,'NRH 445.0 MHz '+anytim(nrh_hdr[index_nrh].date_obs,/yoh,/trun)+' UT', color = 5, /normal,charsize=1.0,charthick=1
END	







