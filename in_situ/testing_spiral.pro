function testing_spiral,radius

;Input radius values should be in R_sun

solar_r = 6.955e8
radius = radius*solar_r
ang_vel = 2.8e-6;2*!pi/2.4e6
;print,ang_vel

v_sw=4.0e5
const = v_sw/ang_vel
phi = (ang_vel/v_sw)*radius

arc_length = 0.5*const*(phi*sqrt(1 + phi^2) -  alog(-1.0*phi + sqrt(1+phi^2)))

;print,'radius :'+string(radius[100]/6.955e8)
;print,'arc_length :'+string(arc_length[100]/6.955e8)
print,'Arc length for '+string(v_sw)
print,string(arc_length)
return,arc_length ;Output is in meters

END

pro plot_arc_length
solar_r = 6.955e8
radius = dindgen(215)

arc = testing_spiral(radius)

loadct,39
!p.color=0
!p.background=255
window,1,xs=600,ys=500
plot,radius/solar_r,arc/solar_r,charsize=1.5,xtitle='Radial vector (Rsun)',$
ytitle='Distance along parker spiral (Rsun)',/xs,/ys,ytickinterval=20,xtickinterval=20,$
yr=[0,260],xr=[0,220],title='Arc length of spiral vs radial distance'





END