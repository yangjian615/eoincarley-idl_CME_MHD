pro plot_ne_models

;cd,'/Users/eoincarley/data/22sep2011_event/LASCO_C2/polarized_brightness'
;restore,'r_pb_pbsim_ne.sav'

set_plot,'ps'
device,filename = 'ne_freq_models.ps',/color,/inches,/encapsulate,ysize=7,xsize=6.5,yoffset=7

;rhos = data_array[0,*]
;pb_data = data_array[1,*]
;pb_fit = data_array[2,*]
;n_e = data_array[3,*]


rhos = (dindgen(101)*(5.0-1.0)/100.0)+1.0
;*************Saito Models*********************************
	 ;pole hole  ;background     ;equator hole
;c1 = ;3.15e6		;1.36e6  		;5.27e6
;c2 = ;1.60e6		;1.6e8   		;3.54e6
;d1 = ;4.71			;2.14    		;3.3
;d2 = ;3.01			;6.13    		;5.8

c1 = 5.27e6
c2 = 3.54e6
d1 = 3.3
d2 = 5.8
saito_ehole = dblarr(n_elements(rhos))
saito_ehole = ( c1*rhos^(-1.0*d1) + c2*rhos^(-1.0*d2)  )

c1 = 3.15e6
c2 = 1.60e6
d1 = 4.71
d2 = 3.01
saito_phole = dblarr(n_elements(rhos))
saito_phole = ( c1*rhos^(-1.0*d1) + c2*rhos^(-1.0*d2) ) 


c1 = 1.36e6
c2 = 1.68e8
d1 = 2.14
d2 = 6.13
saito_bg = dblarr(n_elements(rhos))
saito_bg = (  c1*rhos^(-1.0*d1) + c2*rhos^(-1.0*d2)  ) 

;******************************************************
;**************Newkirk Model*************************
N=4.2e4
newkirk = ( N*10.0^(4.32/rhos) )

;****************************************************
;**************Baumbach Allen Model******************
ba = ( 1.0e8*(  2.99*(rhos)^(-16.0) +1.55*(rhos)^(-6.0)+0.036*(rhos)^(-1.5)  ) )

;****************************************************


loadct,39
!p.color=0
!p.background=255
fac = 1.0;e6
plot,rhos,1.0*saito_bg/fac,/ylog,position=[0.16,0.1,0.9,0.9],/normal,/noerase,$
ytitle='Electron Density [cm!U-3!N]',xtitle='Heliocentric distance [R/Rsun]',linestyle=5,$
title='Coronal Density Models';,yticklen=0.0,linestyle=5;,ystyle=4

;RECTANGLE, 1.4, 1.7, 2.6, 0.5
;xyouts,2.0,1.75,'STEREO COR1',/data


;RECTANGLE, 2.3, 1.25, 2.7, 0.4
;xyouts,3.2,1.3,'LASCO C2',/data


;call = fltarr(n_elements(newkirk))
;call[*] = 2.0*newkirk[*]/fac
;a = interpol(rhos, call, [20.0,400.0])

;RECTANGLE, a[1], 2.3, a[0]-a[1], 0.6, color=50
;xyouts,1.3,2.35,'RSTO CALLISTO',/data

oplot,rhos,1.0*saito_phole/fac,color=140,linestyle=4,thick=3
oplot,rhos,1.0*saito_ehole/fac,color=240,linestyle=3,thick=3
oplot,rhos,1.0*newkirk/fac,color=50,linestyle=6,thick=3

oplot,rhos,1.0*ba/fac,color=200,linestyle=2,thick=3


;oplot,rhos,saito,color=140,linestyle=4,thick=3



legend,['Newkirk','Baum-Allen','Saito','Saito Eq Hole','Saito Pol Hole'],linestyle=[6,2,5,3,4],$
charsize=1.4,color=[50,200,0,240,140],/right,thick=2

;axis,yaxis=0

;plot,rhos,9000.0*sqrt(saito_bg),psym=5,/ylog,$
;xtitle='Heliocentric distance [R/Rsun]',$
;position=[0.15,0.1,0.82,0.95],/normal,/noerase,ytickname=[' ',' ',' ',' ',' '],$
;yticklen=0.0,ystyle=4

;axis,yaxis=0,ystyle=4
;axis,yaxis=1,ytitle='Frequency [MHz]',color=255,ystyle=2
;oplot,rhos,pb_fit,color=240,thick=2
;axis,yaxis=1,yticklen=0.0

;xyouts,0.06,0.35,'Electron Density [cm!U-3!N]',orientation=90.0,/normal
;xyouts,0.95,0.33,'Polarized Brightness [MSB]',orientation=90.0,/normal

device,/close
set_plot,'x'




rsun = 6.955e5 ;km

expon = (dindgen(101)*(5.0 - 3.0)/100.0 ) + 3.0
Df = -10.0^(reverse(expon))


v_saito = Df*(1.0/deriv(rhos*rsun, 1.0*saito_bg/fac))*sqrt(1.0*saito_bg/fac)*2.0/8980.
v_saito_phole = Df*(1.0/deriv(rhos*rsun, 1.0*saito_phole/fac))*sqrt(1.0*saito_phole/fac)*2.0/8980.
v_saito_ehole = Df*(1.0/deriv(rhos*rsun, 1.0*saito_ehole/fac))*sqrt(1.0*saito_ehole/fac)*2.0/8980.
v_newkirk = Df*(1.0/deriv(rhos*rsun, 1.0*newkirk/fac))*sqrt(1.0*newkirk/fac)*2.0/8980.
v_ba = Df*(1.0/deriv(rhos*rsun, 1.0*ba/fac))*sqrt(1.0*ba/fac)*2.0/8980.


plot, rhos, v_saito, /ylog
oplot, rhos, v_saito_phole, color=140, linestyle=4, thick=3
oplot, rhos, v_saito_ehole, color=240, linestyle=3, thick=3
oplot, rhos, v_newkirk, color=50, linestyle=6, thick=3
oplot, rhos, v_ba, color=200, linestyle=2, thick=3


legend,['Newkirk','Baum-Allen','Saito','Saito Eq Hole','Saito Pol Hole'],linestyle=[6,2,5,3,4],$
charsize=1.4,color=[50,200,0,240,140],/right,thick=2

stop


END