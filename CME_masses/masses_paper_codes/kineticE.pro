function mechanicalE,massHeightArray

Nlines = 16

openr,1,massHeightArray
massHeight = fltarr(2,Nlines)
readf,1,massHeight
close,1

G = 6.67e-11
Msun=1.989e30
Rsun = 6.67e8
massHeightTime = fltarr(3,Nlines)
kineticEnergy = fltarr(2,16)

C = (G*Msun)/Rsun


FOR i=0,Nlines-1,1 DO BEGIN

   massHeightTime[0,i] = massHeight[0,i]
   massHeightTime[1,i] = massHeight[1,i]
   massHeightTime[2,i] = 30*i
   kineticEnergy[0,i] = massHeight[0,i]
   
ENDFOR

restore,'mid_vel.sav'
velocity = fltarr(Nlines)
j=0
restore,'mid_r.sav'
height = fltarr(Nlines)


for i=9,21,1 do begin


    height[j] = mid_r[i]*Rsun
    velocity[j] =  mid_vel[i]*1000
    j = j+1
endfor

PotE = fltarr(2,16)
PotE[0,*] = height[*]/Rsun

FOR i=0,12,1 DO BEGIN

   PotE[1,i] =( (-G*Msun*(massHeightTime[1,Nlines-1]/1000))/(height[i])  +  C*(massHeightTime[1,Nlines-1]/1000) )*1e+07
ENDFOR




FOR i=0,Nlines-1,1 DO BEGIN
   
   kineticEnergy[1,i] = (0.5*(massHeightTime[1,i]/1000)*(velocity[i]^2))*1e+07
   
ENDFOR   


loadct,39
!p.color=0
!p.background=255
   
window,1

plot,PotE(0,*),PotE(1,*),psym=4,/ylog,title='pot energy vs. Height for 12-12-2008 CME',xtitle='Height (R/Rsun)',ytitle='Kinetic Energy (ergs)',charsize=1.5,YRANGE = [1e26, 1e32]
oplot,kineticEnergy(0,*),kineticEnergy(1,*),psym=7,color=254
return,kineticEnergy


END
   