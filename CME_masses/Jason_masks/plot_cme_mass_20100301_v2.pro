pro plot_cme_mass_20100301_v2, mask=mask, no_mask = no_mask, invert_mask = invert_mask,$
								pre_event_only = pre_event_only, analyse_mass=analyse_mass,$
								sub_no_mask=sub_no_mask
cd,'/Users/eoincarley/Data/jason_catalogue'
loadct,39
!p.color=0
!p.background=255
!p.symsize=1.0
!p.charsize=1.0
C = 1.0e15		

set_plot,'ps'
device,filename='CME_MASSES_MASKS.ps', /color, /inches, /encapsulate, $
ysize=12, xsize=6


IF KEYWORD_SET(mask) THEN BEGIN
;**********   MASK APPLIED AS NORMAL   ************
	IF keyword_set(analyse_mass) THEN BEGIN
		cme_20100301_analysis, 'c2', mvt_c2
		cme_20100301_analysis, 'c3', mvt_c3
		wset,3
		prepare_for_plot, mvt_c2, mvt_c3, t_c2, mass_c2, t_c3, mass_c3, $
			   		  tstart, tend, min_mass, max_mass
		save,t_c2,mass_c2,t_c3,mass_c3,tstart, tend, min_mass, max_mass, $
		filename='c2c3_massVtime_mask.sav'	   		  
	ENDIF ELSE BEGIN
		restore,'c2c3_massVtime_mask.sav'
	ENDELSE	
	   		  	   		  
	;wset,3
	utplot, t_c2, mass_c2/C, xr=[tstart, tend], yr=[min_mass/C, (max_mass + 0.5*max_mass)/C], $
	/xs, /ys, psym=1, ytitle='CME Mass x1e15 (g)',$
	position=[0.12, 0.68, 0.99, 0.99], xtickname=[' ',' ',' ',' ',' ', ' '],xtit=' '
	
	oplot, t_c2, mass_c2/C
	oplot, t_c3, mass_c3/C, psym=6, color=254
	oplot, t_c3, mass_c3/C, color=254
	legend,['LASCO C2','LASCO C3'], psym=[1,6], color=[0,254], box=0
	legend,['MASK'], /right, box=0
	


ENDIF



IF KEYWORD_SET(no_mask) THEN BEGIN
;**********   NO MASK APPLIED   ************
	IF keyword_set(analyse_mass) THEN BEGIN
		cme_20100301_analysis, 'c2', mvt_c2, /no_mask
		cme_20100301_analysis, 'c3', mvt_c3, /no_mask
		wset,3
		prepare_for_plot, mvt_c2, mvt_c3, t_c2, mass_c2, t_c3, mass_c3, $
			   		  tstart, tend, min_mass, max_mass
		save,t_c2,mass_c2,t_c3,mass_c3,tstart, tend, min_mass, max_mass, $
		filename='c2c3_massVtime_NOmask.sav'
	ENDIF ELSE BEGIN
		restore,'c2c3_massVtime_NOmask.sav'
	ENDELSE
	
	;wset,3

	utplot, t_c2, mass_c2/C, xr=[tstart, tend], yr=[min_mass/C, max_mass/C + 0.5*max_mass/C], $
	/xs, /ys, psym=1, ytitle='CME Mass x1e15 (g)', /noerase, $
	position=[0.12, 0.37, 0.99, 0.68], xtickname=[' ',' ',' ',' ',' ', ' '],xtit=' '
	oplot, t_c2, mass_c2/C
	oplot, t_c3, mass_c3/C, psym=6, color=254
	oplot, t_c3, mass_c3/C, color=254
	
	;legend,['LASCO C2','LASCO C3'], psym=[1,6], color=[0,254], box=0
	legend,['NO MASK'], /right, box=0


ENDIF


