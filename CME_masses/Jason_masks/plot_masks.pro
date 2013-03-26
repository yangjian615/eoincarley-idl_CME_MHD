pro plot_masks

cd,'/Users/eoincarley/Data/jason_catalogue/20100227-0305/C2/all'

set_plot,'ps'
device,filename='plot_masks.ps', /color, /inches, /encapsulate, $
ysize=6, xsize=10
!p.multi=[0,2,1]

data = lasco_readfits('25327112.fts', he1)
suncen = get_suncen(he1)

restore,'cme_mask_bin.sav'
plot_image, cme_mask_bin, title='Mask for no detection (C2)
tvcircle, (he1.rsun/he1.cdelt1), suncen.xcen, suncen.ycen, 254, /data,color=255,thick=1

restore,'cme_mask_bin_CME.sav'
plot_image, cme_mask_bin, title='Mask for CME detection (C2)'
tvcircle, (he1.rsun/he1.cdelt1), suncen.xcen, suncen.ycen, 254, /data,color=255,thick=1


device,/close
set_plot,'x'


set_plot,'ps'
device,filename='plot_masks_inverse.ps', /color, /inches, /encapsulate, $
ysize=6, xsize=6
!p.multi=[0,1,1]
restore,'cme_mask_bin_inverse.sav'
plot_image, cme_mask_bin, title='Inverse Mask (C2)'
tvcircle, (he1.rsun/he1.cdelt1), suncen.xcen, suncen.ycen, 254, /data,color=0,thick=1
device,/close
set_plot,'x'



END