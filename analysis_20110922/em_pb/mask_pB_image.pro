pro mask_pB_image

cd,'/Users/eoincarley/data/22sep2011_event/LASCO_C2/polarized_brightness'

data = lasco_readfits('C2-PB-20110922_0257.fts',hdr)
rsun = get_solar_radius(hdr)

hdr.cdelt1 = 11.9*2.0
hdr.cdelt2 = 11.9*2.0

pixrad = rsun/hdr.cdelt1
suncen = get_sun_center(hdr)

index = circle_mask(data,suncen.xcen,suncen.ycen,'le',pixrad*2.2)

data[index] = 0.0

spawn,'mkdir mask'
cd,'mask'

writefits,'C2-PB-20110922_0257.fts',data,hdr

END
