function chi_polynomial,Ma,theta,p_beta,va,cs,gam,type=type

vu = Ma*va

chi=dindgen(1001)*(40.0/1000)-20.0
If type eq 'oblique' THEN BEGIN
	polyn = fltarr(n_elements(chi))
	polyn[*] = (vu^2.0 -chi[*]*va^2.0)^2.0*$
        (chi[*]*cs^2.0 + 0.5*vu^2.0*(cos(theta*!DTOR))^2.0*( chi[*]*(gam-1.0)  - (gam+1.0)) )+$
        0.5*(va^2.0)*(vu^2.0)*chi[*]*(sin(theta*!DTOR))^2.0*$
        ( (gam+chi[*]*(2.0-gam))*vu^2.0 - ((gam+1)-chi[*]*(gam-1))*chi[*]*va^2.0 )
ENDIF

IF type eq 'perp' THEN BEGIN
	polyn = fltarr(n_elements(chi))
	polyn[*] = 2.0*(2.0-gam)*chi[*]^2.0 + $
	(2*p_beta + (gam-1.0)*p_beta*Ma^2.0 + 2.0)*gam*chi[*] - $
	gam*(gam+1.0)*p_beta*Ma^2.0
ENDIF

result = fltarr(2,n_elements(chi))
result[0,*]=chi[*]
result[1,*]=polyn[*]
return,result
	  
END	  


pro mhd_shock_test,type,VARY_THETA=vary_theta,VARY_MACH=vary_mach

;***********NOTE: This is a trial version of a code, finalised version is MHD_shock.pro

;********Define constants***********
proton_mass = 1.67e-27
n_cm = 3.0e9
n_m = 1.0e6*n_cm
kb=1.38e-23
Temp = 2.0e6
mu=1.26e-6
B_gauss=10.0
B_tesla = (1.0e-4)*B_gauss
gam=5.0/3.0
therm_p = 2.0*n_m*kb*Temp
mag_p = (B_tesla^2.0)/(2.0*mu)
p_beta = therm_p/mag_p

va = B_tesla/sqrt(mu*n_m*proton_mass)
cs=sqrt((gam*therm_p)/(n_m*proton_mass))
;************************************
;p_beta=3.5


theta=45.0
Ma=5.5

;*****loop parametrs
angle1=0.0
angle2=90.0
mach1=1.2
mach2=10.0
type=type
;******************

result=chi_polynomial(Ma,theta,p_beta,va,cs,gam,type = type)
loadct,39
!p.color=0
!p.background=255

If type eq 'perp' then begin
title='Shock adiabatic v. compression ratio, perpendicular shock'
colorkey_a = mach1
colorkey_b = mach2
colorkey_title='Mach Number'
ENDIF
If type eq 'oblique' then begin
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
plot,result[0,*],result[1,*],color=0,$;,yr=[-100,100],xr=[0,10],$
xtitle='Compression ratio',title=title,charsize=1.5,position=[0.1,0.1,0.9,0.95]
color_key, range = [ colorkey_a, colorkey_b ],$
charsize=1.5,title=colorkey_title


IF keyword_set(vary_theta) THEN BEGIN
	FOR i=angle1,angle2 DO BEGIN
		theta = i*1.0d
		result=chi_polynomial(Ma,theta,p_beta,va,cs,gam,type = type)
		oplot,result[0,*],result[1,*],color=i*2.7
		wait,0.05
	ENDFOR
ENDIF

IF keyword_set(vary_mach) THEN BEGIN
	FOR i=mach1,mach2,0.1 DO BEGIN
		Ma=i
		result=chi_polynomial(Ma,theta,p_beta,va,cs,gam,type = type)
		oplot,result[0,*],result[1,*],color=i*25
		wait,0.05
	ENDFOR
ENDIF

comp = dindgen(50)-25.0
zeros = fltarr(n_elements(comp))
zeros[*]=0
oplot,comp,zeros

stop
END