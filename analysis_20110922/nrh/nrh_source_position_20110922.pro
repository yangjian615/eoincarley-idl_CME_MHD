pro nrh_source_position_20110922, choose_points=choose_points

print,'keyword_set'

cd,'/Users/eoincarley/Data/22sep2011_event/NRH'

restore,'s_position_20110922.sav'
tstart = anytim(file2time('20110922_103500'),/yoh,/trun,/time_only)
tend   = anytim(file2time('20110922_110000'),/yoh,/trun,/time_only)
read_nrh,'nrh2_1509_h70_20110922_081556c06_i.fts', nrh_hdr, nrh_data, hbeg=tstart, hend=tend
index2map, nrh_hdr, nrh_data, nrh_struc  
nrh_struc_hdr = nrh_hdr
nrh_times = nrh_hdr.date_obs

IF keyword_set(choose_points) THEN BEGIN
window,2,xs=800,ys=800
loadct,3

angle_position = dblarr(n_elements(nrh_times))
intensity = dblarr(n_elements(nrh_times))
FOR i=0.0, n_elements(nrh_times)-1 DO BEGIN
	loadct,3
	index_nrh=i
	nrh_data_image = nrh_data[*,*,index_nrh]
    plot_image,nrh_data_image,title=nrh_times[index_nrh],charsize=2
	tvcircle, (nrh_struc_hdr[index_nrh].SOLAR_R), $
	64.0, 64.0, 254, /data,color=255,thick=1
	levels=(dindgen(7.0)*(max(nrh_data_image) - max(nrh_data_image)*0.5)/6.0)+max(nrh_data_image)*0.5
    contour,nrh_data_image,levels = levels,/overplot
    
    set_line_color
    plots,source_position[0,i],source_position[1,i]
    t1 = ATAN((source_position[0,i]-64.0),(source_position[1,i]-64.0))*!RADEG
	IF (t1 LT 0)   THEN t1=t1+360.
    IF (t1 GT 360)   THEN t1=t1-360.
    t1 = 360-t1		; convert to position angles
	
	pixrad = nrh_hdr.solar_r/nrh_hdr.cdelt1
	r1 = sqrt((source_position[0,i]-64.0)^2.0 + (source_position[1,i]-64.0)^2.0)
	print,'Heliocentric dist of emission: '+string(r1/nrh_hdr.solar_r)
	rads = dindgen(101)*(r1)/100.0
	xs = COS((t1+90.0)*!DTOR) * rads + 64.0
    ys = SIN((t1+90.0)*!DTOR) * rads + 64.0
    plots,xs,ys,color=5
	print,'Angle: '+string(t1)
    angle_position[i] = t1+90.0
    intensity[i] = total(nrh_data_image)
    
    
    rads = dindgen(101)*(nrh_hdr.solar_r)/100.0
	xs_n = COS((0.0+90.0)*!DTOR) * rads + 64.0
    ys_n = SIN((0.0+90.0)*!DTOR) * rads + 64.0
    plots, xs_n, ys_n, color=5
    ;save, nrh_times, angle_position, filename = 'NRH_150MHz_source_angle_t.sav'
ENDFOR
ENDIF ELSE BEGIN
	restore,'NRH_150MHz_source_angle_t.sav'
ENDELSE
save, nrh_times, intensity, filename='intensity_v_time_450MHz.sav'

loadct,39
!p.color=0
!p.background=255
!p.thick=4
!x.thick=4
!y.thick=4

set_plot,'ps'
device,filename = 'Figure3_NRH_angle_time.ps',$
	/color,/inches, /encapsulate ,$
	ysize=7,xsize=6, bits_per_pixel=8, xoffset=0, yoffset=0
	
	plot_t1 = anytim(file2time('20110922_103500'), /utim)
	plot_t2 = anytim(file2time('20110922_105500'), /utim)
utplot, anytim(nrh_times, /utim), angle_position - 0.0, ytitle='Postion angle ('+cgSymbol('deg')+')',$
/xs, /ys, charsize=1.5, psym=1, position=[0.14, 0.1, 0.95, 0.99],$
xr=[plot_t1, plot_t2], yr=[90.0,140.0], tick_unit=5.0*60.0, charthick=4
set_line_color
legend,['150.9 MHz Source','EUV Wave GC1','EUV Wave GC2','EUV Wave GC3',$
'Linear fit (NRH)'],$
linestyle=[0,0,0,0,0],psym=[1,2,7,4,0],$
charsize=1.2 ,box=0, color=[0,5,3,4,0], /bottom, /right
;GC1 = 140 deg great circle
;GC2 = 150 deg great circle
;GC3 = 160 deg great circle



