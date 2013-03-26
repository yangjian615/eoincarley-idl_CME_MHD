pro plot_pB_transfer_report

cd,'/Users/eoincarley/Data/22sep2011_event/LASCO_C2/polarized_brightness/mask'

loadct,1

data = readfits('C2-PB-20110922_0257.fts',hdr)
restore,'xy_radial_trace_77deg.sav'

set_plot,'ps'
device,filename = 'lascoC2_pB.eps',/color,/inches,/encapsulate,bits_per_pixel=8,ysize=7,xsize=7,yoffset=7
!p.charsize=1.0
plot_image,alog(data),position = [0.1, 0.1, 0.89, 0.9],/normal,$
title='LASCO C2 pB'

cd,'..'
test = lasco_readfits('C2-PB-20110922_0257.fts',hdr)
suncen = get_sun_center(hdr)
rsun = get_solar_radius(hdr)

tvcircle, (rsun/23.8), suncen.xcen, suncen.ycen, 254, /data,color=250,thick=1

plots,xy_radial[0,*],xy_radial[1,*],/continue,/data,color=255,thick=5

FOR i = 70.,80. DO BEGIN
eta = (i+90.0)*!DTOR ;take 0 degrees to be solar north
xs = COS(eta) * dindgen(300.0) + suncen.xcen
ys = SIN(eta) * dindgen(300.0) + suncen.ycen


plots,xs,ys,color=255,/continue,/data,thick=5
ENDFOR

color_key, range = [ 0.0, alog(max(data)) ],ysize=-0.9,barwidth = 0.2,$
charsize=1.0
xyouts,0.97,0.6,'pB [x10!U-9!N MSB]',orientation=270.0,/normal

device,/close
set_plot,'x'

END