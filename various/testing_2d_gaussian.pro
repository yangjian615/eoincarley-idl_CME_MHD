pro testing_2d_gaussian


cd,'/Users/eoincarley/Data/22sep2011_event/NRH'
restore,'test_on_gauss_2d.sav',/verb

dimen = size(data_section)

x = (dindgen(dimen[1]))
y = (dindgen(dimen[2]))
z = dblarr(n_elements(x), n_elements(y))

FOR i=0,n_elements(x)-1 DO BEGIN
	FOR j=0,n_elements(y)-1 DO BEGIN
		z[i,j] = 0.0 + 0.99*exp( -1.0*( ((x[i]-12.0)/5.0)^2.0 + ((y[j]-12.0)/9.0)^2.0)  /2)
	ENDFOR	
ENDFOR
!p.multi=[0,2,1]
loadct,1
!p.color=0
!p.background=255
shade_surf, z, charsize=4.0, az=20.0, zr=[0,1], title='Guess Parameters'
shade_surf, data_section/max(data_section), charsize=3.0, az=20.0, zr=[0,1],$
title= 'Data'


stop


dimen = size(data_section)
x_coord = dindgen(dimen[1])
y_coord = dindgen(dimen[2])
z = data_section/max(data_section)
err = dblarr(dimen[1], dimen[2])
err[*] = 1e-12;sqrt(z)

;fit = 'p[0] + p[1]*exp( -1.0*( (x/p[2])^2.0 + (y/p[3])^2.0 ) /2.0)'
p0 = [0.0D, 1.0D, 12.0D, 12.0D, 12.0D, 12.0D]
p = MPFIT2DFUN('fit', x_coord[*], y_coord[*], z[*], err, p0)



FOR i=0,n_elements(x)-1 DO BEGIN
	FOR j=0,n_elements(y)-1 DO BEGIN
		z[i,j] = p[0] + p[1]*exp( -1.0*( ( (x[i]-p[2])/p[3])^2.0 + ( (y[j]-p[4]) /p[5])^2.0)  /2)
	ENDFOR	
ENDFOR
shade_surf, z, charsize=3,zr=[0,1], title='2D Fit'
shade_surf, data_section/max(data_section), charsize=3.0, title='Data'
stop
END

function fit, x, y, p

result = p[0] + p[1]*exp( -1.0*( ( (x-p[2]) /p[3])^2.0 + ( (y-p[4])/ p[5])^2.0 ) /2.0)

return,result

END