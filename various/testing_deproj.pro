pro testing_deproj

cd,'~'
window,0
restore,'derived_mass_5.sav', /verb
loadct,5
plot, pos_angle, derived_mass_dp[*, 0]/derived_mass[*, 0] , xtitle ='Angle from plane of sky ('+cgSymbol('theta')+')', $
	ytitle = '(Derived Mass)/(Actual Mass)',$
	linestyle=0, /normal, xr=[0,80]

oplot, pos_angle, derived_mass_dp[*, 0]/derived_mass[*, 0], color = 100	
oplot, pos_angle, derived_mass_dp[*, 1]/derived_mass[*, 1], color = 220
oplot, pos_angle, derived_mass_dp[*, 2]/derived_mass[*, 2], color = 50



;---------------------------------------------;
;			Total Brightness
;
cd,'~/Data/secchi_l1/20081212/20081212_cor2b/total_brightness'
pre = sccreadfits('20081212_072220_1B4c2B.fts', he)
img = sccreadfits('20081212_132220_1B4c2B.fts', he)
mask = get_smask(he)
img = (img - pre)*mask


window,1
plot_image, smooth(img, 5) > (5e-13) < 4e-11

suncen = get_suncen(he)
tvcircle, (he.rsun/he.cdelt1), suncen.xcen, suncen.ycen, 254, /data, color=255, thick=1

;-----------------------------------------------;
;			   Mass Images
;
mass_image_pos = scc_calc_cme_mass(img, he, /all, pos = 0.0)
mass_pos = total(mass_image_pos)

mass_angle = dblarr(11)
angles = (dindgen(11)*(80.0-0.0)/10.0)+0.0

FOR i=0, n_elements(mass_angle)-1 DO BEGIN	
	print, angles[i]
	mass_img_angle = scc_calc_cme_mass(img, he, /all, pos = angles[i])
	mass_angle[i] = total(mass_img_angle)
ENDFOR





cd,'~'
window,0
restore,'derived_mass_5.sav', /verb
loadct,5
plot, pos_angle, derived_mass_dp[*, 0]/derived_mass[*, 0] , xtitle ='Angle from plane of sky ('+cgSymbol('theta')+')', $
	ytitle = '(Derived Mass)/(Actual Mass)',$
	linestyle=0, /normal, xr=[0,80], yr=[0,10]

oplot, pos_angle, derived_mass_dp[*, 0]/derived_mass[*, 0], color = 100	
oplot, pos_angle, derived_mass_dp[*, 1]/derived_mass[*, 1], color = 220
oplot, pos_angle, derived_mass_dp[*, 2]/derived_mass[*, 2], color = 50


wset,0
oplot, angles, mass_angle/3.4e15


stop
END