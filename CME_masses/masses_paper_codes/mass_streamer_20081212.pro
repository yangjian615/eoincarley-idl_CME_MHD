pro mass_streamer_20081212

cd,'/Users/eoincarley/Data/secchi_l1/20081212/20081212_cor1/20081212_cor1b_B/mass_images'

bkg = sccreadfits('mass43_20081212_040500_1B4c1B.fts',heb)
img1 = sccreadfits('mass43_20081212_082500_1B4c1B.fts',he1)
img1=img1-bkg
window,0,xs=700,ys=700
img1 = scc_add_datetime(img1,he1)
plot_image,sigrange(img1)
suncen = get_suncen(he1)
tvcircle, (he1.rsun/he1.cdelt1), suncen.xcen, suncen.ycen, 254, /data,color=255,thick=1
sccwritefits,'mass_streamer.fts',img1,he1
print,mean(img1)

END