pro nrh_source_position_20110922_v3, choose_points=choose_points, AIA_IMAGE=AIA_IMAGE, old_linear_fit=old_linear_fit

;v3 got rid of plotting routine at the end
;
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



END

