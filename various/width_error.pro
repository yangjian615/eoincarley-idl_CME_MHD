pro width_error

angles = dindgen(160) 

height = [1.2, 1.5, 2.0, 3.0, 5.0, 10.0, 80.0]
angle_err_height = dblarr(3,n_elements(angles), n_elements(height))

FOR j =0, n_elements(height)-1 DO BEGIN
	FOR i = 0, n_elements(angles)-1 DO BEGIN
		angle = angles(i)
		err = masses_width_error3(height[j], angle)
		angle_err_height[0, i, j] = angle
		angle_err_height[1, i, j] = err
		angle_err_height[2, i, j] = height[j]
	ENDFOR
ENDFOR	

save, angle_err_height, filename='angle_err_height.sav'
print, angle_err_height

;window,0
;plot, angle_err_height[0, *, 0, 0]/2.0, 1.0 - angle_err_height[1, *, 0, 0]/2.0, xtitle='CME half_angle',$
;ytitle = 'Mass underestimation'

;FOR i = 1, n_elements(height) - 1 DO BEGIN
;	oplot,angle_err_height[0, *, i, 0]/2.0, 1.0 - angle_err_height[1, *, i, 0]/2.0, linestyle=i
;ENDFOR	

END