;Only fit the line between radio burst times: 10:39 - 10:56 UT
index1 = closest(anytim(nrh_times,/utim), anytim(file2time('20110922_103900'), /utim))
index2 = closest(anytim(nrh_times,/utim), anytim(file2time('20110922_105600'), /utim))

times_in_ut = anytim(nrh_times[index1:index2], /utim)
times_in_sec = times_in_ut[*] - times_in_ut[0]

angle_position = angle_position[index1:index2]


result = linfit(times_in_sec, angle_position)
time_sim = (dindgen(101)*(times_in_sec[n_elements(times_in_sec)-1]$
- times_in_sec[0])/100.0) + times_in_sec[0]
angle_sim = result[0] + time_sim*result[1]
oplot, times_in_ut[0]+time_sim, angle_sim -90.0

rsun = 6.955e5
harmonic = 2.0

n_e = ((150.9/harmonic)*1.0e6/9000.0)^2.0
rad = (dindgen(1000.0)*(5.0 -1.0)/999.0) +1.0 
n_e_r = dblarr(n_elements(rad))
n_e_r[*] = 7.3e8*exp( -1.0*(rad[*] - 1.0)/0.12 ) + $
	  		1.3e6*exp( -1.0*(rad[*] - 1.0)/0.85 )   ;TCD model
	  	
radius = interpol(rad, n_e_r, n_e)

;radius = 4.32/( alog10(n_e/4.2e4) )  ;Newkirk
rad_km = radius*rsun
NRH_speed = (result[1]*!DTOR)*rad_km
print,'NRH angular velocity: '+string(result[1])+' deg/s = '+string(result[1]*!DTOR)+' rad/s'
print,'NRH source speed '+string(NRH_speed)+' km/s'
print,' '

residuals = dblarr(n_elements(angle_position))
FOR i=0, n_elements(angle_position)-1 DO BEGIN
	data_a = angle_position[i]
	time = times_in_sec[i]
	
	data_a_sim = interpol(angle_sim,time_sim, time)
	residuals[i] = abs(data_a_sim - data_a)
	
ENDFOR
print,mean(residuals)

stop

plot_euv_wave_angle, '140', 2, 5
plot_euv_wave_angle, '150', 7, 3
plot_euv_wave_angle, '160', 4, 4
;plot_euv_wave_angle, '170', 5, 5
;plot_euv_wave_angle, '180', 6, 6

loadct,0

cd,'/Users/eoincarley/Data/22sep2011_event/AIA'
aia_files = findfile('aia*.fits')
read_sdo,aia_files[0], he_aia_pre, data_aia_pre

;           Read in data proper AIA         
mreadfits_header, aia_files, ind, only_tags='exptime'
f = aia_files[where(ind.exptime gt 1.)]
restore,'22_09_2011_xy_pulse_distance_160_arc.sav',/verb
read_sdo, f[1], he_aia, data_aia
read_sdo, f[0], he_aia_pre, data_aia_pre
data_aia_bs = data_aia/he_aia.exptime - data_aia_pre/he_aia_pre.exptime
map_aia = make_map( smooth(data_aia_bs,10) )
map_aia.dx = he_aia.CDELT1	
map_aia.dy = he_aia.CDELT2
map_aia.xc = he_aia.SAT_Y0
map_aia.yc = he_aia.SAT_Z0 

plot_map, map_aia, dmin = -10, dmax = 10, /limb, position=[0.15, 0.6, 0.58, 0.97], /normal,$
/noerase, /noaxes, title=' '

set_line_color
!p.thick=2
plots,x,y, color=4, thick=3

restore,'22_09_2011_xy_pulse_distance_150_arc.sav',/verb
plots,x,y, color=3, thick=3

restore,'22_09_2011_xy_pulse_distance_140_arc.sav',/verb
plots,x,y, color=5, thick=3




cd,'/Users/eoincarley/Data/22sep2011_event/NRH'

device,/close
set_plot,'x'



END

pro plot_euv_wave_angle, angle, psym, color


cd,'/Users/eoincarley/Data/22sep2011_event/AIA'
restore,'22_09_2011_xy_pulse_distance_'+angle+'_arc.sav',/verb
remove_nans,  pulse_x, pulse_x_n, indeces
remove_nans,  pulse_y, pulse_y_n, indeces


angle_eit = dblarr(n_elements(pulse_x_n))
FOR i=0, n_elements(pulse_x_n)-1 DO BEGIN
	angle = ATAN(pulse_x_n[i], pulse_y_n[i])*!RADEG
	IF (angle LT 0)   THEN angle = angle + 360.
    IF (angle GT 360)   THEN angle = angle -360.
    angle = 360.0 - angle
    angle_eit[i] = angle
ENDFOR
set_line_color
oplot, time[indeces], angle_eit, psym=psym, color = color

END