IF KEYWORD_SET(invert_mask) THEN BEGIN
;**********   INVERTED MASK APPLIED   ************
	IF keyword_set(analyse_mass) THEN BEGIN
		cme_20100301_analysis, 'c2', mvt_c2, /invert_mask
		cme_20100301_analysis, 'c3', mvt_c3, /invert_mask

		prepare_for_plot, mvt_c2, mvt_c3, t_c2, mass_c2, t_c3, mass_c3, $
			   		  tstart, tend, min_mass, max_mass
		save,t_c2,mass_c2,t_c3,mass_c3,tstart,tend,min_mass, max_mass,$
		filename='c2c3_massVtime_INVERTmask.sav'   		  
	ENDIF ELSE BEGIN
		restore,'c2c3_massVtime_INVERTmask.sav'
	ENDELSE		   		  
	
	;wset,3

	utplot, t_c2, mass_c2/C, xr=[tstart, tend], yr=[min_mass/C, max_mass/C + 0.5*max_mass/C], $
	/xs, /ys, psym=1, ytitle='CME Mass x1e15 (g)', /noerase, $
	position=[0.12, 0.06, 0.99, 0.37]
	
	oplot, t_c2, mass_c2/C
	oplot, t_c3, mass_c3/C, psym=6, color=254
	oplot, t_c3, mass_c3/C, color=254
	
	legend,['INVERSE MASK'], /right, box=0

ENDIF


IF KEYWORD_SET(pre_event_only) THEN BEGIN
;**********   PRE_EVENT ONLY   ************
	IF keyword_set(analyse_mass) THEN BEGIN
		cme_20100301_analysis, 'c2', mvt_c2, /pre_event_only
		cme_20100301_analysis, 'c3', mvt_c3, /pre_event_only
		wset,3
		prepare_for_plot, mvt_c2, mvt_c3, t_c2, mass_c2, t_c3, mass_c3, $
			   		  tstart, tend, min_mass, max_mass
		save,t_c2,mass_c2,t_c3,mass_c3,tstart,tend,min_mass, max_mass,$
		filename='c2c3_pre_eventONLY_mask.sav'
	ENDIF ELSE BEGIN
		restore,'c2c3_pre_eventONLY_mask.sav'
	ENDELSE	

	wset,3

	utplot, t_c2, mass_c2, xr=[tstart, tend], yr=[min_mass, max_mass + 0.5*max_mass], $
	/xs, /ys, psym=1, ytitle='CME Mass (g)'
	oplot, t_c2, mass_c2
	oplot, t_c3, mass_c3, psym=6, symsize=2.0,color=254
	oplot, t_c3, mass_c3, color=254

ENDIF

device,/close
set_plot,'x'


set_plot,'ps'
device,filename='total_minus_cme_inverse.ps', /color, /inches, /encapsulate, $
ysize=8, xsize=6



IF KEYWORD_SET(sub_no_mask) THEN BEGIN
	;The idea here is to subtract the total image mass by the CME mass.
	;This should be equal to the inverted mask image mass.
	restore,'c2c3_massVtime_NOmask.sav', /verb
	m_no_mask_c2 = mass_c2
	t_no_mask_c2 = t_c2	

	m_no_mask_c3 = mass_c3
	t_no_mask_c3 = t_c3
	restore,'c2c3_massVtime_mask.sav', /verb

	m_mask_c2 = mass_c2
	t_mask_c2 = t_c2	

	m_mask_c3 = mass_c3
	t_mask_c3 = t_c3

	full_minus_cme_c2 = m_no_mask_c2 - m_mask_c2
	full_minus_cme_c3 = m_no_mask_c3 - m_mask_c3

	;No plot this results alongside the inverse mask
	
	restore,'c2c3_massVtime_INVERTmask.sav'	,/verb
	;window,10
	utplot, t_c2, full_minus_cme_c2/C, xr=[tstart, tend], /xs, /ys, ytitle='CME Mass x1e15 (g)',$
	psym=1, yr=[-2.5, 1], position=[0.11, 0.5, 0.95, 0.95], /noerase,$
	xtitle=' ', xtickname=[' ',' ',' ',' ',' ',' ',' ']
	
	oplot,t_c2, full_minus_cme_c2/C
	oplot, t_c2, mass_c2/C, psym=5, color=70
	oplot, t_c2, mass_c2/C, color=70
	
	legend,['Total image minus CME','Inverse Mask'], psym=[1,6], color=[0,70], box=0, /left
	legend,['LASCO C2'], /right, box=0
	
	;window,11
	utplot, t_c3, full_minus_cme_c3/C, xr=[tstart, tend], /xs, /ys, ytitle='CME Mass x1e15 (g)',$
	psym=1, yr=[-6.5, 0.5], position=[0.11, 0.1, 0.95, 0.5],/noerase
	
	oplot,t_c3, full_minus_cme_c3/C
	oplot, t_c3, mass_c3/C, psym=5, color=70
	oplot, t_c3, mass_c3/C, color=70
	
	legend,['Total image minus CME','Inverse Mask'], psym=[1,6], color=[0,70], box=0, /left
	legend,['LASCO C3'], /right, box=0
	
