pro plot_allcallisto_swaves2,array,freq_kHz,times,choose_points=choose_points,all_callisto=all_callisto

cd,'/Users/eoincarley/Data/secchi_l1/20110607/swaves/2011'

;========================Read in high SWAVES A ASCII=======================
data=read_ascii('swaves_average_20110607_a_hfr.dat',delimiter=' ')

hi_freq_kHz = reverse(reform(data.field001[*,0]))
hi_freq_MHz = hi_freq_kHz/1000.
hi_freq_Hz = hi_freq_kHz*1000.

data_size = size(data.field001)
hi_array = dblarr(data_size[2]-1,data_size[1]);-1 usallly absent
FOR i=1,data_size[2]-1 DO BEGIN
  hi_array(i-1,*) = reverse(data.field001[*,i])  
ENDFOR

time0 = anytim(file2time('swaves_average_20110607_a_hfr.dat'),/utim)
times=dblarr(data_size[2]-1)
times[0]=time0
FOR i=1,data_size[2]-2 DO BEGIN
  times[i]=time0+(i*60.)
ENDFOR  

stop
;==========================Read in low SWAVES A ASCII=========================
data=read_ascii('swaves_average_20110607_a_lfr.dat',delimiter=' ')
 

lo_freq_kHz = reverse(reform(data.field01[*,0]))
lo_freq_MHz = lo_freq_kHz/1000.
lo_freq_Hz = lo_freq_kHz*1000.

data_size = size(data.field01)
lo_array = dblarr(data_size[2]-1,data_size[1]);usually withough -5
FOR i=1,data_size[2]-1 DO BEGIN;usually -1
  lo_array(i-1,*) = reverse(data.field01[*,i]);ususally without 5:47, replace with *
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
device, filename = '20110607_radio2_draft3.ps',/color,bits=8,/inches,/landscape


loadct,5
!p.color=0
!p.background=255
!x.margin=[0,0]
!y.margin=[0,0]
!p.charsize=1
;multiplot,[1,3],ygap=0
MHz_convert=1e6

a = anytim(file2time('20110607_060000'),/utim)  ;CALLISTO-SWAVES plot start time
b = anytim(file2time('20110607_100000'),/utim)  ;CALLISTO-SWAVES plot end time

;========================Plot low SWAVES A array========================
ticks = loglevels([0.0025*(MHz_convert),0.125*(MHz_convert)],/fine) 
nticks=n_elements(ticks)

constant=fltarr(n_elements(times))
constant[*]=0.045*(MHz_convert)

;lo_array and hi_array are indexd to remove some frequencies so that 
;there's a smoother transition between plots
spectro_plot,bytscl(lo_array[*,2:n_elements(lo_array[0,*])-1],0,20),$ 
times,lo_freq_MHz[2:n_elements(lo_freq_MHz)-1]*(MHz_convert),$					  
/ylog,YTICKS=nticks-1,YTICKV=Reverse(ticks),/ys,$				  
xr=[a,b],xticks=1,xtickname=[' ',' ',' ',' ',' ',' '],xtitle = '  ',$
title='!3STEREO SWAVES and RSTO eCALLISTO',/xs, $
 position=[0.01,0.82,0.48,1],/normal,/NOERASE    ;pos=[x0,y0,x1,y1]
xyouts,0.3,0.96,'STEREO A SWAVES low',charsize=1,color=255,/normal  
 
loadct,0
oplot,times[*],constant[*],linestyle=2,color=255,thick=2

IF keyword_set(choose_points) THEN BEGIN
point,strlo_x,strlo_y,/data
save,strlo_x,filename='strlo_x.sav'
save,strlo_y,filename='strlo_y.sav'
ENDIF

;remove indexing from lo_freq_MHz and lo_array to view full sectra
;Same applies for the hi arrays


;======================Plot high SWAVES A array========================
loadct,5
;multiplot,ygap=0
ticks = loglevels([0.179*(MHz_convert),16.025*(MHz_convert)],/fine);remove 1e6 to plot in MHz
nticks=n_elements(ticks)
loadct,5

spectro_plot,bytscl(smooth(hi_array[*,0:n_elements(hi_freq_MHz)-2],1),0,20),$
times,hi_freq_MHz[0:n_elements(hi_freq_MHz)-2]*(MHz_convert),$;remove 1e6 to plot in MHz
;spectro_plot,bytscl(smooth(hi_array,1),0,20),times,hi_freq_MHz,$
/xs,/ylog,ytitle='Frequency (Hz)',$
xr=[a,b],xticks=1,xtickname=[' ',' ',' ',' ',' '],xtitle = '  ',YTICKS=nticks-1, $
      YTICKV=Reverse(ticks),/ys,$
       position=[0.01,0.66,0.48,0.82],/normal,/NOERASE
