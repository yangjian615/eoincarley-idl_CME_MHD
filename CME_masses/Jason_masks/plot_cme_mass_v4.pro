pro plot_cme_mass_v4, date, mask=mask, no_mask = no_mask, invert_mask = invert_mask,$
								pre_event_only = pre_event_only, analyse_mass=analyse_mass,$
								sub_no_mask=sub_no_mask, toggle=toggle
								
;v4 is attempt to plot up continous time series of mass development						
								

folder = '/20100227-0305/C2/'+date								
cd,'~/Data/jason_catalogue'+folder
loadct,39
!p.color=0
!p.background=255
!p.symsize=1.0
!p.charsize=1.0
C = 1.0e15	

plotsym, 0, /fill

IF keyword_set(toggle) THEN BEGIN
	set_plot,'ps'
	device,filename='CME_MASSES_MASKS.ps', /color, /inches, /encapsulate, $
	ysize=7, xsize=30
ENDIF

IF KEYWORD_SET(mask) THEN BEGIN
;**********   MASK APPLIED AS NORMAL   ************
	
	IF keyword_set(analyse_mass) THEN BEGIN
		folder = '/20100227-0305/C2/'+date			
		cme_20100301_analysis, 	folder, mvt_c2
		folder = '/20100227-0305/C3/'+date			
		cme_20100301_analysis, 	folder, mvt_c3
		;window,3
		prepare_for_plot, mvt_c2, mvt_c3, t_c2, mass_c2, t_c3, mass_c3, $
			   		  tstart, tend, min_mass, max_mass
		save,t_c2,mass_c2,t_c3,mass_c3,tstart, tend, min_mass, max_mass, $
		filename='c2c3_massVtime_mask.sav'	   		  
	ENDIF ELSE BEGIN
		restore,'c2c3_massVtime_mask.sav'
	ENDELSE	
	set_line_color	   		  	   		  
	!p.multi=[0,1,1]
	utplot, t_c2, mass_c2/C, xr=[tstart, tend], yr=[-2.0, 6.0], $;(max_mass + 0.5*max_mass)/C+0.5], $
	/xs, /ys, psym=1, ytitle='CME Mass x1e15 (g)' ,color=5
	;,$
	;position=[0.12, 0.68, 0.99, 0.99], xtickname=[' ',' ',' ',' ',' ', ' '],xtit=' '

	oplot, t_c2, mass_c2/C, color=5
	oplot, t_c3, mass_c3/C,psym=8, color=4
	oplot, t_c3, mass_c3/C, color=4
	legend,['LASCO C2','LASCO C3'], psym=[1,8], charsize=1.2, box=0
	legend,['Mask', 'No Mask', 'Invert Mask'], linestyle=[0,0,0], color=[5,6,4],/right, box=0
	
	timsim = (dindgen(101)*(t_c2[n_elements(t_c2)-1] - (t_c2[0]-1000.0))/100.0 )+(t_c2[0]-1000.0) 
	zeros = dblarr(n_elements(timsim))
	oplot,timsim,zeros
	

ENDIF



IF KEYWORD_SET(no_mask) THEN BEGIN
;**********   NO MASK APPLIED   ************
	IF keyword_set(analyse_mass) THEN BEGIN
		folder = '/20100227-0305/C2/'+date			
		cme_20100301_analysis, 	folder, mvt_c2, /no_mask
		folder = '/20100227-0305/C3/'+date			
		cme_20100301_analysis, 	folder, mvt_c3, /no_mask
		;wset,3
		prepare_for_plot, mvt_c2, mvt_c3, t_c2, mass_c2, t_c3, mass_c3, $
			   		  tstart, tend, min_mass, max_mass
		save,t_c2,mass_c2,t_c3,mass_c3,tstart, tend, min_mass, max_mass, $
		filename='c2c3_massVtime_NOmask.sav'
	ENDIF ELSE BEGIN
		restore,'c2c3_massVtime_NOmask.sav'
	ENDELSE
	
	;wset,3
	set_line_color
	oplot, t_c2, mass_c2/C, psym=1, color=6;, xr=[tstart, tend], yr=[min_mass/C, max_mass/C + 0.5*max_mass/C], $
	;/xs, /ys, psym=1, ytitle='CME Mass x1e15 (g)', /noerase, $
	;position=[0.12, 0.37, 0.99, 0.68], xtickname=[' ',' ',' ',' ',' ', ' '],xtit=' '
	oplot, t_c2, mass_c2/C, color=6
	oplot, t_c3, mass_c3/C, psym=8, color=6
	oplot, t_c3, mass_c3/C, color=6
	
	;legend,['LASCO C2','LASCO C3'], psym=[1,6], color=[0,254], box=0
	;legend,['NO MASK'], /right, box=0


