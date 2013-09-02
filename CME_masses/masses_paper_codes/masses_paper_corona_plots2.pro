pro masses_paper_corona_plots2_v2

; v2 is cleanup of previous version

cd,'~/Data/secchi_l1/20081212/20081212_cor2a/mass_images'
set_plot,'ps'
device,filename = 'cor2_paper_plot_test_lower_bits.ps', /color, /inches, /landscape, /encapsulate,$
yoffset=13, ysize=8, xsize=13, BITS_PER_PIXEL=8
loadct,5

;---------------------------------------------;
;				   Color key				  ;
;
color_key, range = [ -0.5, 3.0 ],ysize=-0.98,barwidth = 0.19,$
charsize=1.0
xyouts,0.987,0.6,'Pixel values [x10!U10!N g]',orientation=270.0,/normal

;---------------------------------------------;
;				    Image 1
;
background = sccreadfits('mass45_20081212_072220_1B4c2A.fts',he_bkg)
img1 = sccreadfits('mass45_20081212_085220_1B4c2A.fts',he1)
img1 = img1 - background
time1=anytim(file2time('mass45_20081212_085220_1B4c2A.fts'),/yoh,/trun)


byt0=-5.0e9
byt1=3.0e10
plot_image,bytscl( img1, byt0, byt1), xticks=1, yticks=1, yminor=1,$
ytickname=[' ',' '], xtickname=[' ',' '], position=[0.01, 0.5, 0.31333, 0.98], /normal, /noerase
suncen = get_suncen(he1)
tvcircle, (he1.rsun/he1.cdelt1), suncen.xcen, suncen.ycen, 254, /data,color=255,thick=1

xyouts,0.015,0.95,'COR2 A',color=0,/normal,charsize=1.5,charthick=10
xyouts,0.015,0.95,'COR2 A',color=255,/normal,charsize=1.5,charthick=3
xyouts,0.015,0.52,time1,color=0,/normal,charsize=1.5,charthick=10
xyouts,0.015,0.52,time1,color=255,/normal,charsize=1.5,charthick=3

print,'Max '+string(max(sigrange(filter_image(img1,/median))))
print,'Min '+string(min(sigrange(filter_image(img1,/median))))


;---------------------------------------------;
;				    Image 2
;
img2 = sccreadfits('mass45_20081212_122220_1B4c2A.fts',he2)
img2 = img2 - background
time2=anytim(file2time('mass45_20081212_122200_1B4c2A.fts'),/yoh,/trun)


plot_image,bytscl(img2,byt0,byt1),xticks=1,yticks=1,yminor=1,$
ytickname=[' ',' '],xtickname=[' ',' '],position=[0.31333, 0.5, 0.6266, 0.98],/normal,/noerase
suncen = get_suncen(he2)
tvcircle, (he2.rsun/he2.cdelt1), suncen.xcen, suncen.ycen, 254, /data,color=255,thick=1

xyouts,0.318,0.95,'COR2 A',color=0,/normal,charsize=1.5,charthick=10
xyouts,0.318,0.95,'COR2 A',color=255,/normal,charsize=1.5,charthick=3
xyouts,0.318,0.52,time2,color=0,/normal,charsize=1.5,charthick=10
xyouts,0.318,0.52,time2,color=255,/normal,charsize=1.5,charthick=3

;---------------------------------------------;
;				    Image 3
;
img3 = sccreadfits('mass45_20081212_145220_1B4c2A.fts',he3)
img3 = img3 - background
time3=anytim(file2time('mass45_20081212_145220_1B4c2A.fts'),/yoh,/trun)

plot_image,bytscl(img3,byt0,byt1),xticks=1,yticks=1,yminor=1,$
ytickname=[' ',' '],xtickname=[' ',' '],position=[0.6266, 0.5, 0.94, 0.98],/normal,/noerase
suncen = get_suncen(he3)
tvcircle, (he3.rsun/he3.cdelt1), suncen.xcen, suncen.ycen, 254, /data,color=255,thick=2

xyouts,0.631,0.95,'COR2 A',color=0,/normal,charsize=1.5,charthick=10
xyouts,0.631,0.95,'COR2 A',color=255,/normal,charsize=1.5,charthick=3
xyouts,0.631,0.52,time3,color=0,/normal,charsize=1.5,charthick=10
xyouts,0.631,0.52,time3,color=255,/normal,charsize=1.5,charthick=3


