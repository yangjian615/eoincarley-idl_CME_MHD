pro create_mass_images

;
; Creates mass images from iput of a list of l1 images in MSB 
; Images are saved as mass45_YYYMMDD_HHMMSS_xxxxx.fts etc. 
; Eoin Carley 2011-Oct-6th

list = findfile('*.fts')

FOR i=0, n_elements(list)-1 DO BEGIN
	image = list[i]
	da = sccreadfits(image,ha)
	da = filter_image(da,/median)
		
	print,''
	print,'Pre event image time: ' + hePre.date_obs
	print,'Current image: ' + ha.date_obs
	print,''

    msk = get_smask(ha)
    da = da*msk

	mass_image = scc_calc_cme_mass(da,ha,/all,pos=45)
	;45 degrees for CME on 2008-12-12
	;N.B!!! Don't forget to set polarised brightness or total brightness

	name = time2file(ha.date_obs)

	currentImg = 'mass45_'+list[i]
	sccwritefits,currentImg,mass_image,ha

ENDFOR

END
