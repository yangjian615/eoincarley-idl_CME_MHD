pro masses_width_error2

;This code outputs the ratio of observed mass to actual mass for a particular height
;as a function of angular width along the line of sight.

e_mass = double(9.109e-28) ;grams
cme_mass=2.0e15    ;grams
cme_height = 18.0  ;Rsun
mass_error = dblarr(2,180)

FOR k=0.0,179.0 DO BEGIN ;where k is the angle
ang_width=k     ;degrees
rsun=6.955e10      ;cm

g_per_cm2 = cme_mass/(0.5*((cme_height*rsun)^2.0)*(!pi*ang_width/180.0))

e_per_cm2 = (g_per_cm2)/e_mass
apparent_B=0.0
		;Calclate electron brightness at every height and angle
		;Then multiply num electrons at that height and angle
start_angle = -1.0*(ang_width/2.0)
stop_angle = ang_width/2.0
num_elecs=1.0d
apparent_e_total=0.0
total_area=0.0
total_elecs=0.0

	FOR i = start_angle,stop_angle DO BEGIN

		FOR j = 1.1,cme_height,0.1 DO BEGIN
			
			arc_area =  0.5*((j*rsun)^2.0)*(!pi*(1)/180.0) -  $
			            0.5*(((j-0.1)*rsun)^2.0)*(!pi*(1)/180.0)
			       			
			num_elecs=double(e_per_cm2)*double(arc_area)
			eltheory,j*cos(!pi*i/180.0),float(i),d,B_per_e
		    ;apparent_B=apparent_B+(B_per_e*num_elecs)	
		    
		    apparent_B= (B_per_e*num_elecs)	
		    total_elecs = total_elecs+num_elecs
		    eltheory,j*cos(!pi*i/180.0),0.0,d,B_zero
		    apparent_e = apparent_B/B_zero
		    apparent_e_total = apparent_e_total + apparent_e
		    total_area = total_area+arc_area
		    
		ENDFOR
		
	ENDFOR

	num = 2e15/double(e_mass)	
	mass_error[0,k]=k
	mass_error[1,k]=apparent_e_total/num
ENDFOR
window,2
loadct,39
!p.color=0
!p.background=255
plot,mass_error[0,*]/2,mass_error[1,*],yr=[0.5,1],xr=[0,100],charsize=1.5,xtitle='CME half-width (degrees)',$
ytitle='Normalised Units',linestyle=3,title='Height of '+string(cme_height)
a = electronBrightness(10)

;print,'CME mass underestimation is: '+string( (1-(apparent_e_total/num))*100.0)+' percent at '+$
;string(ang_width,format='(I3.2)')+' degree angular width along LOS'


END		