pro find_height_uncertainty
; Work for the 22-Sep-2011
; In response to Ref1 comment2 I need to find an uncertainty for delta R
; See method in red notebook.

; Firstly just do it for no error in the density values themselves i.e.
; just get uncertainty in the position angle range due to density variation
; in the corona
find_max_min_heights, 0.0, av_height
stop
; No subtract the uncertainty in density measurement itself
find_max_min_heights, -0.1, av_height

; No add the uncertainty in density measurement itself
find_max_min_heights, 0.1, av_height

;Produce a plot of error in height as a function of error in density measurement
maxh_array = dblarr(50)
minh_array = dblarr(50)
FOR j=0.0, 49.0 DO BEGIN
	find_max_min_heights, j/100.0, av_height_pos
	find_max_min_heights, -1.0*(j/100.0), av_height_neg
	maxh_array[j] = av_height_pos
	minh_array[j] = av_height_neg
ENDFOR

err = (maxh_array - minh_array)
window,4
plot, dindgen(50), maxh_array, xtitle='Density measurement uncertainty (%)',$
yr=[1,1.5], ytitle='Max R, Min R'

oplot, dindgen(50), minh_array, linestyle=1

STOP

END

;---------------------------------------------------------------------------;
;	PROCEDURE TO FIND THE ERROR DUE TO DENSITY VARIATIONS IN THE CORONA		


pro find_max_min_heights, error, av_height


loadct,1
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


;---------------------------------------------------;
;	Get line profiles between two angles degrees lat
;---------------------------------------------------;
window,1
plot_image, alog10(CAR_DEN_ALL.data)
xcen = 300.0
ycen = 300.0
rhos = dindgen(250)



start_angle= 190.0
stop_angle = 225.0
n_profiles = stop_angle - start_angle
prof_array = dblarr(n_profiles, 250)

FOR i=start_angle, stop_angle-1 DO BEGIN
	angle = i*!DTOR 

	xline = (COS(angle) * rhos + xcen)*1.0 ;working in pixel units ;hdr.cdelt1
	yline = (SIN(angle) * rhos + ycen)*1.0 ;working in pixel units ;hdr.cdelt1
	plots, xline, yline, color=255, thick=1
	line_profile = interpolate(car_den_all.data, xline, yline)
	prof_array[i - start_angle, *] = line_profile
ENDFOR
freq = 75e6
n = freq2dens(freq)

window,3
plot_image, alog10(prof_array)


;Remove the nans from the array
remove_nans, prof_array, junk, junk, nan_pos
prof_array[nan_pos[*]] = 0.0

;Add in the error on the density values themselves
prof_array = prof_array + error*prof_array


;---------------------------------------------;
;	Step through each column and find where is closest to n,
; 	Convert this to a height, then store
;---------------------------------------------;
height  = dblarr(n_profiles)
set_line_color
n_el = dindgen(n_elements(prof_array[0,*]))



FOR i=0, n_profiles-1 DO BEGIN
	noz = where(prof_array[i,*] gt 0.0)
	index = interpol(n_el[noz], prof_array[i,noz], n, /lsquad)
	plots, i, index, psym=1, color=3
	height_as = index*CAR_DEN_ALL.dx
	height[i] = height_as/rsun_arcsec
ENDFOR


index = where(height gt 1.0 and height lt 4.0)
height = height[index]

print,'--------------------------'
print,''
print, 'Average height: '+ string(mean(height)) 
print, 'Max: '+string(max(height)) 
print, 'Min: '+string(min(height))

av_height = mean(height)
delta_r = max(height) - min(height)
print, 'Range of heights: '+string(delta_r)
print,''
print,'--------------------------'


;---------------------------------------------;
;	May need to add to this given that there is
;	an error in the density measurements themselves
;	Pietro currently estimates this at ~10%. To estimate its effect. Subtract 10% of the 
;	density away and see where max/min distance is. Then add 10% and see where the max/min 
; 	position is
;
;---------------------------------------------;
END