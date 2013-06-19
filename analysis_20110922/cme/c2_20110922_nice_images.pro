pro c2_20110922_nice_images

cd,'/Users/eoincarley/Data/22sep2011_event/LASCO_C2/L0.5/L1'

files = findfile('*.fts')
pre = lasco_readfits(files[0], he_pre)
mask = lasco_get_mask(he_pre)
pre = pre*mask
pre_filt = disk_nrgf(pre, he_pre, 0, 0) > (-5.0) < 5.0


!p.multi=[0,1,1]
device, retain =2
loadct,3
window, 0 , xs=700, ys=700
FOR i=3, n_elements(files)-1 DO BEGIN
	
	;pre = lasco_readfits(files[i-1], he_pre)
	;pre = pre*mask
	;pre_filt = disk_nrgf(pre, he_pre, 0, 0) >(-5.0) <5.0
	img = lasco_readfits(files[i], he)
	img = temporary(img)*mask
	img = temporary(img) ;- pre
	img = img/stdev(img)
	
	;--------   Simple base difference   ------------
	mass_image = scc_calc_cme_mass(img, he, /all, pos=0.0)
	mass_image = mass_image/stdev(mass_image)
	plot_image, mass_image > (-1.0) < 3.0, charsize=2.0,$
	;plot_image, img > (-1.0) < 3.0, charsize=2.0,$
	title='Base Difference Only'
	xyouts, 0.19, 0.16, he.date_obs, /normal, charsize=2.0
	suncen = get_suncen(he)
	tvcircle, (he.rsun/he.cdelt1), suncen.xcen, suncen.ycen, 254, /data, color=255, thick=2
	;x2png,'bd_'+he.date_obs+'.png'
	stop
	
	;--------- Base Diff and Log ---------
	; THIS PLOT SHOWS CORONAL RECOIL ON THE OPPOSITE SIDE OF SUN QUITE WELL
	;plot_image, filter_image(alog(img) > (-7.0), /median), $
	;title='Base Difference and Image Log', charsize=2
	;xyouts, 0.19, 0.16, he.date_obs, /normal, charsize=2.0
	;suncen = get_suncen(he)
	;tvcircle, (he.rsun/he.cdelt1), suncen.xcen, suncen.ycen, 254, /data,color=255,thick=2
	;x2png,'bd_log_'+he.date_obs+'.png'
	
	
	;---------- Normalizing Radial Gradient Filter -----------
	;plot_image, disk_nrgf(img, he , 0, 0) >(-2.0) <3.0,$
	;title='Norm Rad Grad Filter, no differencing', charsize=2
	;xyouts, 0.19, 0.16, he.date_obs, /normal, charsize=2.0
	;suncen = get_suncen(he)
	;tvcircle, (he.rsun/he.cdelt1), suncen.xcen, suncen.ycen, 254, /data,color=255,thick=2
	;x2png,'nrgf_'+he.date_obs+'.png'
	
	;nrgf on its own and nrgf(alog10) not so goof at bringing it out
	;plot_image, (disk_nrgf(alog(img), he, 0, 0)) >(-5.0)
	
	;plot_image, alog10((disk_nrgf(img, he, 0, 0)) > (-5.0) < 5.0)
	
	;TERRIBLE
	;plot_image, alog10(disk_nrgf(img, he, 0, 0)) 
	
	;----------   NRGF(img) - NRGF(pre_event)   -----------
	;img_filt = disk_nrgf(img, he, 0, 0) >(-2.0) <3.0
	;img_bs = img_filt - pre_filt
	;plot_image, bytscl(img_bs, -2.0, 2.0) , $
	;title='NRGF(img) - NRGF(pre_event)', charsize=2
	;xyouts, 0.19, 0.16, he.date_obs, /normal, charsize=2.0
	;suncen = get_suncen(he)
	;tvcircle, (he.rsun/he.cdelt1), suncen.xcen, suncen.ycen, 254, /data,color=255,thick=2
	;x2png,'nrgf_bd_'+he.date_obs+'.png'
ENDFOR



END