;------------------------------------------------;
;				  STEREO-B Images
;
cd,'~/Data/secchi_l1/20081212/20081212_cor2b/mass_images'
background = sccreadfits('mass45_20081212_072220_1B4c2B.fts',he_bkg)


;---------------------------------------------;
;				    Image 4
;
img4 = sccreadfits('mass45_20081212_085220_1B4c2B.fts',he4)
img4 = img4 - background
time4=anytim(file2time('mass45_20081212_085220_1B4c2B.fts'),/yoh,/trun)

plot_image,bytscl(img4,byt0,byt1),xticks=1,yticks=1,yminor=1,$
ytickname=[' ',' '],xtickname=[' ',' '],position=[0.01, 0.01, 0.31333, 0.5],/normal,/noerase

suncen = get_suncen(he4)
tvcircle, (he4.rsun/he4.cdelt1), suncen.xcen, suncen.ycen, 254, /data,color=255,thick=1
xyouts,0.015,0.46,'COR2 B',color=0,/normal,charsize=1.5,charthick=10
xyouts,0.015,0.46,'COR2 B',color=255,/normal,charsize=1.5,charthick=3
xyouts,0.015,0.03,time4,color=0,/normal,charsize=1.5,charthick=10
xyouts,0.015,0.03,time4,color=255,/normal,charsize=1.5,charthick=3


;---------------------------------------------;
;				    Image 5
;
img5 = sccreadfits('mass45_20081212_122220_1B4c2B.fts',he5)
img5 = img5 - background
time5=anytim(file2time('mass45_20081212_122220_1B4c2B.fts'),/yoh,/trun)


plot_image,bytscl(img5,byt0,byt1),xticks=1,yticks=1,yminor=1,$
ytickname=[' ',' '],xtickname=[' ',' '],position=[0.31333, 0.01, 0.6266, 0.5],/normal,/noerase

suncen = get_suncen(he5)
tvcircle, (he5.rsun/he5.cdelt1), suncen.xcen, suncen.ycen, 254, /data,color=255,thick=1
xyouts,0.318,0.46,'COR2 B',color=0,/normal,charsize=1.5,charthick=10
xyouts,0.318,0.46,'COR2 B',color=255,/normal,charsize=1.5,charthick=3
xyouts,0.318,0.03,time5,color=0,/normal,charsize=1.5,charthick=10
xyouts,0.318,0.03,time5,color=255,/normal,charsize=1.5,charthick=3

!p.color=255
a=scc_ROI_SECTOR(he5, 1.0, 11.0 ,310.0, 250.0, /draw)
a=scc_ROI_SECTOR(he5, 1.0, 7.5 ,298.0, 268.0, /draw)
!p.color=0


;---------------------------------------------;
;				    Image 6
;
img6 = sccreadfits('mass45_20081212_145220_1B4c2B.fts',he6)
img6 = img6 - background
time6=anytim(file2time('mass45_20081212_145220_1B4c2B.fts'),/yoh,/trun)

plot_image,bytscl(img6,byt0,byt1),xticks=1,yticks=1,yminor=1,/scale,$
ytickname=[' ',' '],xtickname=[' ',' '],position=[0.6266, 0.01, 0.94, 0.5],/normal,/noerase

suncen = get_suncen(he6)
tvcircle, (he6.rsun/he6.cdelt1), suncen.xcen, suncen.ycen, 254, /data,color=255,thick=1

xyouts,0.631,0.46,'COR2 B',color=0,/normal,charsize=1.5,charthick=10
xyouts,0.631,0.46,'COR2 B',color=255,/normal,charsize=1.5,charthick=3
xyouts,0.631,0.03,time6,color=0,/normal,charsize=1.5,charthick=10
xyouts,0.631,0.03,time6,color=255,/normal,charsize=1.5,charthick=3

!p.color=255
a=scc_ROI_SECTOR(he6,1.0,15.5,310.,250.,/draw)
a=scc_ROI_SECTOR(he6,1.0,11.5,298.,268.,/draw)


device,/close
set_plot,'x'

END
