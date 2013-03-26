pro force_20081212,proper_error=proper_error

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

	v_errs = derivsig(t,mid_r,t_errs,h_errs*6.95508e5)
	  ;print, 'v_errs (km?) ', v_errs
	a_errs = derivsig(t,mid_vel*1000.,t_errs,v_errs*1000.)
	  ;print, 'a_errs (m?) ', a_errs
	  ;***********   
	save,v_errs,filename='v_errs20081212.sav'

ENDIF       
    

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

;============Calculate kinetic energy, with everything in c.g.s=================

kin_enrg = dblarr(n_elements(mid_vel[*]))
kin_enrg = 0.5*mass[n_elements(mass)-1]*(mid_vel[*]*1e5)^2
;============Calculate force done by change in kinetic energy over distance=====

force_dist_t = dblarr(3,n_elements(mid_vel)-1)
force_dist_t[1,*] = (mid_km[1:n_elements(mid_km)-1]*1e5)
force_dist_t[2,*] = anytim((time[1:n_elements(time)-1]),/utim)
delta_f_frac = dblarr(n_elements(force_dist_t[0,*]))
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
force_accel = dblarr(3,n_elements(mid_accel))
force_accel[1,*] = mid_km[*]*1e5
force_accel[0,*] =  anytim(time[*],/utim)
f_err = dblarr(n_elements(mid_accel))

     force_accel[2,*] = (mid_accel[*]*100.0)*mass[n_elements(mass)-1]
     f_err[*] = sqrt( (a_errs[*]/mid_accel[*])^2 + (0.1)^2 ) 
     

  f_err[*] = abs(f_err[*]*mid_accel[*]*100.0*mass[n_elements(mass)-1])



set_plot,'ps'
device,filename = '20081212_force.ps',/color,/inches,/portrait,/encapsulate,$
yoffset=0.2,xoffset=0.11,xsize=4,ysize=6
loadct,39
!p.color=0
!p.background=255


!p.multi=[0,1,1]

;Note indexing on mid_vel and force_accel, first and last points have huge errors,
;so they are not plotted here...
!x.range=[2,20]
;============Plot velocity================
plot,(mid_km[1:n_elements(mid_km)-2]*1000)/rsun,mid_vel[1:n_elements(mid_vel)-2],psym=1,ytitle='!6Velocity [km s!U-1!N]',$
position=[0.2,0.51,0.9,0.9],/normal,/noerase,xtickname=[' ',' ',' ',' ',' ',' ']
;oplot,(mid_km*1000)/rsun,mid_vel,linestyle=1
oploterror,(mid_km[1:n_elements(mid_km)-2]*1000)/rsun,mid_vel[1:n_elements(mid_vel)-2],v_errs[1:n_elements(mid_vel)-2],psym=1
;window,2
xyouts,0.83,0.86,'(a)',/normal

;=============Plot force=================
;plot,(force_dist_t[1,*]/100)/rsun,force_dist_t[0,*],psym=4,$
;/ylog,position=[0.1,0.37,0.9,0.63],ytickname=[' ',' ',' ',' '],$
;/normal,/noerase,xtickname=[' ',' ',' ',' ',' ',' ']
;;oplot,(force_dist_t[1,*]/100)/rsun,(force_dist_t[0,*]),linestyle=2
;oploterror,(force_dist_t[1,*]/100)/rsun,force_dist_t[0,*],yerr,psym=1
;oplot,(force_dist_t[1,*]/100)/rsun,force_dist_t[0,*],linestyle=1
;axis,yaxis=1,yticks=3,yr=[1e17,1e20],ytitle='Force [dyne]'
;xyouts,0.85,0.60,'(b)',/normal


fake_r = dindgen(100)+1
const = fltarr(n_elements(fake_r))
const[*]=0
mag=1e18

plot,mid_r[1:n_elements(mid_r)-2],force_accel[2,1:n_elements(force_accel[2,*])-2]/mag,$
psym=4,ytitle='Force x 10!U18!N [dyne]',charsize=1,yr=[-40,40],$
position=[0.2,0.1,0.9,0.51],yminor=10,$
/normal,/noerase,xtitle='CME Height (R!Dsun!N)'

