pro plot_em_and_pb_density

;Procedure to plot the density profile derived from the Emission Measure Data
;and the density prodile from the polarized brightness

cd,'/Users/eoincarley/Data/22sep2011_event/LASCO_C2/polarized_brightness'
restore,'EM_density.sav',/verb ;/Emission Measure density
restore,'radius_ne_average.sav',/verb

loadct,39
!p.color=0
!p.background=255

;plot,rsun,ne_profile,/ylog,charsize=1.5,yr=[1.0e4,1.0e10],xr=[1.0,5.0]
;oplot,radius,ne_average 

;*******Put in one array*****
set_plot,'ps'
device,filename = 'ne_EM_pB_fit.ps',/color,/inches,/encapsulate,ysize=7,xsize=6.5,yoffset=7


rsun_orig = rsun
ne_profile = transpose(ne_profile)
rsun = rsun[0:n_elements(rsun)-2]
rsun = [rsun, radius]
ne_density = [ne_profile, ne_average]
;window,0,xs=500,ys=500
	plot,rsun_orig,ne_profile,charsize=1.5,psym=6,$
	xtitle='Heliocentric Distance [R/R!LSun!N]',ytitle='Electron Desnity [cm!U-3!N]',$
	/ylog,yr=[1.0e4,1.0e10],xr=[1.0,4.0]
	
	oplot,radius,ne_average,psym=5,color=250
	legend,['EM e!U-!N density', 'pB e!U-!N density', '2.7 MK AR', '1.6 MK Corona', 'Addition'],$
	linestyle=[0,0,3,5,0],psym=[6,5,0,0,0],$
	color=[0.0, 250.0, 0.0, 0.0, 100.0], charsize=1.5,/right,box=0
                    
                    
          ;Obselete part of code
;************In order to produce a fit to the data choose a 4 degree poltnomial********
;like the one pb_inverter gives. As start values to the fit average the coefficicents from
;all the radial traces. Should give the same values as ne_average
;cd,'/Users/eoincarley/Data/22sep2011_event/LASCO_C2/polarized_brightness'
;readcol,'info.txt', a, c0, c1, c2, c3, ex0, ex1, ex2, ex3,$
;	format = 'D,D,D,D,D,D,D,D,D'	
;radius  = (dindgen(1001)*(5.0 - 1.0)/1000.0) + 1.0
;c0_av =  median(c0) 		;affects the 4-5 Rsun region
;c1_av =  median(c1)
;c2_av =  median(c2)  ;affects rate of drop off
;c3_av =  median(c3)  		;slides whole line up and down vertically
; average coeffs: -1.8469800e-10   2.8173683e-09  -1.4749251e-08   5.2252285e-08
;	j=0
	;COEFF = [c0[j], c1[j], c2[j], c3[j]] 
	;COEFF = [c0_av, c1_av, c2_av, c3_av] 
	;EXPS = [ex0[j], ex1[j], ex2[j], ex3[j]] 
	;Q=0.58
	;RADII = radius
	;nsube = VDH_INVERSION(RADII,Q,COEFF,EXPS)
	
;************Trying to fit the data with a polynomial is not working. Requires an exponent of ~8.
;************Instead try an eponential fit....
rad_sim  = (dindgen(1001)*(5.0 - 1.0)/1000.0) + 1.0
start = [15.0,-1.1, 0.8]
fit =  '4.0 + p[0]*exp( p[1]*x^p[2] )'
fit_params = mpfitexpr(fit,rsun,alog10(ne_density),err,yfit=yfit,start);,parinfo=q)
ne_sim = dblarr(n_elements(rad_sim))
ne_sim[*] = 10.0^(4.0 + fit_params[0]*exp( fit_params[1]*rad_sim^fit_params[2] ))
;oplot,rad_sim,ne_sim,color=100,thick=4.0
save,rad_sim,ne_sim,filename='r_n_fit_20110922.sav'


	;n = (75.0e6/8980.0)^2.0	
	;index = closest(ne_sim, n)
	;print,rad_sim[index]
	;plots,rad_sim[index],n,psym=2,symsize=3,color=150
	;plots,1.39,n,psym=6,symsize=3,color=200

	;************Newkirk***************
	;R_nk = 4.32/alog10(25.0e6^2.0/3.385e12)
	;plots,R_nk,n,psym=4,symsize=3,color=240
	;**********************************

