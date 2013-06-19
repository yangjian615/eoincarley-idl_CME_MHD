pro do_prep_secchi, check_seq = CHECK_SEQ


;This preps a secchi image and subtracts a minimum monthly background,

;Badly written could do with cleaning up.

files = findfile('*n*.fts')

;If image are in polarization 'sequence' or 'normal' images check to see the three 
;polarizations are there.
    
    
    FOR i=0.0, n_elements(files)-1, 3 DO BEGIN 
		;Check polarization sequence
		hdr0 = scc_fitshdr2struct(HEADFITS(files[i]))
		hdr1 = scc_fitshdr2struct(HEADFITS(files[i+1]))
		hdr2 = scc_fitshdr2struct(HEADFITS(files[i+2]))
		
		polar_seq = [hdr0.polar, hdr1.polar, hdr2.polar]
		index = sort([hdr0.polar, hdr1.polar, hdr2.polar])
		print,polar_seq
		IF polar_seq[index[0]] eq [0.0] and polar_seq[index[1]] eq [120.0] and polar_seq[index[2]] eq [240.0] THEN BEGIN
			secchi_prep,files[i:i+2], hdr, img, /rotate_on, /polariz_on, /write_fits
    	ENDIF ELSE BEGIN
    		print,''
    		print,'Polarization image missing for '+ hdr.date_obs
    		print,''
    		BREAK
    	ENDELSE
	ENDFOR
		
		

END