pro force_20081212_v3,proper_error=proper_error


cd,'/Users/eoincarley/Data/secchi_l1/20081212/COR1+COR2'
;=========================Read in kinematics data================================
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
IF keyword_set(proper_error) THEN BEGIN
	  ; Errors from Jason's Nature 2010       
	  ;n=8 ;<-- taken as the scale4 matlab code which is 2^3. Only valid for Cor1/2 though since running difference in HI1.
	  ; Then considering 3D error trapezoid Inhester paper errors: w/2*cos(alpha/2) and w/2*sin(alpha/2)
	  ; Stereo separation is 86.7 to 86.8 over the day, so average at 86.75
	  ; alpha/2 = 43.375 deg
	  ; cos(alpha/2) = 0.7268744
	  ; sin(alpha/2) = 0.6867704
	  ; so two error trapezoid axes measure [16/2*(0.73), 16/2*(0.69)] = [11.006, 11.649]
	n_cor = 11.6
	  ; But this is a 3sigma error so calculate 1sigma by their percentages (68-95-99.7 rule) => 68n/99.7
	n_cor = (68*n_cor)/99.7
	  ; And in HI1 the error is as follows
	  ;n_hi = 3 ;pixels re: Shanes calcs for 1sigma
	  ; so in 3D recon this is [2*3/2*(0.73), 2*3/2*(0.69)] = [4.127, 4.368]
	n_hi = 4.4

	h_errs = fltarr(n_elements(mid_r))
	t_errs = h_errs

	  ; There are 9 cor1 points with platescl (cdelt) of 7.5043001 arcsec
	for k=0,8 do h_errs[k] = 7.5043001 * n_cor / ((pb0r_stereo(time[k],/arcsec))[2])
	  ; There are 14 cor2 points with platescl (cdelt) of 14.700000 arcsec
	for k=9,22 do h_errs[k] = 14.700000 * n_cor / ((pb0r_stereo(time[k],/arcsec))[2])
	  ; There are 14 HI1 points with platescl (cdelt) of 0.019979876 deg (x3600 = 71.927554 arcsec)
	  ; If I were to make correction for spacecraft plane-of-sky being at 90degrees but CME about half this (rounding off) it will reduce the error, but I don't think I want to do this!
	for k=23,36 do h_errs[k] = 71.927554 * n_hi / ((pb0r_stereo(time[k],/arcsec))[2]) 
	;print, 'h_errs (rsun?) ', h_errs
	t_errs[0:8] = 1.69984 ;seconds
	t_errs[9:22] = 2.00090
	t_errs[23:36] = 1800.0000 ; 30mins ref. Eyles et al. 2008
    
	v_errs = derivsig(t,mid_r*6.95508e5,t_errs,h_errs*6.95508e5)
	  ;print, 'v_errs (km?) ', v_errs
	a_errs = derivsig(t,mid_vel*1000.,t_errs,v_errs*1000.)
	  ;print, 'a_errs (m?) ', a_errs
	  ;***********   
	save,v_errs,filename='v_errs20081212.sav'
    save,a_errs,filename='a_errs20081212.sav'
ENDIF ELSE BEGIN

restore,'v_errs20081212.sav'
restore,'a_errs20081212.sav'

ENDELSE
    

;================================================================================
restore,'COR1and2B_mass_height_time.sav',/verb
time_m = master1[0,*]
zero_t = where(time_m eq 0.0)
remove, zero_t,time_m

mass = master1[1,*]
zero_m = where(mass eq 0.0)
remove, zero_m,mass

height = master1[2,*]
zero_h = where(height eq 0.0)
remove, zero_h,height

stb_mass_ht = dblarr(3,n_elements(time_m))
stb_mass_ht[0,*]=time_m
stb_mass_ht[1,*]=mass
stb_mass_ht[2,*]=height

;============ Calculate kinetic energy, with everything in c.g.s=================

kin_enrg = dblarr(n_elements(mid_vel[*]))
kin_enrg = 0.5*(10.0^15.5306)*(mid_vel[*]*1.0e5)^2.0


;============Calculate force done by change in kinetic energy over distance=====

force_dist_t = dblarr(3,n_elements(mid_vel)-1)
force_dist_t[1,*] = (mid_km[1:n_elements(mid_km)-1]*1e5)
force_dist_t[2,*] = anytim((time[1:n_elements(time)-1]),/utim)
delta_f_frac = dblarr(n_elements(force_dist_t[0,*]))


;===============================================================================
;=================Evaluation of force using kinetic energy======================
;===============================================================================

