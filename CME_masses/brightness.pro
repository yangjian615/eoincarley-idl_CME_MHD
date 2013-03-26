function brightness,mass,width,pos

; Attempt to calculate the brightness of a CME fiven pos position angle and
; angukar width

i=0.0
j=10
while (j lt 80) do begin

width=j

increment = width/10.0
angle1=pos + width*0.5
angle2=pos - width*0.5
totalBobs = 0
theta = angle1

while (theta gt angle2) do begin

theta = angle1 - increment*i 

eltheory,10,theta,r,b
C = 1.97e-24
bObs = ((mass/11.0)*b)/C
totalBobs = totalBobs + bObs

eltheory,10,0,r,b0angle
;
print,(bObs/b0angle)*C
print,(bObs/b)*C
print,''
i = i+1

endwhile
i=0
eltheory,10,0,r,b0angle
mObs = (totalBobs/b0angle)*C

j =j+10

MM = mobs/mass
print,MM
endwhile
end

