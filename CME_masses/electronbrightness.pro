function electronBrightness,mass

; Calculates electron brighness as a function of angle from POS, normalised to brightness
; on POS. It then plots the reult

array = fltarr(2,101)
for i = 0,100,1 do begin
     
     theta=1*i
     eltheory,15,theta,r,b
     array(0,i) = theta
     array(1,i)=b
endfor

eltheory,15,0,r,b
array(1,*) = array(1,*)/b

oplot,array(0,*),array(1,*),linestyle=0;,xtitle='Angular position of electron from POS'
end