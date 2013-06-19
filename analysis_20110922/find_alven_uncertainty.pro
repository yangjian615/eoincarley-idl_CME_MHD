pro find_alven_uncertainty

; In estimating the Alfven speed at the height of the source for 22-Sep-2011 event,
; I need an estimate of the uncertainty on the density and magnetic fiels at this 
; height.
; 12-June-2012

;--------------------------------------;
;		Get the density uncertainty	   ;
;--------------------------------------;

;Firstly, at the height of the source, find_height_ucnerainty.pro found an error
;of 10.5% (see red notebook). Get density variation due to this.

;---------------------------------------------;
;				Read the data
;---------------------------------------------;
cd,'~/Data/22sep2011_event/density_mag'
restore,'cartesian_density_map_22_sep.sav', /verb
files_c2 = findfile('*.fts')
c2data = lasco_readfits(files_c2[0], hdr)
rsun_arcsec = get_solar_radius(hdr)


;---------------------------------------------;
;				Plot the data
;---------------------------------------------;
window,0
plot_image, alog10(CAR_DEN_ALL.data)
xcen = 300.0
ycen = 300.0

rhos = dindgen(250.0)
angle = 200.0*!DTOR 

xline = (COS(angle) * rhos + xcen)*1.0 ;working in pixel units ;hdr.cdelt1
yline = (SIN(angle) * rhos + ycen)*1.0 ;working in pixel units ;hdr.cdelt1
plots, xline, yline, color=255, thick=1
line_profile = interpolate(car_den_all.data, xline, yline)

height_as = rhos*CAR_DEN_ALL.dx
heights = height_as/rsun_arcsec

window,1
plot, heights, line_profile, /ylog, xtitle='Heliocentric distance (Rsun)', ytitle='Density (cm!U-3!N)'

;---------------------------------------------;
;     Get density at 1.29 +/- 0.14 Rsun
;---------------------------------------------;
den = interpol(line_profile, heights, 1.27)
den1 = interpol(line_profile, heights, 1.33)
den2 = interpol(line_profile, heights, 1.18);1.27 - 0.05)


print, 100.0*abs(den1 - den2)/den


stop
END