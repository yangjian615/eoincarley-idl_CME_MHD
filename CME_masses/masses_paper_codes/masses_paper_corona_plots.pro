pro masses_paper_corona_plots

cd,'/Users/eoincarley/Data/secchi_l1/20081212/20081212_cor1/20081212_cor1a_B/mass_images'


;========image1==========
background = sccreadfits('mass45_20081212_040500_1B4c1A.fts',he_bkg)

img1 = sccreadfits('mass45_20081212_064500_1B4c1A.fts',he1)
img1 = img1 - background


;neg = where(img1 le 0.0)
;img1[neg] = 0.0
time1=anytim(file2time('mass45_20081212_064500_1B4c1A.fts'),/yoh,/trun)
;img1 = scc_add_datetime(img1,he1)
set_plot,'ps'
device,filename = 'cor1_paper_plot.ps',/color,/inches,/landscape,/encapsulate,$
yoffset=13,ysize=8,xsize=13

loadct,0

color_key, range = [ -0.3, 1.0 ],ysize=-0.98,barwidth = 0.2,$
charsize=1.0
xyouts,0.987,0.6,'Pixel values [x10!U11!N g]',orientation=270.0,/normal


;plot_image,sigrange(filter_image(img1,/median)),xticks=1,yticks=1,yminor=1,$
byt0=-3.0e10
byt1=1.0e11
plot_image,bytscl(img1,byt0,byt1),xticks=1,yticks=1,yminor=1,$
ytickname=[' ',' '],xtickname=[' ',' '],position=[0.01, 0.5, 0.31333, 0.98],/normal,/noerase
suncen = get_suncen(he1)
tvcircle, (he1.rsun/he1.cdelt1), suncen.xcen, suncen.ycen, 254, /data,color=255,thick=1
xyouts,0.015,0.95,'COR1 A',color=0,/normal,charsize=1.5,charthick=10
xyouts,0.015,0.95,'COR1 A',color=255,/normal,charsize=1.5,charthick=3
xyouts,0.015,0.52,time1,color=0,/normal,charsize=1.5,charthick=10
xyouts,0.015,0.52,time1,color=255,/normal,charsize=1.5,charthick=3

;========image2==========
background = sccreadfits('mass45_20081212_040500_1B4c1A.fts',he_bkg)

img2 = sccreadfits('mass45_20081212_073500_1B4c1A.fts',he2)
img2 = img2 - background
;neg = where(img2 le 0.0)
;img2[neg] = 0.0
time2=anytim(file2time('mass45_20081212_073500_1B4c1A.fts'),/yoh,/trun)

plot_image,bytscl(img2,byt0,byt1),xticks=1,yticks=1,yminor=1,$
ytickname=[' ',' '],xtickname=[' ',' '],position=[0.31333, 0.5, 0.6266, 0.98],/normal,/noerase
suncen = get_suncen(he2)
tvcircle, (he2.rsun/he2.cdelt1), suncen.xcen, suncen.ycen, 254, /data,color=255,thick=1
xyouts,0.318,0.95,'COR1 A',color=0,/normal,charsize=1.5,charthick=10
xyouts,0.318,0.95,'COR1 A',color=255,/normal,charsize=1.5,charthick=3
xyouts,0.318,0.52,time2,color=0,/normal,charsize=1.5,charthick=10
xyouts,0.318,0.52,time2,color=255,/normal,charsize=1.5,charthick=3

;========image3==========
background = sccreadfits('mass45_20081212_040500_1B4c1A.fts',he_bkg)

img3 = sccreadfits('mass45_20081212_091500_1B4c1A.fts',he3)
img3 = img3 - background
;neg = where(img3 le 0.0)
;img3[neg] = 0.0
time3=anytim(file2time('mass45_20081212_091500_1B4c1A.fts'),/yoh,/trun)

plot_image,bytscl(img3,byt0,byt1),xticks=1,yticks=1,yminor=1,$
ytickname=[' ',' '],xtickname=[' ',' '],position=[0.6266, 0.5, 0.94, 0.98],/normal,/noerase
suncen = get_suncen(he3)
tvcircle, (he3.rsun/he3.cdelt1), suncen.xcen, suncen.ycen, 254, /data,color=255,thick=2
xyouts,0.631,0.95,'COR1 A',color=0,/normal,charsize=1.5,charthick=10
xyouts,0.631,0.95,'COR1 A',color=255,/normal,charsize=1.5,charthick=3
xyouts,0.631,0.52,time3,color=0,/normal,charsize=1.5,charthick=10
xyouts,0.631,0.52,time3,color=255,/normal,charsize=1.5,charthick=3

