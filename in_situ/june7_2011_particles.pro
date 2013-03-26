pro june7_2011_particles

cd,'/Users/eoincarley/Data/CALLISTO/20110607/ACE_data'

readcol,'20110607_ace_epam_5m.txt',YYYY,MM,DD,HHMM,MJD,SOD,S,E1,E2,s,p1,p2,p3,p4,p5

;***********Time array, every 300 seconds*****************
t0=anytim(file2time('20110607_ace_epam_5m.txt'),/utim)
times = dblarr(n_elements(YYYY))
times[0]=t0
FOR i = 1, n_elements(YYYY)-1 DO BEGIN
  times[i]=t0+(i*300.)
ENDFOR 

xstart= anytim(file2time('20110607_050000'),/utim)
xend = anytim(file2time('20110607_230000'),/utim)

;**********************************************************
loadct,39
!p.charsize=1.0
set_plot,'ps'
device,filename = 'june7_2011_particles.ps',/color,/inches,/encapsulate,ysize=7,xsize=4;,yoffset=7

;********************   ELECTRONS   ******************************

utplot,times,E1,yr=[1e2,1e5],/ys,/xs,color=250,/ylog,position = [0.14,0.71,0.87,0.99],/normal,$
xtitle=' ',xticks=6,xtickname=[' ',' ',' ',' ',' ',' ',' '],xr=[xstart,xend],$
ytitle='Electrons cm!U-2 !Ns!U-1 !Nsr!U-1'

oplot,times,E2,color=50
legend, ['38-53 keV','175-315 keV'],$
linestyle=[0,0], color=[250,50], box=0,charsize=1.0,/bottom,/right

tim=dblarr(1001)
tim[*] = anytim(file2time('20110607_071000'),/utim)
ysim = ((dindgen(1001)*(1.0e5 - 1.0e2) )/1000.0 ) +1.0e2
oplot,tim,ysim,linestyle=1



;***********************************************************


;*****************       PROTONS (high energy)   ***************************
readcol,'20110607_ace_sis_5m.txt',YYYY,MM,DD,HHMM,MJD,SOD,s1,high_p1,s2,high_p2
utplot,times,high_p1,yr=[0,140],/xs,/ys,color=250,position = [0.14,0.41,0.87,0.70],$
/normal,/noerase,xr=[xstart,xend],$
xtitle=' ',xticks=6,xtickname=[' ',' ',' ',' ',' ',' ',' '],$
ytitle=' ',yticks=7,ytickname=[' ',' ',' ',' ',' ',' ',' ',' '],yminor=4
axis,yaxis=1,yr=[0,140],/ys,ytitle='Protons cm!U-2 !Ns!U-1 !Nsr!U-1 !NMeV!U-1'

oplot,times,high_p2,color=50
legend,['>10 MeV','>30 MeV'],linestyle=[0,0],color=[250,50],charsize=1.0,box=0

tim=dblarr(1001)
tim[*] = anytim(file2time('20110607_071000'),/utim)
ysim = ((dindgen(1001)*(140.0 - 0.0) )/1000.0 ) +1.0
oplot,tim,ysim,linestyle=1



;*****************       PROTONS (low energy)   ***************************
utplot,times,p5,ystyle=1,/xs,color=50,/ylog,yr=[1e0,1e6],position = [0.14,0.11,0.87,0.40],$
/normal,/noerase,xr=[xstart,xend],$
ytitle='Protons cm!U-2 !Ns!U-1 !Nsr!U-1 !NMeV!U-1',xticks=7,$
;xtickname=['05:00','08:00','11:00','14:00','17:00','20:00','23:00'],$
xtitle='Start Time ('+anytim(file2time('20110607_050000'),/yoh,/trun)+') UT'

oplot,times,p4,color=100
oplot,times,p3,color=150
oplot,times,p2,color=200
oplot,times,p1,color=250
legend, ['47-68 keV','115-195 keV','310-580 keV','795-1193 keV','1060-1900 keV'],$
linestyle=[0,0,0,0,0], color=[250,200,150,100,50], charsize=0.8, box=0,/right

;xyouts,0.82,0.073,'00:00',/normal
tim=dblarr(1001)
tim[*] = anytim(file2time('20110607_071000'),/utim)
ysim = ((dindgen(1001)*(1.0e6 - 1.0e0) )/1000.0 ) +1.0e0
oplot,tim,ysim,linestyle=1

xyouts,0.805,0.965,'(a)',charsize=1.0,/normal
xyouts,0.805,0.67,'(b)',charsize=1.0,/normal
xyouts,0.805,0.375,'(c)',charsize=1.0,/normal

device,/close
set_plot,'x'


;!p.multi=[0,1,1]
;b = dblarr(n_elements(p1))
;b[*] = 47.0
;c = dblarr(n_elements(p1))
;c[*] = 115.0
;d = dblarr(n_elements(p1))
;d[*] = 310.0
;e = dblarr(n_elements(p1))
;e[*] = 795.0
;f = dblarr(n_elements(p1))
;f[*] = 1900.0
;g = dblarr(n_elements(p1))
;g[*] = 10000.0
;h = dblarr(n_elements(p1))
;h[*] = 30000.0

;loadct,39
;!p.color=0
;!p.background=255
;window,1,xs=500,ys=600
;FOR i=0,n_elements(p1)-1 DO BEGIN
;let = [b[i],c[i],d[i],e[i],f[i],g[i],h[i]]
;ps = [p1[i],p2[i],p3[i],p4[i],p5[i],high_p1[i],high_p2[i]]

;plot,let,ps,psym=1,/ylog,/xlog,xtitle='MeV',ytitle='Protons cm!U-2 !Ns!U-1 !Nsr!U-1 !NMeV!U-1',$
;title=anytim(times[i],/yoh),yr=[1.0,10000.0]
;oplot,let,ps,linestyle=1
;wait,0.1
;ENDFOR

;stop
END