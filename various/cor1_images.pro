pro coronagraph_images

; 17-Jun-2011. Passing bits and bobs of code onto Jason. Used to produce the CME images 
; for the 22-Sep-2011 event.
; 
; E. Carley
;

;-------------------------------------------;
;			Plot the COR1 Data
;-------------------------------------------;

cd,'~/Desktop/jason_data/cor1'
!p.charsize=1.5

loadct,1
window,0
files = findfile('*.fts')
pre = sccreadfits(files[5],he_pre) 
data = sccreadfits(files[13],he)
;These are the pre-event and object imaged used for Figure 4 of the Nat Phys draft

img = data - pre
mask = get_smask(he)
stop
img = img*mask
img = img/stdev(img)
plot_image, img > (-3.0) < 4.0, title = he.detector+' '+he.date_obs  
;For later images I tweak thes values to bring out the faint front.
							   

;-------------------------------------------;
;			Plot the C2 Data
;-------------------------------------------;

cd,'~/Desktop/jason_data/c2'
files = findfile('*.fts')
pre = lasco_readfits(files[0], he_pre) ;
img = lasco_readfits(files[6], he)
mask = lasco_get_mask_v2(he_pre)
img = temporary(img) - pre
img = img/stdev(img)
img = temporary(img)*mask
loadct,3
window,1
plot_image, filter_image(alog(img) > (-7.0)  , /median), $
title=he.detector+' '+he.date_obs
; Again the values are tweaked for to produce nice images by eye.


;-------------------------------------------;
;			Plot the C3 Data
;-------------------------------------------;

cd,'~/Desktop/jason_data/c3'


files = findfile('*.fts')
pre = lasco_readfits(files[0], he_pre)
img = lasco_readfits(files[5], he)
mask = lasco_get_mask_v2(he_pre)
img = temporary(img) - pre
img = img/stdev(img)
img = temporary(img)*mask
	
window, 3	
plot_image, filter_image(alog(img) > (-7.0), /median), $
title=he.detector+' '+he.date_obs


END


function lasco_get_mask_v2, hdr, set_zero = set_zero
	
	; Return a mask for the LASCO C2 or C3 corongraph
	; Choose occulter sizes as required
	
	; Keyword
	;	-set_sero: return zeros at occulter positions. Default is NaNs.	
	
	;E. Carley Sep-2012
	
	IF hdr.DETECTOR eq 'C2' THEN occult_inner = 2.2
	IF hdr.DETECTOR eq 'C3' THEN occult_inner = 5.95
	
	IF hdr.DETECTOR eq 'C2' THEN occult_outer = 6.0
	IF hdr.DETECTOR eq 'C3' THEN occult_outer = 30.5
	
	mask = dblarr(hdr.NAXIS1, hdr.NAXIS2)
	mask[*,*] = 1.0
	rsun = hdr.rsun
	pixrad=rsun/hdr.CDELT1
	sun = scc_SUN_CENTER(hdr)
	index_occulter = circle_mask(mask, sun.XCEN, sun.YCEN, 'le', pixrad*occult_inner)
	IF keyword_set(set_zero) THEN BEGIN
		mask[index_occulter] = 0.0
	ENDIF ELSE BEGIN
		mask[index_occulter] = !VALUES.F_NAN
	ENDELSE
	
	index_outer = circle_mask(mask, sun.XCEN, sun.YCEN, 'ge', pixrad*occult_outer)
	IF keyword_set(set_zero) THEN BEGIN
		mask[index_occulter] = 0.0
	ENDIF ELSE BEGIN
		mask[index_occulter] = !VALUES.F_NAN
	ENDELSE
		
return,mask	

END