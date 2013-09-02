pro tcd_crest

cd,'/Users/eoincarley/Data/22sep2011_event'

set_plot,'ps'
device, filename='test_tcd_crest.ps', /color, /inches, /landscape, /encapsulate,$
xs=14, ys=7, yoffset=14

file = 'TCD-logo-wide.jpg'
queryStatus = QUERY_IMAGE(file, imageInfo)
tcd_crest = READ_IMAGE(file)
x = 500
y = x/6.8
tcd_crest_small = fltarr(3, x, y)

tcd_crest1 = transpose(transpose(tcd_crest[0,*,*]))
tcd_crest2 = transpose(transpose(tcd_crest[1,*,*]))
tcd_crest3 = transpose(transpose(tcd_crest[2,*,*]))

tcd_crest_small[0,*,*] = congrid(tcd_crest1, x, y)
tcd_crest_small[1,*,*] = congrid(tcd_crest2, x, y)
tcd_crest_small[2,*,*] = congrid(tcd_crest3, x, y)



;DEVICE, DECOMPOSED = 0, color=1
loadct,0
TV, tcd_crest_small, 0.15, 0.15, xsize=2.5, ysize=2.5/6.81592, true=1, /inches
	


device,/close
set_plot,'x'
stop

END