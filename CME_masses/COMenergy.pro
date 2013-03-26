function COMenergy,massHeightArray

; Calculates the velocity from COM movement, then kinetic energy
; Calculate potential form COM height
; Requires a data array of COM to be already made


Nlines = 16




openr,1,massHeightArray
massHeight = fltarr(2,Nlines)
readf,1,massHeight
close,1

G = 6.67e-11
Msun=1.989e30
Rsun = 6.67e8
massHeightTime = fltarr(2,Nlines)
kineticEnergy = fltarr(2,16)

C = (G*Msun)/Rsun
openr,1,'COMdata'
COMdata = fltarr(3,16)
readf,1,COMdata
close,1


FOR i=0,Nlines-1,1 DO BEGIN

   ;massHeightTime[0,i] = massHeight[0,i]
   massHeightTime[1,i] = massHeight[1,i]
   massHeightTime[0,i] = COMdata[1,i]/COS(44.65/!radeg)
   ;kineticEnergy[0,i]  = massHeight[0,i]
   
ENDFOR

velocity = fltarr(Nlines)
for i =1,Nlines-1,1 do begin
    j = i-1
    velocity[i] = ((massHeightTime[0,i] - massHeightTime[0,j])*Rsun)/1800
endfor    

    



PotE = fltarr(Nlines)
height = fltarr(Nlines)




height(*) = massHeightTime[0,*]*Rsun

PotE = fltarr(2,16)
PotE[0,*] = height[*]/Rsun

FOR i=0,Nlines-1,1 DO BEGIN

   PotE[1,i] =( (-G*Msun*(massHeightTime[1,i]/1000))/(height[i])  +  C*(massHeightTime[1,i]/1000) )*1e+07
ENDFOR




FOR i=0,Nlines-1,1 DO BEGIN
   
   kineticEnergy[1,i] = (0.5*(massHeightTime[1,i]/1000)*(velocity[i]^2))*1e+07
   
ENDFOR   


loadct,39
!p.color=0
!p.background=255

height(*) = height(*)/Rsun
   
window,1



plot,massHeightTime(0,*),PotE(1,*),psym=4,linestyle=3,/ylog,title='Centre of Mass energy vs. Height for 12-12-2008 CME',xtitle='Height (R/Rsun)',ytitle='Energy (ergs)',charsize=1.5,YRANGE = [1e28, 1e31]
oplot,massHeightTime(0,*),kineticEnergy(1,*),psym=7,color=254,thick=1
oplot,massHeightTime(0,*),PotE(1,*),linestyle=1
oplot,massHeightTime(0,*),kineticEnergy(1,*),linestyle=5
legend, ['Potential energy','Kinetic energy'], linestyle=[3,2],psym=[4,7],color=[0,254], charsize=1.2, box=0

return,kineticEnergy


END
   