;*****************Hydrostatic Equilibrium Models******************
;						 (Active Region) 


	k = 1.38e-16 		;c.g.s
	m_proton = 1.67e-24 ;grams
	g = 274.0*100.0  	;cgs
	T = 2.0e6			;Kelvin
	R = 6.955e10		;c.g.s
	H =  (k*T)/(m_proton*g) 
    H = H/R
    rad_sim  = (dindgen(1001)*(5.0-1.0)/1000.0)+1.0
	y = dblarr(n_elements(rad_sim))
	y[*] = 1.2e9*exp(-1.00d*(rad_sim[*])/H)

oplot,rad_sim,y,color=240


q = replicate({fixed:0, limited:[0,0], limits:[0.D,0.D]}, 2)

q(0).limited(0)=1
q(0).limits(0) = 1.0e9
q(0).limited(1)=1
q(0).limits(1) = 5.0e12

q(1).limited(0)=1
q(1).limits(0) = 0.1
q(1).limited(1)=1
q(1).limits(1) = 0.2

start = [1.0e11, 0.108]
fit =  'p[0]*exp(-1.0d*(x)/p[1])'
fit_params = mpfitexpr(fit, rsun_orig, ne_profile, err, yfit=yfit, start, parinfo=q)



rad_sim  = (dindgen(1001)*(5.0-1.0)/1000.0)+1.0
ne_sim_HE = dblarr( n_elements(rad_sim) )
ne_sim_HE[*] = fit_params[0.0]*exp(-1.0d*(rad_sim)/fit_params[1.0])

oplot,rad_sim, ne_sim_HE, linestyle=3,thick=3

ne_active_region = ne_sim_HE

print,'Temperature from HE model of actve region: ' +$
			string(     (((fit_params[1]*R)*m_proton*g)/k)/1.0e6  )+' MK'
print,'Scale height of active region: '+string(fit_params[1])		
print,'Number Density of active region: '+string(ne_sim_HE[0])+' [cm!U-3!N]'





;*****************Hydrostatic Equilibrium Models******************
;						 (Coronagraph) 


Grav = 6.687e-8        ;c.g.s
Msun = 1.989e33		   ;c.g.s
;g = dblarr(n_elements(radius))
;g[*] = Grav*Msun / ( (radius[*]*Rsun)^2.0 )
g = Grav*Msun / ( (3.5*R)^2.0 )
T = 2.0e6
H =  (k*T)/(m_proton*g) 

ne_sim_HE = dblarr(n_elements(rad_sim))
ne_sim_HE[*] = 2.5e6*exp(-1.0d*(rad_sim[*]*R)/H)



q = replicate({fixed:0, limited:[0,0], limits:[0.D,0.D]},2)

q(0).limited(0)=1
q(0).limits(0) = 1.0e5
q(0).limited(1)=1
q(0).limits(1) = 1.0e9
H = H/R

start = [1.0e6,H]
fit =  'p[0]*exp(-1.0d*(x)/p[1])'
fit_params = mpfitexpr(fit,radius,ne_average,err,yfit=yfit,start,parinfo=q)
ne_sim_HE = dblarr(n_elements(rad_sim))
ne_sim_HE[*] = fit_params[0]*exp(-1.0d*(rad_sim)/fit_params[1])

ne_corona = ne_sim_He

oplot,rad_sim,ne_sim_HE,linestyle=5,thick=3.0;
print,'Temperature from HE model of corona: ' +string( (   ( (fit_params[1]*R)*m_proton*g)/(k)  )/1.0e6 )+' MK'
print,'Number Density of corona: '+string(ne_sim_HE[0])+' [cm!U-3!N]'
print,'Scale height of corona: '+string(fit_params[1])

ne_add = ne_active_region + ne_corona
oplot,rad_sim,ne_add,linestyle=0,thick=5.0,color=100


device,/close
set_plot,'x'

END