pro mag_from_pfss_map

; Get the magnetic field at a particular position

; Use the height of 75 MHz derived in height_from_ensity_map.pro (1.29 Rsun at 15 degrees
; below the east equator)
loadct,5
restore,'cartesian_bfield_corrected.sav',/verb
CAR_BFIELD_ALL = CAR_BFIELD_CORRECTED
;-------------------------------;
;			Plot Map 			;
;-------------------------------;
window,0
plot_map, CAR_BFIELD_ALL, /log, fov = [-60, 60, -60, 60]

;-------------------------------;
;		Plot just data 			;
;-------------------------------;
xcen = 300
ycen = 300
plot_image, alog10(CAR_BFIELD_ALL.data)

Barr = dblarr(226-190)
FOR i=190, 225 DO BEGIN

	angle=i*!DTOR
	rhos = dindgen(280)
	xloc = COS(angle)*rhos + xcen
	yloc = SIN(angle)*rhos + ycen
	rhos_arcsec = rhos*CAR_BFIELD_ALL.dx
	rsun_arcsec = 965.80252
	rsun = rhos_arcsec/rsun_arcsec
	plots, xloc, yloc
	b_profile = interpolate(CAR_BFIELD_ALL.data, xloc, yloc)

	window,1
	plot, rsun, b_profile, /ylog
	r = 1.18;1.28 ;Choose height
	B = interpol(b_profile, rsun, r)
	n = freq2dens(75e6)
	va = B/sqrt(4.0*!PI*n*!p_mass*1000.0*0.6)
	Barr[i-190] = B
	print,''
	print,'---------------------------------------'
	print, 'Magnetic field at '+string(r)+' '+string(B)+' G'
	;print, 'Aflven speed at '+string(r)+' '+string(va/1.0e5)+' km/s'
	print,'---------------------------------------'
	print,''

ENDFOR

print, 'Mean B field along radio blob trajectory: '+string(mean(Barr))
print, 'Error on the mean: '+string(stdev(Barr)/sqrt(n_elements(Barr)))

stop
;		 As a check, plot up the alfven map and get the speed 			;

restore,'cartesian_alfven_22_sep.sav',/verb
window,3
plot_image, alog10(CAR_ALFVEN_ALL.data)
plots, xloc, yloc
alf_profile = interpolate(CAR_ALFVEN_ALL.data, xloc, yloc)
window,4
plot, rsun, alf_profile, /ylog
r = 1.29
alf = interpol(alf_profile, rsun, r)


print,'Alfven speed map (km/s):'
print, alf

END