function chi_polynomial,Ma,theta_vn,theta_bv,va,cs,gam

;
; Shock polynomial for variable chi (compression ratio). Polynomial expression taken
; from equation (2.3) 'A note on the compression ratio in MHD shocks' Kabin 2001.
;


vu = Ma*va
A = (Ma*cos(theta_vn*!DTOR))/cos(theta_vn*!DTOR - theta_bv*!DTOR)
S = cs/va
k=tan((theta_vn - theta_bv)*!DTOR)


chi=dindgen(10001)*(4.0/10000.0)

;***********Calculate polynomial for input params****************
	polyn = dblarr(n_elements(chi))
	L = (A^2.0 -chi)^2.0
	M = (A^2.0 - (2.0*chi*S^2.0)/(chi+1.0 -gam*(chi-1.0)))
	N = chi*(k^2.0)*(A^2.0)
	O = ((2.0*chi - gam*(chi-1.0))/(chi+1.0 -gam*(chi-1.0)))*A^2.0 - chi
	
	polyn[*] = L[*]*M[*] -N[*]*O[*]
;****************************************************************	
	

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
;           -chi - compression ratio
;                  
;  Last modified:
;           -Dec-2011 (E.Carley) - Written
;
			

;********Define constants***********
proton_mass = 1.67e-27
n_cm = 2.6e7           		;number density (cm^-3)
n_m = 1.0e6*n_cm 	   		;number density (m^-3)
kb=1.38e-23		 	   		;Boltzman constant (SI)
Temp = 1.0e6           		;Temperature (K)
mu=1.26e-6			   		;magnetic permeability (SI)
B_gauss=10.1		   		;magnetic field stregth (c.g.s)
B_tesla = (1.0e-4)*B_gauss  ;mag field strenght (SI)
gam=5.0/3.0					;adiabatic index
therm_p = 2.0*n_m*kb*Temp	;thermal pressure (ideal gas law)
mag_p = (B_tesla^2.0)/(2.0*mu) ;magnetic pressure
p_beta = therm_p/mag_p		;plasma beta parameter
va = B_tesla/sqrt(mu*n_m*proton_mass)     ;Alfven speed
cs=sqrt((gam*therm_p)/(n_m*proton_mass))  ;Sound speed
;************************************


result=chi_polynomial(Ma, theta_vn, theta_bv, va, cs, gam)


chi = interpol(result[0,*], result[1,*], 0.0)

print,''
print,'*********************************'
print,'Compression ratio: '+string(chi)
print,'*********************************'
print,''


END