ENDIF


IF KEYWORD_SET(invert_mask) THEN BEGIN
;**********   INVERTED MASK APPLIED   ************
	IF keyword_set(analyse_mass) THEN BEGIN
		folder = '/20100227-0305/C2/'+date			
		cme_20100301_analysis, 	folder, mvt_c2, /invert_mask
		folder = '/20100227-0305/C3/'+date			
		cme_20100301_analysis, 	folder, mvt_c3, /invert_mask

		prepare_for_plot, mvt_c2, mvt_c3, t_c2, mass_c2, t_c3, mass_c3, $
			   		  tstart, tend, min_mass, max_mass
		save,t_c2,mass_c2,t_c3,mass_c3,tstart,tend,min_mass, max_mass,$
		filename='c2c3_massVtime_INVERTmask.sav'   		  
	ENDIF ELSE BEGIN
		restore,'c2c3_massVtime_INVERTmask.sav'
	ENDELSE		   		  
	
	;wset,3
	set_line_color
	oplot, t_c2, mass_c2/C, psym=1, color=4;, xr=[tstart, tend], yr=[min_mass/C, max_mass/C + 0.5*max_mass/C], $
	;/xs, /ys, psym=1, ytitle='CME Mass x1e15 (g)', /noerase, $
	;position=[0.12, 0.37, 0.99, 0.68], xtickname=[' ',' ',' ',' ',' ', ' '],xtit=' '
	oplot, t_c2, mass_c2/C, color=4
	oplot, t_c3, mass_c3/C, psym=8, color=4
	oplot, t_c3, mass_c3/C, color=4
	
	;legend,['INVERSE MASK'], /right, box=0

ENDIF


IF KEYWORD_SET(pre_event_only) THEN BEGIN
;**********   PRE_EVENT ONLY   ************
	IF keyword_set(analyse_mass) THEN BEGIN
		folder = '/20100227-0305/C2/'+date			
		cme_20100301_analysis, 	folder, mvt_c2, /pre_event_only
		folder = '/20100227-0305/C3/'+date			
		cme_20100301_analysis, 	folder, mvt_c3, /pre_event_only
		wset,3
		prepare_for_plot, mvt_c2, mvt_c3, t_c2, mass_c2, t_c3, mass_c3, $
			   		  tstart, tend, min_mass, max_mass
		save,t_c2,mass_c2,t_c3,mass_c3,tstart,tend,min_mass, max_mass,$
		filename='c2c3_pre_eventONLY_mask.sav'
	ENDIF ELSE BEGIN
		restore,'c2c3_pre_eventONLY_mask.sav'
	ENDELSE	

	wset,3

	oplot, t_c2, mass_c2/C, psym=1;, xr=[tstart, tend], yr=[min_mass/C, max_mass/C + 0.5*max_mass/C], $
	;/xs, /ys, psym=1, ytitle='CME Mass x1e15 (g)', /noerase, $
	;position=[0.12, 0.37, 0.99, 0.68], xtickname=[' ',' ',' ',' ',' ', ' '],xtit=' '
	oplot, t_c2, mass_c2/C
	oplot, t_c3, mass_c3/C, psym=6, color=254
	oplot, t_c3, mass_c3/C, color=254

ENDIF

IF keyword_set(toggle) THEN BEGIN
device,/close
set_plot,'x'
ENDIF


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

cd,'~/Data/jason_catalogue/'+folder

;lasco_cube = dblarr(he_gen.naxis1 , he_gen.naxis2, n_elements(files))
files = findfile('*.fts')
lasco_times = dblarr(n_elements(files))
FOR i=0, n_elements(files)-1 DO BEGIN

	he = LASCO_FITSHDR2STRUCT( HEADFITS(files[i]) )
;Get lasco file times. Note: The date_obs in the header files are the ones corrected for
;time drift, see http://lasco-www.nrl.navy.mil/index.php?p=content/stars/sunpos. I need
;the original times in the history array of the header. Also I need to set the second to 
;zero to match against Jason's times.


	;data = lasco_readfits(files[i],he)
	;IF he.naxis1 eq he_gen.naxis1 THEN BEGIN
	;	lasco_cube[*,*,i] = lasco_readfits(files[i],he)
	;ENDIF	
		;The following commented lines were to take into account that while prepping level 0.5
		;files, the prep routines apply a time correction. If level 1 files are downloaded straight
		;from NRL server then no need to get 'Original date_obs:'
		date_index = where(strmid(transpose(he.history[*]),0,18) eq 'Original date_obs:')
		date_obs_nc = anytim(strmid(he.history[date_index],19,27),/ex)
		date_obs_nc[2] = 0.0
		lasco_times[i] = anytim(anytim(date_obs_nc, /yoh, /trun),/utim)
		;lasco_times[i] = anytim(he.date_obs, /utim)
