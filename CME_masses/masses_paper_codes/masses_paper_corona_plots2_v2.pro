pro masses_paper_corona_plots2_v2, toggle=toggle

; v2 is cleanup of previous version

cd,'~/Data/secchi_l1/20081212/20081212_cor2a/mass_images'

IF KEYWORD_SET(toggle) THEN BEGIN
	set_plot,'ps'
	!p.font=0
	!p.charsize=1
	device,filename = 'cor2_paper_plot_thesis.ps', /color, /inches, /landscape, /encapsulate,$
	yoffset=13, ysize=8, xsize=13, /helvetica
	loadct,5
ENDIF ELSE BEGIN
	window, 1, xs=1300, ys=800
ENDELSE
;---------------------------------------------;
;				   Color key				  ;
;
;color_key, range = [ -0.1, 2.0 ], ysize=-0.98, barwidth = 0.3, charsize=1.0
;xyouts, 0.987, 0.6, 'Pixel values [x10!U10!N g]', orientation=270.0, /normal
smooth_param=5
npix=1024
npix=1024

;---------------------------------------------;
;				    Image 1
;
background = sccreadfits('mass45_20081212_072220_1B4c2A.fts',he_bkg)
img = sccreadfits('mass45_20081212_085220_1B4c2A.fts',he1)
img = img - background
img = congrid( temporary(img), npix, npix)
time1=anytim(file2time('mass45_20081212_085220_1B4c2A.fts'),/yoh,/trun)

byt0 = -1.0e9
byt1 = 2.0e10

plot_image, smooth(bytscl( img, byt0, byt1), smooth_param), xticks=1, yticks=1, yminor=1,$
ytickname=[' ',' '], xtickname=[' ',' '], position=[0.01, 0.5, 0.31333, 0.98], /normal, /noerase
suncen = get_suncen(he1)
tvcircle, (he1.rsun/he1.cdelt1)/2.0, suncen.xcen/2.0, suncen.ycen/2.0, 254, /data, color=255, thick=1


xyouts,0.015,0.95,'COR2 A',color=0,/normal, charthick=10
xyouts,0.015,0.95,'COR2 A',color=255,/normal, charthick=3
xyouts,0.015,0.52,time1+' UT', color=0,/normal, charthick=10
xyouts,0.015,0.52,time1+' UT', color=255,/normal, charthick=3

;print,'Max '+string(max(sigrange(filter_image(img1,/median))))
;print,'Min '+string(min(sigrange(filter_image(img1,/median))))

img1=0.0
;---------------------------------------------;
;				    Image 2
;
img = sccreadfits('mass45_20081212_122220_1B4c2A.fts',he2)
img = img - background
img = congrid( temporary(img), npix, npix)
time2=anytim(file2time('mass45_20081212_122200_1B4c2A.fts'),/yoh,/trun)


plot_image, smooth(bytscl(img, byt0, byt1), smooth_param), xticks=1,yticks=1,yminor=1,$
ytickname=[' ',' '],xtickname=[' ',' '],position=[0.31333, 0.5, 0.6266, 0.98],/normal,/noerase
suncen = get_suncen(he2)
tvcircle, (he2.rsun/he2.cdelt1)/2.0, suncen.xcen/2.0, suncen.ycen/2.0, 254, /data, color=255, thick=1

xyouts,0.318,0.95,'COR2 A',color=0,/normal, charthick=10
xyouts,0.318,0.95,'COR2 A',color=255,/normal, charthick=3
xyouts,0.318,0.52,time2+' UT', color=0,/normal, charthick=10
xyouts,0.318,0.52,time2+' UT', color=255,/normal, charthick=3


img2=0.0

;---------------------------------------------;
;				    Image 3
;
img = sccreadfits('mass45_20081212_145220_1B4c2A.fts',he3)
img = img - background
img = congrid( temporary(img), npix, npix)
time3=anytim(file2time('mass45_20081212_145220_1B4c2A.fts'),/yoh,/trun)

plot_image, smooth(bytscl(img, byt0, byt1), smooth_param), xticks=1,yticks=1,yminor=1,$
ytickname=[' ',' '],xtickname=[' ',' '],position=[0.6266, 0.5, 0.94, 0.98],/normal,/noerase
suncen = get_suncen(he3)
tvcircle, (he3.rsun/he3.cdelt1)/2.0, suncen.xcen/2.0, suncen.ycen/2.0, 254, /data, color=255, thick=1

xyouts,0.631,0.95,'COR2 A',color=0,/normal, charthick=10
xyouts,0.631,0.95,'COR2 A',color=255,/normal, charthick=3
xyouts,0.631,0.52,time3+' UT', color=0,/normal, charthick=10
xyouts,0.631,0.52,time3+' UT', color=255,/normal, charthick=3

