FUNCTION fun,R,V, vrsnak=vrsnak

COMMON share,vsw_a,alpha,bet,gam 

print,vsw_a,alpha,bet,gam
;*******************Define Function*************************
;
;   This analysis is based on Byrne et al. 2010 in Nature.
;	From Shane's analysis of solar wind drag


	dvdr = dblarr(n_elements(V))
	vsw  = dblarr(n_elements(R))
	vsw[*]=vsw_a*sqrt( 1.0 - exp( -1.0*(R[*]-2.8)/8.1 ) ) 


	 						;IF KEYWORD_SET(vrsnak) THEN BEGIN
	dvdr[*] = -1.0d*(  6.95508*(10.0d^(5.0d))  )*( alpha*(R[*]^bet) )*( 1.0 - vsw[*]/V[*] )    ;*abs(V[*] - vsw[*])
	             			;ENDIF ELSE BEGIN
							;	dvdr[*] = 6.955e5*( alpha*(R^bet) )*( 1.0/V[*] )*(abs( V[*]-vsw )^gam)
							;ENDELSE

;stop;***********************************************************
return,dvdr
END


pro velocity_fit_20081212_v2

COMMON share,vsw_a,alpha,bet,gam
    
    vsw_a = 400.0d   ;555.0             ;Assymptotic value of solar wind velocity 
	alpha = 2.0d-3  ;For some reason a factor of !pi works!!!  I haven't a clue why  ;4.55e-5			  ;6.66e-5  These three params seem to be the better fit
	bet =  -1.0d     ;-2.025		      ;-2.0     at least visually.
	gam =   2.0      ;2.275				  ;2.5


;*******************Initial Values***********************
V = 1000.0d        ;272.5  	     ;Shane's Thesis
R = 30.0d        ;6.625   		;Shane's Thesis
v_initial=V
r_initial=R

;*********************Runge-Kutta***********************

H = 0.1d             ;Step size
;nsteps = round(  (R_data[n_elements(R_data)-1]-R_data[0])/H  )  ;Number of loop iterations
nsteps =  (200.0-R)/H

vfit = dblarr(2,nsteps)
       ;Do the integration
FOR i=0.0, nsteps-1 DO BEGIN
	vfit[0,i]=R
    vfit[1,i]=V 
    dvdr_i = fun(R,V,/vrsnak)

	Result = RK4( V, dvdr_i, R, H, 'fun', /double)
	R=R+H
    V=Result
    
    print,R,Result
ENDFOR


params='Initial Height='+string(r_initial,format='(f5.2)')+', '+$
	   'Initial Velocity='+string(v_initial,format='(f7.3)')+', '+$
	   'Asym Solar Wind Speed='+string(vsw_a,format='(f7.2)')+', '+$
	   'alpha='+string(alpha,format='(f11.8)')+', '+$
	   'beta='+string(bet,format='(f6.3)')+', '+$
	   'Gamma='+string(gam,format='(f6.3)')
	   print,params
save,vfit,params,filename='velocity_fit_20081212.sav'
plot,vfit[0,*],vfit[1,*],linestyle=0;,yr=[0,1200]

stop
END