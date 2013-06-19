pro width_error

; This produces the mass angular width error for a number of heights
; The results are plotted up using plot_width_error.pro. Eoin Carley Apr 2013


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


END