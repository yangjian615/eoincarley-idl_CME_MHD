pro test_cal_swaves,array,freq_kHz,times,choose_points=choose_points,all_callisto=all_callisto

;====Jul-14th - I noticed that the data was being read in wrong. Underneath the frequenct entry
;125 there values 1,2,3,4,5,6....1439. Clearly just the row indexing of the array. This is because
;the first two rows have 319 entries, whereas all other rows have 320. Solution: get the frequencies from
;the first data reaf. Then read data again and skip the first two rows to get all 320 columns, avoiding the
;first column with indexing entries


cd,'/Users/eoincarley/Data/secchi_l1/20110607/swaves/2011'

;========================Read in high SWAVES A ASCII=======================
freq_grab=read_ascii('swaves_average_20110607_a_hfr.dat',delimiter=' ')
data=read_ascii('swaves_average_20110607_a_hfr.dat',delimiter=' ',data_start=2)

hi_freq_kHz = reverse(reform(freq_grab.field001[*,0]))
hi_freq_MHz = hi_freq_kHz/1000.
hi_freq_Hz = hi_freq_kHz*1000.

data_size = size(data.field001)
hi_array = dblarr(data_size[2],data_size[1]-1)
FOR i=0,data_size[2]-1 DO BEGIN
  hi_array(i,*) = reverse(data.field001[1:n_elements(data.field001[*,0])-1,i])  
ENDFOR

time0 = anytim(file2time('swaves_average_20110607_a_hfr.dat'),/utim)
times=dblarr(data_size[2])
times[0]=time0
FOR i=1,data_size[2]-1 DO BEGIN
  times[i]=time0+(i*60.)
ENDFOR  


;==========================Read in low SWAVES A ASCII=========================
freq_grab=read_ascii('swaves_average_20110607_a_lfr.dat',delimiter=' ')
data=read_ascii('swaves_average_20110607_a_lfr.dat',delimiter=' ',data_start=2) 

lo_freq_kHz = reverse(reform(freq_grab.field01[*,0]))
lo_freq_MHz = lo_freq_kHz/1000.
lo_freq_Hz = lo_freq_kHz*1000.

data_size = size(data.field01)
lo_array = dblarr(data_size[2],data_size[1]-1)
FOR i=0,data_size[2]-1 DO BEGIN;usually -1
  lo_array(i,*) = reverse(data.field01[1:n_elements(data.field01[*,0])-1,i])
ENDFOR

;======================Read in start CALLISTO spectrum=======================


cd,'/Users/eoincarley/Data/CALLISTO/20110607/'

restore,'spec_z_20110607.sav'
restore,'spec_x_20110607.sav'
restore,'spec_y_20110607.sav'

cal_array = spec_z_20110607
cal_time = spec_x_20110607
cal_freq = spec_y_20110607
running_mean_background,cal_array,back
cal_arraybs = cal_array - back


;============================================================================
;===================Start plotting CALLISTO and SWAVES A=====================
;============================================================================

;=======Define device variables======
set_plot,'ps'
device, filename = 'test_cal_swaves.ps',/color,bits=8,/inches,/landscape

loadct,5
!p.color=0
!p.background=255
!x.margin=[0,0]
!y.margin=[0,0]
!p.charsize=1


;=========Other variables===========
MHz_convert=1e6
a = anytim(file2time('20110607_060000'),/utim)  ;CALLISTO-SWAVES plot start time
b = anytim(file2time('20110607_100000'),/utim)  ;CALLISTO-SWAVES plot end time
stop_freq = closest(lo_freq_MHz, 0.01)
constant=fltarr(n_elements(times))
constant[*]=0.045*(MHz_convert)

;========================Plot low SWAVES A array========================
ticks = loglevels([0.01*(MHz_convert),0.125*(MHz_convert)],/fine) 
nticks=n_elements(ticks)

;lo_array and hi_array are indexd to remove some frequencies so that 
;there's a smoother transition between plots
spectro_plot,bytscl(lo_array[*,0:stop_freq],0,20),times,lo_freq_MHz[0:stop_freq]*(MHz_convert),$					  
	/ylog,YTICKS=nticks-1,YTICKV=Reverse(ticks),/ys,ytickname=['10!U5!N',' ',' ','10!U4!N'],$				  
	xr=[a,b],xticks=1,xtickname=[' ',' ',' ',' ',' ',' '],xtitle = '  ',/xs, $
 	position=[0.01,0.85,0.48,1],/normal,/NOERASE    
    ;position=[x0,y0,x1,y1]

