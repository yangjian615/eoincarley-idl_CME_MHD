pro create_composite_img_v4

; Similar to create_composite_img but now with AIA. Intended use: make movie of AIA and NRH
; create_composite_img still useful for plotting LASCO, NRH, SWAP
; v3 the NRH map creation is functionalised in this version 

; v4 calls plot_low_mid_20110922_v2, which doesn't plot goes


t1 = anytim(file2time('20110922_103900'),/utim)
t2 = anytim(file2time('20110922_111000'),/utim)

goes = latest_goes_v1_20110922('20110922_103500','20110922_105900')

;***************  		CALLISTO DATA		********************;
cd,'/Users/eoincarley/Data/CALLISTO/20110922'

files = findfile('*.fit')
radio_spectro_fits_read,files[0], low1data, l1time, lfreq
radio_spectro_fits_read,files[2], low2data, l2time, lfreq
radio_spectro_fits_read,files[1], mid1data, m1time, mfreq
radio_spectro_fits_read,files[3], mid2data, m2time, mfreq


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

stop
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
	

window,0,xs=1000,ys=700
FOR i=1, 183 DO BEGIN ;n_elements(f)-1 DO BEGIN
	cd,'/Users/eoincarley/Data/22sep2011_event/NRH/NRH_AIA_pdf'
	;set_plot,'ps'
	;device,filename = 'AIA_193_NRH150_445-'+string(i, format='(I2.2)')+'.ps',$
	;/color,/inches,/landscape,/encapsulate,$
	;ysize=6,xsize=12, bits_per_pixel=8, yoffset=12

	cd,'/Users/eoincarley/Data/22sep2011_event/AIA'
	restore,'22_09_2011_xy_pulse_distance_160_arc.sav',/verb
	read_sdo, f[i], he_aia, data_aia
	read_sdo, f[i-1], he_aia_pre, data_aia_pre
	data_aia_bs = data_aia/he_aia.exptime - data_aia_pre/he_aia_pre.exptime
	loadct,39
	!p.color=0
	!p.background=255
   	plot_low_mid_20110922_v2, he_aia.date_obs, goes, low_data_bg, low_times, mid_data_bg, mid_times, $
   	low_data, mid_data, lfreq, mfreq, mean_low, mean_mid, mean_all
   	

   	loadct,0
	stretch,0,170
	
	;*****************   Plot the C2 image   ******************; 
	;	In this version (create_composite_img_v3) it doesn't matter what C2 image.
	;	It's only used as base onto which AIA and NRH can be overplot

	plot_map,mapc2,/notitle,/nolabels,fov = [30.0,30.0],center = [-850.0,-100.0],$
	position=[0.5,0.08,0.97,0.97], /isotropic, /noerase
	;[0.5,0.08,0.97,0.97]
	;***********        Make the AIA map and plot         *********

	map_aia = make_map( smooth(data_aia_bs,10) )
	map_aia.dx = he_aia.CDELT1	
	map_aia.dy = he_aia.CDELT2
	map_aia.xc = he_aia.SAT_Y0
	map_aia.yc = he_aia.SAT_Z0 
	plot_map, map_aia, /composite, /average, dmin = -10, dmax = 10
	plot_helio, file2time('20110922_104600'), /over, gstyle=0, gthick=1, gcolor=0, grid_spacing=10.0

	;Plot AIA positions of EUV wave.
	;pulse_x = remove_nans(pulse_x)
	;pulse_y = remove_nans(pulse_y)
	;plots, pulse_x, pulse_y, psym=1, symsize=3
	;stop

	;*********             NRH DATA           *************;
	;***********   Obtain closest NRH image  **************;
	
	overplot_nrh, nrh_times_150, nrh_data_150, nrh_hdr_150, he_aia, 3

	overplot_nrh, nrh_times_445, nrh_data_445, nrh_hdr_445, he_aia, 5
stop
	
ENDFOR	
;save,nrh_total_flux_150,time_nrh_total_flux,filename='nrh_total_flux_150.sav'

END

pro overplot_nrh, nrh_times, nrh_data, nrh_hdr, he_aia, c_color
	
	index_nrh = closest(anytim(nrh_times,/utim), anytim(he_aia.date_obs,/utim)  )

	nrh_data_select = alog10( nrh_data[*,*,index_nrh] )
	map_nrh = make_map(nrh_data_select)
	map_nrh.dx = 29.9410591125
	map_nrh.dy = 29.9410591125
	map_nrh.xc = 64.0
	map_nrh.yc = 64.0
	
	max_val = max( alog10(nrh_data[*,*,*]) ,/nan)
	
	levels = (dindgen(20.0)*(max_val - max_val*0.9)/19.0) + max_val*0.9
	set_line_color 
	plot_map, map_nrh, /overlay, /cont, levels=levels, c_color=c_color
	angstrom = '!6!sA!r!u!9 %!6!n'
	;xyouts,0.51,0.17,'AIA 193 '+angstrom+' '+anytim(he_aia.date_obs,/yoh,/trun)+' UT', color= 1,/normal,charsize=2.0,charthick=4
	xyouts,0.51,0.16,'AIA 193 '+angstrom+' '+anytim(he_aia.date_obs,/yoh,/trun)+' UT', color = 0,/normal,charsize=1.0,charthick=1
	
	;xyouts,0.51,0.15,'NRH 150 MHz '+anytim(nrh_hdr[index_nrh].date_obs,/yoh,/trun)+' UT', color=1, /normal,charsize=2.0,charthick=4
	xyouts,0.51,0.13,'NRH 150.9 MHz '+anytim(nrh_hdr[index_nrh].date_obs,/yoh,/trun)+' UT', color = 3, /normal,charsize=1.0,charthick=1
	
	;xyouts,0.51,0.13,'NRH 450 MHz '+anytim(nrh_hdr[index_nrh].date_obs,/yoh,/trun)+' UT', color=1, /normal,charsize=2.0,charthick=4
	xyouts,0.51,0.1,'NRH 445.0 MHz '+anytim(nrh_hdr[index_nrh].date_obs,/yoh,/trun)+' UT', color = 5, /normal,charsize=1.0,charthick=1
END	






