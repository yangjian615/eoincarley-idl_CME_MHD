pro cor1_plots,img1,img2,img3,img4,img5,img6,he1,he2,he3,he4,he5,he6

;Sample of the plot procedure used to plot COR1A mass images in paper

;files = findfiles('*.fit')
;img4 = sccreadfits(files[i],hei]

;loadct,39 $
;!p.color=0 $ 
;!p.background=255 

;multiplot,/reset

;window,1,xs=900,ys=700
;multiplot,[3,2]

;loadct,0
;xloadct
;stop

plot_image,sigrange(filter_image(img4,fwhm=4)),title=time4,ytitle='STEREO COR 1 A',xticks=1,yticks=1,ytickname=[' ',' ']
suncen = get_suncen(he4)
tvcircle, (he4.rsun/he4.cdelt1), suncen[0], suncen[1], 254, /data,color=255,thick=2
multiplot

plot_image,sigrange(filter_image(img5,fwhm=4)),title=time5,xticks=1,yticks=1,ytickname=[' ',' ']
suncen = get_suncen(he5)
tvcircle, (he5.rsun/he5.cdelt1), suncen[0], suncen[1], 254, /data,color=255,thick=2

multiplot 
plot_image,sigrange(filter_image(img6,fwhm=4)),title=time6,xticks=1,yticks=1,ytickname=[' ',' ']
suncen = get_suncen(he6)
tvcircle, (he1.rsun/he1.cdelt1), suncen[0], suncen[1], 254, /data,color=255,thick=2

stop
multiplot 
plot_image,sigrange(filter_image(img1,fwhm=4)),title=time1,ytitle='STEREO COR 1 B', xticks=1,yticks=1,ytickname=[' ',' '],color=255
suncen = get_suncen(he1)
tvcircle, (he1.rsun/he1.cdelt1), suncen[0], suncen[1], 254, /data,color=0,thick=2
multiplot 
plot_image,sigrange(filter_image(img2,fwhm=4)),title=time2,xticks=1,yticks=1,ytickname=[' ',' ']
suncen = get_suncen(he2)
tvcircle, (he2.rsun/he2.cdelt1), suncen[0], suncen[1], 254, /data,color=0,thick=2
multiplot 
stop
plot_image,sigrange(filter_image(img3,fwhm=4)),title=time3,xticks=1,yticks=1,ytickname=[' ',' ']
suncen = get_suncen(he3)
tvcircle, (he3.rsun/he3.cdelt1), suncen[0], suncen[1], 254, /data,color=255,thick=2

end