;min_pix = min(img3)
;max_pix = max(img3)
;color_key, range = [ min_pix/1.0e12, max_pix/1.0e12 ], barwidth = 0.19, title = 'Pixel values [x10!U12!N g]'


;=========image4=========
cd,'/Users/eoincarley/Data/secchi_l1/20081212/20081212_cor1/20081212_cor1b_B/mass_images'
background = sccreadfits('mass45_20081212_040500_1B4c1B.fts',he_bkg)

img4 = sccreadfits('mass45_20081212_064500_1B4c1B.fts',he4)
img4 = img4 - background
;neg = where(img4 le 0.0)
;img4[neg] = 0.0
time4=anytim(file2time('mass45_20081212_064500_1B4c1B.fts'),/yoh,/trun)
;img1 = scc_add_datetime(img1,he1)


plot_image,bytscl(img4,byt0,byt1),xticks=1,yticks=1,yminor=1,$
ytickname=[' ',' '],xtickname=[' ',' '],position=[0.01, 0.01, 0.31333, 0.5],/normal,/noerase
suncen = get_suncen(he4)
tvcircle, (he4.rsun/he4.cdelt1), suncen.xcen, suncen.ycen, 254, /data,color=255,thick=1
xyouts,0.015,0.46,'COR1 B',color=0,/normal,charsize=1.5,charthick=10
xyouts,0.015,0.46,'COR1 B',color=255,/normal,charsize=1.5,charthick=3
xyouts,0.015,0.02,time4,color=0,/normal,charsize=1.5,charthick=10
xyouts,0.015,0.02,time4,color=255,/normal,charsize=1.5,charthick=3

;=========image5=============
img5 = sccreadfits('mass45_20081212_073500_1B4c1B.fts',he5)
img5 = img5 - background
;neg = where(img5 le 0.0)
;img5[neg] = 0.0
time5=anytim(file2time('mass45_20081212_073500_1B4c1B.fts'),/yoh,/trun)
;img1 = scc_add_datetime(img1,he1)


plot_image,bytscl(img5,byt0,byt1),xticks=1,yticks=1,yminor=1,$
ytickname=[' ',' '],xtickname=[' ',' '],position=[0.31333, 0.01, 0.6266, 0.5],/normal,/noerase
suncen = get_suncen(he5)
tvcircle, (he5.rsun/he5.cdelt1), suncen.xcen, suncen.ycen, 254, /data,color=255,thick=1
xyouts,0.318,0.46,'COR1 B',color=0,/normal,charsize=1.5,charthick=10
xyouts,0.318,0.46,'COR1 B',color=255,/normal,charsize=1.5,charthick=3
xyouts,0.318,0.02,time5,color=0,/normal,charsize=1.5,charthick=10
xyouts,0.318,0.02,time5,color=255,/normal,charsize=1.5,charthick=3

;=========image6=============
img6 = sccreadfits('mass45_20081212_091500_1B4c1B.fts',he6)
img6 = img6 - background
;neg = where(img6 le 0.0)
;img6[neg] = 0.0
time6=anytim(file2time('mass45_20081212_091500_1B4c1B.fts'),/yoh,/trun)
;img1 = scc_add_datetime(img1,he1)


plot_image,bytscl(img6,byt0,byt1),xticks=1,yticks=1,yminor=1,/scale,$
ytickname=[' ',' '],xtickname=[' ',' '],position=[0.6266, 0.01, 0.94, 0.5],/normal,/noerase
suncen = get_suncen(he6)
tvcircle, (he6.rsun/he6.cdelt1), suncen.xcen, suncen.ycen, 254, /data,color=255,thick=1
;min_pix = min(img6)
;max_pix = max(img6)
;color_key, range = [ min_pix/1.0e11, max_pix/1.0e11 ], barwidth = 0.19, title = 'Pixel values [x10!U11!N g]'
              ;labels = [ '0', '5', '10', '15', '20', '25', '30', ' ' ]
;tvcircle, (he1.rsun/he1.cdelt1), suncen[0], suncen[1], 254, /data,color=255,thick=2
xyouts,0.631,0.46,'COR1 B',color=0,/normal,charsize=1.5,charthick=10
xyouts,0.631,0.46,'COR1 B',color=255,/normal,charsize=1.5,charthick=3
xyouts,0.631,0.02,time6,color=0,/normal,charsize=1.5,charthick=10
xyouts,0.631,0.02,time6,color=255,/normal,charsize=1.5,charthick=3

device,/close
set_plot,'x'

END
