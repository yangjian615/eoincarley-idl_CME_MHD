pro plot_allcallisto_swaves,array,freq_kHz,times,choose_points=choose_points,all_callisto=all_callisto

cd,'/Users/eoincarley/Data/secchi_l1/20110607/swaves/2011'

;===========================Read in high SWAVES ASCII=======================
data=read_ascii('swaves_average_20110607_a_hfr.dat',delimiter=' ')
help,data,/str
hi_freq_kHz = reverse(reform(data.field001[*,0]));0:317 usually *
hi_freq_MHz = hi_freq_kHz/1000.
hi_freq_Hz = hi_freq_kHz*1000.

data_size = size(data.field001)
hi_array = dblarr(data_size[2]-1,data_size[1]);-1 usallly absent

FOR i=1,data_size[2]-1 DO BEGIN
  hi_array(i-1,*) = reverse(data.field001[*,i]);0:317 usually *  
ENDFOR

time0 = anytim(file2time('swaves_average_20110607_a_hfr.dat'),/utim)
times=dblarr(data_size[2]-1)
times[0]=time0
FOR i=1,data_size[2]-2 DO BEGIN
  times[i]=time0+(i*60.)
ENDFOR  

a = anytim(file2time('20110607_062000'),/utim)
b = anytim(file2time('20110607_100000'),/utim)


;==========================Read in low SWAVES ASCII=========================
 
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

;;==========================Read in CALLISTO spectrum=======================


cd,'/Users/eoincarley/Data/CALLISTO/20110607/'

restore,'spec_z_20110607.sav'
restore,'spec_x_20110607.sav'
restore,'spec_y_20110607.sav'

cal_array = spec_z_20110607
cal_time = spec_x_20110607
cal_freq = spec_y_20110607
running_mean_background,cal_array,back


cal_arraybs = cal_array - back
;set_plot,'ps'
;device, /landscape, filename = 'testing.ps',/color,bits=8

;============================================================================
;==============================Start plotting================================
;============================================================================

;=======Define window and mutiplot variables======
set_plot,'ps'
device, filename = '20110607_radio1.ps',/color,bits=8,/inches,xsize=8.5,ysize=11,$
yoffset=0,xoffset=0
loadct,39
!p.color=0
!p.background=255
;window,20,xs=1000,ys=800
loadct,5
!p.color=0
!p.background=255
;!x.margin=[2,2]
;!y.margin=[5,5]
!p.charsize=1
;multiplot,[1,3],ygap=0
MHz_convert=1e6

;========================Low SWAVES array========================
ticks = loglevels([0.0025*(MHz_convert),0.125*(MHz_convert)],/fine) ;remove 1e6 to plot in MHz
nticks=n_elements(ticks)

constant=fltarr(n_elements(times))
constant[*]=0.045*(MHz_convert)
;lo_array and hi_array are indexd to remove some frequencies so that 
;there's a smoother transition between plots

spectro_plot,bytscl(lo_array[*,2:n_elements(lo_array[0,*])-1],0,20),$ 
times,lo_freq_MHz[2:n_elements(lo_freq_MHz)-1]*(MHz_convert),$		;remove 1e6 to plot in MHz			  
/ylog,$;ytitle='Frequency (MHz)',$						  
xr=[a,b],title='!3SWAVES and eCallisto Ireland, 350-0.0025 MHz',/xs,YTICKS=nticks-1, $
      YTICKV=Reverse(ticks),/ys,$
      ;pos=[x0,y0,x1,y1]
 position=[0.1,0.85,0.95,0.95],/normal,/NOERASE

IF keyword_set(choose_points) THEN BEGIN
point,strlo_x,strlo_y,/data
save,strlo_x,filename='strlo_x.sav'
save,strlo_y,filename='strlo_y.sav'
ENDIF

;remove indexing from lo_freq_MHz and lo_array to view full sectra
;Same applies for the hi arrays

loadct,0
oplot,times[*],constant[*],linestyle=2,color=255,thick=2
loadct,5

;========================High SWAVES array========================

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
       position=[0.1,0.75,0.95,0.85],/normal,/NOERASE
      
IF keyword_set(choose_points) THEN BEGIN
point,strhi_x,strhi_y,/data
save,strhi_x,filename='strhi_x.sav'
save,strhi_y,filename='strhi_y.sav'

ENDIF


;===================Plot Callisto dynamic spectra=================
;multiplot,ygap=0
loadct,5

ticks = loglevels([16.025*1e6,400*1e6],/fine);remove 1e6 to plot in MHz
nticks=n_elements(ticks)

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

