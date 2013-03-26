pro various_betas_perp

;Perpendicular shock. Recreating Fig 9(b) from Vrsnak 2002 A&A 396, 673

set_line_color
cd,'~/idl/MHD_shocks'
restore,'ma_v_chi_beta0.sav', /verb

plot, chi , ma, xr=[0.5, 2.0], yr=[1,2.0], ytitle='Mach Number', xtitle='Compression',$
charsize=1.5, psym=1
legend,['Beta=0','Beta=0.1','Beta=0.2','Beta=1'], psym=[1,2,6,4], color=[0,3,4,5], box=0, charsize=2.0

restore,'ma_v_chi_beta0dot1.sav', /verb
oplot, chi, ma, psym=2, color=3

restore,'ma_v_chi_beta0dot2.sav', /verb
oplot, chi , ma, psym=6, color=4

restore,'ma_v_chi_beta1.sav', /verb
oplot, chi , ma, psym=4, color=5


END