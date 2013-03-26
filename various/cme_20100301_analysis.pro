pro cme_20100301_analysis,folder

; -Analysis of CME in collaboration with Jason
; -Date: 12-Sep-2012
; -N.B! After reducing the level 0.5 images to level1, the date of observation is shifted
;  This is due to a time correction added inside reduce_level_1.pro. To fid the original 
;  time, go to the history array of the level 1 header: anytim(strmid(he.history[11],19,27),/yoh)
;

cd,'/Users/eoincarley/Data/jason_catalogue/l1/'+folder

files = findfile('*.fts')
lasco_times = dblarr(n_elements(files))
;Get lasco file times. Note: The date_obs in the header files are the ones corrected for
;time drift, see http://lasco-www.nrl.navy.mil/index.php?p=content/stars/sunpos. I need
;the original times in the history array of the header. Also I need to set the second to 
;zero to match against Jason's times.

FOR i=0, n_elements(files)-1 DO BEGIN
	junk = lasco_readfits(files[i],he)
	date_index = where(strmid(transpose(he.history[*]),0,18) eq 'Original date_obs:')
	date_obs_nc = anytim(strmid(he.history[date_index],19,27),/ex)
	date_obs_nc[2] = 0.0
	lasco_times[i] = anytim(anytim(date_obs_nc, /yoh, /trun),/utim)
ENDFOR	

pre_event = lasco_readfits(files[0], he_pre)

cd,'/Users/eoincarley/Data/jason_catalogue/CME_detection_output/'+folder
mask_files = findfile('CME*.sav')
mask_times = anytim(file2time(mask_files), /ex)
mask_times[2,*] = 0.0 ;need to ignore the seconds
mask_times = anytim(mask_times, /utim)

FOR i=1.0, n_elements(mask_files)-1 DO BEGIN
cd,'/Users/eoincarley/Data/jason_catalogue/CME_detection_output/'+folder
	index_lasco = where(lasco_times eq mask_times[i])
	IF index_lasco ne -1 THEN BEGIN
		print,' '
		print,'Image time (uncorrected for clock drift): '+anytim(lasco_times[index_lasco], /yoh)
		print,'Mask time: '+anytim(mask_times[i],/yoh)
		print,' '
		
		restore,mask_files[i]
		cd,'/Users/eoincarley/Data/jason_catalogue/l1/'+folder
		data = lasco_readfits(files[index_lasco], he)
		data_bs = data - pre_event
		
		indices_1 = where(cme_mask ge 3.0)
		indices_0 = where(cme_mask lt 3.0)
		cme_mask_bin = cme_mask
		cme_mask_bin[indices_1] = 1.0
		cme_mask_bin[indices_0] = 0.0

		img = data_bs*cme_mask_bin  
		
		mass_image = scc_calc_cme_mass(img,he,/all,pos=0.0)
		print,'CME Mass: '+string(total(mass_image))+' grams'
		
		plot_image,sigrange(img), title=anytim(mask_times[i],/yoh)
	ENDIF ELSE BEGIN
		print,' '
		print,'No matching mask available for: '+anytim(date_obs_nc, /yoh, /trun)
		print,' '
	ENDELSE	

ENDFOR


stop
END