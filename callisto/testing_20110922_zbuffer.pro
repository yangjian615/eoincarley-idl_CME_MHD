pro testing_20110922_zbuffer

cd,'/Users/eoincarley/Data/CALLISTO/20110922'
radio_spectro_fits_read,'BIR_20110922_103000_01.fit',z0,x0,y0
running_mean_background,z0,back
zb0=z0-back

radio_spectro_fits_read,'BIR_20110922_104459_01.fit',z1,x1,y0
running_mean_background,z1,back
zb1=z1-back



a = anytim(file2time('20110922_105100'),/utim)
b = anytim(file2time('20110922_105300'),/utim)
zraw=[z0,z1]
zb=[zb0,zb1]
x = [x0,x1]

;z_new = zb-smooth(zb,3,/ed)
;z_new = sobel(zb)
;z_new = z_new*zb

thisDevice = !D.Name
set_plot,'z',/copy
!p.multi=[0,1,1]
;spectro_plot,zraw,x,y,/xs,/ys,charsize=1.5,ytitle='Frequency [MHz]'


device, set_resolution=[1000,500],z_buffer=0
erase

loadct,9
!p.color=255
!p.background=0
stretch,240,100
spectro_plot,zb,x,y0,charsize=1.5,/xs,/ys,ytitle='Frequency [MHz]',xr=[a,b],$
title='RSTO low CALLISTO receiver',yr=[100,10],ytickv=[100,80,60,40,20,10],yticks=5,$
yminor=4
;spectro_plot,zb,x,y0,charsize=1.5

snapshot = TVRD()
TVLCT, r, g, b, /Get
Device, Z_Buffer=1
Set_Plot, thisDevice

image24 = BytArr(3, 1000, 500)
image24[0,*,*] = r[snapshot]
image24[1,*,*] = g[snapshot]
image24[2,*,*] = b[snapshot]

write_png, 'default_plot.png', image24,r,g,b



END