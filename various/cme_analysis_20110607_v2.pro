pro cme_analysis_20110607_v2

; This is to get the height and times of the cme leading edges
; To see the plotting script for these height times see cme_ht_analysis_20110607
; Use cor1 and cor2 total brightness to make runninf difference images.
; Point and click to get front position
; Use the cor2 double images also.

;Firstly, the cor1 images.
cd,'/Users/eoincarley/Data/secchi_l1/20110607/cor1'
files = findfile('*.fts')
data = sccreadfits(files[0], he_pre)

data_cube_rd = dblarr(he_pre.naxis1, he_pre.naxis2, n_elements(files)-1)
mask = get_smask(he_pre)
;Create image cube
window,0
window,1
window,2

min_val = -1.0e-10 ;cor1
max_val = 0.3e-9

;min_val = -1.0e-11 ;cor2 total B from normals
;max_val = 0.3e-10

;min_val = -40.0 ;cor2 double images
;max_val = 40.0 

height_time = dblarr(3,n_elements(files)-1)
FOR i=1, n_elements(files)-1 DO BEGIN

	wset,0
	loadct,3
	data = sccreadfits(files[i], he)
	;data_cube[*,*,i] = data
	data_pre = sccreadfits(files[i-1], he_pre)
	;data_cube_rd[*,*,i-1] = (data_cube[*, *, i] - data_cube[*, *, i-1])*mask
	data_cube_rd[*,*,i-1] = (data - data_pre)*mask
	plot_image, bytscl(data_cube_rd[*,*,i-1], min_val, max_val), title=he.date_obs
	sun = scc_SUN_CENTER(he)
	pixrad = he.rsun/he.cdelt1
	;r1 = SQRT((x-sun.xcen)^2.0 +(y-sun.xcen)^2.0)/pixrad
	
	r1 = pixrad*15.0
	rads = dindgen(1001)*(r1)/1000.0
	prof = dblarr(n_elements(rads), 10.0)
	
	
	data_cube_rd_scl = filter_image(bytscl(data_cube_rd[*,*,i-1], min_val, max_val),/median)
	FOR j=115, 125-1 DO BEGIN
		t1=j
		xs = COS((t1+90.0)*!DTOR) * rads + sun.xcen
    	ys = SIN((t1+90.0)*!DTOR) * rads + sun.ycen
        set_line_color
        plots, xs, ys, color=5
        prof[*, j-115] = INTERPOLATE(data_cube_rd_scl, xs, ys)
    ENDFOR
    prof_sm = smooth(avg(prof,1),30)
    derivative = smooth(deriv(rads,prof_sm),30)
    ;wset,1
    ;plot,rads, prof_sm, yr=[0,400], charsize=2
    
    
    front_pix = find_points(rads,derivative)
    print,'				'
	print,front_pix[0]/pixrad
	print,'				'
	
	wset,1
	plot_image, bytscl(data_cube_rd[*,*,i-1], min_val, max_val), title=he.date_obs
	t1=120.0
	xs = COS((t1+90.0)*!DTOR) * (front_pix[0]) + sun.xcen
    ys = SIN((t1+90.0)*!DTOR) * (front_pix[0]) + sun.ycen
    set_line_color
    plots, xs, ys, color=5, psym=1, symsize=3, thick=3
    
    height_time[0,i-1] = anytim(he.date_obs, /utim)
    height_time[1,i-1] = front_pix[0]/pixrad
    height_time[2,i-1] = front_pix[1]/pixrad

ENDFOR

info = 'Made using cme_analysis_20110607_v2'
save,height_time,info,filename='COR1_ht_20110607.sav'

END

function find_points, rads, derivative
wset,2
plot, rads, derivative, charsize=1.5, yr=[-10, 10]
point,x,y,/data

index0 = closest(rads,x[0])
index1 = closest(rads,x[1])
window,3,xs=300,ys=300
rads_sec = rads[index0:index1]
deriv_sec = derivative[index0:index1]
plot, rads_sec, deriv_sec, charsize=1.5,/xs,/ys
Result = GAUSSFIT( rads_sec, deriv_sec, a, nterms=4)

rad_sim = (dindgen(100)*(rads_sec[n_elements(rads_sec)-1] - rads_sec[0])/99.0 ) + rads_sec[0]
z = dblarr(n_elements(rad_sim))
z[*] = (rad_sim[*] - a[1])/a[2]
fit = dblarr(n_elements(rad_sim))
fit = a[0]*exp((-1.0*z[*]^2.0)/2.0) + a[3]
set_line_color
oplot,rad_sim,fit,color=3

second_deriv = deriv(rad_sim,fit)
;window,4
;plot,rad_sim,second_deriv,color=3

index_max = where(second_deriv eq max(second_deriv))
index_min = where(deriv_sec eq min(deriv_sec))

rad_fwhm = [rad_sim[index_min], a[2]]

return, rad_fwhm
END