xyouts,0.26,0.97,'!6STEREO A SWAVES low',charsize=1,color=255,/normal 
xyouts,0.015, 0.97,'(a)',charsize=1.2,color=255,/normal 
loadct,0
oplot,times[*],constant[*],linestyle=2,color=255,thick=2

IF keyword_set(choose_points) THEN BEGIN
	point,strlo_x,strlo_y,/data
	save,strlo_x,filename='strlo_x.sav'
	save,strlo_y,filename='strlo_y.sav'
ENDIF

;remove indexing from lo_freq_MHz and lo_array to view full spectra
;Same applies for the hi arrays


;======================Plot high SWAVES A array========================
loadct,5

ticks = loglevels([0.179*(MHz_convert),16.025*(MHz_convert)],/fine);remove 1e6 to plot in MHz
nticks=n_elements(ticks)

spectro_plot,bytscl(smooth(hi_array[*,0:n_elements(hi_freq_MHz)-2],1),0,20),$
times,hi_freq_MHz[0:n_elements(hi_freq_MHz)-2]*(MHz_convert),$;remove MHZ_convert to plot in MHz
	/xs,ytitle='Frequency (Hz)',xr=[a,b],xticks=1,xtickname=[' ',' ',' ',' ',' '],xtitle = '  ',$
	YTICKS=nticks-1,YTICKV=Reverse(ticks),/ys,/ylog,ytickname=['10!U7!N',' ',' ','10!U6!N',' ',' '],$
    position=[0.01,0.69,0.48,0.85],/normal,/NOERASE
    ;position=[x0,y0,x1,y1]
    
xyouts,0.26,0.78,'STEREO A SWAVES high',charsize=1,color=255,/normal    

IF keyword_set(choose_points) THEN BEGIN
	point,strhi_x,strhi_y,/data
	save,strhi_x,filename='strhi_x.sav'
	save,strhi_y,filename='strhi_y.sav'
ENDIF

;=================Read in all CALLISTO dynamic spectra=================

IF keyword_set(all_callisto) THEN BEGIN
 cd,'/Users/eoincarley/Data/CALLISTO/20110607/Fits'
   z_all = cal_arraybs
   x_all = cal_time
   saved_x = findfile('*x.sav')
   saved_z = findfile('*z.sav')
   
   FOR i=1,n_elements(saved_x)-1 DO BEGIN
       restore,saved_x[i]
       x_all = [x_all,x_master]
   ENDFOR
   FOR i=1,n_elements(saved_z)-1 DO BEGIN
       restore,saved_z[i]
       running_mean_background,znew,zbs
       znew=znew-zbs
       znew = filter_image(znew,/median)
       znew = smooth(znew,7)
       znew = tracedespike(znew,stat=2)
       z_all = [z_all,znew]
   ENDFOR
   ;running_mean_background,z_all,z_allbs
   ;z_all = z_all - z_allbs
   restore,saved_z[0]
   restore,saved_x[0]
   running_mean_background,znew,zbs
   znew=znew-zbs
   znew = filter_image(znew,/median)
   znew = smooth(znew,7)
   znew = tracedespike(znew,stat=2)
   z_all = [znew,z_all]
   x_all =[x_master,x_all]
   save,z_all,filename='z_all_20110607.sav'
   save,x_all,filename='x_all_20110607.sav'
ENDIF ELSE BEGIN
	cd,'/Users/eoincarley/Data/CALLISTO/20110607/Fits'
	restore,'z_all_20110607.sav'
	restore,'x_all_20110607.sav'
ENDELSE 

;===================Plot Callisto dynamic spectra=================

ticks = loglevels([16.025*(MHz_convert),400*(MHz_convert)],/fine);remove 1e6 to plot in MHz
nticks=n_elements(ticks)

spectro_plot,bytscl(z_all,0,30),x_all,cal_freq*(MHz_convert),$
	/xs,xr=[a,b],tick_unit=1800,xticks=9,xtitle=' ',xticklen=-0.04,xminor=3, $
	yticks = nticks-1,/ylog,yr=[355*(MHz_convert),16.25*(MHz_convert)],YTICKV=Reverse(ticks),yminor=10,$
	ytickname=[' ','10!U8!N',' ',' '],position=[0.01,0.53,0.48,0.69],/normal,/NOERASE

loadct,39
x_rec = anytim(file2time('20110607_062500'),/utim)
y_rec = 21*(MHz_convert)
rectangle,x_rec,y_rec,1200,270*(MHz_convert),color=0,thick=3,linestyle=0
rectangle,x_rec,y_rec,1200,270*(MHz_convert),color=255,thick=3,linestyle=2
xyouts,0.26,0.62,'RSTO eCallisto',charsize=1,color=255,/normal

