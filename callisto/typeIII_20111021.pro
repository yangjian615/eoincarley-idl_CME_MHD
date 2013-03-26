pro typeIII_20111021

cd,'/Users/eoincarley/Data/CALLISTO/20111021

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

window,0,xs=700,ys=800

loadct,9
stretch,255,70
!p.charsize=1.5
spectro_plot,constbacksub(z0,/auto),x0,y0,/xs,/ys,ytitle='Frequency [MHz]',$
;spectro_plot,z0,x0,y0,/xs,/ys,ytitle='Frequency [MHz]',$
yticks=2,ytickv=[10,50,90],yr=[100,10],yminor = 4,$
xrange='2011-oct-21 '+['12:56:00','13:00:00'],$
xticks=2,xtickname=[' ',' ',' ',' ',' '],xtitle=' ',title='eCallisto Birr Castle, Ireland',$
position=[0.1,0.74,0.98,0.96]

stretch,270,40
spectro_plot,constbacksub(z1,/auto),x1,y1,/xs,/ys,ytitle='Frequency [MHz]',$
;spectro_plot,z1,x1,y1,/xs,/ys,ytitle='Frequency [MHz]',$
yticks=1,ytickv=[100,150],yr=[200,100],yminor = 5,$
xrange='2011-oct-21 '+['12:56:00','13:00:00'],$
xticks=2,xtickname=[' ',' ',' ',' ',' '],xtitle=' ',xticklen=0,/noerase,/normal,$
position=[0.1,0.52,0.98,0.74]

spectro_plot,constbacksub(z2,/auto),x2,y2,/xs,/ys,ytitle='Frequency [MHz]',$
yticks=2,ytickv=[200,300,400],yr=[400,200],yminor = 5,$
position=[0.1,0.1,0.98,0.52],xrange='2011-oct-21 '+['12:56:00','13:00:00'],$
/noerase,/normal

stop
END