pro halpha_imgs_20110922

files = findfile('*.fts')

pre_event = readfits(files[0],he)
pre_event = pre_event/median(pre_event)
he = fitshead2struct(he)

loadct,3
Device, RETAIN=2
window,0,xs=1000,ys=1000

FOR i = 300, n_elements(files)-1 DO BEGIN
	pre_event = readfits(files[i-10],he_pre)
	pre_event = pre_event/median(pre_event)



	data = readfits(files[i],he)
	he = fitshead2struct(he)
	print,'File time: '+string(he.date_obs)
	
	img = data/mean(data) 
	
	;Result = CORREL_IMAGES( img, pre_event)
	;shifts = array_indices(result, where(result eq max(result)))
	img = img - pre_event
	img = (img -mean(img))/stdev(img)
	
	
	
	plot_image, sigrange(img[0:500,300:1500]), title='Kanzelhoehe H-alpha '+he.date_obs,charsize=1.5

	;cd,'pngs/run_diff/zoom'
	;x2png,'rd_zoom_h-alpha_'+he.date_obs
	;cd,'../../..'

ENDFOR	


stop
END