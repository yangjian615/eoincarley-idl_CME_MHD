pro plot_mass_area,cor2b_mass_area

cd,'/Users/eoincarley/data/secchi_l1/20081212/20081212_cor2b/mass_images'
restore,'cor2b_mass_area.sav'

set_plot,'ps'
device,filename = '20081212_mass_area.ps',/color,bits=8,/inches,/portrait,/encapsulate,$
xsize=6,ysize=6
;window,1,xs=600,ys=500
;!x.margin=[12,5]



plot,cor2b_mass_area[0,*]/1e5,cor2b_mass_area[1,*]/1e15,psym=1,$
charsize=1,xtitle='!6CME area (pixels) x 10!U5!N',ytitle='CME Mass (g) x 10!U15!N',$
/xs,/ys,yr=[0,2.5],xr=[0,3];,title='COR2 B CME Mass vs. Area'

lin = linfit(cor2b_mass_area[0,0:9]/1e5,cor2b_mass_area[1,0:9]/1e15)
pixels = dindgen(1001)*(3.5/1000)
;stop
gen = lin[0] + lin[1]*pixels
;oplot,pixels,gen
;window,2,xs=500,ys=500

;plot,cor2b_mass_area[0,*],cor2b_mass_area[1,*]/cor2b_mass_area[0,*],psym=4,$
;ytitle='CME column density (g/area)',xtitle='CME area (arbitrary units)',charsize=1.5

print,cor2b_mass_area[1,*]/cor2b_mass_area[0,*]

device,/close
set_plot,'x'

END