img3=0.0
;------------------------------------------------;
;				  STEREO-B Images
;
cd,'~/Data/secchi_l1/20081212/20081212_cor2b/mass_images'
background = sccreadfits('mass45_20081212_072220_1B4c2B.fts',he_bkg)


;---------------------------------------------;
;				    Image 4
;
img = sccreadfits('mass45_20081212_085220_1B4c2B.fts',he4)
img = img - background
img = congrid( temporary(img), npix, npix)
time4=anytim(file2time('mass45_20081212_085220_1B4c2B.fts'),/yoh,/trun)

plot_image, smooth(bytscl(img, byt0, byt1), smooth_param), xticks=1,yticks=1,yminor=1,$
ytickname=[' ',' '],xtickname=[' ',' '],position=[0.01, 0.01, 0.31333, 0.5],/normal,/noerase

suncen = get_suncen(he4)
tvcircle, (he4.rsun/he4.cdelt1)/2.0, suncen.xcen/2.0, suncen.ycen/2.0, 254, /data, color=255, thick=1
xyouts,0.015,0.46,'COR2 B',color=0,/normal, charthick=10
xyouts,0.015,0.46,'COR2 B',color=255,/normal, charthick=3
xyouts,0.015,0.03,time4+' UT', color=0,/normal, charthick=10
xyouts,0.015,0.03,time4+' UT', color=255,/normal, charthick=3

img4=0.0
;---------------------------------------------;
;				    Image 5
;
img = sccreadfits('mass45_20081212_122220_1B4c2B.fts',he5)
img = img - background
img = congrid( temporary(img), npix, npix)
time5=anytim(file2time('mass45_20081212_122220_1B4c2B.fts'),/yoh,/trun)


plot_image, smooth(bytscl(img, byt0, byt1), smooth_param),xticks=1,yticks=1,yminor=1,$
ytickname=[' ',' '],xtickname=[' ',' '],position=[0.31333, 0.01, 0.6266, 0.5],/normal,/noerase

suncen = get_suncen(he5)
tvcircle, (he4.rsun/he4.cdelt1)/2.0, suncen.xcen/2.0, suncen.ycen/2.0, 254, /data, color=255, thick=1
xyouts,0.318,0.46,'COR2 B',color=0,/normal, charthick=10
xyouts,0.318,0.46,'COR2 B',color=255,/normal, charthick=3
xyouts,0.318,0.03,time5+' UT',color=0,/normal, charthick=10
xyouts,0.318,0.03,time5+' UT',color=255,/normal, charthick=3

;!p.color=255
;a=scc_ROI_SECTOR(he5, 1.0, 11.0 ,310.0, 250.0, /draw)
;a=scc_ROI_SECTOR(he5, 1.0, 7.5 ,298.0, 268.0, /draw)
;!p.color=0

img5=0.0
;---------------------------------------------;
;				    Image 6
;
img = sccreadfits('mass45_20081212_145220_1B4c2B.fts',he6)
img = img - background
img = congrid( temporary(img), npix, npix)
time6=anytim(file2time('mass45_20081212_145220_1B4c2B.fts'),/yoh,/trun)

plot_image,  smooth(bytscl(img, byt0, byt1), smooth_param),xticks=1,yticks=1,yminor=1,/scale,$
ytickname=[' ',' '],xtickname=[' ',' '],position=[0.6266, 0.01, 0.94, 0.5],/normal,/noerase

suncen = get_suncen(he6)
tvcircle, (he4.rsun/he4.cdelt1)/2.0, suncen.xcen/2.0, suncen.ycen/2.0, 254, /data, color=255, thick=1

xyouts,0.631,0.46,'COR2 B',color=0,/normal, charthick=10
xyouts,0.631,0.46,'COR2 B',color=255,/normal, charthick=3
xyouts,0.631,0.03,time6+' UT',color=0,/normal, charthick=10
xyouts,0.631,0.03,time6+' UT',color=255,/normal, charthick=3

;!p.color=255
;a=scc_ROI_SECTOR(he6, 1.0, 15.5, 310., 250., /draw)
;a=scc_ROI_SECTOR(he6, 1.0, 11.5, 298., 268., /draw)


cgCOLORBAR, POSITION=[0.945, 0.01, 0.95, 0.98], /normal, /vertical, /right, $
MAXRANGE =2.0, MINRANGE=-0.1, color=0, charsize=1
set_line_color
xyouts, 0.98, 0.5, 'Pixel values [x10!U10!N g]' , alignment=0.5, orientation=270, /normal, color=0

IF KEYWORD_SET(toggle) THEN BEGIN
	device,/close
	set_plot,'x'
ENDIF

END