xyouts,0.3,0.78,'STEREO A SWAVES high',charsize=1,color=255,/normal    
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

loadct,5
ticks = loglevels([16.025*(MHz_convert),400*(MHz_convert)],/fine);remove 1e6 to plot in MHz
nticks=n_elements(ticks)

spectro_plot,bytscl(z_all,0,40),x_all,cal_freq*(MHz_convert),$
/xs,xr=[a,b],tick_unit=1800,xticks=9,xtitle=' ',xticklen=-0.04,xminor=3, $
yticks = nticks-1,/ylog,yr=[355*(MHz_convert),16.25*(MHz_convert)],YTICKV=Reverse(ticks),$
position=[0.01,0.5,0.48,0.66],/normal,/NOERASE,yminor=10
loadct,39
x_rec = anytim(file2time('20110607_062500'),/utim)
y_rec = 21*(MHz_convert)
rectangle,x_rec,y_rec,1200,270*(MHz_convert),color=140,thick=3,linestyle=2
xyouts,0.32,0.62,'RSTO eCallisto',charsize=1,color=255,/normal

;========================================================
;===============THE CALLISTO and SWAVES B data===========
;========================================================
loadct,5
ticks = loglevels([16.025*1e6,400*1e6],/fine);remove 1e6 to plot in MHz
nticks=n_elements(ticks)
spectro_plot,bytscl(reverse(z_all,2),0,40),x_all,reverse(cal_freq*(MHz_convert)),/xs,/ylog,xr=[a,b],$
yticks = nticks-1,tick_unit=1900,YTICKV=(ticks),xtitle = '  ',$
position=[0.01,0.29,0.48,0.45],/normal,/NOERASE,yr=[16.25*(MHz_convert),355*(MHz_convert)],$
xtickname=[' ',' ']
xyouts,0.32,0.41,'RSTO eCallisto',charsize=1,color=255,/normal


axis,xaxis=1,xstyle=1,color=0,xtickname=[' ',' ',' ',' ',' ',' ',' ',' ',' '],$
xticklen=-0.04,xticks=8,xminor=3

  
cd,'/Users/eoincarley/Data/secchi_l1/20110607/swaves/2011'

;========================Read in high B SWAVES ASCII=======================
data=read_ascii('swaves_average_20110607_b_hfr.dat',delimiter=' ')

hi_freq_kHz = reverse(reform(data.field001[*,0]));0:317 usually *
hi_freq_MHz = hi_freq_kHz/1000.
hi_freq_Hz = hi_freq_kHz*1000.

data_size = size(data.field001)
hi_array = dblarr(data_size[2]-1,data_size[1]);-1 usallly absent
FOR i=1,data_size[2]-1 DO BEGIN
  hi_array(i-1,*) = reverse(data.field001[*,i]);0:317 usually *  
ENDFOR

;=========================Read in low B SWAVES ASCII========================
data=read_ascii('swaves_average_20110607_a_lfr.dat',delimiter=' ')
help,data,/str 

lo_freq_kHz = reverse(reform(data.field01[*,0]))
lo_freq_MHz = lo_freq_kHz/1000.
lo_freq_Hz = lo_freq_kHz*1000.

data_size = size(data.field01)
lo_array = dblarr(data_size[2]-1,data_size[1]);usually withough -5

FOR i=1,data_size[2]-1 DO BEGIN;usually -1
  lo_array(i-1,*) = reverse(data.field01[*,i]);ususally without 5:47, replace with *
ENDFOR


;===========================Plot high SWAVES B array========================================

ticks = loglevels([0.179*(MHz_convert),16.025*(MHz_convert)],/fine)
nticks=n_elements(ticks)

ticks = loglevels([0.179*(MHz_convert),16.025*(MHz_convert)],/fine);remove 1e6 to plot in MHz
nticks=n_elements(ticks)
loadct,5

spectro_plot,bytscl(smooth(  reverse(hi_array[*,0:n_elements(hi_freq_MHz)-2],2),1),0,20),$
times,reverse(hi_freq_MHz[0:n_elements(hi_freq_MHz)-2]*(MHz_convert)),$;remove 1e6 to plot in MHz
;spectro_plot,bytscl(smooth(hi_array,1),0,20),times,hi_freq_MHz,$
/xs,/ylog,ytitle='Frequency (Hz)',$
xr=[a,b],xticks=1,xtickname=[' ',' ',' ',' ',' '],xtitle = '  ',YTICKS=nticks-1, $
    YTICKV=Reverse(ticks),/ys,$
       position=[0.01,0.13,0.48,0.29],/normal,/NOERASE
