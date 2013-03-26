PRO PlottOverview

list = findfile('*.prn')
print,list[2]

sunfile = list[2]
sundata = read_ascii(sunfile, DATA_START=1, DELIMITER=";")
freq = reform(sundata.field1[0,*])
ysun = reform(sundata.field1[1,*])

;reffile = 'C:\TEMP\callisto\log\OVS_BLEN7m_20080429_Sky_00.prn'
;refdata = read_ascii(reffile, DATA_START=1, DELIMITER=";")
;freq = reform(refdata.field1[0,*])
;yref = reform(refdata.field1[1,*])

title  = 'Callisto spectral overview, normal oprations 20101106'
xtitle = 'Frequency [MHz]'
ytitle = 'Intensity [mV]'

freqrange = [45,870];frequency range to plot
freqstep  = 50; stepsize frequency-axis
yrange    = [1000,2500];y-axis range
ystep     = 200; = 10dB

;set_plot,'PS'
;device,filename='C:\TEMP\callisto\log\ovplot.ps',bits_per_pixel=8,/color
loadct,39
!p.color=0
!p.background=255

window,1,xs=900,ys=500

plot,freq,ysun,color=1,xrange=freqrange,xtickinterval=freqstep,yrange=yrange,ytickinterval=ystep,$
title=title,ytitle=ytitle,xtitle=xtitle,charsize=1.5


;loadct,5
;oplot,freq,ysun,color=133
;oplot,freq,yref,color=33
;xyouts,100,2300,'Sun (red)' ,color=133,charthick=3, charsize=2
;xyouts,300,2300,'Sky (blue)',color=33 ,charthick=3, charsize=2

;device,/close
;set_plot,'Win'

image3d = TVRD(TRUE=1)
WRITE_JPEG, 'OV_normaloperations20101106.jpg', image3d, TRUE=1, QUALITY=100


end