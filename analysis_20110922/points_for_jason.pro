pro points_for_jason

; Point and click on the CME front and shock for the 22-Sep-2011 event, to be passed onto Jason.
; Written 10-June-2013

; set up a window
device, retain = 2
loadct,3
window, 0 , xs=700, ys=700


cd,'~/Data/22sep2011_event/LASCO_C3/L0.5/L1'

;c2times = get_fits_times('~/Data/22sep2011_event/LASCO_C2/L0.5/L1')
;c3times = get_fits_times('~/Data/22sep2011_event/LASCO_C3/L0.5/L1')

files = findfile('*.fts')
pre = lasco_readfits(files[0], he_pre)
mask = lasco_get_mask(he_pre)
pre = pre*mask

front_xy = dblarr(2,10, 3)
times = dblarr(3)
FOR i=3, 10 DO BEGIN
	loadct,3
	img = lasco_readfits(files[i], he)
	img = temporary(img)*mask
	img = temporary(img) - pre
	img = img/stdev(img)
	
 	;THIS PLOT SHOWS CORONAL RECOIL ON THE OPPOSITE SIDE OF SUN QUITE WELL
	plot_image, filter_image(alog(img) > (-7.0), /median), $
	title=he.date_obs, charsize=2
	;suncen = get_suncen(he)
	;tvcircle, (he.rsun/he.cdelt1), suncen.xcen, suncen.ycen, 254, /data, color=255,thick=2
	
	point, shock_x, shock_y, newlabel = ' ', /nocross
	time = [he.date_obs]
	set_line_color
	plots, shock_x, shock_y, /data, psym=1, color=5
	save, shock_x, shock_y, time, filename='c3_shock_'+time2file(he.date_obs)+'.sav'
	x2png,'c3shock_'+he.date_obs+'.png'
	stop
ENDFOR


END