xyouts,0.3,0.25,'STEREO B SWAVES high',charsize=1,color=255,/normal
;===========================Plot low SWAVES B array========================================; 
ticks = loglevels([0.0025*(MHz_convert),0.125*(MHz_convert)],/fine) 
nticks=n_elements(ticks)

constant=fltarr(n_elements(times))
constant[*]=0.045*(MHz_convert)
;lo_array and hi_array are indexd to remove some frequencies so that 
;there's a smoother transition between plots

spectro_plot,bytscl(reverse(lo_array[*,2:n_elements(lo_array[0,*])-1],2),0,20),$ 
times,reverse(lo_freq_MHz[2:n_elements(lo_freq_MHz)-1]*(MHz_convert)),$					  
/ylog,$;ytitle='Frequency (MHz)',$						  
xr=[a,b],/xs,YTICKS=nticks-1, xtitle='Start Time ('+anytim(a,/yoh,/trun)+') UT',tick_unit=7200,$
      YTICKV=Reverse(ticks),/ys,xticks=1,xtickname=[' ',' ',' ',' '],$
      ;pos=[x0,y0,x1,y1]
 position=[0.01,0.0,0.48,0.13],/normal,/NOERASE
xyouts,0.3,0.03,'STEREO B SWAVES low',charsize=1,color=255,/normal 
 
loadct,0
oplot,times[*],constant[*],linestyle=2,color=255,thick=2 

;==========================================================================
;===========================Plot the zoom ins==============================
;==========================================================================

a = anytim(file2time('20110607_062500'),/utim)
b = anytim(file2time('20110607_064500'),/utim)
running_mean_background,spec_z_20110607,backg
spec_z_20110607 = spec_z_20110607 - backg

loadct,0
stretch,255,0
!p.color=255
;spectro_plot,bytscl(constbacksub(spec_z_20110607,/auto),0,30),spec_x_20110607,spec_y_20110607,/xs,xr=[a,b],$;ytitle='Frequency (MHz)'
spectro_plot,bytscl(constbacksub(spec_z_20110607,/auto),0,50),spec_x_20110607,spec_y_20110607,/xs,xr=[a,b],$
ytitle='Frequency (MHz)',title='RSTO eCALLISTO',/ys,xtitle='Start Time ('+anytim(a,/yoh,/trun)+') UT',$
position=[0.55,0.55,1,1],/normal,yr=[20,300],tick_unit=300,yticks=10,/NOERASE
x_rec = anytim(file2time('20110607_062700'),/utim)
loadct,39
rectangle,x_rec,30,250,60,color=50,thick=3,linestyle=2

plots,[0.1,0.56],[0.51,.55],/normal,thick=3,linestyle=2,color=140;======[x1,x2],[y1,y2]=====
plots,[0.1,0.55],[0.65,1],/normal,thick=3,linestyle=2,color=140

plots,[0.595,0.55],[0.89,.43],/normal,thick=3,linestyle=2,color=50;======[x1,x2],[y1,y2]====
plots,[0.69,1],[0.89,.445],/normal,thick=3,linestyle=2,color=50;======[x1,x2],[y1,y2]=======

cd,'/Users/eoincarley/Data/CALLISTO/20110607/Fits'
a = anytim(file2time('20110607_062700'),/utim)
b = anytim(file2time('20110607_062900'),/utim)
radio_spectro_fits_read,'BIR_20110607_062400_10.fit',z_zoom2,x_zoom2,y_zoom2
;loadct,39
;plots,[0.135,0.1],[0.51,0.27],/normal,thick=3,linestyle=1,color=60
;plots,[0.32,0.95],[0.51,0.27],/normal,thick=3,linestyle=1,color=60
loadct,0
stretch,255,0
!p.color=255
spectro_plot,bytscl(constbacksub(z_zoom2,/auto),0,200),x_zoom2,y_zoom2,/xs,xr=[a,b],$
ytitle='Frequency (MHz)',title='RSTO eCALLISTO',/ys,yr=[30,90],tick_unit=40,$
xtitle='Start Time ('+anytim(a,/yoh,/trun)+') UT',position=[0.55,0,1,0.44],/normal,/NOERASE


;pos=[x0,y0,x1,y1]


END
