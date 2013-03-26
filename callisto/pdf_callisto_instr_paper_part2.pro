pro pdf_callisto_instr_paper_part2


cd,'/Users/eoincarley/Data/CALLISTO/20110607/'

restore,'spec_z_20110607.sav'
restore,'spec_x_20110607.sav'
restore,'spec_y_20110607.sav'

cal_array = spec_z_20110607
cal_time = spec_x_20110607
cal_freq = spec_y_20110607
running_mean_background,cal_array,back
cal_arraybs = cal_array - back
cd,'/Users/eoincarley/Data/CALLISTO/instrument_paper
set_plot,'ps'
device, filename = '20110607_callisto_instr.ps',/color,bits=8,/inches,/landscape


a = anytim(file2time('20110607_062500'),/utim)
b = anytim(file2time('20110607_064500'),/utim)
running_mean_background,spec_z_20110607,backg
spec_z_20110607 = spec_z_20110607 - backg

loadct,9
stretch,350,80
!p.color=350
!p.charsize=0.8

spectro_plot,bytscl(spec_z_20110607,-20,50),spec_x_20110607,spec_y_20110607,$
	/xs,xr=[a,b],xtitle='!6Start Time ('+anytim(a,/yoh,/trun)+') UT',tick_unit=300,$
	ytitle='Frequency (MHz)',/ys,yr=[20,300],yticks=7,ytickunit=40,yminor=2,$
	position=[0.55,0.55,1,1],/normal,/NOERASE

x_rec = anytim(file2time('20110607_062700'),/utim)

loadct,39
stretch,255,0
!p.color=0
rectangle,x_rec,30,130,60,color=0,thick=3,linestyle=0
rectangle,x_rec,30,130,60,color=255,thick=3,linestyle=2
xyouts,0.555,0.97,'(a)',charsize=1.0,color=255,/normal

;plots,[0.1,0.56],[0.54,.55],/normal,thick=3,linestyle=0,color=0;======[x1,x2],[y1,y2]=====
;plots,[0.1,0.56],[0.54,.55],/normal,thick=3,linestyle=2,color=255
;plots,[0.1,0.55],[0.68,1],/normal,thick=3,linestyle=0,color=0
;plots,[0.1,0.55],[0.68,1],/normal,thick=3,linestyle=2,color=255

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

xyouts,0.56,0.44,'(b)',/normal,charsize=1.0,color=255
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