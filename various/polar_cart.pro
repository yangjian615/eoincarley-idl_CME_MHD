pro polar_cart

r = (dindgen(100)*(1.5-1.0)/99.0) +1.0
n_0 = 1.0e12
n_e = n_0*exp(-1.0*r/0.04)
theta = dindgen(360) + 1.0

plot, r, n_e

rtheta = fltarr(360,100)
FOR i=0, 359 DO BEGIN
	rtheta[i,*] = n_e
ENDFOR	

plot_image, rtheta

polrec, dindgen(100)+1.0, theta*!DTOR, x, y
stop

END