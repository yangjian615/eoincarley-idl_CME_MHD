pro plot_masses

cd,'/Users/eoincarley/Data/secchi_l1/20081212/20081212_cor1/20081212_cor1a_B/mass_results
restore,'COR1Amass_height_time.sav'
cor1a=mass_array

cd,'/Users/eoincarley/Data/secchi_l1/20081212/20081212_cor1/20081212_cor1b_B/mass_results
restore,'COR1Bmass_height_time.sav'
cor1b=mass_array

cd,'~/Data/secchi_l1/20081212/20081212_cor2a/mass_images/
restore,'COR2Amass_height_time.sav'
cor2a=mass_array


cd,'~/Data/secchi_l1/20081212/20081212_cor2b/mass_images/
restore,'COR2Bmass_height_time.sav'
cor2b=mass_array

;tstart = cor1a[2,0]
;tend = cor2b[2,n_elements(cor2b(2,*))-1]
tstart = anytim(file2time('20081212_040000'),/utim)
tend = anytim(file2time('20081212_180000'),/utim)

loadct,39
!p.color=0
!p.background=255
window,30,xs=1000,ys=500
!p.multi=[0,2,1]

utplot,cor2b(2,*),cor2b(1,*),/ylog,yr=[1e12,1e16],xr=[tstart,tend],psym=1,charsize=1.5,ytitl='CME Mass (g)',/xs,title='2008/12/12 CME Mass vs. time'
oplot,cor2a(2,*),cor2a(1,*),psym=2
oplot,cor1a(2,*),cor1a(1,*),psym=5
oplot,cor1b(2,*),cor1b(1,*),psym=4
legend,['COR1 A','COR1 B','COR2 A','COR2 B'],psym=[5,4,2,1],box=0,charsize=1.5,/bottom,/right

hstart = cor1a[0,0]/COS(49*!DTOR)
hend = cor2b[0,n_elements(cor2b(0,*))-1]/COS(43*!DTOR)

plot,cor2b(0,*)/COS(43*!DTOR),cor2b(1,*),/ylog,yr=[1e12,1e16],xr=[0,25],title='2008/12/12 CME Mass vs. height'$
,psym=1,charsize=1.5,ytitl='CME Mass (g)',/xs,xtitle='Solar radii (R/Rsun)'
oplot,cor2a(0,*)/COS(49*!DTOR),cor2a(1,*),psym=2
oplot,cor1a(0,0:26)/COS(49*!DTOR),cor1a(1,0:26),psym=5
oplot,cor1b(0,0:26)/COS(43*!DTOR),cor1b(1,0:26),psym=4
legend,['COR1 A','COR1 B','COR2 A','COR2 B'],psym=[5,4,2,1],box=0,charsize=1.5,/bottom,/right
x2png,'Mass_no_add.png'
END