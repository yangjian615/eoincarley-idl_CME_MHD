function masks_for_fft, hdr

	IF hdr.detector eq 'COR1' or hdr.detector eq 'COR2' THEN BEGIN
		mask = fltarr(hdr.naxis1, hdr.naxis2)
		mask[*,*] = 1.0
		rsun = hdr.rsun
		pixrad=rsun/hdr.CDELT1
		sun = scc_SUN_CENTER(hdr)
		IF hdr.detector eq 'COR1' THEN r_outer = 1.4
		IF hdr.detector eq 'COR1' THEN r_inner = 0.4
		
		
		index_outer = circle_mask(mask, sun.XCEN, sun.YCEN, 'ge', pixrad*r_outer)
		mask[index_outer] = 20.0
		index_outer = circle_mask(mask, sun.XCEN, sun.YCEN, 'le', pixrad*r_inner)
		mask[index_outer] = 20.0
	ENDIF	
		
return,mask	
END		
