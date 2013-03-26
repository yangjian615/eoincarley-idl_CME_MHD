pro wl_shock_mach_20110922

cd,'/Users/eoincarley/Data/22sep2011_event/secchi/COR1/b/24540411/l1_new'
files = findfile('*.fts')
i=13
pre = sccreadfits(files[5],he_pre);usually 5
data = sccreadfits(files[i],he)

;----------- remove nans --------------
remove_nans, pre, junk, junk, nan_pos
pre[nan_pos[*]] = 0.0
remove_nans, data, junk, junk, nan_pos
data[nan_pos[*]] = 0.0

pre = scc_calc_cme_mass(pre, he_pre, /all, pos=40.0)
data = scc_calc_cme_mass(data, he, /all, pos=40.0)
;----------- plot_image ---------------
loadct,0
window, 0, xs=900, ys=900
img = data - pre
mask = get_smask(he)
img  = (img /stdev(img))*mask
img = smooth(img,2)
plot_image, sobel(img) > (0.0) < 2.0, title=he.date_obs, xr=[300,500], yr=[100,300]

;----------- Get points for radius of curvature ----------------;
point, cme_x, cme_y, /data, color=0

window,1
plot, cme_x, cme_y, psym=1, /xs, /ys, xr=[300, 450], yr=[130, 250]
circle_fit_result = fit_circle(cme_x, cme_y, /radius_fix)
xcenter = circle_fit_result[0]
ycenter = circle_fit_result[1]
circle_radius = circle_fit_result[2]
angles = dindgen(360) + 1.0
x_sim = xcenter + circle_radius*cos(!DTOR*angles)
y_sim = ycenter + circle_radius*sin(!DTOR*angles)
set_line_color
oplot, x_sim, y_sim, color=5
pixrad = he.rsun/he.cdelt1 ;pixels per radius
print,''
print,'CME radius of curvature:' +string(circle_radius/pixrad)
print,''


wset,0
loadct,0
plot_image, img > (0.0) < 2.0, title=he.date_obs, xr=[300,500], yr=[100,300]
set_line_color
oplot, x_sim, y_sim, color=5, linestyle=2
plots, xcenter, ycenter, psym=1, color=5, symsize=3

;-----------Draw radius that passes through circle centre -----------
sun = scc_SUN_CENTER(he)
hyp = sqrt((xcenter - sun.xcen)^2.0 + (ycenter - sun.ycen)^2.0)
op = sqrt((xcenter - xcenter)^2.0 + (ycenter - sun.ycen)^2.0)
angle = asin( op/hyp )
angle = 360*!DTOR - angle
plots, sun.xcen, sun.ycen, psym=1, color=5, symsize=3

rhos = findgen(300)
xline = COS(angle) * rhos + sun.xcen
yline = SIN(angle) * rhos + sun.ycen
plots, xline, yline, color=5


;---------- Choose the stand-off distance -------------
circ_x = cos(angle)*circle_radius + xcenter
circ_y = sin(angle)*circle_radius + ycenter
plots, circ_x, circ_y, color=3, psym=1, symsize=3

print,''
print,'Chose stand-off distance:'
print,''
cursor, x_so, y_so, /data
delR = sqrt((circ_x - x_so)^2.0 + (circ_y - y_so)^2.0) ;Stand-off distance

wset,0
loadct,0
plot_image, img > 0.0 < 3.0, title=he.date_obs, xr=[300,500], yr=[100,300]
set_line_color
oplot, x_sim, y_sim, color=5, linestyle=2
plots, xcenter, ycenter, psym=1, color=5, symsize=3
plots, x_so, y_so, psym=1, color=5, symsize=3
plots, xline, yline, color=5
plots, circ_x, circ_y, color=3, psym=1, symsize=3

print,''
print,'Stand-off distance: '+string(delR/pixrad)
print,''

;--------- Calculate Mach -------------
gam = 5.0/3.0
del = delR/circle_radius
mach = sqrt(1 + (1.24*del - (gam-1)/(gam+1))^(-1.0))
print,''
print,'Mach Number: '+string(mach)
print,''


;Ma = Ms/sqrt(2.0/(gam*p_beta))
;--------------------------------------
cme_points = fltarr(2,n_elements(cme_x))
cme_points[0,*] = cme_x
cme_points[1,*] = cme_y
;save, cme_points, circle_fit_result, x_so, y_so, filename='circle_params_' + he.date_obs+'.sav'
stop
END