oploterror,mid_r[1:n_elements(mid_r)-2],force_accel[2,1:n_elements(force_accel[2,*])-2]/mag,$
f_err[1:n_elements(f_err)-1]/mag,psym=4
xyouts,0.83,0.46,'(b)',/normal

;oplot,fake_r[*],const[*],linestyle=1

stop_index = where(mid_r lt 23)
stop_index = stop_index[n_elements(stop_index)-1]
print,'========================================================================'
print,'========================================================================'
print,where(mid_r lt 7)
print,'Max force below 7 Rsun :'+string(max(force_accel[2,4]))+' +/-'+string(f_err[4])+' [dyne]'
print,'Average force below 7 Rsun :'+string(mean(force_accel[2,1:11]))+' +/-'+string(mean(f_err[1:11]))+' [dyne]'
;print,'Average force after 7 Rsun :'+string(mean(force_accel[2,11:n_elements(force_accel[2,*])-2]))+$
;' +/-'+string(mean(f_err[11:n_elements(f_err[*])-2]))+' [dyne]'
print,'Average force after 7 Rsun :'+string(mean(force_accel[2,12:stop_index]))+$
' +/-'+string(mean(f_err[12:stop_index]))+' [dyne]'

print,'Total average force :'+string(mean(force_accel[2,*]))+' +/-'+string(mean(f_err[*]))+' [dyne]'
print,'========================================================================'
print,'========================================================================'
print,'radius 11',mid_r[11]
;===========Calculate the mean and standard dev of data==================

print,'Height of max force :'+string(mid_r[4])
const[*] = mean(force_accel[2,11:22])/mag
;oplot,fake_r[*],const[*],linestyle=0

const[*] = mean(force_accel[2,11:22])/mag + mean(f_err[11:22])/mag
;oplot,fake_r[*],const[*],linestyle=1
const[*] = mean(force_accel[2,11:22])/mag - mean(f_err[11:22])/mag
;oplot,fake_r[*],const[*],linestyle=1

;radius=7.0
r_sun = 6.955e10 ;cm
proton_mass=1.67e-24
sw_mann,[fake_r],vs=vs,n=n
angle = 26.0*fake_r^0.22
angle2 = 52.0*fake_r^0.22
ram_p = dblarr(n_elements(fake_r))
ram_p[*]=0.5*(n[*])*(proton_mass)*((vs[*]*1e5)^2)*((!pi*angle/180.0)*r_sun*fake_r)*$
((!pi*angle2/180.0)*r_sun*fake_r)

oplot,fake_r[0:20],ram_p[0:20]/1.0e18
radius_ang = fltarr(2,n_elements(angle))
radius_ang[0,*]=fake_r[*]
radius_ang[1,*]=angle[*]

stop
oplot,fake_r[0:20],2*ram_p[0:20]/1.0e18,linestyle=2

radius=4.0
r_sun = 6.955e10 ;cm
proton_mass=1.67e-24
sw_mann,[radius],vs=vs,n=n
angle = 26.0*radius^0.22
angle2 = 52.0*radius^0.22
ram_p=0.5*(n)*(proton_mass)*((vs*1e5)^2)*((!pi*angle/180.0)*r_sun*radius)*$
((!pi*angle2/180.0)*r_sun*radius)

print,vs
print,n
print,'========================================================================'
print,'CME area exposed :' +string(((!pi*angle/180.0)*r_sun*radius)*((!pi*angle2/180.0)*r_sun*radius))+' [cm^2]'
print,'Dynamic ram pressure due to the' 
print,'solar wind at' +string(radius)+' Rsun: '+string(ram_p)+' [dyne]'


;mean_force = mean(force_dist_t[0,*])
;stand_dev = sig_array(force_dist_t[0,*])
;no_of_sd = dblarr(n_elements(force_dist_t[0,*]))
;no_of_sd[*] = (abs(mean_force-force_dist_t[0,*]))/stand_dev
;letter = greek('sigma')
;plot,(force_dist_t[1,*]/100)/rsun,no_of_sd,psym=1,$
;xtitle='CME Height (R!Dsun!N)',ytitle=letter+' from mean force',position=[0.1,0.1,0.9,0.37],$
;/normal,/noerase
;oplot,(force_dist_t[1,*]/100)/rsun,no_of_sd,linestyle=1
;xyouts,0.85,0.34,'(c)',/normal


device,/close
set_plot,'x'
END
       