ENDFOR	

pre_event = lasco_readfits(files[0], he_pre)

cd,'~/Data/jason_catalogue/20100227-0305/'+he.detector+'/masks'
mask_files = findfile('CME_mask_*.sav')
mask_times = anytim(file2time(mask_files), /ex)
mask_times[2,*] = 0.0 ;need to ignore the seconds
mask_times = anytim(mask_times, /utim)

CME_mass_v_time = dblarr(2,n_elements(mask_files)-1)

IF KEYWORD_SET(pre_event_only) THEN BEGIN
	cd,'~/Data/jason_catalogue/pre_pre_event/'+folder
	pre_pre_file = findfile('*.fts')
	pre_pre_event = lasco_readfits(pre_pre_file[0], he_pre_pre)
ENDIF


;window,10
FOR i=97.0, n_elements(mask_files)-1 DO BEGIN
	cd,'~/Data/jason_catalogue/20100227-0305/'+he.detector+'/masks'
	index_lasco = where(lasco_times eq mask_times[i])
	IF index_lasco ne -1 THEN BEGIN
		
		restore, mask_files[i]
		IF KEYWORD_SET(pre_event_only) THEN BEGIN
			data_bs = pre_event - pre_pre_event
			he = he_pre
		ENDIF ELSE BEGIN
			print,' '
			print,'Image time: '+anytim(lasco_times[index_lasco], /yoh)
			print,'Mask time: '+anytim(mask_times[i],/yoh)
			print,' '
		
			cd,'~/Data/jason_catalogue/'+folder
			data = lasco_readfits(files[index_lasco], he)
			;data = lasco_cube[*,*,index_lasco]
			;he = LASCO_FITSHDR2STRUCT( HEADFITS(files[index_lasco]) )
			data_bs = data - pre_event
		ENDELSE	
		
		indices_1 = where(cme_mask ge 3.0)
		indices_0 = where(cme_mask lt 3.0)
		cme_mask_bin = cme_mask
		stop
		save,cme_mask_bin,filename='cme_mask_bin.sav'
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

		
		;!p.multi=[0,2,1]
		
		;window,0, xs=700, ys=400
		mass_image = scc_calc_cme_mass(img, he, /all, pos=0.0)
		mass_image = smooth(mass_image, 5)
		IF max(mass_image) ne min(mass_image) THEN BEGIN
			hist = histogram(mass_image, binsize = 1e8)
			bins = dindgen(n_elements(hist))*(max(mass_image) - min(mass_image))/(n_elements(hist)-1) + min(mass_image)
			plot, bins, hist, /ylog, psym=10, yr=[1, 1e9], charsize=1.5
		ENDIF
		print,'CME Mass: '+string(total(mass_image))+' grams'
		CME_mass_v_time[1,i-1] = total(mass_image)
		CME_mass_v_time[0,i-1] = anytim(mask_times[i],/utim)
		
	
		;shade_surf, sigrange(mass_image), title=anytim(mask_times[i],/yoh), charsize=3
		plot_image, sigrange(mass_image), title=anytim(mask_times[i],/yoh), charsize=1.5

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
	IF no_zeros[0] ne -1 THEN t_c2 = t_c2[no_zeros]
	tstart  = t_c2[0] - 60.0*30.0
	mass_c2 = mvt_c2[1,*]
	IF no_zeros[0] ne -1 THEN mass_c2 = mass_c2[no_zeros]

	t_c3 = mvt_c3[0,*]
	no_zeros = where(t_c3 gt 0.0)
	IF no_zeros[0] ne -1 THEN t_c3 = t_c3[no_zeros]
	tend = t_c3[n_elements(t_c3)-1]
	mass_c3 = mvt_c3[1,*]
	IF no_zeros[0] ne -1 THEN mass_c3 = mass_c3[no_zeros]

	; *****  Get max and min for the  axes  *****
	all_mass = [transpose(mvt_c2[1,*]), transpose(mvt_c3[1,*])]
	;pos_mass = where(all_mass gt 0.0)
	min_mass = min(all_mass[*])
	max_mass = max(all_mass[*])

END




