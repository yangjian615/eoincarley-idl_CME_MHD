pro plot_width_deproj_err_v2
cd,'~'


;--------------------------------------;
;			   1.2 Rsun				   ;
;
restore,'derived_mass_1_2.sav', /verb

loadct,39
set_plot,'ps'
!p.charsize=1
!p.font=0
!p.thick=3
device, filename='deproj_errors.eps', xsize=10, ysize=10, /inches, /color, /helvetica, /encapsulate

plot, pos_angle, derived_mass_dp[*, 0] , xtitle ='Angle from plane of sky ('+cgSymbol('theta')+')', ytitle = '(Derived Mass)/(Actual Mass)',$
	linestyle=0, yr=[0,2], position=[0.35, 0.72, 0.6, 0.97], /normal
xyouts, 0.475, 0.98, 'CME height: 1.2 R ', /normal, alignment=0.5	
xyouts, 0.475, 0.98, '            !L!9n!X!N', /normal, charsize=1.5, alignment=0.5, font=-1
	
oplot, pos_angle, derived_mass_dp[*, 0], color = 100	
oplot, pos_angle, derived_mass_dp[*, 1], color = 220
oplot, pos_angle, derived_mass_dp[*, 2], color = 50

oplot, pos_angle, derived_mass[*, 0], linestyle=5, color = 100
oplot, pos_angle, derived_mass[*, 1], linestyle=5, color = 220
oplot, pos_angle, derived_mass[*, 2], linestyle=5, color = 30
legend, [cgsymbol('phi')+'=40'+cgSymbol('deg'), $
		 cgsymbol('phi')+'=80'+cgSymbol('deg'), $
		 cgsymbol('phi')+'=120'+cgSymbol('deg')], $
		 color=[100, 220, 30], linestyle=[0,0,0], box=0


hlin = pos_angle
hlin[*]=1.0
loadct,0
oplot, pos_angle, hlin, color=150




;--------------------------------------;
;			   5 Rsun				   ;
;

loadct,39
restore,'derived_mass_5.sav', /verb

plot, pos_angle, derived_mass_dp[*, 0] , xtitle ='Angle from plane of sky ('+cgSymbol('theta')+')', ytitle = '(Derived Mass)/(Actual Mass)',$
	linestyle=0, yr=[0,2], position=[0.35, 0.39, 0.6, 0.64], /normal, /noerase
	
xyouts, 0.475, 0.65, 'CME height: 5 R ', /normal, alignment=0.5	
xyouts, 0.475, 0.65, '           !L!9n!X!N', /normal, charsize=1.5, alignment=0.5, font=-1
	
oplot, pos_angle, derived_mass_dp[*, 0], color = 100	
oplot, pos_angle, derived_mass_dp[*, 1], color = 220
oplot, pos_angle, derived_mass_dp[*, 2], color = 50

oplot, pos_angle, derived_mass[*, 0], linestyle=5, color = 100
oplot, pos_angle, derived_mass[*, 1], linestyle=5, color = 220
oplot, pos_angle, derived_mass[*, 2], linestyle=5, color = 30
legend, [cgsymbol('phi')+'=40'+cgSymbol('deg'), $
		 cgsymbol('phi')+'=80'+cgSymbol('deg'), $
		 cgsymbol('phi')+'=120'+cgSymbol('deg')], $
		 color=[100, 220, 30], linestyle=[0,0,0], box=0

loadct,0
oplot, pos_angle, hlin, color=150




;--------------------------------------;
;			   10 Rsun				   ;
;

loadct,39
restore,'derived_mass_10.sav', /verb

plot, pos_angle, derived_mass_dp[*, 0] , xtitle ='Angle from plane of sky ('+cgSymbol('theta')+')', ytitle = '(Derived Mass)/(Actual Mass)',$
	linestyle=0, yr=[0,2], position=[0.35, 0.05, 0.6, 0.31], /normal, /noerase
	
xyouts, 0.475, 0.32, 'CME height: 10 R ', /normal, alignment=0.5	
xyouts, 0.479, 0.32, '           !L!9n!X!N', /normal, charsize=1.5, alignment=0.5, font=-1
	
oplot, pos_angle, derived_mass_dp[*, 0], color = 100	
oplot, pos_angle, derived_mass_dp[*, 1], color = 220
oplot, pos_angle, derived_mass_dp[*, 2], color = 50

oplot, pos_angle, derived_mass[*, 0], linestyle=5, color = 100
oplot, pos_angle, derived_mass[*, 1], linestyle=5, color = 220
oplot, pos_angle, derived_mass[*, 2], linestyle=5, color = 30
legend, [cgsymbol('phi')+'=40'+cgSymbol('deg'), $
		 cgsymbol('phi')+'=80'+cgSymbol('deg'), $
		 cgsymbol('phi')+'=120'+cgSymbol('deg')], $
		 color=[100, 220, 30], linestyle=[0,0,0], box=0

loadct,0
oplot, pos_angle, hlin, color=150




device,/close
set_plot,'x'


END