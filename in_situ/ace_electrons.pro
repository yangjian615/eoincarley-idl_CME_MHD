pro ace_electrons

;read in the ace electron ascii and plot electron flux
cd,'/Users/eoincarley/Data/CALLISTO/20110607/ACE_data'

files = sock_find('http://www.swpc.noaa.gov/','20110607_*.txt',path='/ftpdir/lists/ace/')
sock_copy,files[0:n_elements(files)-1]
readcol,'20110607_ace_epam_5m.txt',YYYY,MM,DD,HHMM,MJD,SOD,S,E1,E2,s,p1,p2,p3,p4,p5

t0=anytim(file2time('20110607_ace_epam_5m.txt'),/utim)
times = dblarr(n_elements(YYYY))
times[0]=t0
FOR i = 1, n_elements(YYYY)-1 DO BEGIN
  times[i]=t0+(i*300.)
ENDFOR 


!p.multi=[0,1,1]
loadct,39
!p.color=0
!p.background=255
window,14,xs=800,ys=800
!p.multi=[0,1,3]
!p.charsize=3

a = anytim(file2time('20110607_000000'),/utim)
b = anytim(file2time('20110608_000000'),/utim)

utplot,times,E1,yr=[1e2,1e5],/ys,/xs,color=250,/ylog,$
ytitle='Particles cm!U-2 !Ns!U-1 !Nsr!U-1 !NMeV!U-1',title='ACE Differential Electron Flux',$
xr=[a,b]
oplot,times,E2,color=50
legend, ['38-53 keV','175-315 keV'],$
linestyle=[0,0], color=[250,50], charsize=1.3, box=0,pos=[0.125,0.95],/normal

;===================High energy protons====================
readcol,'20110607_ace_sis_5m.txt',YYYY,MM,DD,HHMM,MJD,SOD,s1,high_p1,s2,high_p2
print,high_p1
;window,16,xs=700,ys=500
utplot,times,high_p1,yr=[0,140],xr=[a,b],/xs,/ys,color=250,$
ytitle='Particles cm!U-2 !Ns!U-1 !Nsr!U-1',title='ACE Integral High Energy Proton flux'
oplot,times,high_p2,color=50
legend,['>10 MeV','>30 MeV'],linestyle=[0,0],color=[250,50],box=0,charsize=1.5,$
pos=[0.125,0.6125],/normal


;window,15,xs=700,ys=460
utplot,times,p5,/ys,/xs,color=50,/ylog,yr=[1e0,1e6],xr=[a,b],$
ytitle='Particles cm!U-2 !Ns!U-1 !Nsr!U-1 !NMeV!U-1',title='ACE Differential Low Energy Proton Flux'
oplot,times,p4,color=100
oplot,times,p3,color=150
oplot,times,p2,color=200
oplot,times,p1,color=250
legend, ['1060-1900 keV','795-1193 keV','310-580 keV','115-195 keV','47-68 keV'],$
linestyle=[0,0,0,0,0], color=[50,100,150,200,250], charsize=1, box=0,pos=[0.75,0.2875],/normal




;maximum E1 for the 20110607 is at element 90, it occurs at time 07-Jun-11 07:30:00.000
;initial rise begins at 07-Jun-11 06:54:43.456
;xyouts,272,397,'Bulk electron arrival 07:30 UT *',/device
;xyouts,413,125,'* First electron arrival 06:55 UT',/device

END