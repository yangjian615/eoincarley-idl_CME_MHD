pro create_composite_img_v5

; Similar to create_composite_img but now with AIA. Intended use: make movie of AIA and NRH
; create_composite_img still useful for plotting LASCO, NRH, SWAP
; v3 the NRH map creation is functionalised in this version 

; v4 calls plot_low_mid_20110922_v2, which doesn't plot goes

; v5 now plots ps to make movie from

;Device, RETAIN=2
t1 = anytim(file2time('20110922_103500'),/utim)
t2 = anytim(file2time('20110922_111000'),/utim)

goes = latest_goes_v1_20110922('20110922_103500','20110922_105900')

;***************  		CALLISTO DATA		********************;
cd,'/Users/eoincarley/Data/CALLISTO/20110922'

files = findfile('*.fit')
radio_spectro_fits_read,files[1], low1data, l1time, lfreq
radio_spectro_fits_read,files[4], low2data, l2time, lfreq
radio_spectro_fits_read,files[2], mid1data, m1time, mfreq
radio_spectro_fits_read,files[5], mid2data, m2time, mfreq


;Put in the FM band blackout
low_FM_index = where(lfreq gt 90.0)
low_data = [low1data, low2data]
low_times = [l1time, l2time]

;Put in the FM band blackout
mid_FM_index = where(mfreq lt 112.0)
mid_data = [mid1data, mid2data]
mid_times = [m1time, m2time]

low_data_bg = constbacksub(low_data, /auto)
mid_data_bg = constbacksub(mid_data, /auto)
low_data_bg[*,  low_FM_index[0] : low_FM_index[n_elements(low_FM_index)-1] ] = -15.0
mid_data_bg[*,  mid_FM_index[0] : mid_FM_index[n_elements(mid_FM_index)-1] ] = -10.0

mean_low = fltarr(n_elements(low_times))
mean_mid = fltarr(n_elements(mid_times))
mean_all = fltarr(n_elements(low_times))
FOR i=0, n_elements(low_times)-1 DO BEGIN
	mean_low[i] = mean(low_data[i,*])
	mean_mid[i] = mean(mid_data[i,*])
	mean_all[i] = mean([mean_low[i], mean_mid[i]])
ENDFOR	

 
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
	
	
	print,'                       '
	print,'Finished reading NRH data'
	print,'                       '
	
	!p.font=0
	!p.charsize=1.0
	

