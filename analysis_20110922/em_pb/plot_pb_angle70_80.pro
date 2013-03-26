pro plot_pb_angle70_80

cd,'/Users/eoincarley/Data/22sep2011_event/LASCO_C2/polarized_brightness'

readcol,'coeffs_exps.txt', a, c0, c1, c2, c3, ex0, ex1, ex2, ex3,$
	format = 'D,D,D,D,D,D,D,D,D'	
radius  = (dindgen(1001)*(5.0 - 2.4)/1000.0) + 2.4  ;note that changing the radius values here effects plot_em_and_pb_density.pro
pb = dblarr(n_elements(radius))
pb[*] = c0[0]*radius[*]^ex0[0] + c1[0]*radius[*]^ex0[0] + c2[0]*radius[*]^ex0[0] + c3[0]*radius[*]^ex0[0] 	
loadct,39
!p.color=0
!p.background=255
window,0,xs=600,ys=800
;plot,radius,pb,charsize=2.0,/ylog,yr=[1.0e-9,1.0e-7],ytitle='Polarized Brightness [MSB]',$
;xtitle='Heliocentric Distance [R/R!Lsun!N]',ystyle=1

FOR i=1,n_elements(a)-1 DO BEGIN
	pb = dblarr(n_elements(radius))
	pb[*] = c0[i]*radius[*]^ex0[i] + c1[i]*radius[*]^ex0[i] + c2[i]*radius[*]^ex0[i] + c3[i]*radius[*]^ex0[i] 	
	oplot,radius,pb,color=60
ENDFOR	
	
;*****************Get ne associated with each radial trace*****************
ne_array = dblarr(n_elements(radius), n_elements(c0))

FOR j=0,n_elements(c0)-1 DO BEGIN

	COEFF = [c0[j], c1[j], c2[j], c3[j]] 
	EXPS = [ex0[j], ex1[j], ex2[j], ex3[j]] 
	Q=0.58
	RADII = radius
	
	nsube = VDH_INVERSION(RADII,Q,COEFF,EXPS)
	ne_array[*,j] = nsube
	
ENDFOR	
window,1	
plot_image,ne_array
save,ne_array,filename='ne_array.sav'

;window,2,xs=600,ys=800

set_plot,'ps'
device,filename = 'ne_average.ps',/color,/inches,/encapsulate,ysize=7,xsize=6.5,yoffset=7

ne_r = ne_array(*,0)
plot,radius,ne_r,charsize=1.5,/ylog,ytitle='Electron Density [cm!U-3!N]',$
xtitle='Heliocentric Distance [R/R!Lsun!N]',xthick=5,ythick=5

legend,['All radial traces','Average'],linestyle=[0,0],$
charsize=1.4,color=[0,250],/right,thick=2
;*********************Get average ne of all ne profiles
FOR i=1,n_elements(c0)-1 DO BEGIN
	ne_r = ne_array[*,i]	
	oplot,radius,ne_r
ENDFOR	

ne_average = dblarr(n_elements(radius))
FOR i=0, n_elements(radius)-1 DO BEGIN
	ne_average[i] = mean(ne_array(i,*))
	ENDFOR
oplot,radius,ne_average,color=240,linestyle=0,thick=3
save,radius,ne_average,filename='radius_ne_average.sav'

device,/close
set_plot,'x'

;From average of all radial traces, ne_average was calculated. Use this to calculate plasma frequency
;as fucntion of height.

e_charge = 4.80320425e-10 ;cgs
e_mass = 9.1095e-28 ;cgs
f_plasma = dblarr(n_elements(ne_average))
f_plasma[*] = sqrt((e_charge^2.0)/(!PI*e_mass))*sqrt(ne_average[*])

set_plot,'ps'
device,filename = 'fplasma_average.ps',/color,/inches,/encapsulate,ysize=7,xsize=6.5,yoffset=7

plot,radius,1.0*f_plasma,charsize=1.5,/ylog,ytitle='Plasma Frequency [Hz]',$
xtitle='Heliocentric Distance [R/R!Lsun!N]'

device,/close
set_plot,'x'

END	