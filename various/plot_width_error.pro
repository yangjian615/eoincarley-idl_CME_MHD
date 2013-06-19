pro plot_width_error, toggle = toggle

cd,'~/Data'
restore,'angle_err_height.sav'

height = [1.2, 1.5, 2.0, 3.0, 5.0, 10.0, 80.0]
!p.thick=7
!x.thick=7
!y.thick=7
!p.charthick=7
!p.charsize=2.0



IF keyword_set(toggle) THEN BEGIN
	set_plot,'ps'
	device, filename='width_error.ps', /color,/inches,/portrait,/encapsulate,$
	xsize=10,ysize=8;
ENDIF ELSE BEGIN
	window, 0, xs=600, ys=600
ENDELSE

result = greek('phi')
sun = SUNSYMBOL()

plot, angle_err_height[0, *, 0, 0], 1.0 - angle_err_height[1, *, 0, 0]/100.0, xtitle='CME Width ('+result+')',$
ytitle = '(Derived Mass)/(Actual Mass)', xr=[0, 170], yr=[0.5, 1]

loadct,39
FOR i = 1, n_elements(height) - 1 DO BEGIN
	oplot,angle_err_height[0, *, i, 0], 1.0 - angle_err_height[1, *, i, 0]/100.0, linestyle=i, color=i*40
ENDFOR	

xyouts, 0.80, 0.22, '1.2', /normal
xyouts, 0.80, 0.27, '1.5', /normal
xyouts, 0.80, 0.31, '2.0', /normal
xyouts, 0.80, 0.35, '3.0', /normal
xyouts, 0.80, 0.38, '5.0', /normal
xyouts, 0.80, 0.41, '10.0', /normal
xyouts, 0.80, 0.44, '80.0', /normal
set_line_color
xyouts, 0.80, 0.48, 'CME Height (R!L'+sun+'!N)', /normal, charsize=1.5, color=1, charthick=20
xyouts, 0.80, 0.48, 'CME Height (R!L'+sun+'!N)', /normal, charsize=1.5


IF keyword_set(toggle) THEN BEGIN
	device,/close
	set_plot,'x'
ENDIF

END