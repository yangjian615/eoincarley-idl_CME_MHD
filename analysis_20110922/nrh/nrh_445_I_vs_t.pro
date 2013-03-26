pro nrh_445_I_vs_t

cd,'/Users/eoincarley/Data/22sep2011_event/NRH'

tstart = anytim(file2time('20110922_103500'),/yoh,/trun,/time_only)
tend   = anytim(file2time('20110922_110000'),/yoh,/trun,/time_only)
read_nrh,'nrh2_4450_h70_20110922_081556c06_i.fts', nrh_hdr, nrh_data, hbeg=tstart, hend=tend
index2map, nrh_hdr, nrh_data, nrh_struc  
nrh_struc_hdr = nrh_hdr
nrh_times = nrh_hdr.date_obs

window,2,xs=800,ys=800
loadct,3

intensity = dblarr(n_elements(nrh_times))
FOR i=0.0, n_elements(nrh_times)-1 DO BEGIN
	loadct,3
	index_nrh=i
	nrh_data_image = nrh_data[*,*,index_nrh]
    plot_image, nrh_data_image, title=nrh_times[index_nrh], charsize=2
	tvcircle, (nrh_struc_hdr[index_nrh].SOLAR_R), $
	64.0, 64.0, 254, /data,color=255,thick=1
	levels=(dindgen(7.0)*(max(nrh_data_image) - max(nrh_data_image)*0.5)/6.0)+max(nrh_data_image)*0.5
    contour,nrh_data_image,levels = levels,/overplot
    intensity[i] = total(nrh_data_image)
	wait,0.05
ENDFOR
utplot, anytim(nrh_times, /utim), intensity, /xs, /ys, /ylog, charsize=1.5

save, nrh_times, intensity, filename='intensity_v_time_450MHz.sav'

END