FOR i=10, 19 DO BEGIN ;n_elements(f)-1 DO BEGIN
	print,i
	cd,'/Users/eoincarley/Data/22sep2011_event/AIA'

	
	read_sdo, f[i], he_aia, data_aia
	read_sdo, f[i-5], he_aia_pre, data_aia_pre
	set_plot,'ps'
	device, filename=he_aia.date_obs+'.ps', /Helvetica, /color, /inches, /landscape, /encapsulate,$
	xs=14, ys=8, bits_per_pixel=8, yoffset=14
	
	index2map, he_aia_pre, smooth(temporary(data_aia_pre), 7)/he_aia_pre.exptime, map_aia_pre, outsize = 1024
	index2map, he_aia, smooth(temporary(data_aia), 7)/he_aia.exptime, map_aia, outsize = 1024
	
	map_aia.dx = he_aia.CDELT1*4.0	
	map_aia.dy = he_aia.CDELT2*4.0
	map_aia.xc = he_aia.SAT_Y0/4.0
	map_aia.yc = he_aia.SAT_Z0/4.0 

	loadct,39
   	plot_low_mid_20110922_v3, he_aia.date_obs, goes, low_data_bg, low_times, mid_data_bg, mid_times, $
   	low_data, mid_data, lfreq, mfreq, mean_low, mean_mid, mean_all
   	
	
	;------------------------   Plot the C2 image   ******************; 
	;	In this version (create_composite_img_v3) it doesn't matter what C2 image.
	;	It's only used as base onto which AIA and NRH can be overplot

	loadct,0
	stretch,0,170

	index = circle_mask(c2_data, suncenter.xcen, suncenter.ycen, 'le', pixrad*2.1)
	c2_data_edit = c2_data
	c2_data_edit[*,*] = mean(c2_data/max(c2_data))-0.3
	c2_data_edit[index]= -0.1
	mapc2 = make_map(c2_data_edit)
	mapc2.dx = 11.9
	mapc2.dy = 11.9
	mapc2.xc = 14.4704
	mapc2.yc = 61.2137
	axes_thickness=3
	loadct,0
	
	FOV = [40.0,40.0]
	CENTER = [-1300.0, 50.0]
	plot_map, mapc2, /notitle, fov = FOV, center = CENTER, $
	position = [0.51, 0.1, 0.98, 0.97],  /noerase, dmin=-0.5, dmax=1,$
	xtickv=[-1500, -1000, -500], xticks=2, xminor=5, $
	xticklen=-0.01, ytickv=[-1000, -500, 0, 500], yticks=3, yminor=5, $
	yticklen=-0.01, ytitle=' '
	 
	xyouts, 0.48, 0.535,'Y (arcsecs)', /normal, orientation=90.0, alignment=0.5 
  
	
	
	;--------------        Make the AIA map and plot        ---------------;
	; 																	   ;
	
		
	loadct,1
	;stretch,-60,150
	;gamma_ct,2.0
	;aia_lct, rr, gg, bb, wave=211, /load
	;
	;Normal plot with usaturated colour scale was achived with device, retain=0, and /average keyword here
	plot_map, diff_map(map_aia, map_aia_pre), /composite, /noaxes, /average, dmin=-6.0, dmax=3.0

	set_line_color
	plot_helio, he_aia.date_obs, /over, gstyle=0, gthick=2.0, gcolor=1, grid_spacing=15.0
	

	;-------------------           NRH DATA           ---------------------;
	;					   Obtain closest NRH image  					   ;
	
	overplot_nrh, nrh_times_150, nrh_data_150, nrh_hdr_150, he_aia, 2
	device,/close
	set_plot,'x'
	
	;wset, 0 & rgbSnapshot = tvrd(TRUE=1)
        ;write_png, he_aia.date_obs+'.png', rgbSnapshot
	;x2png,he_aia.date_obs+'.png'

ENDFOR	
;save,nrh_total_flux_150,time_nrh_total_flux,filename='nrh_total_flux_150.sav'

END

pro overplot_nrh, nrh_times, nrh_data, nrh_hdr, he_aia, c_color
	
	index_nrh = closest(anytim(nrh_times,/utim), anytim(he_aia.date_obs,/utim)  )

	nrh_data_select = alog10( smooth(nrh_data[*,*,index_nrh],3) )
	map_nrh = make_map(nrh_data_select)
	map_nrh.dx = 29.9410591125
	map_nrh.dy = 29.9410591125
	map_nrh.xc = 64.0
	map_nrh.yc = 64.0
	
	max_val = max( alog10(nrh_data[*,*,index_nrh]) ,/nan)
	
	nlevels=5
	levels = (dindgen(nlevels)*(max_val - max_val*0.95)/(nlevels-1)) + max_val*0.95
	loadct,33
	intens = (dindgen(101)*(0.9 - 0.7)/100.0)+0.7 ;intesnities scaled between 10^7 K to 10^9 K
	cols = (dindgen(101)*(220 - 70)/100)+70  ;choose the color range to represent these intensities.
	colors = round(interpol(cols, intens, levels/9.0)) ;c
	
	plot_map, map_nrh, /overlay, /cont, levels=levels, c_color=colors, thick=5.0
	;plot_map, map_nrh, /over, /composition, /interlace;, levels=levels, c_color=c_color, cthick=10.0, thick=5.0
	;plot_map, map_nrh, /overlay, /cont, levels=levels, c_color=0, cthick=10.0, thick=1.0
	set_line_color
	angstrom = 'A'
	
	xyouts,0.52,0.15,'AIA 211 '+angstrom+' '+anytim(he_aia.date_obs,/yoh,/trun)+' UT', color = 1,/normal
	
	xyouts,0.52,0.12,'NRH 150.9 MHz '+anytim(nrh_hdr[index_nrh].date_obs,/yoh,/trun)+' UT', color = 1, /normal
	
END	






