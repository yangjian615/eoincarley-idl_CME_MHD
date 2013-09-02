pro plot_width_deproj_err

;---------------------------------------;
;		 POS and De-projected  			;
; 				5 Rsun
;

width_deproj_err, 1.2, pos_angle, derived_mass_dp, /deproj

set_line_color
window,0, xs=600, ys=600

plot, pos_angle, derived_mass_dp[*, 0] , xtitle ='Angle from plane of sky', ytitle = 'Derived/Actual Mass',$
	linestyle=0, yr=[0,5], title='1.2 Rsun'
FOR i=1, n_elements(derived_mass_dp[0, *])-1 DO BEGIN
	oplot, pos_angle, derived_mass_dp[*, i], color=(i)*2.0
ENDFOR	

width_deproj_err, 1.2, pos_angle, derived_mass

FOR i=0, n_elements(derived_mass[0, *])-1 DO BEGIN
	oplot, pos_angle, derived_mass[*, i], linestyle=1, color=(i-1)*2.0
ENDFOR
save, pos_angle, derived_mass, derived_mass_dp, filename='derived_mass_1_2.sav'
stop
;---------------------------------------;
;		 POS and De-projected  			;
; 				10 Rsun
;


width_deproj_err, 35.0, pos_angle, derived_mass_dp, /deproj

set_line_color
window,1, xs=600, ys=600
plot, pos_angle, derived_mass_dp[*, 0] , xtitle ='Angle from plane of sky', ytitle = 'Derived/Actual Mass',$
	linestyle=0, yr=[0,5], title='35 Rsun'
FOR i=1, n_elements(derived_mass_dp[0, *])-1 DO BEGIN
	oplot, pos_angle, derived_mass_dp[*, i], color=i*2.0
ENDFOR	

width_deproj_err, 35.0, pos_angle, derived_mass

FOR i=0, n_elements(derived_mass[0, *])-1 DO BEGIN
	oplot, pos_angle, derived_mass[*, i], linestyle=1, color=(i-1)*2.0
ENDFOR
;save, pos_angle, derived_mass, derived_mass_dp, filename='derived_mass_10.sav'

stop
;---------------------------------------;
;		 POS and De-projected  			;
; 				20 Rsun
;

width_deproj_err, 50.0, pos_angle, derived_mass_dp, /deproj

set_line_color
window,2, xs=600, ys=600
plot, pos_angle, derived_mass_dp[*, 0] , xtitle ='Angle from plane of sky', ytitle = 'Derived/Actual Mass',$
	linestyle=0, yr=[0,5], title='20 Rsun'
FOR i=1, n_elements(derived_mass_dp[0, *])-1 DO BEGIN
	oplot, pos_angle, derived_mass_dp[*, i], color=i*2.0
ENDFOR	

width_deproj_err, 50.0, pos_angle, derived_mass

FOR i=0, n_elements(derived_mass[0, *])-1 DO BEGIN
	oplot, pos_angle, derived_mass[*, i], linestyle=1, color=(i-1)*2.0
ENDFOR
;save, pos_angle, derived_mass, derived_mass_dp, filename='derived_mass_20.sav'


END

;------------------------------------;
;
;		Calculate width error
;
;------------------------------------;

pro width_deproj_err, height, pos_angle, derived_mass, deproj = deproj

;Code to reproduce Figure 4 (right) of Vourlidas ApJ 722:1522–1538, 2010 October 20
npos = 50
pos_angle = (dindgen(npos)*(80.0 - 0.0)/(npos-1.0) ) + 0.0
cme_widths = [40.0, 80.0, 120.0];, 140.0]; (dindgen(21)*(160.0 - 20.0)/20.0 ) + 20.0
derived_mass = dblarr(n_elements(pos_angle), n_elements(cme_widths))

h = height
FOR j = 0, n_elements(cme_widths)-1 DO BEGIN
	cme_width = cme_widths[j]
		print,'------------------------------'
		print,'------------------------------'
		print,' '
		print,'CME Width: '+string(cme_width)
		print,' '
		print,'------------------------------'
	
	FOR i =0, n_elements(pos_angle)-1 DO BEGIN
		angle = pos_angle[i]
		IF keyword_set(deproj) THEN BEGIN
			compare_angle = angle
		ENDIF ELSE BEGIN
			compare_angle = 0.0
		ENDELSE
		
		print,'								 '
		print,'POS angle: '+string(angle)
		print, ' '
		derived_mass[i, j] = masses_width_error4(h, cme_width, angle, compare_angle)
	END	
	
ENDFOR	


END