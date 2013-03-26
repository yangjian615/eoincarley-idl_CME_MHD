pro plot_callisto_swaves,array,freq_kHz,times,choose_points=choose_points,all_callisto=all_callisto

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



;=======================CALLISTO=====================================
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

;=========================Start Plotting=========================
MHz_convert=1e6
stop_freq = closest(lo_freq_MHz, 0.02)
loadct,39
!p.color=0
!p.background=255
window,20,xs=1200,ys=700
loadct,5
!p.color=0
!p.background=255
!x.margin=[15,4]
!y.margin=[5,5]
multiplot,[1,3],ygap=0

a = anytim(file2time('20110607_062000'),/utim)
b = anytim(file2time('20110607_100000'),/utim)

ticks = loglevels([0.02*(MHz_convert),0.125*(MHz_convert)],/fine) ;remove 1e6 to plot in MHz
nticks=n_elements(ticks)

constant=fltarr(n_elements(times))
constant[*]=0.045*(MHz_convert)
;lo_array and hi_array are indexd to remove some frequencies so that 
;there's a smoother transition between plots

spectro_plot,bytscl(lo_array[*,0:stop_freq],0,20),$ 
times,lo_freq_MHz[0:stop_freq]*(MHz_convert),$		;remove 1e6 to plot in MHz			  
/ylog,$;ytitle='Frequency (MHz)',$						  
xr=[a,b],title='!3SWAVES and eCallisto Ireland, 350-0.0025 MHz',/xs,YTICKS=nticks-1, $
      YTICKV=Reverse(ticks),/ys
      ;pos=[x0,y0,x1,y1]
 ;position=[0.1,0.85,0.95,0.95],/normal,/NOERASE

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

multiplot,ygap=0
ticks = loglevels([0.179*(MHz_convert),16.025*(MHz_convert)],/fine);remove 1e6 to plot in MHz
nticks=n_elements(ticks)
loadct,5

spectro_plot,bytscl(smooth(hi_array[*,0:n_elements(hi_freq_MHz)-2],1),0,20),$
times,hi_freq_MHz[0:n_elements(hi_freq_MHz)-2]*(MHz_convert),$;remove 1e6 to plot in MHz
;spectro_plot,bytscl(smooth(hi_array,1),0,20),times,hi_freq_MHz,$
/xs,/ylog,ytitle='Frequency (Hz)',$
xr=[a,b],xticks=1,xtickname=[' ',' ',' ',' ',' '],xtitle = '  ',YTICKS=nticks-1, $
      YTICKV=Reverse(ticks),/ys
      ; position=[0.1,0.75,0.95,0.85],/normal,/NOERASE
      
IF keyword_set(choose_points) THEN BEGIN
point,strhi_x,strhi_y,/data
save,strhi_x,filename='strhi_x.sav'
save,strhi_y,filename='strhi_y.sav'

ENDIF

;stop

loadct,5
data = scale_vector(findgen(200),20,400)
ticks = loglevels([16.025,400],/fine)
nticks=n_elements(ticks)
multiplot,ygap=0
;=============================Plot Callisto dynamic spectra=================================

;window,21,xs=1200,ys=700
spectro_plot,bytscl(cal_arraybs,0.01,40),cal_time,cal_freq,/xs,/ylog,charsize=1.5,ytitle='Frequency (MHz)',xr=[a,b],$
;title='eCallisto, Birr Castle, 2011/06/07 20-90 MHz',
yticks = nticks-1,tick_unit=1200,yr=[355,16.25],YTICKV=Reverse(ticks)



IF keyword_set(choose_points) THEN BEGIN
point,cal_x,cal_y,/data
save,cal_x,filename='cal_x.sav'
save,cal_y,filename='cal_y.sav'
ENDIF
xyouts,940,205,'eCallisto Birr, Ireland',charsize=2,color=0,/device
xyouts,940,405,'STEREO SWAVES HIGH',charsize=2,color=255,/device
xyouts,940,605,'STEREO SWAVES LOW',charsize=2,color=255,/device
xyouts,940,520,'0.045 MHz',charsize=2,color=255,/device
multiplot,/reset 
  
END