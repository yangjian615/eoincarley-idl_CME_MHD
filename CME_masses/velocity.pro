function Velocity,massHeightArray

;Calculates the velcoity of the centre of mass given the centre of mass array


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

velocityCOM = fltarr(Nlines)
for i =1,Nlines-1,1 do begin
    j = i-1
    velocityCOM[i] =( ((massHeightTime[0,i] - massHeightTime[0,j])*Rsun)/1800 )/1000
    
endfor  
velocityCOM[0] = velocityCOM[1]

restore,'mid_vel.sav'
velocityFront = fltarr(14)
j=0
print,size(mid_vel)
for i = 9,22,1 do begin
    
   velocityFront[j] = mid_vel[i]
   j=j+1
endfor


time = (findgen(16)+1)*30


window,1
plot,time(*),velocityCOM(*),psym=1,Xtitle='Time in mins after CME first appearance in COR2 FOV',Ytitle='Velocity (km/s)',Title='Velocity vs Time; 12-12-2008 event',yrange=[0,600]
oplot,time(*),velocityCOM(*),linestyle=2
oplot,time(*),velocityFront(*),psym=4,color=240
oplot,time(*),velocityFront(*),linestyle=4
end
