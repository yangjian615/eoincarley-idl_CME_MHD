PRO PlottOverview1

list = findfile('*.prn')


multiplot,[1,4],mxtitle = 'Frequency [MHz]',mytitle='Intensity [mV]',mTitle='Callisto spectral overview, Birr Castle Ireland'
for i=0,3,1 do begin

sunfile = '/Users/eoincarley/data/CALLISTO/' + list[i]
sundata = read_ascii(sunfile, DATA_START=1, DELIMITER=";")
freq = reform(sundata.field1[0,*])
ysun = reform(sundata.field1[1,*])

;reffile = 'C:\TEMP\callisto\log\OVS_BLEN7m_20080429_Sky_00.prn'
;refdata = read_ascii(reffile, DATA_START=1, DELIMITER=";")
;freq = reform(refdata.field1[0,*])
;yref = reform(refdata.field1[1,*])

title  = 'Callisto spectral overview, Birr Castle Ireland'
xtitle = 'Frequency [MHz]'
ytitle = 'Intensity [mV]'

freqrange = [0,900];frequency range to plot
freqstep  = 50; stepsize frequency-axis
yrange    = [750,2500];y-axis range
ystep     = 250; = 10dB

;set_plot,'PS'
;device,filename='C:\TEMP\callisto\log\ovplot.ps',bits_per_pixel=8,/color
loadct,39
!p.color=0
!p.background=255


if i eq 0 then begin
plot,freq,ysun,color=1,xtickinterval=freqstep,yrange=yrange,ytickinterval=ystep,charsize=1
multiplot
ENDIF
if i eq 1 then begin
plot,freq,ysun,color=1,xtickinterval=freqstep,yrange=yrange,ytickinterval=ystep,charsize=1
multiplot
ENDIF
if i eq 2 then begin
plot,freq,ysun,color=1,xtickinterval=freqstep,yrange=yrange,ytickinterval=ystep,charsize=1
multiplot
ENDIF
if i eq 3 then begin
plot,freq,xrange=freqrange,ysun,color=1,xtickinterval=freqstep,yrange=yrange,ytickinterval=ystep,charsize=1
multiplot,/reset
ENDIF
AXIS, xAXIS=0, XRANGE=freqrange
;loadct,5
;oplot,freq,ysun,color=133
;oplot,freq,yref,color=33
;xyouts,100,2300,'Sun (red)' ,color=133,charthick=3, charsize=2
;xyouts,300,2300,'Sky (blue)',color=33 ,charthick=3, charsize=2

;device,/close
;set_plot,'Win'
ENDFOR
image3d = TVRD(TRUE=1)
WRITE_JPEG, '/Users/eoincarley/data/CALLISTO/ov.jpg', image3d, TRUE=1, QUALITY=100


end