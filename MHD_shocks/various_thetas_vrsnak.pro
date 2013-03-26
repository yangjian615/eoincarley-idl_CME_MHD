pro various_thetas_vrsnak

;Perpendicular shock. Recreating Fig 9(a) from Vrsnak 2002 A&A 396, 673


set_line_color
produce_chis, 89.0, chi_array, Ma_array
plot,  sqrt(chi_array)-1.0  , Ma_array, /xs, /ys, xr=[0.0, 1.0], yr=[1, 5], linestyle=0,$
charsize=2.0, xtitle= 'BDW=sqrt(chi)-1.0', ytitle='Alfven Mach', thick=3

legend,['Theta=90','Theta=60','Theta=30'], linestyle=[0,0,0], color=[1, 5, 6], box=0, charsize=2.0


produce_chis, 60.0, chi_array, Ma_array
oplot,  sqrt(chi_array)-1.0 , Ma_array, psym=3, color=5

produce_chis, 30.0, chi_array, Ma_array
oplot,  sqrt(chi_array)-1.0 , Ma_array, psym=3, thick=3, color=6

produce_chis, 1.0, chi_array, Ma_array
oplot,  sqrt(chi_array)-1.0 , Ma_array, psym=1




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