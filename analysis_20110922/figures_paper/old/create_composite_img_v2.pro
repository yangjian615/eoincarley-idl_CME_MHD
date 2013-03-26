pro create_composite_img_v2

;Similar to create_composite_img but now with AIA. Intended use: make movie of AIA and NRH
;create_composite_img still useful for plotting LASCO, NRH, SWAP

t1 = anytim(file2time('20110922_103500'),/utim)
t2 = anytim(file2time('20110922_105900'),/utim)


goes=latest_goes_v1_20110922('20110922_103500','20110922_105900')



cd,'/Users/eoincarley/Data/CALLISTO/20110922'

files = findfile('*.fit')
radio_spectro_fits_read,files[0], low1data, l1time, lfreq
radio_spectro_fits_read,files[2], low2data, l2time, lfreq
radio_spectro_fits_read,files[1], mid1data, m1time, mfreq
radio_spectro_fits_read,files[3], mid2data, m2time, mfreq

low_data = [low1data, low2data]
low_times = [l1time, l2time]

mid_data = [mid1data, mid2data]
mid_times = [m1time, m2time]

low_data_bg = constbacksub(low_data, /auto)
mid_data_bg = constbacksub(mid_data, /auto)

mean_low = fltarr(n_elements(low_times))
mean_mid = fltarr(n_elements(mid_times))
mean_all = fltarr(n_elements(low_times))
FOR i=0, n_elements(low_times)-1 DO BEGIN
	mean_low[i] = mean(low_data[i,*])
	mean_mid[i] = mean(mid_data[i,*])
	mean_all[i] = mean([mean_low[i], mean_mid[i]])
ENDFOR	





cd,'/Users/eoincarley/Data/22sep2011_event/LASCO_C2/L0.5/L1'
files=findfile('*.fts')
file = files[4]
c2_data = readfits(file,c2_hdr) 
pre_data = readfits('24373725.fts',pre_hdr)
c2_bs_data = c2_data - pre_data
junk = lasco_readfits(file,c2_hdr_struc)
print,'C2 time: '+anytim(c2_hdr_struc.date_obs,/yoh)

	c2_data = c2_bs_data
	cd,'/Users/eoincarley/Data/22sep2011_event/LASCO_C2/L0.5/L1'

	junk= lasco_readfits('24373729.fts',hdr) 
	rsun = get_solar_radius(hdr)
	pixrad=rsun/hdr.cdelt1
	suncenter=get_sun_center(hdr)
	index = circle_mask(c2_data, suncenter.xcen, suncenter.ycen, 'le',pixrad*2.1)
	c2_data[index] = 0.0

	mapc2 = make_map(bytscl(c2_data,-5.0e-10,1.5e-9)  )
	mapc2.dx = 11.9
	mapc2.dy = 11.9
	mapc2.xc = 14.4704
	mapc2.yc = 61.2137




;           Read in the AIA pre image             ;
cd,'/Users/eoincarley/Data/22sep2011_event/AIA'
aia_files = findfile('aia*.fits')
read_sdo,aia_files[0], he_aia_pre, data_aia_pre


;           Read in data proper AIA         
mreadfits_header, aia_files, ind, only_tags='exptime'
f = aia_files[where(ind.exptime gt 1.)]
;window,2,xs=800,ys=800

window,10,xs=1300,ys=1000
nrh_total_flux_150 = 0.0
time_nrh_total_flux = 0.0

