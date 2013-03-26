pro polar_density_fitting
;Procedure to fit SDO density map (1-1.3 Rsun) and LASCO density maps (2.5 - 6 Rsun) with Plane parallel and Spherical Model

;Restore the SDO emission measure polar map
cd,'/Users/eoincarley/Data/22sep2011_event/pietro'
restore,'sdo_polar_density.sav',/verb ; map created using a constant lenght
;restore,'/Users/zucca/sdo_polar_density_map_new.sav',/verb ;Map created using the Stellar Atmosphere Method and a dt of 2e6


;and The Lasco density Map
restore,'pbne_20110922_0257_C2_2.5rsun.sav',/verb

radius=[dist_rsun[0:125],rhos]

for i=35,119 do begin
i = 35;15 degress below equator
;Plots SDO the density Profile 
	loadct,0
	plot,dist_rsun,polar_density[*,i],charsize=1.5,psym=6,$
	xtitle='Heliocentric Distance [R/R!LSun!N]',ytitle='Electron Desnity [cm!U-3!N]',$
	/ylog,yr=[1.0e4,1.0e10],xr=[1.0,4.0];,/noerase
	
;Plots the LASCO density Profile


oplot,rhos,nearr[*,i]

density=[polar_density[*,i],nearr[*,i]]

;*****************Plane Parallel + Spherical Hydrostatic Equilibrium Models******************
;
;******Fit**** (SDO + LASCO Data)

q = replicate({fixed:0, limited:[0,0], limits:[0.D,0.D]}, 4)

q(0).limited(0)=1
q(0).limits(0) = 1.0e9
q(0).limited(1)=1
q(0).limits(1) = 5.0e12

q(1).limited(0)=1
q(1).limits(0) = 0.1
q(1).limited(1)=1
q(1).limits(1) = 0.2

q(2).limited(0)=1
q(2).limits(0) = 1.0e8
q(2).limited(1)=1
q(2).limits(1) = 5.0e9

q(3).limited(0)=1
q(3).limits(0) = 1.e6
q(3).limited(1)=1
q(3).limits(1) =9.e6

start = [1.0e11,0.108,1.2e9, 5.e6]
err=density*0.154
fit ='p[0]*exp(-1.0d*(x)/p[1])+p[2]*exp((1.59819e18/p[3])*((1/(x*6.955e10))-(1/6.955e10)))'

;Check for non zero in the density arrays
non_zero=where(density ne 0)
err=density[non_zero]*0.154

fit_params_pp_sp = mpfitexpr(fit,radius[non_zero],density[non_zero], err, yfit=yfit, start, parinfo=q,/quiet)



rad_sim  = (dindgen(1001)*(5.0-1.0)/1000.0)+1.0
ne_sim_HE_SPH = dblarr( n_elements(rad_sim) )
ne_sim_HE_SPH[*] = fit_params_pp_sp[0.0]*exp(-1.0d*(rad_sim)/fit_params_pp_sp[1.0])+fit_params_pp_sp[2.0]*exp((1.59819e18/fit_params_pp_sp[3.0])*((1/(rad_sim*6.955e10))-(1/6.955e10)))

set_line_color
oplot, rad_sim, ne_sim_HE_SPH, linestyle=5,thick=2,color=5
save, rad_sim, ne_sim_HE_SPH, filename='pietros_code_pb_euv_density.sav'


fp = 75.0e6
n_e = ( fp/ ( 1.0/(2.0*!pi) * sqrt(  ( 4.0*!pi*(4.8032e-10)^2.0  )  / (!e_mass*1000.0)  ) ) )^2.0
h_est = interpol(rad_sim, ne_sim_HE_SPH, n_e)

Bg = 2.2/h_est^2.0
BT = Bg*1e-4
mu = 1.256e-6
mp = 1.27e-27
va = (BT/sqrt(mu*n_e*1.0e6*mp))/1000.0

print,'------------------------'
print,' '
print,'Density: '+string(n_e)
print,'Height of this density: '+string(h_est)
print,' '
print,'------------------------'

print,'Temperature from HE model of coronograph data: ' +string(fit_params_pp_sp[3.0])+'K'		
print,'Number Density of coronograph data: '+string(fit_params_pp_sp[2.0])+' [cm!U-3!N]'


stop

endfor

end
