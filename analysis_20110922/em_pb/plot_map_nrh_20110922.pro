pro plot_map_nrh_20110922

cd,'/Users/eoincarley/Data/22sep2011_event/LASCO_C2/L0.5/L1'
files=findfile('*.fts')
;FOR i=5,5:n_elements(files)-1 do begin
cd,'/Users/eoincarley/Data/22sep2011_event/LASCO_C2/L0.5/L1'
file = files[4]
c2_data = readfits(file,c2_hdr) 
pre_data = readfits('24373725.fts',pre_hdr)
c2_bs_data = c2_data - pre_data
junk = lasco_readfits(file,c2_hdr_struc)
print,'C2 time: '+anytim(c2_hdr_struc.date_obs,/yoh)

tstart = anytim(anytim(c2_hdr_struc.date_obs,/utim)-60.0*5.0,/yoh,/trun,/time_only)
tend   = anytim(anytim(c2_hdr_struc.date_obs,/utim)+60.0*5.0,/yoh,/trun,/time_only)
cd,'/Users/eoincarley/data/22sep2011_event/nrh'
read_nrh,'nrh2_1509_h70_20110922_081556c06_i.fts', nrh_hdr, nrh_data, hbeg=tstart, hend=tend
index2map, nrh_hdr, nrh_data, nrh_struc  
nrh_struc_hdr = nrh_hdr

nrh_times = nrh_hdr.date_obs
index_nrh = closest(anytim(nrh_times,/utim), anytim(c2_hdr_struc.date_obs,/utim)     )






loadct,39
!p.color=0
!p.background=255

window,2,xs=800,ys=800
;****************Create Composite Image******************



;*********MASK THE NRH DATA*************
nrh_data = nrh_data[*,*,index_nrh]


loadct,5
!p.color=255
!p.background=0
map_nrh = make_map(sigrange(nrh_data))
map_nrh.dx = 29.9410591125
map_nrh.dy = 29.9410591125
map_nrh.xc = 64 
map_nrh.yc = 64  
plot_map,map_nrh,/limb


cd,'/Users/eoincarley/data/22sep2011_event/nrh'
read_nrh,'nrh2_4450_h70_20110922_081556c06_i.fts', nrh_hdr, nrh_data, hbeg=tstart, hend=tend
index2map, nrh_hdr, nrh_data, nrh_struc  
nrh_struc_hdr = nrh_hdr

nrh_times = nrh_hdr.date_obs
index_nrh = closest(anytim(nrh_times,/utim), anytim(c2_hdr_struc.date_obs,/utim)     )


nrh_data = nrh_data[*,*,index_nrh]
rsun = nrh_struc_hdr[index_nrh].solar_r
pixrad_nrh = nrh_struc_hdr[index_nrh].solar_r ;rsun/nrh_struc_hdr[0].cdelt1
;;suncenter=get_sun_center(nrh_struc_hdr)
index = circle_mask(nrh_data, 64.0, 64.0, 'ge', pixrad_nrh*2.1)
nrh_data[index] = 0.0

map_nrh = make_map(nrh_data)
map_nrh.dx = 29.9410591125
map_nrh.dy = 29.9410591125
map_nrh.xc = 64 
map_nrh.yc = 64  
levels=(dindgen(21.0)*(7.0e6 - 4.5e6)/20.0)+4.5e6
plot_map,map_nrh,/overlay,/cont,levels=levels,lcolor=2

x2png,anytim(c2_hdr_struc.date_obs,/yoh)




;*******************************************************;	
;		Now show location of the radio bursts			;

plot_freq_height,222.95e6,150
plot_freq_height,75.45e6,150

plot_freq_height,15.00e6,150

plot_freq_height,25.00e6,240
plot_freq_height,40.00e6,240


stop
	
END


pro plot_freq_height,f,color
loadct,39

rad_sim = dindgen(10001)*(5.0)/10000.0
ne_sim = dblarr(n_elements(rad_sim))
  ne_sim[*] = 10.0^(4.0 + 41.3955*exp( -2.12782*rad_sim[*]^0.494212   ) )
;   see plot_em_and_pb_density for this equatione

n_value = (f/8980.0)^2.0

result = interpol(rad_sim, ne_sim, n_value)
loc = result*960.0 ;960 arcsecs to 1Rsun

;get x and y coords (in arcsecs)
angles = (dindgen(101)*(40.0+40.0)/100.0 )-40.0
x = dindgen(n_elements(angles))
y = dindgen(n_elements(angles))
x = loc*cos(!DTOR*angles)*(-1.0)
y = loc*sin(!DTOR*angles)
plots,x,y,linestyle=0,thick=2,color=color

END