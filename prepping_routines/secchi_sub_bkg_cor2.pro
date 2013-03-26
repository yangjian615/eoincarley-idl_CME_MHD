pro secchi_sub_bkg_cor2, check_seq = CHECK_SEQ


;This preps a secchi image and subtracts a minimum monthly background,

;Badly written could do with cleaning up.

files = findfile('*n*.fts')

;If image are in polarization 'sequence' or 'normal' images check to see the three 
;polarizations are there.

    
    
    i=0.0 
		;Check polarization sequence
		hdr0 = scc_fitshdr2struct(HEADFITS(files[i]))
		hdr1 = scc_fitshdr2struct(HEADFITS(files[i+1]))
		hdr2 = scc_fitshdr2struct(HEADFITS(files[i+2]))
		
		polar_seq = [hdr0.polar, hdr1.polar, hdr2.polar]
		index = sort([hdr0.polar, hdr1.polar, hdr2.polar])
		print,polar_seq
		IF polar_seq[index[0]] eq [0.0] and polar_seq[index[1]] eq [120.0] and polar_seq[index[2]] eq [240.0] THEN BEGIN
			secchi_prep_vtest,files[i:i+2], hdr, img, /rotate_on, /polariz_on, /write_fits
    	ENDIF ELSE BEGIN
    		;BREAK
    	ENDELSE
   
    	mask = get_smask(hdr)
    	pre_event = img*mask

  
	;FOR i = 6, 8 DO BEGIN; n_elements(files)-1, 3 DO BEGIN 
	i=6.0 
		;Check polarization sequence
		hdr0 = scc_fitshdr2struct(HEADFITS(files[i]))
		hdr1 = scc_fitshdr2struct(HEADFITS(files[i+1]))
		hdr2 = scc_fitshdr2struct(HEADFITS(files[i+2]))
		
		polar_seq = [hdr0.polar, hdr1.polar, hdr2.polar]
		index = sort([hdr0.polar, hdr1.polar, hdr2.polar])
		print,polar_seq
		IF polar_seq[index[0]] eq [0.0] and polar_seq[index[1]] eq [120.0] and polar_seq[index[2]] eq [240.0] THEN BEGIN
			secchi_prep_vtest,files[i:i+2], hdr, img, /rotate_on, /polariz_on
    	ENDIF ELSE BEGIN
    		;BREAK
    	ENDELSE
   
    	mask = get_smask(hdr)
    	img = img*mask
    	;wset,9
    	
    	mask2 = dblarr(hdr.NAXIS1, hdr.NAXIS2)
		mask2[*,*] = 1.0
		rsun = get_solar_radius(hdr)
		pixrad=rsun/hdr.CDELT1
		sun = scc_SUN_CENTER(hdr)
		index_outer = circle_mask(mask, sun.XCEN, sun.YCEN, 'ge', pixrad*15.0)
		mask2[index_outer] = 0.0
    	
    	img = img*mask
    	img = img*mask2
    	
    	pre_event = pre_event*mask
    	pre_event = pre_event*mask2
    	wset,9
    	!p.multi=[0,1,1]
    	
    	
    	img_bs = img - pre_event
    	
    	
    	
    	plot_image, img_bs > (-2.5e-11) < 5.0e-11, title=hdr.detector +' A '+hdr.date_obs,$
    	charsize=2.0
    	
    	suncen = get_suncen(hdr)
		tvcircle, (hdr.rsun/hdr.cdelt1), suncen.xcen, suncen.ycen, 254, /data,color=255,thick=2
		
		;------------------------
		result = radial_gradient_filter(img_bs,hdr)
		window,10,xs=700,ys=700
		plot_image,sigrange(result)
    

    	
    	   	
    	
    ;ENDFOR
    

stop
END