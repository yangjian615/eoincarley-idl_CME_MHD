pro radius_to_density, radius, NEWKIRK = newkirk, SAITO=saito, BAUM = baum, $
								HYDRO_EQ = hydro_eq, TEMP = temp, n_0 = n_0, $
								ALL = all
; radius in solar radii

; /temp and /n_0 set the temperature and initial density for hydroequilibrium

; /all will output everything

; E. Carley (2012-Sep-25)


C = 8980.0
MHz = 1.0e6

;-----------  Newkirk Model --------------
IF keyword_set(newkirk) or keyword_set(all) THEN BEGIN
	N=4.2e4
	newkirk =  N*10.0^(4.32/radius) 
	print,'----------------------------------'
	print,'		Newkirk Model 		'
	print,'Radius: ' +string(radius)+' Rsun'
	print,'Electron density (quiet sun): '+string(newkirk)+' (cm^-3)'
	print,'Plasma frequency (quiet sun): '+string( (C*sqrt(newkirk))/MHz )+' (MHz)'
	print,' '
	print,'----------------------------------'
ENDIF
;----------------------------------------


;-----------  SAITO Model --------------
IF keyword_set(saito) or keyword_set(all) THEN BEGIN
	c1 = 5.27e6
	c2 = 3.54e6
	d1 = 3.3
	d2 = 5.8
	;saito_ehole = dblarr(n_elements(rhos))
	saito_ehole =  c1*radius^(-1.0*d1) + c2*radius^(-1.0*d2)  

	c1 = 3.15e6
	c2 = 1.60e6
	d1 = 4.71
	d2 = 3.01
	;saito_phole = dblarr(n_elements(rhos))
	saito_phole =  c1*radius^(-1.0*d1) + c2*radius^(-1.0*d2)  


	c1 = 1.36e6
	c2 = 1.68e8
	d1 = 2.14
	d2 = 6.13
	;saito_bg = dblarr(n_elements(rhos))
	saito_bg =  c1*radius^(-1.0*d1) + c2*radius^(-1.0*d2)  
	print,'----------------------------------'
	print,'		Saito Model 		'
	print,'Radius: ' +string(radius)+' Rsun'
	print,'Electron density (equatorial coronal hole): '+string(saito_ehole)+' (cm^-3)'
	print,'Plasma frequency (quiet sun): '+string( (C*sqrt(saito_ehole))/MHz )+' (MHz)'
	print,' '
	print,'Electron density (polar coronal hole): '+string(saito_phole)+' (cm^-3)'
	print,'Plasma frequency (quiet sun): '+string( (C*sqrt(saito_phole))/MHz )+' (MHz)'
	print,' '
	print,'Electron density (quiet sun): '+string(saito_bg)+' (cm^-3)'
	print,'Plasma frequency (quiet sun): '+string( (C*sqrt(saito_bg))/MHz )+' (MHz)'
	print,' '
	print,'----------------------------------'
ENDIF
;----------------------------------------


;-----------  Baum Model --------------
IF keyword_set(baum) or keyword_set(all) THEN BEGIN
	ba =  1.0e8*(  2.99*(radius)^(-16.0) + 1.55*(radius)^(-6.0) + 0.036*(radius)^(-1.5)  ) 
	print,'----------------------------------'
	print,'		Baumbach-Allen Model 		'
	print,'Radius: ' +string(radius)+' Rsun'
	print,'Electron density (quiet sun): '+string(ba)+' (cm^-3)'
	print,'Plasma frequency (quiet sun): '+string( (C*sqrt(ba))/MHz )+' (MHz)'
	print,' '
	print,'----------------------------------'
ENDIF	


;-----------  Hydrostatic Equilibrium Model --------------
If keyword_set(hydro_eq) or keyword_set(all) THEN BEGIN
	rsun = 6.955e8  	;m
	k = 1.38e-23    	;(SI)
	IF keyword_set(temp) THEN T=temp ELSE T = 1.0e6			;(K)
	u_H = 1.00794		;atomic mass hydrogen
	amu = 1.6605e-27	;atomic unit (kg)
	m = amu*u_H			;mass hydorgen (kg)
	Guni = 6.687e-11	;Universal Grav Const. (SI)
	Msun = 1.989e30		;Solar Mass (kg)
	g = Guni*Msun/(rsun^2.0) ;Solar gravity (m/s/s)
	H = (k*T)/(m*g)		;Scale Height (m)
	Hrsun = H/rsun		;Scale Height (Rsun)
	

	IF keyword_set(n_0) THEN n_0=n_0 ELSE n_0 = 1.0e16		;Starting e density (m^-3)

	n_e = n_0*exp(-1.0d*abs(radius-1.0)/Hrsun)
	n_e = n_e/1.0e6
	
	print,'----------------------------------'
	print,'		Hydrostatic Equilibrium Model 		'
	print,'Radius: ' +string(radius)+' (Rsun)'
	print,'Temperature: ' +string(T)+' (K)'
	print,'Gravity at 1Rsun: ' +string(g)+' (m/s/s)'
	print,'Scale Height: ' +string(Hrsun)+' (Rsun) = '+string(H/1.0e6)+' Mm'
	print,'Electron density (quiet sun): '+string(n_e)+' (cm^-3)'
	print,'Plasma frequency (quiet sun): '+string( (C*sqrt(n_e))/MHz )+' (MHz)'
	print,' '
	print,'----------------------------------'
	
	stop
ENDIF

END