FOR i = 1, n_elements(kin_enrg)-1 DO BEGIN
    force_dist_t[0,i-1] = abs(kin_enrg[i]-kin_enrg[i-1])/$
    ((mid_km[i]-mid_km[i-1])*1e5)
    
    delta_f_frac[i-1] =	sqrt((6e14/2e15)^2 +$ 
                        ((2.0*v_errs[i]*1.0e5)/(mid_vel[i]*1.0e5))^2 +$
    					((2.0*v_errs[i-1]*1.0e5)/(mid_vel[i-1]*1.0e5))^2 )
ENDFOR 
yerr = delta_f_frac*force_dist_t[0,*]


;===============================================================================
;====================Calculate force using the acceleration=====================
;===============================================================================
force_accel = dblarr(3,n_elements(mid_accel))
force_accel[1,*] = mid_km[*]*1.0e5
force_accel[0,*] =  anytim(time[*],/utim)
f_err = dblarr(n_elements(mid_accel))
restore,'A_mass_error_20081212.sav',/verb ;finite width errors
restore,'B_mass_error_20081212.sav',/verb
;B_error = B_error
     ;following mass values of 10.0^15.5306 is from fit to B data
     force_accel[2,*] = (mid_accel[*]*100.0)*10.0^15.5306; c.g.s
     FOR i = 0,n_elements(f_err)-1 DO BEGIN
     ;Force error derived from Jason's acceleration errors, finite width error, streamer mass error
     f_err[i] = sqrt( (a_errs[i]/mid_accel[i])^2 +$
                      (B_error[n_elements(B_error)-1]/100.0 + 4.5e14/(10.0^15.5306) + 0.06 + 0.02)^2 )
                      ;Add six percent because of conversion to grams from masb error. See Vourlidas 2010 ApJ 722
                      ;2 percent error from user generated uncertainties, see corB_user_errors. Average of last three
                      ;errors is ~2%
     ENDFOR  
  f_err[*] = abs(f_err[*]*mid_accel[*]*100.0*10.0^15.5306) ;c.g.s




;**********************************PLOTTING*******************************

set_plot,'ps'
device,filename = '20081212_force_v2.eps',/color,/inches,/portrait,/encapsulate,$
xsize=4.5,ysize=10;,yoffset=0.2,xoffset=0.11,
loadct,39
!p.color=0
!p.background=255
!p.charsize=1.0
;!x.range=[2,20]


;Note indexing on mid_vel and force_accel, first and last points have huge errors,
;so they are not plotted here...


;**********************Plot Velocity**********************

plot,(mid_km[1:n_elements(mid_km)-2]*1000)/rsun,mid_vel[1:n_elements(mid_vel)-2],psym=6,$
	position=[0.13, 0.75, 0.98, 0.98],/normal,/noerase,xtickname=[' ',' ',' ',' ',' ',' '],$
	xticks=4,xminor=4,xr=[2,18],/xs,xtickv=[2,6,10,14,18]
	   ;oplot,(mid_km*1000)/rsun,mid_vel,linestyle=1
   
	;oploterror,(mid_km[1:n_elements(mid_km)-2]*1000)/rsun,mid_vel[1:n_elements(mid_vel)-2],$
	;v_errs[1:n_elements(mid_vel)-2],psym=6
	
	xyouts,0.90,0.96,'(a)',/normal
	xyouts,0.031,0.80,'!6Velocity [km s!U-1!N]',/normal,orientation=90.0

		restore,'velocity_fit_20081212.sav' ;made using velocity_fit_20081212.pro
		vfit = vr_integ
		oplot,vfit[0,329:n_elements(vfit[0,*])-1],vfit[1,329:n_elements(vfit[0,*])-1],$
		linestyle=0,color=60,thick=2

	fake_r = dindgen(100)+1
	zeros = fltarr(n_elements(fake_r))

    oploterror,(mid_km[1:n_elements(mid_km)-2]*1000.0)/rsun,mid_vel[1:n_elements(mid_vel)-2],$
	v_errs[1:n_elements(mid_vel)-2],psym=6


;*********************Plot Acceleration**********************

plot,(mid_km[1:n_elements(mid_km)-2]*1000)/rsun,mid_accel[1:n_elements(mid_accel)-2],psym=4,$
	position=[0.13, 0.51, 0.98, 0.75],yr=[-150,200],/ys,/normal,$
	/noerase,xtickname=[' ',' ',' ',' ',' ',' '],xticks=4,xminor=4,xr=[2,18],/xs,xtickv=[2,6,10,14,18]
	
	xyouts,0.90,0.73,'(b)',/normal
	oplot,fake_r[*]-1,zeros[*],linestyle=0

	xyouts,0.031,0.56,'Acceleration [m s!U-2!N]',/normal,orientation=90.0

		accel_fit = deriv(vfit[0,*],vfit[1,*])
		bigger_than7 = where(vfit[0,*] gt 7.0)
		oplot,vfit[0,329:n_elements(vfit[0,*])-1],accel_fit[329:n_elements(vfit[0,*])-1],$
	    linestyle=0,color=60,thick=2


    oploterror,(mid_km[1:n_elements(mid_km)-2]*1000.0)/rsun,mid_accel[1:n_elements(mid_accel)-2],$
	a_errs[1:n_elements(mid_accel)-2],psym=4


