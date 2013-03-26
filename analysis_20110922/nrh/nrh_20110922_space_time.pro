pro nrh_20110922_space_time


t1 = anytim(file2time('20110922_103000'), /yoh, /trun, /time_only)
t2 = anytim(file2time('20110922_110000'), /yoh, /trun, /time_only)

	
freq = '1509'
cd,'/Users/eoincarley/data/22sep2011_event/nrh'
read_nrh,'nrh2_'+freq+'_h70_20110922_081556c06_i.fts', nrh_hdr, nrh_data, hbeg=t1, hend=t2
index2map, nrh_hdr, nrh_data, nrh_struc  
nrh_struc_hdr = nrh_hdr
nrh_times = nrh_hdr.date_obs
stop
st_nrh = fltarr(nrh_hdr[0].naxis1, n_elements(nrh_times))

!p.multi=[0,1,2]
FOR i=0, n_elements(nrh_times)-1 DO BEGIN	

	nrh_image = nrh_data[*,*,i]
	plot_image, nrh_image
	
	nrh_slice = avg(nrh_image,0)
	plot, nrh_slice
	st_nrh[*,i]=nrh_slice
ENDFOR
!p.multi=[0,1,1]
plot_image,sigrange(transpose(st_nrh))
stop

END