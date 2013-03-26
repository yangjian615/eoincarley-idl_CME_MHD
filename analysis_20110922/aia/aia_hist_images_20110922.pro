pro aia_hist_images_20110922

	;Plot hists of various AIA images
	cd,'/Users/eoincarley/Data/22sep2011_event/AIA'
	aia_files = findfile('aia*')
	read_sdo,aia_files[0], he_aia0, data_aia0
	a=histogram(data_aia0,binsize=1)              
 	binsa = FINDGEN(N_ELEMENTS(a)) + MIN(data_aia0)
 	loadct,39
 	!p.color=0
 	!p.background=255
 	plot,binsa,a,yr=[10,1e8],/ylog,charsize=1.5,xtitle='Pixel Value',$
 	ytitle='Number of pixels with value',title='Histograms AIA 193 Ang images, 2011-Sep-22'
 	
 	loadct,39
 	read_sdo,aia_files[1], he_aia1, data_aia1
	b=histogram(data_aia1,binsize=1)              
 	binsb = FINDGEN(N_ELEMENTS(b)) + MIN(data_aia1)
 	oplot,binsb,b,color=240
 	
 	read_sdo,aia_files[16], he_aia2, data_aia2
	c=histogram(data_aia2,binsize=1)              
 	binsc = FINDGEN(N_ELEMENTS(c)) + MIN(data_aia2)
 	oplot,binsc,c,color=100
 	
 	legend,['Base image: '+anytim(he_aia0.date_obs,/yoh,/time_only,/trun)+' UT', $
 	'Image 1: '+anytim(he_aia1.date_obs,/yoh,/time_only,/trun)+' UT',$
 	'Image 2: '+anytim(he_aia2.date_obs,/yoh,/time_only,/trun)+' UT'],$
 	color=[0,240,100],linestyle=[0,0,0],charsize=1.5
 	
 	loadct,0
 	window,2
 	!p.multi=[0,2,1]
 	data = data_aia1 - data_aia0
 	plot_image,sigrange(data),title='Base difference Image 1',charsize=1.5
 	data = data_aia2 - data_aia0
 	plot_image,sigrange(data),title='Base difference Image 2',charsize=1.5
 	
END 	
 	
	