;**********************Plot Energies**********************

plot,(mid_km[1:n_elements(mid_km)-2]*1000)/rsun, kin_enrg[1:n_elements(mid_accel)-2]/1.0e30,$
	position=[0.13, 0.28, 0.98, 0.51],/normal,/noerase,$
	xtickname=[' ',' ',' ',' ',' ',' '],psym=6,yr=[0,6],xticks=4,xminor=4,xr=[2,18],/xs,$
	xtickv=[2,6,10,14,18]
	xyouts,0.90,0.49,'(c)',/normal
	xyouts,0.031,0.29,'Kinetic Energy [x10!U30!N ergs]',/normal,orientation=90.0

	K_errors_frac = dblarr(n_elements(kin_enrg))
	K_errors_frac = sqrt ( (0.30)^2.0 + (2*(v_errs*1.0e5)/(mid_vel*1.0e5))^2.0 )
	;18% error on mass is from maximum error due to finite width (10%), MSB->grams error (6%), sig error (2%)
	K_errors = K_errors_frac*kin_enrg
	oploterror,(mid_km[1:n_elements(mid_km)-2]*1000)/rsun, kin_enrg[1:n_elements(mid_accel)-2]/1.0e30,$
	K_errors[1:n_elements(kin_enrg)-2]/1.0e30,psym=6

		kinE_fit = dblarr(n_elements(vfit[1,*]))
		kinE_fit[*] = 0.5*(10.0^15.5306)*(vfit[1,*]*1.0e5)^2.0
		kinE_fit[*] = transpose(kinE_fit[*])
		;print,'**********Plotting Energy Fit***************'
		;print,' '
		;restore,'velocity_fit_20081212.sav' ;made using velocity_fit_20081212.pro
		oplot,vfit[0,329:n_elements(vfit[0,*])-1],kinE_fit[329:n_elements(vfit[0,*])-1]/1.0e30,$
		linestyle=0,color=60, thick=2




;***********************Plot Force*************************

fake_r = dindgen(100)+1

const = fltarr(n_elements(fake_r))
const[*]=0
mag=1.0e13
sun=sunsymbol()																	;1.0e-5 to convert to Newtons

plot,mid_r[1:n_elements(mid_r)-2],(force_accel[2,1:n_elements(force_accel[2,*])-2]*1.0e-5)/mag,$
	psym=4,yr=[-50,50],$
	position=[0.13, 0.05, 0.98, 0.28],yminor=4,xticks=4,xminor=4,xr=[2,18],/xs,$
	xtickv=[2,6,10,14,18],$
	/normal,/noerase,xtitle='CME Front Height [R/R!L'+sun+'!N]'

	oploterror,mid_r[1:n_elements(mid_r)-2],(force_accel[2,1:n_elements(force_accel[2,*])-2]*1e-5)/mag,$
	f_err[1:n_elements(f_err)-1]*1e-5/mag,psym=4
	xyouts,0.90,0.26,'(d)',/normal

		force_fit = ((10.0^15.5306)/1000.0)*accel_fit[*]
		oplot,vfit[0,329:n_elements(vfit[0,*])-1],force_fit[329:n_elements(vfit[0,*])-1]/1.0e13,$
		linestyle=0,color=60,thick=2

	;329:n_elements(vfit[0,*])-1

	zeros = fltarr(n_elements(fake_r))
	oplot,fake_r[*]-1,zeros[*],linestyle=0
	xyouts,0.031,0.09,'Force [x 10!U13!N N]',/normal,orientation=90.0



;******************************************************************
;**********************END PLOTTING********************************
;******************************************************************

stop_index = where(mid_r lt 20)
stop_index = stop_index[n_elements(stop_index)-1]
print,'========================================================================'
print,'========================================================================'
print,where(mid_r lt 3)
print,'Max force below 7 Rsun :'+string(max(force_accel[2,4]))+' +/-'+string(f_err[4])+' [dyne]'

print,'Average force below 7 Rsun :'+string(mean(force_accel[2,1:11]))+' +/-'+string(mean(f_err[1:11]))+' [dyne]'

