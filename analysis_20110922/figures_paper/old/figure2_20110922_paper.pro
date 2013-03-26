pro figure2_20110922_paper

cd,'/Users/eoincarley/Data/22sep2011_event/NRH/NRH_AIA_pdf'
set_plot,'ps'
device,filename = 'testing11.ps',/color,/inches,/landscape,/encapsulate,$
yoffset=13,ysize=8,xsize=13, bits_per_pixel=8

print,'First Image'
create_composite,19,[0.01,0.51,0.3,0.99], [30.0,30.0], '(a)'

print,'Second Image'
create_composite,26,[0.31,0.51,0.6,0.99], [30.0,30.0], '(b)'

print,'Third Image, also CME image'
create_composite,31,[0.61,0.51,0.9,0.99], [60.0,60.0], '(c)'

create_composite,46,[0.01,0.01,0.3,0.49], [30.0,30.0], '(d)'

create_composite,47,[0.31,0.01,0.6,0.49], [30.0,30.0], '(e)'

create_composite,51,[0.61,0.01,0.9,0.49], [30.0,30.0], '(f)'



END
pro create_composite, image_num, pos, FOV, tag

; Similar to create_composite_img but now with AIA. Intended use: make movie of AIA and NRH
; create_composite_img still useful for plotting LASCO, NRH, SWAP
; v3 the NRH map creation is functionalised in this version 

; v4 calls plot_low_mid_20110922_v2, which doesn't plot goes


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
index = circle_mask(c2_data, suncenter.xcen, suncenter.ycen, 'le', pixrad*2.1)
c2_data[index] = 0.0

; 	    MAKE C2 MAP
mapc2 = make_map(bytscl(c2_data,-5.0e-10,1.5e-9)  )
mapc2.dx = 11.9
mapc2.dy = 11.9
mapc2.xc = 14.4704
mapc2.yc = 61.2137


;******************************************************;


;           Read in the AIA pre image             ;
cd,'/Users/eoincarley/Data/22sep2011_event/AIA'
aia_files = findfile('aia*.fits')
read_sdo,aia_files[0], he_aia_pre, data_aia_pre

;           Read in data proper AIA         
mreadfits_header, aia_files, ind, only_tags='exptime'
f = aia_files[where(ind.exptime gt 1.)]

;******************************************************;

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
	print,'                       '
	


;FOR i=1, 183 DO BEGIN ;n_elements(f)-1 DO BEGIN
i=image_num


	cd,'/Users/eoincarley/Data/22sep2011_event/AIA'
	read_sdo, f[i], he_aia, data_aia
	read_sdo, f[i-1], he_aia_pre, data_aia_pre
	data_aia_bs = data_aia/he_aia.exptime - data_aia_pre/he_aia_pre.exptime
	loadct,39
	!p.color=0
	!p.background=255
   	;plot_low_mid_20110922_v2, he_aia.date_obs, goes, low_data_bg, low_times, mid_data_bg, mid_times, $
   	;low_data, mid_data, lfreq, mfreq, mean_low, mean_mid, mean_all

   	loadct,0
	stretch,0,170
	
	;*****************   Plot the C2 image   ******************; 
	;	In this version (create_composite_img_v3) it doesn't matter what C2 image.
	;	It's only used as base onto which AIA and NRH can be overplot
	print,'TEST!!!!!!!'
	plot_map,mapc2,/notitle,/nolabels,fov = FOV,center = [-850.0,-40.0],$
	position = pos, /isotropic, /noerase, /noxticks, /noyticks
	;[0.5,0.08,0.97,0.97]
	;xyouts,pos[0]+0.01,pos[3]-0.01, tag
	
	
	;***********        Make the AIA map and plot         *********
	
	map_aia = make_map( smooth(data_aia_bs,10) )
	map_aia.dx = he_aia.CDELT1	
	map_aia.dy = he_aia.CDELT2
	map_aia.xc = he_aia.SAT_Y0
	map_aia.yc = he_aia.SAT_Z0 
	plot_map, map_aia, /composite, /average, dmin = -9, dmax = 9, /noxticks, /noyticks
	plot_helio, file2time('20110922_104600'), /over, gstyle=0, gthick=0.5, gcolor=0, grid_spacing=15.0

	;*********             NRH DATA           *************;
	;***********   Obtain closest NRH image  **************;
	
	overplot_nrh, nrh_times_150, nrh_data_150, nrh_hdr_150, he_aia, 3, pos, tag

	overplot_nrh, nrh_times_445, nrh_data_445, nrh_hdr_445, he_aia, 5, pos, tag

	
;ENDFOR	
;save,nrh_total_flux_150,time_nrh_total_flux,filename='nrh_total_flux_150.sav'


END

pro overplot_nrh, nrh_times, nrh_data, nrh_hdr, he_aia, c_color, pos, tag
	
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
	plot_map, map_nrh, /overlay, /cont, levels=levels, c_color=c_color, /noxticks, /noyticks
	angstrom = '!6!sA!r!u!9 %!6!n'
	
	xyouts,pos[0]+0.01,pos[1]+0.05,'AIA 193 '+angstrom+' '+anytim(he_aia.date_obs,/yoh,/trun)+' UT', color = 0,/normal,charsize=1.0,charthick=1
	xyouts,pos[0]+0.01,pos[3]-0.04,tag, color = 1,/normal,charsize=1.5,charthick=1
	;xyouts,pos[0]+0.01, pos[1]+0.05, '(a)',  color = 0,/normal,charsize=1.0,charthick=1
	
	xyouts,pos[0]+0.01,pos[1]+0.03,'NRH 150.9 MHz '+anytim(nrh_hdr[index_nrh].date_obs,/yoh,/trun)+' UT', color = 3, /normal,charsize=1.0,charthick=1
	
	;'AIA 193 '+angstrom+' '+anytim(he_aia.date_obs,/yoh,/trun)+' UT'
	xyouts,pos[0]+0.01,pos[1]+0.01,'NRH 445.0 MHz '+anytim(nrh_hdr[index_nrh].date_obs,/yoh,/trun)+' UT', color = 5, /normal,charsize=1.0,charthick=1
END	







