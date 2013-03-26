pro euvi_base_diff

files = findfile('*.fts')
pre = sccreadfits(files[0], he_pre)
DEVICE, RETAIN=2
window, 0, xs=1000, ys=1000
;-------------- Base difference ------------------
loadct,0
FOR i=1, 16 DO BEGIN
	pre = sccreadfits(files[i-1], he_pre)
	data = sccreadfits(files[i], he)
	img = data - pre
	img = (img - mean(img))/stdev(img)
	;img = disk_nrgf(img, he, 0, 0)
	;loadct,8
	;fft_image, img, img_new
	plot_image,sigrange(img) <1.0
	;stop
	;plot_image, smooth(sigrange(img),10) , title =  he.date_obs, charsize=1.5
	x2png, he.date_obs+'.png'
	;stop
ENDFOR



END

