pro create_movie

; Create movie from pB images

; 2013-Apr-03 
loadct,5
files = findfile('*.fts')
pre = sccreadfits(files[0], pre_hdr)
mask = get_smask(pre_hdr)
FOR i = 1, n_elements(files)-1 DO BEGIN
	obj = sccreadfits(files[i], hdr)
	obj = obj - pre
	obj = obj/mean(obj)
	img = obj*mask
	plot_image, sigrange(img), title=hdr.date_obs
ENDFOR




END