FOR i=1,183 DO BEGIN;n_elements(f)-1 DO BEGIN
    ;wset,10
	
	cd,'/Users/eoincarley/Data/22sep2011_event/AIA'

	read_sdo,f[i], he_aia, data_aia
	read_sdo,f[i-1], he_aia_pre, data_aia_pre
	data_aia_bs = data_aia/he_aia.exptime - data_aia_pre/he_aia_pre.exptime
	loadct,39
	!p.color=0
	!p.background=255
   	plot_low_mid_20110922, he_aia.date_obs, goes, low_data_bg, low_times, mid_data_bg, mid_times,$
   	low_data, mid_data, lfreq, mfreq, mean_low, mean_mid, mean_all

   	loadct,0
	stretch,0,170
	
	;*****************   Plot the C2 image   ******************; 
	;	In this version (create_composite_img_v2) it doesn't matter what c2 image.
	;	It's only used as base onto which AIA and NRH can be overplot

	plot_map,mapc2,/notitle,/nolabels,fov = [30.0,30.0],center = [-850.0,-100.0],$
	position=[0.5,0.2,0.97,0.9], /isotropic, /noerase
	xyouts,0.55,0.87,'AIA 193 Angstrom '+anytim(he_aia.date_obs,/yoh,/trun)+' UT', color=0,/normal,charsize=2.0,charthick=1
	xyouts,0.55,0.85,'NRH 150 MHz (Red) '+anytim(nrh_hdr[index_nrh].date_obs,/yoh,/trun)+' UT', color=0,/normal,charsize=2.0,charthick=1
	xyouts,0.55,0.83,'NRH 450 MHz (Blue) '+anytim(nrh_hdr[index_nrh].date_obs,/yoh,/trun)+' UT', color=0,/normal,charsize=2.0,charthick=1


	;***********        Make the AIA map          *********

	map_aia = make_map( smooth(data_aia_bs,10) )
	map_aia.dx = he_aia.CDELT1	
	map_aia.dy = he_aia.CDELT2
	map_aia.xc = he_aia.SAT_Y0
	map_aia.yc = he_aia.SAT_Z0 
	plot_map,map_aia,/composite,/average,dmin = -10, dmax = 10



	;*********             NRH DATA           *************
	;***********    Obtain closest NRH image **************;
	tstart = anytim(anytim(he_aia.date_obs,/utim)-10.0,/yoh,/trun,/time_only)
	tend   = anytim(anytim(he_aia.date_obs,/utim)+10.0,/yoh,/trun,/time_only)
	
	choose_nrh_image, '1509', he_aia, map_nrh, nrh_data, tstart, tend
	
	levels=(dindgen(7.0)*(max(nrh_data) - max(nrh_data)*0.5)/6.0)+max(nrh_data)*0.5
	set_line_color 
	plot_map,map_nrh,/overlay,/cont,levels=levels,c_color=3



	;***********		Second NRH      ****************

	choose_nrh_image, '4450', he_aia, map_nrh, nrh_data, tstart, tend
	
	levels=(dindgen(7.0)*(max(nrh_data) - max(nrh_data)*0.5)/6.0)+max(nrh_data)*0.5
	set_line_color 
	plot_map,map_nrh,/overlay,/cont,levels=levels,c_color=3
    
    
	cd,'NRH_AIA'
	x2png,string(i)+'.png'
	
ENDFOR	
;save,nrh_total_flux_150,time_nrh_total_flux,filename='nrh_total_flux_150.sav'
;stop
END

pro choose_nrh_image,freq,he_aia, map_nrh, nrh_data, tstart, tend

	cd,'/Users/eoincarley/data/22sep2011_event/nrh'
	read_nrh,'nrh2_'+freq+'_h70_20110922_081556c06_i.fts', nrh_hdr, nrh_data, hbeg=tstart, hend=tend
	index2map, nrh_hdr, nrh_data, nrh_struc  
	nrh_struc_hdr = nrh_hdr
	nrh_times = nrh_hdr.date_obs
	index_nrh = closest(anytim(nrh_times,/utim), anytim(he_aia.date_obs,/utim)  )

	nrh_data = nrh_data[*,*,index_nrh]
	map_nrh = make_map(nrh_data)
	map_nrh.dx = 29.9410591125
	map_nrh.dy = 29.9410591125
	map_nrh.xc = 64 
	map_nrh.yc = 64  
	
END	






