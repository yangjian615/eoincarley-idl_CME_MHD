pro example_20110922

;
;
;
;
;

cd,'/Users/eoincarley/Data/CALLISTO/20110922'
radio_spectro_fits_read,'BIR_20110922_103000_01.fit',z0,x0,y0
radio_spectro_fits_read,'BIR_20110922_104459_01.fit',z1,x1,y0

a = anytim(file2time('20110922_103900'),/utim)
b = anytim(file2time('20110922_104600'),/utim)

zraw=[z0,z1]
x=[x0,x1]

thisDevice = !D.Name
set_plot,'z',/copy

device, set_resolution=[1000,500],z_buffer=0
erase

loadct,9
!p.color=255
!p.background=0

stretch,255,80
spectro_plot,constbacksub(zraw,/auto),x,y0,/xs,/ys,charsize=1.5,ytitle='Frequency [MHz]',$;,xr=[a,b],$
title='RSTO low CALLISTO receiver',yr=[100,10],ytickv=[100,80,60,40,20,10],yticks=5,$
yminor=4,xr='2011-sep-22 '+['10:51:00','10:53:00']


snapshot = TVRD()
TVLCT, r, g, b, /Get
Device, Z_Buffer=1
Set_Plot, thisDevice

image24 = BytArr(3, 1000, 500)
image24[0,*,*] = r[snapshot]
image24[1,*,*] = g[snapshot]
image24[2,*,*] = b[snapshot]

write_png, 'zb_herrigbones.png', image24, r, g, b

set_plot,'x'

END