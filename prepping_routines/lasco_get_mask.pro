function lasco_get_mask,hdr
	
	IF hdr.DETECTOR eq 'C2' THEN occult_r = 2.2
	IF hdr.DETECTOR eq 'C3' THEN occult_r = 5.95
	
	IF hdr.DETECTOR eq 'C2' THEN occult_outer = 6.0
	IF hdr.DETECTOR eq 'C3' THEN occult_outer = 30.5
	
	mask = dblarr(hdr.NAXIS1, hdr.NAXIS2)
	mask[*,*] = 1.0
	rsun = hdr.rsun
	pixrad=rsun/hdr.CDELT1
	sun = scc_SUN_CENTER(hdr)
	index_occulter = circle_mask(mask, sun.XCEN, sun.YCEN, 'le', pixrad*occult_r)
	mask[index_occulter] = 0.0
	
	index_outer = circle_mask(mask, sun.XCEN, sun.YCEN, 'ge', pixrad*occult_outer)
	mask[index_outer] = 0.0
		
return,mask	

END