pro masses_paper_corona_plots_v2, toggle  = toggle


;v2 is a clean up

cd,'~/Data/secchi_l1/20081212/20081212_cor1/20081212_cor1a_B/mass_images'

IF KEYWORD_SET(toggle) THEN BEGIN
	set_plot,'ps'
	!p.font=0
	!p.charsize=1
	device,filename = 'cor1_paper_plot_thesis.ps', /color, /inches, /landscape, /encapsulate,$
	yoffset=13, ysize=8, xsize=13, /helvetica
ENDIF ELSE BEGIN
	window, 1, xs=1300, ys=800
ENDELSE
loadct,5


byt0 = -0.5e10
byt1 = 5.0e10
;---------------------------------------------;
;				    Image 1
;
background = sccreadfits('mass45_20081212_040500_1B4c1A.fts',he_bkg)
img = sccreadfits('mass45_20081212_064500_1B4c1A.fts',he1)
img = img - background
time1=anytim(file2time('mass45_20081212_064500_1B4c1A.fts'),/yoh,/trun)



plot_image, smooth(bytscl(img, byt0, byt1),5), xticks=1,yticks=1,yminor=1,$
ytickname=[' ',' '],xtickname=[' ',' '],position=[0.01, 0.5, 0.31333, 0.98],/normal,/noerase
suncen = get_suncen(he1)

tvcircle, (he1.rsun/he1.cdelt1), suncen.xcen, suncen.ycen, 254, /data,color=255,thick=1
xyouts,0.015,0.95,'COR1 A',color=0,/normal, charthick=10
xyouts,0.015,0.95,'COR1 A',color=255,/normal, charthick=3
xyouts,0.015,0.52,time1 +' UT', color=0,/normal, charthick=10
xyouts,0.015,0.52,time1 +' UT',color=255,/normal, charthick=3

;---------------------------------------------;
;				    Image 2
;
background = sccreadfits('mass45_20081212_040500_1B4c1A.fts',he_bkg)
img = sccreadfits('mass45_20081212_073500_1B4c1A.fts',he2)
img = img - background
time2=anytim(file2time('mass45_20081212_073500_1B4c1A.fts'),/yoh,/trun)

plot_image, smooth(bytscl(img, byt0, byt1),5), xticks=1,yticks=1,yminor=1,$
ytickname=[' ',' '],xtickname=[' ',' '],position=[0.31333, 0.5, 0.6266, 0.98],/normal,/noerase

suncen = get_suncen(he2)
tvcircle, (he2.rsun/he2.cdelt1), suncen.xcen, suncen.ycen, 254, /data,color=255,thick=1
xyouts,0.318,0.95,'COR1 A',color=0,/normal, charthick=10
xyouts,0.318,0.95,'COR1 A',color=255,/normal, charthick=3
xyouts,0.318,0.52,time2 +' UT',color=0,/normal, charthick=10
xyouts,0.318,0.52,time2 +' UT',color=255,/normal, charthick=3

;---------------------------------------------;
;				    Image 3
;
background = sccreadfits('mass45_20081212_040500_1B4c1A.fts',he_bkg)
img = sccreadfits('mass45_20081212_091500_1B4c1A.fts',he3)
img = img - background
time3=anytim(file2time('mass45_20081212_091500_1B4c1A.fts'),/yoh,/trun)

plot_image, smooth(bytscl(img, byt0, byt1),5), xticks=1,yticks=1,yminor=1,$
ytickname=[' ',' '],xtickname=[' ',' '],position=[0.6266, 0.5, 0.94, 0.98],/normal,/noerase

suncen = get_suncen(he3)
tvcircle, (he3.rsun/he3.cdelt1), suncen.xcen, suncen.ycen, 254, /data,color=255,thick=2
xyouts,0.631,0.95,'COR1 A',color=0,/normal, charthick=10
xyouts,0.631,0.95,'COR1 A',color=255,/normal, charthick=3
xyouts,0.631,0.52,time3 +' UT',color=0,/normal, charthick=10
xyouts,0.631,0.52,time3 +' UT',color=255,/normal, charthick=3



