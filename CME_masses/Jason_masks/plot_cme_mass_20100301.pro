pro plot_cme_mass_20100301

cme_20100301_analysis, 'c2', mvt_c2_mask
cme_20100301_analysis, 'c3', mvt_c3_mask

; Get rid of zero values
t_c2 = mvt_c2[0,*]
no_zeros = where(t_c2 gt 0.0)
t_c2 = t_c2[no_zeros]
tstart  = t_c2[0] - 60.0*30.0
mass_c2 = mvt_c2[1,*]
mass_c2 = mass_c2[no_zeros]

t_c3 = mvt_c3[0,*]
no_zeros = where(t_c3 gt 0.0)
t_c3 = t_c3[no_zeros]
tend = t_c3[n_elements(t_c3)-1]
mass_c3 = mvt_c3[1,*]
mass_c3 = mass_c3[no_zeros]


loadct,39
!p.color=0
!p.background=255
window,1,xs=700,ys=700

; *****  Get max and min for the  axes  *****
all_mass = [transpose(mvt_c2[1,*]), transpose(mvt_c3[1,*])]
pos_mass = where(all_mass gt 0.0)
min_mass = min(all_mass[pos_mass])
max_mass = max(all_mass[pos_mass])

utplot, t_c2, mass_c2, xr=[tstart, tend], yr=[min_mass, max_mass + 0.5*max_mass], $
/xs, /ys, psym=1, charsize=2.0, symsize=2.0,/ylog, ytitle='CME Mass (g)'
oplot,t_c2, mass_c2
oplot, t_c3, mass_c3, psym=6, symsize=2.0,color=254
oplot,t_c3, mass_c3,color=254



stop
END


pro cme_20100301_analysis, folder, CME_mass_v_time, no_mask = NO_MASK

; -Analysis of CME in collaboration with Jason
; -Date: 12-Sep-2012
; -N.B! After reducing the level 0.5 images to level1, the date of observation is shifted
;  This is due to a time correction added inside reduce_level_1.pro. To fid the original 
;  time, go to the history array of the level 1 header: anytim(strmid(he.history[11],19,27),/yoh)
;

cd,'/Users/eoincarley/Data/jason_catalogue/l1/'+folder

files = findfile('*.fts')
he_gen = LASCO_FITSHDR2STRUCT( HEADFITS(files[0]) )
lasco_times = dblarr(n_elements(files))
;Get lasco file times. Note: The date_obs in the header files are the ones corrected for
;time drift, see http://lasco-www.nrl.navy.mil/index.php?p=content/stars/sunpos. I need
;the original times in the history array of the header. Also I need to set the second to 
;zero to match against Jason's times.

lasco_cube = dblarr(he_gen.naxis1 , he_gen.naxis2, n_elements(files))
FOR i=0, n_elements(files)-1 DO BEGIN
	data = lasco_readfits(files[i],he)
	IF he.naxis1 eq he_gen.naxis1 THEN BEGIN
		lasco_cube[*,*,i] = lasco_readfits(files[i],he)
	ENDIF	
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

CME_mass_v_time = dblarr(2,n_elements(mask_files)-1)


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
		;data = lasco_readfits(files[index_lasco], he)
		data = lasco_cube[*,*,index_lasco]
		he = LASCO_FITSHDR2STRUCT( HEADFITS(files[index_lasco]) )
		data_bs = data - pre_event
		
		indices_1 = where(cme_mask ge 3.0)
		indices_0 = where(cme_mask lt 3.0)
		cme_mask_bin = cme_mask
		cme_mask_bin[indices_1] = 1.0
		cme_mask_bin[indices_0] = 0.0
		
		IF keyword_set(no_mask) THEN BEGIN
			occult_mask = lasco_get_mask(he)
			img = data_bs*occult_mask
		ENDIF ELSE BEGIN	
			img = data_bs*cme_mask_bin
		ENDELSE	
		
		
		mass_image = scc_calc_cme_mass(img, he, /all, pos=0.0)
		print,'CME Mass: '+string(total(mass_image))+' grams'
		CME_mass_v_time[1,i-1] = total(mass_image)
		CME_mass_v_time[0,i-1] = anytim(mask_times[i],/utim)
		
		
		plot_image,sigrange(img), title=anytim(mask_times[i],/yoh)
	ENDIF ELSE BEGIN
		print,' '
		print,'No matching mask available for: '+anytim(date_obs_nc, /yoh, /trun)
		print,' '
	ENDELSE	

ENDFOR

END