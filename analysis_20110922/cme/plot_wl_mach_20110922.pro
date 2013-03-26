pro plot_wl_mach_20110922

cd,'/Users/eoincarley/Data/22sep2011_event/secchi/COR1/b/24540411/l1_new'
files = findfile('*.fts')
device, retain=2
!p.color=0
!p.background=255
window, 0, xs=1600, ys=700

!p.charsize=2.5
!p.multi=[0,3,1]
FOR i=13, 15 DO BEGIN
loadct,0
pre = sccreadfits(files[5],he_pre);usually 5
data = sccreadfits(files[i],he)

;----------- remove nans --------------
remove_nans, pre, junk, junk, nan_pos
pre[nan_pos[*]] = 0.0
remove_nans, data, junk, junk, nan_pos
data[nan_pos[*]] = 0.0


;-----------  Plot Image --------------

img = data - pre
mask = get_smask(he)
img  = (img /stdev(img))*mask
plot_image, img > (-0.5) < 3.0, title=he.date_obs

;--------- Restore Circle Fit ---------
restore, 'circle_params_' + he.date_obs+'.sav', /verb
set_line_color
xcenter = circle_fit_result[0]
ycenter = circle_fit_result[1]
plots, xcenter, ycenter, psym=1, color=5, symsize=2

circle_radius = circle_fit_result[2]
angles = dindgen(360) + 1.0
x_sim = xcenter + circle_radius*cos(!DTOR*angles)
y_sim = ycenter + circle_radius*sin(!DTOR*angles)
;oplot, x_sim, y_sim, color=5, linestyle=2, thick=2
pixrad = he.rsun/he.cdelt1 ;pixels per radius


;-----------Draw radius that passes through circle centre -----------
sun = scc_SUN_CENTER(he)
hyp = sqrt((xcenter - sun.xcen)^2.0 + (ycenter - sun.ycen)^2.0)
op = sqrt((xcenter - xcenter)^2.0 + (ycenter - sun.ycen)^2.0)
angle = asin( op/hyp )
angle = 360*!DTOR - angle
plots, sun.xcen, sun.ycen, psym=2, color=5, symsize=2
rhos = findgen(300)
xline = COS(angle) * rhos + sun.xcen
yline = SIN(angle) * rhos + sun.ycen
plots, xline, yline, color=5


;---------- Plot circle radius, apex and shock front -------------

rhos = (findgen(100)*(circle_radius)/99.0 )
circ_radx = cos(angle)*rhos + xcenter
circ_rady = sin(angle)*rhos + ycenter
plots, circ_radx, circ_rady, color=3, linestyle=0, thick=2

circ_x = cos(angle)*circle_radius + xcenter
circ_y = sin(angle)*circle_radius + ycenter
plots, circ_x, circ_y, color=3, psym=1, symsize=2

plots, x_so, y_so, psym=1, color=3, symsize=2

;---------- Calculate Mach -------------
delR = sqrt((circ_x - x_so)^2.0 + (circ_y - y_so)^2.0) ;Stand-off distance
gam = 4.0/3.0
del = delR/circle_radius
mach = sqrt(1 + (1.24*del - (gam-1)/(gam+1))^(-1.0))

print,'------------------------------------'
print,''
print,'CME radius of curvature:' +string(circle_radius/pixrad)+' R/Rsun'
print,'Stand-off dist: '+string(delR/pixrad)+' R/Rsun'
print,'Mach Number: '+string(mach)
print,''
print,'------------------------------------'
set_line_color
legend, ['Mach Number: '+string(mach, format='(f3.1)')], textcolors=[1], charsize=2.0, box=0
;xyouts, 0.34, 0.34, 'Mach Number: '+string(mach, format='(f3.1)'), /normal, charsize=1.5
END
x2png,'plot_wl_mach_imgs_no_circ.png'



END