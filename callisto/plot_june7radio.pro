pro plot_june7radio

cd,'/Users/eoincarley/Data/CALLISTO/20110607'

restore,'spec_x_20110607.sav'
restore,'spec_y_20110607.sav'
restore,'spec_z_20110607.sav'
cd,'/Users/eoincarley/Data/CALLISTO/20110607/Fits'
;restore,'2011-06-07T05:38:25.442_1HRx.sav'
;restore,'2011-06-07T05:38:25.442_1HRz.sav'
;running_mean_background,znew,backg
;znew=znew-backg


a = anytim(file2time('20110607_061500'),/utim)
b = anytim(file2time('20110607_065000'),/utim)
running_mean_background,spec_z_20110607,backg
spec_z_20110607 = spec_z_20110607 - backg
;spec_z_20110607 = [znew,spec_z_20110607]
;spec_x_20110607 = [x_master,spec_x_20110607]
;set_plot,'ps'
;device, filename = 'june7_radio.ps',/color,bits=8,/inches,/landscape


;cd,'/Users/eoincarley/Data/CALLISTO/20110607/Fits';
;	restore,'z_all_20110607.sav';
;	restore,'x_all_20110607.sav'

;window,10,xs=1000,ys=600
;spectro_plot,bytscl(z_all,-50,50),x_all,spec_y_20110607,$;
;	/xs,xr=[a,b],xtitle='!6Start Time ('+anytim(a,/yoh,/trun)+') UT',tick_unit=300,$
;	ytitle='Frequency (MHz)',/ys,yr=[20,300],yticks=7,ytickunit=40,yminor=2,charsize=2,$
;	title='RSTO eCALLISTO, June 7th 2011 Event'
;loadct,39
;latest_goes,'20110607_061500','20110607_065000',goes_array,time
;time = anytim(file2time(time),/utim)
;axis,yaxis=1,yr=[1e-9,1e-3],/ylog,/save,charsize=1.5
;outplot,time,goes_array[1,*],color=240,thick=2
;outplot,time,goes_array[2,*],color=100,thick=2
;stop



cd,'/Users/eoincarley/Data/CALLISTO/20110607/Fits'
radio_spectro_fits_read,'BIR_20110607_062400_10.fit',z_zoom,x_zoom,y_zoom

a = anytim(file2time('20110607_062700'),/utim)
b = anytim(file2time('20110607_062900'),/utim)
;xyouts,1,0.5,'(c)',/normal,charsize=1.5,color=255

;!p.position=[0.55,0,1,0.47]
window,11,xs=1000,ys=600
spectro_plot,bytscl(z_zoom,0,250),x_zoom,y_zoom,$
	/xs,xr=[a,b],xtitle='Start Time ('+anytim(a,/yoh,/trun)+') UT',tick_unit=30,$
	ytitle='Frequency (MHz)',/ys,yr=[30,90],yminor=2,charsize=1.5,$
	title='RSTO eCALLISTO, Herringbones'
	
;lates_goes,'

;device,/close
;set_plot,'x'
END	
	
	