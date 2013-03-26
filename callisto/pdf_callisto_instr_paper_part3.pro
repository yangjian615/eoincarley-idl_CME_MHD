pro pdf_callisto_instr_paper_part3

cd,'/Users/eoincarley/Data/CALLISTO/instrument_paper
radio_spectro_fits_read,'BIR_20110922_103000_01.fit',z,x,y
running_mean_background,z,back
zb=z-back

a = anytim(file2time('20110922_103800'),/utim)
b = anytim(file2time('20110922_134500'),/utim)

goes_data = latest_goes('20110922_100000','20110922_120000')


set_plot,'ps'
device,filename = 'callisto_instr_paper1_goes.ps',/color,bits=8,/inches,/encapsulate,$
xsize=10,ysize=8,xoffset=10.0

!p.multi=[0,1,2]

xstart = anytim(file2time('20110922_100000'),/utim)
xend = anytim(file2time('20110922_120000'),/utim)
xstart_display = anytim(file2time('20110922_100000'),/yoh, /trun)

loadct,39
!p.background=255
!p.color=0
utplot,goes_data[0,*],goes_data[1,*],/ylog,xr=[xstart,xend],$
/xs,thick=1,yrange=[1e-9,1e-3],psym=3,xtitle='Start Time (2011-Sep-22 10:00:00 UT)',$
position=[0.07,0.6,0.95,0.97]
oplot,goes_data[0,*],goes_data[1,*],color=245

xyouts,0.02, 0.75, 'Watts m!U-2!N',/normal,orientation=90
axis,yaxis=1,ytickname=[' ','A','B','C','M','X',' '];,charsize=1.5
;axis,yaxis=0,yrange=[1e-9,1e-3];,charsize=1.5
oplot,goes_data[0,*],goes_data[2,*],color=80,thick=1
legend, ['GOES15 0.1-0.8 nm','GOES15 0.05-0.4 nm'],$
linestyle=[0,0], color=[245,80], box=0,pos=[0.07,0.96],/normal

loadct,0
i_gen = dindgen(1001)*((1.0e-3 - 1.0e-9)/1000)+1.0e-9
tcon = anytim(file2time('20110922_103900'),/utim)
plots,tcon,i_gen,linestyle=2
;plots,tcon,i_gen,linestyle=2,color=255

i_gen = dindgen(1001)*((1.0e-3 - 1.0e-9)/1000)+1.0e-9
tcon = anytim(file2time('20110922_104500'),/utim)
plots,tcon,i_gen,linestyle=2
;plots,tcon,i_gen,linestyle=2,color=255

plots,[0.07,0.355],[0.50,0.6],/normal,linestyle=2
plots,[0.90,0.4],[0.50,0.6],/normal,linestyle=2

loadct,0
plots,goes_data[0,*],1e-8,thick=0.2,color=200
plots,goes_data[0,*],1e-7,thick=0.2,color=200
plots,goes_data[0,*],1e-6,thick=0.2,color=200
plots,goes_data[0,*],1e-5,thick=0.2,color=200
plots,goes_data[0,*],1e-4,thick=0.2,color=200
;oplot,goes(0,*),goes(1,*),color=230,thick=1.7



loadct,9
!p.color=255
!p.background=0
stretch,255,60
spectro_plot,bytscl(constbacksub(z,/auto),-30,80),x,y,/xs,/ys,ytitle='!6Frequency [MHz]',$
yr=[100,10],yticks=9,yminor=2,$
xrange='2011-sep-22 '+['10:39:00','10:45:00'],charsize=1,$
xtitle='!6Start Time (2011-Sep-22 10:39:00 UT)',position=[0.07,0.1,0.90,0.5]

color_key, range = [ min(constbacksub(z,/auto)), max(constbacksub(z,/auto)) ],ysize=-0.5,barwidth = 0.2,$
charsize=1.0,title='Intensity (DNs)'

xyouts,0.09, 0.28, 'F',/normal,charsize=2,charthick=8
xyouts,0.09, 0.28, 'F',/normal,charsize=2,charthick=2,color=0

xyouts,0.13, 0.18, 'H',/normal,charsize=2,charthick=8
xyouts,0.13, 0.18, 'H',/normal,charsize=2,charthick=2,color=0


;loadct,5
;!p.color=0
;!p.background=255
;stretch,255,0
;spectro_plot,zb,x,y,/xs,/ys,charsize=1.5,ytitle='Frequency [MHz]'


device,/close
set_plot,'x'


set_plot,'ps'
device,filename = 'callisto_surface_for_transfer.ps',/color,bits=16,/inches,/encapsulate,$
xsize=12,ysize=8;,xoffset=10.0

loadct,0
!p.color=255
!p.background=0
stretch,255,60

t1 = closest(x,anytim( file2time('20110922_103800'),/utim) )
t2 = closest(x,anytim( file2time('20110922_104400'),/utim) )

test = smooth(constbacksub(z,/auto),30)
shade_surf,test[t1:t2,*],charsize=2.5,az=40,ax=40,position=[0.15,0.1,0.99,0.99],yticks=9,$
ytickname=[100,90,80,70,60,50,40,30,20,10],ytitle='Frequency (MHz)',/ys,/xs,/zs,$
xticks=3,xtickname=['10:38','10:40','10:42','10:44'],xtitle='Start Time (2011-Sep-22 10:38:00 UT)',$
xminor=3,ztitle='I n t e n s i t y (DNs)'

;

device,/close
set_plot,'x'

END





;utplot,goes(0,*),goes(1,*),xr=[xstart,xend],$
;/xs,thick=1,yrange=[1e-9,1e-3],/ylog,title='1-minute GOES-15 Solar X-ray Flux',psym=3,$
;position=[0.055,0.69,0.98,0.94],/normal,/noerase
;oplot,goes(0,*),goes(1,*),color=240,thick=2

;xyouts,0.015, 0.78, 'Watts m!U-2!N',/normal,orientation=90

;axis,yaxis=1,ytickname=[' ','A','B','C','M','X',' '];,charsize=1.5
;axis,yaxis=0,yrange=[1e-9,1e-3];,charsize=1.5
;axis,xaxis=0,XTICKFORMAT = 'LABEL_DATE',XTICKUNITS = 'minutes',$
;xtickinterval=10,/xs,charsize=1.5,xtitle='!1 Start time: ('+start_time+') UT'

;plots,goes(0,*),1e-8
;plots,goes(0,*),1e-7
;plots,goes(0,*),1e-6
;plots,goes(0,*),1e-5
;plots,goes(0,*),1e-4
;oplot,goes(0,*),goes(1,*),color=230,thick=1.7
;oplot,goes(0,*),goes(2,*),color=80,thick=1.7 

;legend, ['GOES15 0.1-0.8nm','GOES15 0.05-0.4nm'],$
;linestyle=[0,0], color=[220,80], box=0,pos=[0.05,0.935],/normal