function e_bright, toggle=toggle

; Calculates electron brighness as a function of angle from POS, normalised to brightness
; on POS. It then plots the reult

!p.thick=7
!x.thick=7
!y.thick=7
!p.charthick=7
!p.charsize=2.0


loadct,0
IF keyword_set(toggle) THEN BEGIN
	set_plot,'ps'
	device, filename='e_brightness.ps', /color,/inches,/portrait,/encapsulate,$
	xsize=10,ysize=8;
ENDIF ELSE BEGIN
window,0
ENDELSE

array = fltarr(2,101)
for i = 0, 100, 1 do begin
     theta=1*i
     eltheory,15,theta,r,b
     array(0,i) = theta
     array(1,i)=b
endfor

eltheory,15,0,r,b
array(1,*) = array(1,*)/b

theta = greek('theta')
plot, array(0,*), array(1,*), linestyle=0, xtitle='Angle from sky-plane ('+theta+')',$
ytitle='Normalised CME Brightness', color=0

IF keyword_set(toggle) THEN BEGIN
	device,/close
	set_plot, 'x'
ENDIF
END