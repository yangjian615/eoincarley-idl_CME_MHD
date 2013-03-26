FUNCTION dvdr,R,V, vrsnak=vrsnak

COMMON share,vsw_a,alpha,bet,gam 

;*******************Define Function*************************
;
;   This analysis is based on Byrne et al. 2010 in Nature.
;	From Shane's analysis of solar wind drag


	dvdr = dblarr(n_elements(V))
	vsw  = dblarr(n_elements(R))
	vsw[*]=vsw_a*sqrt( 1-exp( -1.0*(R[*]-2.8)/8.1) ) 


	;IF KEYWORD_SET(vrsnak) THEN BEGIN
		;dvdr[*] = 6.955e5*( alpha*(R[*]^bet) )*(1.0-V[*]/vsw[*]);*abs(V[*] - vsw[*])
	;ENDIF ELSE BEGIN
		dvdr[*] = 6.955e5*( alpha*(R^bet) )*( 1.0/V[*] )*(abs( V[*]-vsw )^gam)
	;ENDELSE

;stop;***********************************************************
return,dvdr
END


pro velocity_fit_20081212

cd,'/Users/eoincarley/Data/secchi_l1/20081212/COR1+COR2'
;****************************Read in kinematics data******************************
readcol, 'kins_meanspread.txt', mid_a, mid_r, top_a, top_r, bottom_a, bottom_r, $
midtop_a, midtop_r, mibottom_a, midbottom_r, time, f='D,D,D,D,D,D,D,D,D,D,A'

	   utbasedata = anytim(time[0])
       t = anytim(time) - utbasedata
       rsun = 6.95508e8

       mid_km = mid_r * rsun / 1000.0d
       top_km = top_r * rsun / 1000.0d
       bottom_km = bottom_r * rsun / 1000.0d
       midtop_km = midtop_r * rsun / 1000.0d
       midbottom_km = midbottom_r * rsun / 1000.0d

       mid_vel = deriv(t, mid_km)
       top_vel = deriv(t, top_km)
       bottom_vel = deriv(t, bottom_km)
       midtop_vel = deriv(t, midtop_km)
       midbottom_vel = deriv(t, midbottom_km)

       mid_accel = deriv(t, mid_vel) * 1000.0d ; to be in Metres
       top_accel = deriv(t, top_vel) * 1000.0d
       bottom_accel = deriv(t, bottom_vel) * 1000.0d
       midtop_accel = deriv(t, midtop_vel) * 1000.0d
       midbottom_accel = deriv(t, midbottom_vel) * 1000.0d
       
       
;********************************************************************************  

plot,mid_r,mid_vel,xtitle='Heliocentric Distance [R/R!Lsun!N]',ytitle='Velocity [km/s]',$
psym=1

end_r = n_elements(mid_r)-1
V_data = mid_vel[10:end_r]
R_data = mid_r[10:end_r]

COMMON share,vsw_a,alpha,bet,gam
    
    vsw_a = 555.0             ;Assymptotic value of solar wind velocity 
	alpha = 4.55e-5			  ;6.66e-5  These three params seem to be the better fit
	bet =  -2.025				  ;-2.0     at least visually.
	gam =   2.275				  ;2.5


;*******************Initial Values***********************
V = 272.5  	     ;Shane's Thesis
R = 6.625   		;Shane's Thesis
v_initial=V
r_initial=R

dvdr_i = dvdr(R,V,/vrsnak)


;*********************Runge-Kutta***********************
H = 0.01             ;Step size
;nsteps = round(  (R_data[n_elements(R_data)-1]-R_data[0])/H  )  ;Number of loop iterations
nsteps = round( (200.0-R)/H)


vfit = fltarr(2,nsteps)
vfit[0,0]=R
vfit[1,0]=V

       ;Do the integration
FOR i=1., nsteps-1 DO BEGIN
	Result = RK4( V, dvdr_i, R, H, 'dvdr', /double)
	V=Result
	R=R+H
	vfit[0,i]=R
    vfit[1,i]=Result
    dvdr_i = dvdr(R,V,/vrsnak)
    print,R,V
    ;plots,R,V,psym=3
    ;wait,0.3
ENDFOR


params='Initial Height='+string(r_initial,format='(f5.2)')+', '+$
	   'Initial Velocity='+string(v_initial,format='(f7.3)')+', '+$
	   'Asym Solar Wind Speed='+string(vsw_a,format='(f7.2)')+', '+$
	   'alpha='+string(alpha,format='(f11.8)')+', '+$
	   'beta='+string(bet,format='(f6.3)')+', '+$
	   'Gamma='+string(gam,format='(f6.3)')
	   print,params
save,vfit,params,filename='velocity_fit_20081212.sav'
oplot,vfit[0,*],vfit[1,*],linestyle=0;,yr=[0,1200]

stop
END