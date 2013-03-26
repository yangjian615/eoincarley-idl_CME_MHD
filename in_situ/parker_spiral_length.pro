function parker_spiral_length, radius, solar_wind_vel

; Input radius values should be in R_sun

; Output length along the spiral for that rsun

; solar wind_vel (km/s)

; radius in rsun

solar_r = 6.955e8
radius = radius*solar_r
ang_vel = 2.8e-6 ;2*!pi/2.4e6
;print,ang_vel

v_sw = solar_wind_vel*(1.0e3) ;km/s
const = v_sw/ang_vel
phi = (ang_vel/v_sw)*radius

arc_length = 0.5*const*(phi*sqrt(1.0 + phi^2.0) -  alog(-1.0*phi + sqrt(1.0+phi^2.0)))
arc_length = arc_length/6.955e8

print,'Arc length for '+string(v_sw/1.0e3)+' km/s'
print,string(arc_length)+' R/Rsun'
return,arc_length ;Output is in Rsun

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