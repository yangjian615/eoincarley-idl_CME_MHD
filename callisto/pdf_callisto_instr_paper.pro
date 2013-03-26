pro pdf_callisto_instr_paper

cd,'/Users/eoincarley/Data/CALLISTO/instrument_paper
radio_spectro_fits_read,'BIR_20110922_103000_01.fit',z,x,y
running_mean_background,z,back
zb=z-back

a = anytim(file2time('20110922_103800'),/utim)
b = anytim(file2time('20110922_134500'),/utim)

set_plot,'ps'
device,filename = 'callisto_instr_paper1.ps',/color,bits=8,/inches,/encapsulate,$
xsize=10,ysize=5,xoffset=10.0


loadct,9
!p.color=255
!p.background=0
stretch,255,60
spectro_plot,zb,x,y,/xs,/ys,ytitle='!6Frequency [MHz]',$
yr=[100,10],ytickv=[100,80,60,40,20,10],yticks=5,yminor=4,$
xrange='2011-sep-22 '+['10:39:00','10:45:00'],charsize=1,xtitle='!6Start Time (2011-Sep-22 10:39:00 UT)'

;loadct,5
;!p.color=0
;!p.background=255
;stretch,255,0
;spectro_plot,zb,x,y,/xs,/ys,charsize=1.5,ytitle='Frequency [MHz]'

device,/close
set_plot,'x'


cd,'/Users/eoincarley/Data/CALLISTO/instrument_paper
radio_spectro_fits_read,'BIR_20110922_104459_01.fit',z,x,y
running_mean_background,z,back
zb=z-back

set_plot,'ps'
device,filename = 'callisto_instr_paper2.ps',/color,bits=8,/inches,/encapsulate,$
xsize=10,ysize=5,xoffset=10.0


loadct,9
!p.color=255
!p.background=0
stretch,255,80
spectro_plot,constbacksub(z,/auto),x,y,/xs,/ys,ytitle='!6Frequency [MHz]',$
;spectro_plot,zb,x,y,/xs,/ys,ytitle='!6Frequency [MHz]',$
yr=[100,10],yticks=9,yminor=2,$
xrange='2011-sep-22 '+['10:51:00','10:53:00'],charsize=1,xtitle='!6Start Time (2011-Sep-22 10:51:00 UT)',$
position=[0.08,0.1,0.95,0.95],/normal


device,/close
set_plot,'x'

set_plot,'ps'
device,filename = 'callisto_instr_paper3.ps',/color,bits=8,/inches,/encapsulate,$
xsize=6.5,ysize=8,xoffset=1.0

cd,'/Users/eoincarley/Data/CALLISTO/20111021'

files = findfile('*.fit')

low = files[1]
mid = files[2]
high = files[0]

radio_spectro_fits_read,low,z0,x0,y0
radio_spectro_fits_read,mid,z1,x1,y1
radio_spectro_fits_read,high,z2,x2,y2


loadct,39
!p.color=255
!p.background=0

loadct,9
stretch,255,70
!p.charsize=1
spectro_plot,constbacksub(z0,/auto),x0,y0,/xs,/ys,$
yticks=2,ytickv=[10,50,90],yr=[100,10],yminor = 4,$
xrange='2011-oct-21 '+['12:56:00','12:59:00'],$
xticks=3,xtickname=[' ',' ',' ',' ',' ',' ',' ',' ',' '],xtitle=' ',$
position=[0.1,0.755,0.97,0.975]

stretch,270,40
spectro_plot,constbacksub(z1,/auto),x1,y1,/xs,/ys,$
;spectro_plot,z1,x1,y1,/xs,/ys,ytitle='Frequency [MHz]',$
yticks=1,ytickv=[100,150],yr=[200,100],yminor = 5,$
xrange='2011-oct-21 '+['12:56:00','12:59:00'],$
xticks=3,xtickname=[' ',' ',' ',' ',' ',' ',' ',' ',' '],xtitle=' ',xticklen=0,/noerase,/normal,$
position=[0.1,0.52,0.97,0.755]


spectro_plot,constbacksub(z2,/auto),x2,y2,/xs,/ys,$
yticks=2,ytickv=[200,300,400],yr=[400,200],yminor = 5,$
position=[0.1,0.06,0.97,0.52],xrange='2011-oct-21 '+['12:56:00','12:59:00'],tick_unit=60,$
/noerase,/normal,xtitle='!6Start Time (2011-Oct-21 12:56:00 UT)'

xyouts,0.25, 0.35, 'Type III',/normal,charsize=1.2,charthick=2
xyouts,0.75, 0.17, 'Type II',/normal,charsize=1.2,charthick=2

xyouts,0.03,0.44,'Frequency [MHz]',orientation=90,/normal

device,/close
set_plot,'x'




END