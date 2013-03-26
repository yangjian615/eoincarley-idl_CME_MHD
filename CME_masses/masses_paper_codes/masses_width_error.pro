pro masses_width_error
;First attemot at this code. Doesn't work! See masses_width_error2.pro

e_mass = 9.109e-28 ;grams
cme_mass=2.0e15 ;grams
cme_height = 10 ;Rsun
ang_width=60    ;degrees

g_per_deg = cme_mass/ang_width
g_per_radial = g_per_deg/(cme_height*100)
num_elecs = (g_per_radial*1.0d)/e_mass
apparent_B=0.0
;Calclate electron brightness at every height and angle
;Then multiply num electrons at that height and angle

angle1 = -1.0*(ang_width/2)
angle2 = 1.0*(ang_width/2)

	FOR i = angle1,angle2 DO BEGIN
		FOR j = 1.,cme_height,0.01 DO BEGIN
			;eltheory,j,i,d,total_B
		    eltheory,j*cos(!pi*i/180),float(i),d,total_B
		    print,j
		    apparent_B=apparent_B+(total_B*num_elecs)
		ENDFOR
	ENDFOR	  
    
stop
;Calculate electron brightness from assumption everything is in 2-D plane
actual_B = 0.0
g_per_radial2=cme_mass/(cme_height*100)
num_elecs = (g_per_radial2*1.0d)/e_mass

		FOR j = 1.,cme_height,0.01 DO BEGIN
		    eltheory,j,0,d,total_B
		    actual_B=actual_B+(total_B*num_elecs)
		ENDFOR
	
print,'CME mass underestimation is: '+string( (1-(apparent_B/actual_B))*100)+' percent at '+$
string(ang_width,format='(I2.2)')+' degree angular width along LOS'

END		