pro spectro_zoom

data = findfile('*.fit')
radio_spectro_fits_read,data[0],z,x,y

running_mean_background,z,backg
zsubNew = z - backg

window,0
loadct,5
xNew = x
yNew = y

!mouse.button=1
WHILE(!MOUSE.BUTTON NE 4) DO BEGIN

zsub = zsubNew
window,0
spectro_plot,bytscl(smooth(zsub,10),-2,6),xNew,yNew,/xs,/ys
print,'Choose starting (time,frequency)'
cursor,tstart,fstart,/data,/down
print,'Choose ending (time,frequency)'
cursor,tend,fend,/data,/down
    
    IF !MOUSE.BUTTON EQ 1 THEN $
	loadct,5
	window,1
	spectro_plot,smooth(zsubNew,5),xNew,yNew,/xs,/ys,$
	xrange=[tstart,tend],yrange=[fstart,fend],ytitle='Frequency (MHz)'
	;print,anytim(tstart,/yohkoh)
	a = closest(xNew,tstart)
	b = closest(xNew,tend)
	c = closest(yNew, fstart)
	d = closest(yNew,fend)
	
	
	zsubNew = zsub[a:b , c:d]
	help,zsubNew
	xNew = x[a:b]
	yNew = y[c:d]
	window,3
	spectro_plot,zsubNew,xNew,yNew,/xs,/ys
	
	Print,'Continue Zoom? (Y/N)'
	continue=''
	read,continue
	
	If (continue eq 'n') THEN BREAK
	
ENDWHILE
end