ENDIF
device,/close
set_plot,'x'


END


pro cme_20100301_analysis, folder, CME_mass_v_time, no_mask = NO_MASK, $
						   invert_mask = INVERT_MASK, pre_event_only = PRE_EVENT_ONLY

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

IF KEYWORD_SET(pre_event_only) THEN BEGIN
	cd,'/Users/eoincarley/Data/jason_catalogue/pre_pre_event/'+folder
	pre_pre_file = findfile('*.fts')
	pre_pre_event = lasco_readfits(pre_pre_file[0], he_pre_pre)
ENDIF


;window,10
FOR i=1.0, n_elements(mask_files)-1 DO BEGIN
	cd,'/Users/eoincarley/Data/jason_catalogue/CME_detection_output/'+folder
	index_lasco = where(lasco_times eq mask_times[i])
	IF index_lasco ne -1 THEN BEGIN
		
		restore,mask_files[i]
		IF KEYWORD_SET(pre_event_only) THEN BEGIN
			data_bs = pre_event - pre_pre_event
			he = he_pre
			
		ENDIF ELSE BEGIN
			print,' '
			print,'Image time (uncorrected for clock drift): '+anytim(lasco_times[index_lasco], /yoh)
			print,'Mask time: '+anytim(mask_times[i],/yoh)
			print,' '
		
			cd,'/Users/eoincarley/Data/jason_catalogue/l1/'+folder
			;data = lasco_readfits(files[index_lasco], he)
			data = lasco_cube[*,*,index_lasco]
			he = LASCO_FITSHDR2STRUCT( HEADFITS(files[index_lasco]) )
			data_bs = data - pre_event
		ENDELSE	
		
		indices_1 = where(cme_mask ge 3.0)
		indices_0 = where(cme_mask lt 3.0)
		cme_mask_bin = cme_mask
		IF KEYWORD_SET(invert_mask) THEN BEGIN
			cme_mask_bin[indices_1] = 0.0
			cme_mask_bin[indices_0] = 1.0
		ENDIF ELSE BEGIN	
			cme_mask_bin[indices_1] = 1.0
			cme_mask_bin[indices_0] = 0.0
		ENDELSE	
		
		IF KEYWORD_SET(no_mask) THEN BEGIN
			occult_mask = lasco_get_mask(he)
			img = data_bs*occult_mask
		ENDIF ELSE BEGIN	
			img = data_bs*cme_mask_bin
		ENDELSE	
		
		
		mass_image = scc_calc_cme_mass(img, he, /all, pos=0.0)
		print,'CME Mass: '+string(total(mass_image))+' grams'
		CME_mass_v_time[1,i-1] = total(mass_image)
		CME_mass_v_time[0,i-1] = anytim(mask_times[i],/utim)
		
		!p.multi=[0,1,1]
		window,0
		plot_image,sigrange(img), title=anytim(mask_times[i],/yoh)
		
	ENDIF ELSE BEGIN
		print,' '
		print,'No matching mask available for: '+anytim(date_obs_nc, /yoh, /trun)
		print,' '
	ENDELSE	

ENDFOR

END


pro prepare_for_plot, mvt_c2, mvt_c3, t_c2, mass_c2, t_c3, mass_c3, $
			   		  tstart, tend, min_mass, max_mass
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

	; *****  Get max and min for the  axes  *****
	all_mass = [transpose(mvt_c2[1,*]), transpose(mvt_c3[1,*])]
	;pos_mass = where(all_mass gt 0.0)
	min_mass = min(all_mass[*])
	max_mass = max(all_mass[*])

END