;========================================================
;===============THE CALLISTO and SWAVES B data===========
;========================================================
loadct,5
ticks = loglevels([16.025*1e6,400*1e6],/fine);remove 1e6 to plot in MHz
nticks=n_elements(ticks)

spectro_plot,bytscl(reverse(z_all,2),0,30),x_all,reverse(cal_freq*(MHz_convert)),$
	/xs,xr=[a,b],tick_unit=1900,xtitle = '  ',xtickname=[' ',' '],$
	yticks = nticks-1,YTICKV=(ticks),yr=[16.25*(MHz_convert),355*(MHz_convert)],/ylog,$
	ytickname=[' ',' ','10!U8!N',' '],position=[0.01,0.32,0.48,0.48],/normal,/NOERASE

axis,xaxis=1,xstyle=1,color=0,xtickname=[' ',' ',' ',' ',' ',' ',' ',' ',' '],$
xticklen=-0.04,xticks=8,xminor=3

xyouts,0.26,0.41,'RSTO eCallisto',charsize=1,color=255,/normal

  
cd,'/Users/eoincarley/Data/secchi_l1/20110607/swaves/2011'

;========================Read in high B SWAVES ASCII=======================
freq_grab=read_ascii('swaves_average_20110607_b_hfr.dat',delimiter=' ')
data=read_ascii('swaves_average_20110607_b_hfr.dat',delimiter=' ',data_start=2)

hi_freq_kHz = reverse(reform(freq_grab.field001[*,0]))
hi_freq_MHz = hi_freq_kHz/1000.
hi_freq_Hz = hi_freq_kHz*1000.

data_size = size(data.field001)
hi_array = dblarr(data_size[2],data_size[1]-1)
FOR i=0,data_size[2]-1 DO BEGIN
  hi_array(i,*) = reverse(data.field001[1:n_elements(data.field001[*,0])-1,i])  
ENDFOR

;=========================Read in low B SWAVES ASCII========================
freq_grab=read_ascii('swaves_average_20110607_b_lfr.dat',delimiter=' ')
data=read_ascii('swaves_average_20110607_b_lfr.dat',delimiter=' ',data_start=2) 

lo_freq_kHz = reverse(reform(freq_grab.field01[*,0]))
lo_freq_MHz = lo_freq_kHz/1000.
lo_freq_Hz = lo_freq_kHz*1000.

data_size = size(data.field01)
lo_array = dblarr(data_size[2],data_size[1]-1)
FOR i=0,data_size[2]-1 DO BEGIN;usually -1
  lo_array(i,*) = reverse(data.field01[1:n_elements(data.field01[*,0])-1,i])
ENDFOR


;===========================Plot high SWAVES B array========================================

ticks = loglevels([0.179*(MHz_convert),16.025*(MHz_convert)],/fine);remove 1e6 to plot in MHz
nticks=n_elements(ticks)
loadct,5

spectro_plot,bytscl(smooth(  reverse(hi_array[*,0:n_elements(hi_freq_MHz)-2],2),1),0,20),$
times,reverse(hi_freq_MHz[0:n_elements(hi_freq_MHz)-2]*(MHz_convert)),$;remove 1e6 to plot in MHz
	/xs,xr=[a,b],xticks=1,xtickname=[' ',' ',' ',' ',' '],xtitle = '  ',$
	/ylog,ytitle='Frequency (Hz)',YTICKS=nticks-1,YTICKV=Reverse(ticks),/ys,$
    ytickname=['10!U7!N',' ',' ','10!U6!N',' ',' '],position=[0.01,0.14,0.48,0.32],/normal,/NOERASE

xyouts,0.26,0.25,'STEREO B SWAVES high',charsize=1,color=255,/normal
;===========================Plot low SWAVES B array========================================; 
ticks = loglevels([0.01*(MHz_convert),0.125*(MHz_convert)],/fine) 
nticks=n_elements(ticks)

constant=fltarr(n_elements(times))
constant[*]=0.045*(MHz_convert)
;lo_array and hi_array are indexd to remove some frequencies so that 
;there's a smoother transition between plots

spectro_plot,bytscl(reverse(lo_array[*,0:stop_freq],2),0,20),$
times,reverse(lo_freq_MHz[0:stop_freq]*(MHz_convert)),$;ytitle='Frequency (MHz)',$						  
	xr=[a,b],/xs, xticks=9,xtitle='Start Time ('+anytim(a,/yoh,/trun)+') UT',tick_unit=1800,$
	YTICKV=Reverse(ticks),YTICKS=nticks-1,/ylog,/ys,ytickname=['10!U5!N',' ',' ','10!U4!N'],$
	position=[0.01,0.0,0.48,0.14],/normal,/NOERASE
	;pos=[x0,y0,x1,y1]
	
