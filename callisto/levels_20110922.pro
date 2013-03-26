pro levels_20110922

cd,'~/Data/CALLISTO/20110922/pre_event'

list=findfile('*01.fit')
radio_spectro_fits_read,list[0],low,t_low,y_low

list=findfile('*02.fit')
radio_spectro_fits_read,list[0],mid,t_mid,y_mid

list=findfile('*03.fit')
radio_spectro_fits_read,list[0],high,t_high,y_high

master = [reverse(transpose(low)),reverse(transpose(mid)),$
         reverse(transpose(high))]

master=transpose(reverse(master))

RUNNING_MEAN_BACKGROUND,master,masterb

freq=[reverse(y_low),reverse(y_mid),reverse(y_high)]

I=reverse(reform(masterb[10,*]))

thisDevice = !D.Name
set_plot,'z',/copy
device, set_resolution=[1000,600],z_buffer=0
loadct,39
!p.color=0
!p.background=255

!p.charsize=1.5
plot,freq[0:199],I[0:199],psym=0,xr=[10,400],yr=[80,200],/xs,$
xtitle='Frequency (MHz)',ytitle='Intensity (Arbitrary units)',$
title='RSTO CALLISTO spectrum'
legend,['10-105.5 MHz','100-195.8 MHz','200-403.6 MHz'],$
psym=[0,0,0],color=[0,254,50],position=[0.6,0.9],/normal,box=0

oplot,freq[200:399],I[200:399],psym=0,color=254

oplot,freq[400:599],I[400:599],psym=0,color=50


snapshot = TVRD()
TVLCT, r, g, b, /Get
Device, Z_Buffer=1
Set_Plot, thisDevice

image24 = BytArr(3, 1000, 600)
image24[0,*,*] = r[snapshot]
image24[1,*,*] = g[snapshot]
image24[2,*,*] = b[snapshot]

write_png, 'seperate_spectra.png',image24,r,g,b
stop
END