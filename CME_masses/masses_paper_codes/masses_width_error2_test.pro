pro masses_width_error2_test

;This code outputs the ratio of observed mass to actual mass for a particular height
;as a function of angular width along the line of sight.
;This test seems to work for all heights above 2.4. The results are a bit different to
;Vourlidas 2000 i.e. this code seems to add 5 % onto mass overestimation

e_mass = double(9.109e-28) ;grams
cme_mass=2.0e15    ;grams
cme_height = 1.7  ;Rsun
mass_error = dblarr(2,180)
rsun=6.955e10
nsteps_angle=10
nsteps_h=10

FOR k=0,179 DO BEGIN ;where k is the angle
   print,k
	ang_width=k     ;degrees
	g_per_cm2 = cme_mass/[ (0.5*((cme_height*rsun)^2.0)*(ang_width*!DTOR)) -$  
										(0.5*(rsun^2.0)*(ang_width*!DTOR)) ]
	e_per_cm2 = g_per_cm2/e_mass
	apparent_B=0.0d
		
	start_angle = -1.0*(ang_width/2.0)
	stop_angle = 1.0*(ang_width/2.0)
	angle_steps =0.1;= (stop_angle-start_angle)/nsteps_angle ;0.5 degree steps work well for 10Rsun
	
	num_elecs=1.0d
	apparent_e_total=0.0d
	total_area=0.0d
	total_elecs=0.0d
	h_steps= 0.0035;(cme_height-1)/nsteps_h ;200 steps in height seems to be the best
	h_start = 1.0035;1+h_steps
	
	    ;Calclate electron brightness at every height and angle
		;Then multiply num electrons at that height and angle

	FOR i = start_angle,stop_angle,angle_steps DO BEGIN

		FOR j = h_start,cme_height,h_steps DO BEGIN
			
			arc_area =  0.5*((j*rsun)^2.0)*(angle_steps*!DTOR) -  $
			            0.5*(((j-h_steps)*rsun)^2.0)*(angle_steps*!DTOR)
			       			
			num_elecs=double(e_per_cm2)*double(arc_area)
			;eltheory,j*cos(!pi*i/180.0),float(i),d,B_per_e
			eltheory,j,float(i),d,B_per_e
		   
		    
		    apparent_B= (B_per_e*num_elecs)	
		    total_elecs = total_elecs+num_elecs
		    ;eltheory,j*cos(!pi*i/180.0),0.0,d,B_zero
		    eltheory,j,0.0,d,B_zero
		    apparent_e = apparent_B/B_zero
		    apparent_e_total = apparent_e_total + apparent_e
		    total_area = total_area+arc_area
		    
		ENDFOR
		
	ENDFOR

	num = 2.0e15/double(e_mass)	
	mass_error[0,k]=k
	mass_error[1,k]=apparent_e_total/num
	
ENDFOR
stop

window,2
loadct,39
!p.color=0
!p.background=255
plot,mass_error[0,*]/2,mass_error[1,*],yr=[0.5,1],xr=[0,100],charsize=1.5,xtitle='CME half-width (degrees)',$
ytitle='Normalised Units',linestyle=3,title='Height of '+string(cme_height)+' R!Lsun!N'
;oplot,mass_error[0,*]/2,mass_error[1,*],linestyle=5

;a = electronBrightness(10)

;print,'CME mass underestimation is: '+string( (1-(apparent_e_total/num))*100.0)+' percent at '+$
;string(ang_width,format='(I3.2)')+' degree angular width along LOS'


END		