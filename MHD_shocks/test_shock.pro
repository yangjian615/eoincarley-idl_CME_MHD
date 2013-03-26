pro test_shock

;Trying to reporoduce Figure 9(a) KABIN 2003

;theta_vn = (dindgen(1001)*(65.0 - 35.0)/1000.0 )+35.0
;chi_array = dblarr(n_elements(theta_vn))
;FOR i=0,n_elements(theta_vn)-1 DO BEGIN
	
;	theta = theta_vn[i]
;	mhd_shock_fixframe, theta, 63.0, 4.16666, chi
;	chi_array[i] = chi
	;set b_gauss = 1.1 to recreate figure
	
;ENDFOR

;plot, theta_vn, chi_array, /xs, /ys, yr=[3.35, 3.50]


set_line_color
produce_chis, 89.0, chi_array, Ma_array
plot,  sqrt(chi_array)-1.0  , Ma_array, /xs, /ys, xr=[0.0, 1.0], yr=[1, 5], linestyle=0,$
charsize=2.0, xtitle= 'BDW=sqrt(chi)-1.0', ytitle='Alfven Mach', thick=3

legend,['Theta=90','Theta=60','Theta=30'], linestyle=[0,0,0], color=[0, 5, 6], box=0, charsize=2.0


produce_chis, 60.0, chi_array, Ma_array
oplot,  sqrt(chi_array)-1.0 , Ma_array, psym=3, color=5

produce_chis, 30.0, chi_array, Ma_array
oplot,  sqrt(chi_array)-1.0 , Ma_array, psym=3, thick=3, color=6

;produce_chis, 1.0, chi_array, Ma_array
;oplot,  sqrt(chi_array)-1.0 , Ma_array, psym=1




END

pro produce_chis, angle, chi_array, Ma_array

Ma_array = (dindgen(1001)*(5.0 - 1.0)/1000.0 ) + 1.0
chi_array = dblarr(n_elements(Ma_array))
FOR i=0,n_elements(Ma_array)-1 DO BEGIN
	
	Ma = Ma_array[i]
	mhd_shock_fixframe, 180.0, angle, Ma, chi
	chi_array[i] = chi
	;set b_gauss = 1.1 to recreate figure
	
ENDFOR

indeces = where(sqrt(chi_array)-1.0 lt 0.81)
Ma_array = Ma_array[indeces] 
chi_array = chi_array[indeces]

END