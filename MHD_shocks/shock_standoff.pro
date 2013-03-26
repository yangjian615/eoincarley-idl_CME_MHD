pro shock_standoff

; Code to show the diferece of between a gas dynamic and full MHD treatment of 
; shock standoff distance as function of Mach.
; Most source will use Spreiter et al.'s derivation usng purely gas dynamics and
; substituting the sonic Mach number with the Alfven Mach number.
; However, Carins 1994 GRL 21, 25 showed that this is in adequate and a full 
; MHD approach should be used. This code recreates Figure 5 in their paper.


M = (dindgen(101)*(10.0-0.0)/100) +0.0
gam=5.0/3.0
alpha = 1.0 + 1.1*((gam-1.0)*M^2.0 + 2.0)/((gam+1.0)*(M^2.0))  ;Spreiter's original formula.
; This formula, most assume that M is Aflven Mach. Most likely valid in the corona
; where Alfven speed dominates. See Spreiter et al. 1966

Ma=(dindgen(101)*(10.0-0.0)/100) +0.0
Ms=10.0
A = (gam-1.0) + gam/((Ma)^2.0) + 2.0/Ms^2.0
alphaMHD = 1 + 1.1/(2*(gam+1))*( A + sqrt(A^2.0 -4*(gam-2)*(gam+1)*(1/Ma^2.0)   )    )
;alphaMHD = 1/alphaMHD


plot, M, alpha-1.0, charsize=1.5, xr=[1,6], yr=[0,2], /xs, xtitle='Alfven Mach', ytitle='DeltaR/Rc'
oplot, Ma, alphaMHD-1.0, linestyle=2

;To see following numbers run plot_wl_mach_20110922
Rc=0.719
delR = 0.5

;Rc = 0.86612093 ;R/Rsun
;delR =  0.52689965 ;R/Rsun

;Rc = 1.0497221
;delR = 0.59365661

hd_mach = interpol(M, alpha-1.0, delR/Rc)
mhd_mach = interpol(Ma, alphaMHD-1.0, delR/Rc)
print, hd_mach, mhd_mach


;Results show that the full MHD treatment gives slightly different answers, 
;but nothing drastically different


END