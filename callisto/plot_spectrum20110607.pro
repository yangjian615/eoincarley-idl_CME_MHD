pro plot_spectrum20110607,z_bs

cd,'/Users/eoincarley/data/CALLISTO/20110607

restore,'spec_z_20110607.sav'
restore,'spec_x_20110607.sav'
restore,'spec_y_20110607.sav'

z_mast = spec_z_20110607
x_mast = spec_x_20110607
y_mast = spec_y_20110607



a = anytim(file2time('20110607_062500'),/utim)
b = anytim(file2time('20110607_063300'),/utim)
window,1,xs=900,ys=600

spectro_plot,bytscl(z_mast,130,200),x_mast,y_mast,/xs,/ys,charsize=1.5,yr=[35,90],xr=[a,b],$
tick_unit=60,ytickinterval=5,ytitle='Frequency (MHz)', title='eCallisto Birr, Ireland 35-90 MHz'


running_mean_background,z_mast,back

z_bs = z_mast - back
;window,2,xs=900,ys=600
;spectro_plot,bytscl(z_bs,1,50),x_mast,y_mast,/xs,/ys,charsize=1.5,yr=[35,90],xr=[a,b]
;z_norm = fltarr(7200,400)
;FOR i=0,n_elements(y_mast)-1 DO BEGIN

  ;  z_bs[*,i] = z_bs[*,i]/max(z_bs[*,i])

;ENDFOR

;window,3,xs=1000,ys=600

;window,12
;q = anytim(file2time('20110607_060000'),/utim)
;p = anytim(file2time('20110607_073000'),/utim)
;spectro_plot,bytscl(z_bs,1,50),x_mast,y_mast,/xs,/ys,charsize=1.5,ytitle='Frequency (MHz)',$
;title='eCallisto, Birr Castle, 2011/06/07 350-20 MHz',ytickinterval=25,tick_unit=600,xr=[q,p]


end