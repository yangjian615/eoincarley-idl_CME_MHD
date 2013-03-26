function radial_gradient_filter_v2, img, hdr

;still not working....

    img_rad_filt = dblarr(hdr.naxis1, hdr.naxis2)
    plot_image,img > (-2.5e-11) < 5.0e-11, title=hdr.detector +' A '+hdr.date_obs,$
    charsize=2.0
    	old_x = 3000.0
    suncen = get_suncen(hdr)
	tvcircle, (hdr.rsun/hdr.cdelt1), suncen.xcen, suncen.ycen, 254, /data,color=255,thick=2
	sim_x = dindgen(hdr.naxis1)
	sim_y = dindgen(hdr.naxis2)
	
	angle=( dindgen(15001.0)*(360.0 - 0.0)/15000.0 ) + 0.0
	j=angle+90.0
  	eta = j*!DTOR
		FOR i=4.0, 14.0, 0.015  DO BEGIN
			angle_profile = dblarr(n_elements(angle))
			sun = scc_SUN_CENTER(hdr)
    		xs = COS(eta) * (hdr.rsun/hdr.cdelt1)*i + sun.XCEN
    		ys = SIN(eta) * (hdr.rsun/hdr.cdelt2)*i + sun.YCEN
 			print,'Rsun : '+string(i)
    		annulus = INTERPOLATE(img,xs,ys)	; do bilinear interpolation to pick up the line
    		plots,xs,ys,color=255
    		FOR j=0, n_elements(xs)-1 DO BEGIN
    			;Closest pixel pos to current x and j
    			closest_x = closest(sim_x, xs[j])
    			closest_y = closest(sim_y, ys[j])
    			IF closest_x ne old_x THEN BEGIN 
    				img_rad_filt[closest_x, closest_y] = (img[ closest_x, closest_y] - mean(annulus))/stdev(annulus)
    				;print,'At position '+string( [closest_x, closest_y])+' the value is ' +string(img[ closest_x, closest_y])
    			ENDIF
    			old_x = closest_x
    			old_y = closest_x
    			
    			
    		ENDFOR	
  		ENDFOR
  return,img_rad_filt
    
END    