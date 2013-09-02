function masses_width_error4, height, angle, pos_angle, compar_angle

;Input a range of height values and the upper limit to the errors on the masses come out
;Take a fine grid of heights and compare this to the actual height values in the masses/forces studies
;so you can get errors at those heights


cme_height = height  ;Rsun (variable)
ang_width = angle    ;2*(26*(cme_height^0.22) );degrees

e_mass = 9.109d-28		   ;grams
cme_mass=2.0e15    		   ;grams
num = cme_mass/e_mass	
rsun= 6.955e10			   ;m
nsteps_h=200.0


   
g_per_cm2 = cme_mass/[ (0.5*((cme_height*rsun)^2.0)*(ang_width*!DTOR)) -$  
									(0.5*(rsun^2.0)*(ang_width*!DTOR)) ]
e_per_cm2 = g_per_cm2/e_mass
apparent_B=0.0d
		
start_angle = -1.0*(ang_width/2.0)
stop_angle = 1.0*(ang_width/2.0)
angle_steps = 0.1;
	
num_elecs=1.0d
apparent_e_total=0.0d
total_area=0.0d
total_elecs=0.0d
h_step = (cme_height-1.0)/nsteps_h ;200 steps in height seems to be the best
h_start = 1.0 + h_step;1+h_steps
	
;Calclate electron brightness at every height and angle
;Then multiply num electrons at that height and angle

start_angle = start_angle + pos_angle
stop_angle = stop_angle + pos_angle
	
FOR i = start_angle, stop_angle, angle_steps DO BEGIN

	FOR j = h_start,cme_height,h_step DO BEGIN
			
		arc_area =  0.5*((j*rsun)^2.0)*(angle_steps*!DTOR) -  $
			        0.5*(((j-h_step)*rsun)^2.0)*(angle_steps*!DTOR)
			       			
		num_elecs=double(e_per_cm2)*double(arc_area)
		eltheory, j, float(i), d, B_per_e  ;Electron brightness at particular angle and height
		   
		apparent_B= (B_per_e*num_elecs)	
		total_elecs = total_elecs+num_elecs
		eltheory, j, compar_angle, d, B_zero
		apparent_e = apparent_B/B_zero
		apparent_e_total = apparent_e_total + apparent_e
		total_area = total_area+arc_area
		    
	ENDFOR
		
ENDFOR

doa = apparent_e_total/num
error=(1.0-(doa))*100.0

;print,'CME width: '+string(ang_width)+' (degrees)'
print, 'Derived/Actual: '+string(doa)
return, doa
END		