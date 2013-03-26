function masks_for_20110607, hdr

	IF hdr.detector eq 'COR1' or hdr.detector eq 'COR2' THEN BEGIN
		mask = get_smask(hdr)
		rsun = hdr.rsun
		pixrad=rsun/hdr.CDELT1
		sun = scc_SUN_CENTER(hdr)
		IF hdr.detector eq 'COR1' THEN r_outer = 4.5
		IF hdr.detector eq 'COR2' THEN r_outer = 14.0
		index_outer = circle_mask(mask, sun.XCEN, sun.YCEN, 'ge', pixrad*r_outer)
		mask[index_outer] = 0.0
	ENDIF	
		IF hdr.detector eq 'C2' THEN mask = lasco_get_mask(hdr)
		IF hdr.detector eq 'C3' THEN mask = lasco_get_mask(hdr)
	
return,mask	
END		
