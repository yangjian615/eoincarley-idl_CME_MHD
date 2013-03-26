;-------------------------------------------------------------------------->

pro make_spiral, rfootarr, thetafootarr, footpos_x, footpos_y, $
	foot=infootpoint, earthlon=inearthlon, velocity=inchvelocity, $
	bin=inbin, constants=constants_arr

if n_elements(inbin) lt 1 then bin=.1 else bin=inbin
footpoint=infootpoint
earthlon=inearthlon
chvelocity=inchvelocity

constants_arr=sw_constants()
alpha_b=constants_arr[0]
alpha_rho=constants_arr[1]
alpha_t=constants_arr[2]
au_km=constants_arr[3]
vernal_equinox=constants_arr[4]
nan=constants_arr[5]
r_sun=constants_arr[6]
omegasun=constants_arr[7]
omegaearth=constants_arr[8]

	thetafootarr=footpoint+earthlon+(-findgen(360./float(bin))*float(bin))

	;delta R = R(blob) - delta theta (velocity(blob) / omega_sun)
	rfootarr=abs((thetafootarr-thetafootarr[0])/omegasun*chvelocity)
	thetafootarr=sw_theta_shift(thetafootarr)
	
	;theta = theta(blob) + delta theta
	polrec, rfootarr, thetafootarr, footpos_x, footpos_y, /degrees
end

;-------------------------------------------------------------------------->