print,'Average force after 7 Rsun :'+string(mean(force_accel[2,12:stop_index-1]))+$
' +/-'+string(mean(f_err[12:stop_index-1]))+' [dyne]'

print,'Total average force :'+string(mean(force_accel[2,*]))+' +/-'+string(mean(f_err[*]))+' [dyne]'
print,'========================================================================'
print,'========================================================================'
print,'radius element 11',mid_r[12]
;===========Calculate the mean and standard dev of data==================

print,'Height of max force :'+string(mid_r[4])
print,'Time of max force :'+string(time[4])
print,'Kinetic energy at height of '+string(mid_r[4],format='(f5.2)')+' R_sun : '$
+string(kin_enrg[4],format='(e11.4)')+' +/- '+string(K_errors[4],format='(e11.4)')+' [ergs]'

print,'Kinetic energy at height of '+string(mid_r[stop_index],format='(f5.2)')+' R_sun : '$
+string(kin_enrg[stop_index],format='(e11.4)')+' +/- '+string(K_errors[stop_index],format='(e11.4)')+' [ergs]'

;stop,'Paused'

const[*] = mean(force_accel[2,11:22])/mag
;oplot,fake_r[*],const[*],linestyle=0

const[*] = mean(force_accel[2,11:22])/mag + mean(f_err[11:22])/mag
;oplot,fake_r[*],const[*],linestyle=1
const[*] = mean(force_accel[2,11:22])/mag - mean(f_err[11:22])/mag
;oplot,fake_r[*],const[*],linestyle=1


;================Force due to CME drag calculation====================

r_sun = 6.955e10         ;cm
proton_mass=1.67e-24     ;g
                         ;sw_mann,[fake_r],vs=vs,n=n *old line*
sw_mann,mid_r,vs=vs,n=n  ;use Mann et al. (1999) model to calculate solar wind density and velocity
angle = 26.0*mid_r^0.22  ;define latitudinal anglular width
angle2 = 52.0*mid_r^0.22 ;define longitudinal anglular width
						 ;ram_p = dblarr(n_elements(fake_r)) *old line*
drag_coef=1.0
sw_drag = dblarr(n_elements(mid_r))
vs=vs
sw_drag[*]=-0.5*drag_coef*n[*]*proton_mass*((mid_vel[*]-vs[*])*1.0e5)*abs((mid_vel[*]-vs[*])*1e5)*$
((angle*!DTOR)*r_sun*mid_r[*])*((angle2*!DTOR)*r_sun*mid_r[*])

;oplot,fake_r[0:20],ram_p[0:20]/1.0e18
drag_terms = fltarr(5,n_elements(mid_r))
;radius_ang[0,*]=fake_r[*]
drag_terms[0,*]=mid_r[*]
drag_terms[1,*]=vs[*]
drag_terms[2,*]=n[*]
drag_terms[3,*]=mid_vel[*]
drag_terms[4,*]=sw_drag[*]


velocities = fltarr(2,n_elements(mid_vel))
velocities[0,*]=mid_vel[*]
velocities[1,*]=vs[*]

;oplot,mid_r[0:23],sw_drag[0:23]/1.0e18,linestyle=2

radius=2.9
r_sun = 6.955e10 ;cm
proton_mass=1.67e-24
sw_mann,[radius],vs=vs,n=n
angle = 26.0*radius^0.22
angle2 = 52.0*radius^0.22
sw_drag=-0.5*drag_coef*n*proton_mass*((mid_vel[4]-vs)*1.0e5)*abs((mid_vel[4]-vs)*1e5)*$
((angle*!DTOR)*r_sun*radius)*((angle2*!DTOR)*r_sun*radius)

print,'Solar wind speed at 2.9 Rsun' +string(vs)
print,n
print,'========================================================================'
print,'CME area exposed :' +string(((angle*!DTOR)*r_sun*radius)*((angle2*!DTOR)*r_sun*radius))+' [cm^2]'
print,'Dynamic ram pressure due to the' 
print,'solar wind at' +string(radius)+' Rsun: '+string(sw_drag)+' [dyne]'


;==========Gravity calculation======
G=6.67e-11 ;SI
Msun = 1.9891e30 ;kg
Mcme = (10.0^15.5306)/1000.0 ;kg
dis=(6.955e8)*3.0

F_grav = (G*Msun*Mcme)/(dis^2.0) ;N
F_grav = F_grav*1.0e5 ;dyne

print,'Force due to gravity at 3 R_sun :' +string(F_grav)+' [dyne]'
print,'Lorentz force at 3 R_sun:' +string(max(force_accel[2,4])+F_grav-sw_drag)+' [dyne]'



device,/close
set_plot,'x'
HERE:
END
       