;---------------------------------------------;
;				    STEREO B
;
;---------------------------------------------;
;				    Image 4
;
cd,'~/Data/secchi_l1/20081212/20081212_cor1/20081212_cor1b_B/mass_images'
background = sccreadfits('mass45_20081212_040500_1B4c1B.fts',he_bkg)

img = sccreadfits('mass45_20081212_064500_1B4c1B.fts',he4)
img = img - background
time4=anytim(file2time('mass45_20081212_064500_1B4c1B.fts'),/yoh,/trun)


plot_image, smooth(bytscl(img, byt0, byt1),5), xticks=1,yticks=1,yminor=1,$
ytickname=[' ',' '],xtickname=[' ',' '],position=[0.01, 0.01, 0.31333, 0.5],/normal,/noerase

suncen = get_suncen(he4)
tvcircle, (he4.rsun/he4.cdelt1), suncen.xcen, suncen.ycen, 254, /data,color=255,thick=1
xyouts,0.015,0.46,'COR1 B',color=0,/normal, charthick=10
xyouts,0.015,0.46,'COR1 B',color=255,/normal, charthick=3
xyouts,0.015,0.02,time4 +' UT',color=0,/normal, charthick=10
xyouts,0.015,0.02,time4 +' UT',color=255,/normal, charthick=3

;---------------------------------------------;
;				    Image 5
;
img = sccreadfits('mass45_20081212_073500_1B4c1B.fts',he5)
img = img - background

time5=anytim(file2time('mass45_20081212_073500_1B4c1B.fts'),/yoh,/trun)

plot_image, smooth(bytscl(img, byt0, byt1),5), xticks=1,yticks=1,yminor=1,$
ytickname=[' ',' '],xtickname=[' ',' '],position=[0.31333, 0.01, 0.6266, 0.5],/normal,/noerase
suncen = get_suncen(he5)
tvcircle, (he5.rsun/he5.cdelt1), suncen.xcen, suncen.ycen, 254, /data,color=255,thick=1
xyouts,0.318,0.46,'COR1 B',color=0,/normal, charthick=10
xyouts,0.318,0.46,'COR1 B',color=255,/normal, charthick=3
xyouts,0.318,0.02,time5 +' UT',color=0,/normal, charthick=10
xyouts,0.318,0.02,time5 +' UT',color=255,/normal, charthick=3

;---------------------------------------------;
;				    Image 5
;
img = sccreadfits('mass45_20081212_091500_1B4c1B.fts',he6)
img = img - background
time6=anytim(file2time('mass45_20081212_091500_1B4c1B.fts'),/yoh,/trun)

plot_image, smooth(bytscl(img, byt0, byt1),5), xticks=1,yticks=1,yminor=1,$
ytickname=[' ',' '],xtickname=[' ',' '],position=[0.6266, 0.01, 0.94, 0.5],/normal,/noerase
suncen = get_suncen(he6)
tvcircle, (he6.rsun/he6.cdelt1), suncen.xcen, suncen.ycen, 254, /data,color=255,thick=1

xyouts,0.631,0.46,'COR1 B',color=0,/normal, charthick=10
xyouts,0.631,0.46,'COR1 B',color=255,/normal, charthick=3
xyouts,0.631,0.02,time6 +' UT',color=0,/normal, charthick=10
xyouts,0.631,0.02,time6 +' UT',color=255,/normal, charthick=3


cgCOLORBAR, POSITION=[0.945, 0.01, 0.95, 0.98], /normal, /vertical, /right, $
MAXRANGE =5.0, MINRANGE=-0.5, color=0, charsize=1
set_line_color
xyouts, 0.98, 0.5, 'Pixel values [x10!U10!N g]' , alignment=0.5, orientation=270, /normal, color=0

IF KEYWORD_SET(toggle) THEN BEGIN
	device,/close
	set_plot,'x'
ENDIF

END
