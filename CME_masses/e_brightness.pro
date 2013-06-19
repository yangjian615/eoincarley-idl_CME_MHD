function e_brightness

; Calculates electron brighness as a function of angle from POS, normalised to brightness
; on POS. It then plots the reult


set_plot,'ps'
device, filename='e_brightness.ps', /color,/inches,/portrait,/encapsulate,$
xsize=10,ysize=8;

array = fltarr(2,101)
for i = 0, 100, 1 do begin
     theta=1*i
     eltheory,15,theta,r,b
     array(0,i) = theta
     array(1,i)=b
endfor

eltheory,15,0,r,b
array(1,*) = array(1,*)/b

plot, array(0,*), array(1,*), linestyle=0;,xtitle='Angular position of electron from POS'

device,/close
set_plot, 'x'

END