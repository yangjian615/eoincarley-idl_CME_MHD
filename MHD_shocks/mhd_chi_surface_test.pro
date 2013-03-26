function chi_polynomial,Ma,theta_vn,theta_bv,va,cs,gam

;
; Shock polynomial for variable chi (compression ratio). Polynomial expression taken
; from equation (2.3) 'A note on the compression ratio in MHD shocks' Kabin 2001.
;

vu = Ma*va
A = (Ma*cos(theta_vn*!DTOR))/cos(theta_vn*!DTOR - theta_bv*!DTOR)
S = cs/va
k=tan((theta_vn - theta_bv)*!DTOR)

chi=dindgen(10001)*(4.0/10000)
    ;Expression is quite big so break down into parts. L, M, N, O labelling is arbitrary.
	polyn = dblarr(n_elements(chi))
	L = (A^2.0 -chi)^2.0
	M = (A^2.0 - (2.0*chi*S^2.0)/(chi+1 -gam*(chi-1)))
	N = chi*(k^2.0)*(A^2.0)
	O = ((2*chi - gam*(chi-1))/(chi+1 -gam*(chi-1)))*A^2.0 - chi
	
	polyn[*] = L[*]*M[*] -N[*]*O[*]
	
result = fltarr(2,n_elements(chi))
result[0,*]=chi[*]
result[1,*]=polyn[*]
return,result

END	  

pro mhd_shock_fixframe,theta_vn,theta_bv,Ma,chi
			
;
;			
;  Name: mhd_shock_fixframe
;
;  Purpose: Routine that ouputs the compression ratio of a shock given particular theta_vn, theta_bv
;			and Mach numbers. Shock in fixed frame.
;
;  Input parameters:
;           -theta_vn - angle between shock normal and flow
;			-theta_bv - angle between magnetic field and flow
;			-Ma - Alfven Mach number
;
;  Outputs:
;           -chi - shock compression ratio
;                  
;  Last modified:
;           -Dec-2011 (E.Carley) - Written
;			

;********Define constants***********
proton_mass = 1.67e-27
n_cm = 3.0e9           		;number density (cm^-3)
n_m = 1.0e6*n_cm 	   		;number density (m^-3)
kb=1.38e-23		 	   		;Boltzman constant (SI)
Temp = 2.0e6           		;Temperature (K)
mu=1.26e-6			   		;magnetic permeability (SI)
B_gauss=10.0		   		;magnetic field stregth (c.g.s)
B_tesla = (1.0e-4)*B_gauss  ;mag field strenght (SI)
gam=5.0/3.0					;adiabatic index
therm_p = 2.0*n_m*kb*Temp	;thermal pressure (ideal gas law)
mag_p = (B_tesla^2.0)/(2.0*mu) ;magnetic pressure
p_beta = therm_p/mag_p		;plasma beta parameter

va = B_tesla/sqrt(mu*n_m*proton_mass)     ;Alfven speed
cs=sqrt((gam*therm_p)/(n_m*proton_mass))  ;Sound speed
;************************************


result=chi_polynomial(Ma,theta_vn,theta_bv,va,cs,gam)

chi = interpol(result[0,*],result[1,*],0.0)

;print,''
;print,'*********************************'
;print,'Compression ratio: '+string(chi)
;print,'*********************************'
;print,''

END



pro mhd_chi_surface_test, chi_surface, vary_thetaBV_thetaVn = vary_thetaBV_thetaVn, $
					vary_mach_thetaBV = vary_mach_thetaBV
					
;
;			
;  Name: mhd_chi_surface_test (suffix of test because first loop doesn't work)
;
;  Purpose: Create a surface of compression ratios z, given x,y values of mach and theta_bv, or 
;           theta_bv and theta_vn
;
;  Input parameters:
;			-None
;
;  Outputs:
;           -chi_surface - A surface of compression ratios given a set of variables
;
;  Keywords
;			-vary_thetaBV_thetaVn - produce a surface of compressions for varying theta_vn and theta_bv (I think 
;									results for this might be wrong)
;			-vary_mach_thetaBV - produce a surface of compressions for varying Mach and theta_bv. Works
;								 at least for head one flow
;				                    
;
;  Last modified:
;			-Jan-2012 (E.Carley) - Modified with if statements so you can choose what variables to 
;								   loop through. 
;           -Dec-2011 (E.Carley) - Written
;
;  N.B: I don't think the first loop for theta_vn, theta_bv variables is correct. This is because
;		the relationship between theta_bv and theta_bn is not correct. Need to look into this more.
;		Second loop for theta_bv and Mach variables is fine, at least for head on flow i.e., 
;		theta_vn = 0.0
;		 
;		 


;*****************************************************************************************;
;          Note sure if the expression relating theta_bv to theta_bn is correct here.     ;
;          Need to check the Kabin 2001 paper to see how it's defined					  ;
;*****************************************************************************************;           
IF keyword_set(vary_thetaBV_thetaVn)
    chi_surface = fltarr(891,891)
    Ma = 4.0
	FOR j=0.0,89.0,0.1 DO BEGIN
   	theta_vn=j
    print,'theta_vn '+string(j)
	 	FOR i=0.0,89.0,0.1 DO BEGIN
	 	    theta_bn = i
  	 		theta_bv = abs(theta_vn - theta_bn)
  			mhd_shock_fixframe,theta_vn,theta_bv,Ma,chi
  			chi_surface[j*10,i*10] = chi
  			print,'Compression :'+string(chi)
  		ENDFOR	
	ENDFOR  
ENDIF


;**********Keep theta_vn constant and vary Mach number and theta_bv**************
IF keyword_set(vary_mach_thetaBV)
	chi_surface=fltarr(301,391)
    theta_vn=0.0
	FOR j=1.0,4.0,0.01 DO BEGIN
  		 Ma=j
  		 print,'Alfven Mach '+string(Ma)
			FOR i=50.0,89.9,0.1 DO BEGIN
  				theta_bn = i
  				theta_bv = abs(theta_vn-theta_bn)
 				mhd_shock_fixframe,theta_vn,theta_bv,Ma,chi
 				chi_surface[j*100-100,i*10 -500.0] = chi
 				print,'Compression :'+string(chi)
 			ENDFOR	
	ENDFOR 
ENDIF

save,chi_surface,filename='vary_mach_thetaBn.sav'

END