;remove 1e6 to plot in MHz
spectro_plot,bytscl(z_all,0,40),x_all,cal_freq*(MHz_convert),/xs,/ylog,xr=[a,b],$;ytitle='Frequency (MHz)'
;title='eCallisto, Birr Castle, 2011/06/07 20-90 MHz',
yticks = nticks-1,tick_unit=1200,yr=[355*(MHz_convert),16.25*(MHz_convert)],YTICKV=Reverse(ticks),$
position=[0.1,0.65,0.95,0.75],/normal,/NOERASE,xtitle='Start Time ('+anytim(a,/yoh,/trun)+') UT'

;=====================Label the SWAVES eCALLISTO composite==============
loadct,39
xyouts,0.73,0.72,'eCallisto Birr, Ireland',charsize=1,color=255,/normal
xyouts,0.73,0.83,'STEREO SWAVES HIGH',charsize=1,color=255,/normal
xyouts,0.73,0.92,'STEREO SWAVES LOW',charsize=1,color=255,/normal
xyouts,0.73,0.88,'0.045 MHz',charsize=1,color=255,/normal

;==========Draw rectangle on callisto spectrum============
x_rec = anytim(file2time('20110607_062500'),/utim)
y_rec = 21*(MHz_convert)
loadct,39
rectangle,x_rec,y_rec,1200,270*(MHz_convert),color=100,thick=3,linestyle=1


IF keyword_set(choose_points) THEN BEGIN
point,cal_x,cal_y,/data
save,cal_x,filename='cal_x.sav'
save,cal_y,filename='cal_y.sav'
ENDIF


;multiplot,/reset 
;==============================Plot zoom-in 1====================================
;multiplot,ygap=0
a = anytim(file2time('20110607_062500'),/utim)
b = anytim(file2time('20110607_064500'),/utim)
running_mean_background,spec_z_20110607,backg
spec_z_20110607 = spec_z_20110607 - backg
;stop
loadct,0
stretch,255,0
!p.color=255
spectro_plot,bytscl(spec_z_20110607,0,50),spec_x_20110607,spec_y_20110607,/xs,xr=[a,b],$;ytitle='Frequency (MHz)'
ytitle='Frequency (MHz)',title='eCallisto Birr Castle, Ireland',/ys,xtitle='Start Time ('+anytim(a,/yoh,/trun)+') UT',$
position=[0.1,0.34,0.95,0.57],/normal,yr=[20,300],tick_unit=300,yticks=10,/NOERASE
x_rec = anytim(file2time('20110607_062550'),/utim)
loadct,39
rectangle,x_rec,30,250,60,color=60,thick=3,linestyle=1

plots,[0.12,0.1],[0.655,0.57],/normal,thick=3,linestyle=1,color=60
plots,[0.2,0.95],[0.655,0.57],/normal,thick=3,linestyle=1,color=60



;==========================Plot zoom-in 2=====================================
loadct,0
stretch,255,0
!p.color=255
cd,'/Users/eoincarley/Data/CALLISTO/20110607/Fits'
a = anytim(file2time('20110607_062540'),/utim)
b = anytim(file2time('20110607_063000'),/utim)
radio_spectro_fits_read,'BIR_20110607_062400_10.fit',z_zoom2,x_zoom2,y_zoom2
loadct,39
plots,[0.135,0.1],[0.51,0.27],/normal,thick=3,linestyle=1,color=60
plots,[0.32,0.95],[0.51,0.27],/normal,thick=3,linestyle=1,color=60
loadct,0
stretch,255,0
!p.color=255
spectro_plot,bytscl(constbacksub(z_zoom2,/auto),-5,200),x_zoom2,y_zoom2,/xs,xr=[a,b],$
ytitle='Frequency (MHz)',title='eCallisto Birr Castle, Ireland',/ys,yr=[30,90],$
;position=[0.1,0.05,0.95,0.27],/normal,yr=[30,90],tick_unit=30,/NOERASE
xtitle='Start Time ('+anytim(a,/yoh,/trun)+') UT',position=[0.1,(0.05),0.95,(0.27)],/normal,/NOERASE

;=========================Plot lines======================================== 



;======[x1,x2],[y1,y2]=====

;plots,[0.12,0.1],[0.655,0.57],/normal,thick=3,linestyle=1,color=60
;plots,[0.2,0.95],[0.655,0.57],/normal,thick=3,linestyle=1,color=60

;plots,[0.135,0.1],[0.502,0.27],/normal,thick=3,linestyle=1,color=60
;plots,[0.31,0.95],[0.502,0.27],/normal,thick=3,linestyle=1,color=60

;xyouts,0.73,0.67,'eCallisto Birr, Ireland',charsize=1,color=255,/normal
;xyouts,0.73,0.77,'STEREO SWAVES HIGH',charsize=1,color=255,/normal
;xyouts,0.73,0.87,'STEREO SWAVES LOW',charsize=1,color=255,/normal
;xyouts,0.73,0.83,'0.045 MHz',charsize=1,color=255,/normal


END