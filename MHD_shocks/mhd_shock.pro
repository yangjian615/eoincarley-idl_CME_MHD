function chi_polynomial,Ma,theta,p_beta,va,cs,gam,type=type

;   Name: chi_polynomial
;
;   Purpose: To evaluate the polynomial that is a function of shock compression (chi)
;			 At polynomial y=0, we get value for chi
;
;   Inputs:  as defined in 'mhd_shock'
;
;   Keyword: 
;		Type -either 'oblique' or 'perp' 
;
;   Note: 
;	 -Need to check the Priest and Forbes 'Magnetic Reconnection' book to see if that Ma
;	  is sonic Mach or Alfven Mach
;

vu = Ma*va
chi=dindgen(1001)*(40.0/1000)-20.0 ;values between -20 and 20 (realisticly chi is between 0-4

IF type eq 'oblique' THEN BEGIN

	;Note: oblique shock as defined in Priest and Forbes 'Magnetic Reconnection' equation 1.51.
	;      This equation is for oblique shock in the de Hoffman-Teller frame so magnetic field
	;	   is parallel to flow
	polyn = fltarr(n_elements(chi))
	polyn[*] = (vu^2.0 -chi[*]*va^2.0)^2.0*$
        (chi[*]*cs^2.0 + 0.5*vu^2.0*(cos(theta*!DTOR))^2.0*( chi[*]*(gam-1.0)  - (gam+1.0)) )+$
        0.5*(va^2.0)*(vu^2.0)*chi[*]*(sin(theta*!DTOR))^2.0*$
        ( (gam+chi[*]*(2.0-gam))*vu^2.0 - ((gam+1)-chi[*]*(gam-1))*chi[*]*va^2.0 )
ENDIF

IF type eq 'perp' THEN BEGIN
	;N.B!! This gives the sonic Mach Number only, Ma here is labelled incorrectly
	;it should be Ms (sonic Mach)
	;
	polyn = fltarr(n_elements(chi))
	polyn[*] = 2.0*(2.0-gam)*chi[*]^2.0 + $
	(2*p_beta + (gam-1.0)*p_beta*Ma^2.0 + 2.0)*gam*chi[*] - $
	gam*(gam+1.0)*p_beta*Ma^2.0
	
	;!!!!!! NOT ALFVEN MACH, THIS IS SONIC MACH
ENDIF

result = fltarr(2,n_elements(chi))
result[0,*]=chi[*]
result[1,*]=polyn[*]
return,result
	  
END	  


pro mhd_shock,type,VARY_THETA=vary_theta,VARY_MACH=vary_mach

;  Name: mhd_shock
;
;  Purpose: Routine to plot the shock adiabatic vs compresion ratio for varying theta_vn or Mach number
;           (theta_vn is angle between flow and shock normal).
;
;  Input parameters:
;           -type -Either 'perp' for perpendiuclar shock or 'oblique'.
;				   'oblique' restricts frame to be de Hoffman-Teller
;
;  Keyword parametrs:
;           -vary_theta - plot the adiabatic vs compression for varying theta, Mach held constant
;           -vary-mach - the adiabatic vs compression for varying (Alfven?) Mach number, theta held constant
;
;  Outputs:
;           -None - just a plot of shock adiabatic versus compression
;                  
;
;  Last modified:
;           - Dec-2011 (E.Carley) - Written
;
window,0

;********Define constants***********
proton_mass = 1.67e-27
n_cm = 3.0e9           		;number density (cm^-3)
n_m = 1.0e6*n_cm 	   		;number density (m^-3)
kb=1.38e-23		 	   		;Boltzman constant (SI)
Temp = 1.4e6           		;Temperature (K)
mu=1.26e-6			   		;magnetic permeability (SI)
B_gauss = 10.0		   		;magnetic field stregth (c.g.s)
B_tesla = (1.0e-4)*B_gauss  ;mag field strenght (SI)
gam = 5.0/3.0				;adiabatic index (ideal gas)
therm_p = 2.0*n_m*kb*Temp	;thermal pressure (ideal gas law)
mag_p = (B_tesla^2.0)/(2.0*mu) ;magnetic pressure
p_beta = therm_p/mag_p		;plasma beta parameter

va = B_tesla/sqrt(mu*n_m*proton_mass)     ;Alfven speed
cs=sqrt((gam*therm_p)/(n_m*proton_mass))  ;Sound speed
;************************************

theta=45.0					;Angle between flow and shock normal. Kept constant if /vary_mach
Ma=5.0						;Alfven Mach number. Kept constant if vary /theta

;********loop parametrs********
angle1=0.0					;If /vary_theta these are angles to go between
angle2=89.0					;
mach1=1.05					;If /vary_mach these are Machs to go between
mach2=10.05
type=type					;'oblique' or 'perp'
;******************

result=chi_polynomial(Ma,theta,p_beta,va,cs,gam,type = type) ;see functio above

loadct,1
!p.color=0
!p.background=255

IF type eq 'perp' THEN BEGIN
title='Shock adiabatic v. compression ratio, perpendicular shock'
colorkey_a = mach1
colorkey_b = mach2
colorkey_title='Mach Number'
ENDIF
IF type eq 'oblique' THEN BEGIN
  IF keyword_set(vary_theta) THEN BEGIN
	title='Shock adiabatic v. compression ratio, oblique shock'
	colorkey_a = angle1
	colorkey_b = angle2
	colorkey_title='Angle between flow and shock normal'
  ENDIF
  IF keyword_set(vary_mach) THEN BEGIN
	title='Shock adiabatic v. compression ratio, oblique shock'
	colorkey_a = mach1
	colorkey_b = mach2
	colorkey_title='Mach Number'
  ENDIF
ENDIF


;*************Plot********************
plot,result[0,*],result[1,*],color=0, $;yr=[-100,100],xr=[0,10],$
xtitle='Compression ratio',title=title,charsize=1.5,position=[0.1,0.1,0.9,0.95]
color_key, range = [ colorkey_a, colorkey_b ],$
charsize=1.5,title=colorkey_title
print,interpol(result[0,*], result[1,*],0.0)


IF keyword_set(vary_theta) THEN BEGIN
	FOR i=angle1,angle2 DO BEGIN
		theta = i*1.0d
		result=chi_polynomial(Ma,theta,p_beta,va,cs,gam,type = type)
		oplot,result[0,*],result[1,*],color=i*2.7
		print,'Shock compression at '+string(theta)+'degrees: '+string(interpol(result[0,*], result[1,*],0.0))
		wait,0.05
	ENDFOR
ENDIF

mach_v_comp = dblarr(2, (mach2-mach1)/0.01 )
IF keyword_set(vary_mach) THEN BEGIN
	FOR i=mach1,mach2,0.01 DO BEGIN
		Ma=i
		result=chi_polynomial(Ma,theta,p_beta,va,cs,gam,type = type)
		oplot,result[0,*],result[1,*],color=i*25
		compression = interpol(result[0,*], result[1,*], 0.0)
		print,'Shock compression at Mach'+string(Ma, format='(f4.1)')+': '+string(compression)
		j = (i-1.05)/0.01
		print,j
		mach_v_comp[0,j] = Ma
		mach_v_comp[1,j] = compression
		;wait,0.05
	ENDFOR
ENDIF

comp = dindgen(50)-25.0
zeros = fltarr(n_elements(comp))
zeros[*]=0
oplot,comp,zeros

window,1
plot,mach_v_comp[0,*],mach_v_comp[1,*], psym=3, xtitle='Mach Number', ytitle='Shock Compression',$
charsize=1.5
comp=1.69
mach_est = interpol(mach_v_comp[0,*], mach_v_comp[1,*], comp)
print,'For compression of '+string(comp, format='(f5.2)')+', Mach = '+string(mach_est)



END