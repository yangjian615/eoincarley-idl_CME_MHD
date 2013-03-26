pro plot_pb_ne

cd,'/Users/eoincarley/data/22sep2011_event/LASCO_C2/polarized_brightness'
restore,'r_pb_pbsim_ne.sav'

set_plot,'ps'
device,filename = 'pB_ne.ps',/color,/inches,/encapsulate,ysize=7,xsize=7,yoffset=7

rhos = data_array[0,*]
pb_data = data_array[1,*]
pb_fit = data_array[2,*]
n_e = data_array[3,*]

loadct,39
!p.color=0
!p.background=255
!p.thick=4
!p.charsize=1.5

	 ;pole hole  ;background     ;equator hole
;c1 = ;3.15e6		;1.36e6  		;5.27e6
;c2 = ;1.60e6		;1.6e8   		;3.54e6
;d1 = ;4.71			;2.14    		;3.3
;d2 = ;3.01			;6.13    		;5.8
c1 = 5.27e6
c2 = 3.54e6
d1 = 3.3
d2 = 5.8


saito = dblarr(n_elements(rhos))
saito = (c1*rhos^(-1.0*d1) + c2*rhos^(-1.0*d2))
!p.charthick=5

plot,rhos,n_e,/ylog,position=[0.15,0.1,0.82,0.95],/normal,/noerase,$
ytitle='Electron Density [cm!U-3!N]',xtitle='Heliocentric distance [R/Rsun]',$
color=50,yticklen=0.0,ystyle=4,linestyle=5,xthick=5.0,ythick=5.0,charthick=5.0,thick=5.0

oplot,rhos,saito,color=140,linestyle=4,thick=5.0


legend,['pB data','pB fit','e!U-!N density','Saito equat crnl hole'],linestyle=[0,0,5,4],$
psym=[5,0,0,0],charsize=1.2,color=[0,240,50,140]

axis,yaxis=0,ythick=5

plot,rhos,pb_data,psym=5,/ylog,$
xtitle='Heliocentric distance [R/Rsun]',$
position=[0.15,0.1,0.82,0.95],/normal,/noerase,ytickname=[' ',' ',' ',' ',' '],$
yticklen=0.0,ystyle=4,xthick=5.0,ythick=5.0,charthick=7.0,thick=5.0

axis,yaxis=0,ystyle=4,ythick=5,charthick=5
axis,yaxis=1,ytitle='Polarized Brightness [MSB]',color=255,ystyle=2,ythick=5,charthick=5.0
oplot,rhos,pb_fit,color=240,thick=5
axis,yaxis=1,yticklen=0.0,ythick=5

xyouts,0.06,0.35,'Electron Density [cm!U-3!N]',orientation=90.0,/normal,charthick=5.0
xyouts,0.95,0.33,'Polarized Brightness [MSB]',orientation=90.0,/normal,charthick=5.0

device,/close
set_plot,'x'

END