xyouts,0.26,0.01,'STEREO B SWAVES low',charsize=1,color=255,/normal 
 
loadct,0
constant=fltarr(n_elements(times))
constant[*]=0.03*(MHz_convert)
oplot,times[*],constant[*],linestyle=2,color=255,thick=2 

;==========================================================================
;===========================Plot the zoom-ins==============================
;==========================================================================

a = anytim(file2time('20110607_062500'),/utim)
b = anytim(file2time('20110607_064500'),/utim)
running_mean_background,spec_z_20110607,backg
spec_z_20110607 = spec_z_20110607 - backg

loadct,9
stretch,350,80
!p.color=350

spectro_plot,bytscl(spec_z_20110607,-20,50),spec_x_20110607,spec_y_20110607,$
	/xs,xr=[a,b],xtitle='Start Time ('+anytim(a,/yoh,/trun)+') UT',tick_unit=300,$
	ytitle='Frequency (MHz)',/ys,yr=[20,300],yticks=7,ytickunit=40,yminor=2,$
	position=[0.55,0.55,1,1],/normal,/NOERASE

x_rec = anytim(file2time('20110607_062700'),/utim)

loadct,39
stretch,255,0
!p.color=0
rectangle,x_rec,30,130,60,color=0,thick=3,linestyle=0
rectangle,x_rec,30,130,60,color=255,thick=3,linestyle=2
xyouts,0.555,0.97,'(b)',charsize=1.2,color=255,/normal

plots,[0.1,0.56],[0.54,.55],/normal,thick=3,linestyle=0,color=0;======[x1,x2],[y1,y2]=====
plots,[0.1,0.56],[0.54,.55],/normal,thick=3,linestyle=2,color=255
plots,[0.1,0.55],[0.68,1],/normal,thick=3,linestyle=0,color=0
plots,[0.1,0.55],[0.68,1],/normal,thick=3,linestyle=2,color=255

plots,[0.595,0.55],[0.89,.47],/normal,thick=3,linestyle=0,color=0;======[x1,x2],[y1,y2]====
plots,[0.595,0.55],[0.89,.47],/normal,thick=3,linestyle=2,color=255
plots,[0.64,1],[0.89,0.47],/normal,thick=3,linestyle=0,color=0;======[x1,x2],[y1,y2]=======
plots,[0.64,1],[0.89,0.47],/normal,thick=3,linestyle=2,color=255

cd,'/Users/eoincarley/Data/CALLISTO/20110607/Fits'
radio_spectro_fits_read,'BIR_20110607_062400_10.fit',z_zoom,x_zoom,y_zoom

a = anytim(file2time('20110607_062700'),/utim)
b = anytim(file2time('20110607_062900'),/utim)
;xyouts,1,0.5,'(c)',/normal,charsize=1.5,color=255
loadct,9
stretch,350,50
!p.color=350
modct,gamma=0.9
;!p.position=[0.55,0,1,0.47]
spectro_plot,bytscl(z_zoom,0,250),x_zoom,y_zoom,$
	/xs,xr=[a,b],xtitle='Start Time ('+anytim(a,/yoh,/trun)+') UT',tick_unit=30,$
	ytitle='Frequency (MHz)',/ys,yr=[30,90],yminor=2,$
	position=[0.55,0,1,0.47],/normal,/NOERASE

xyouts,0.56,0.44,'(c)',/normal,charsize=1.2,color=255
;===================Plot inset to panel (b)===============================
loadct,9
stretch,255,0
!p.color=255
modct,gamma=0.5
a = anytim(file2time('20110607_062550'),/utim)
b = anytim(file2time('20110607_062630'),/utim)
spectro_plot,smooth(bytscl(z_zoom,140,170),3),x_zoom,y_zoom,$
	/xs,xr=[a,b],xtitle=' ',xticks=1,xtickname=[' ',' ',' ',' ',' ',' ',' '],$
	/ys,yr=[30,90],yticks=1,ytickname=[' ',' '],$
	position=[0.84,0.85,0.99,0.99],/normal,/NOERASE
	;pos=[x0,y0,x1,y1]
	
axis,xaxis=0,xticklen=-0.05,xticks=2,xtickname=['06:25:50','06:26:10','06:26:30'],charsize=0.8
axis,yaxis=0,yticklen=-0.05,yticks=2,ytickname=['90','60','30'],charsize=0.8,yminor=3	
device,/close
set_plot,'x'
END
