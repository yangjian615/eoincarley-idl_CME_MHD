pro create_composite_img

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
index_nrh = closest(anytim(nrh_times,/utim), anytim(c2_hdr_struc.date_obs,/utim)  )






loadct,39
!p.color=0
!p.background=255
window,2,xs=800,ys=800

;****************Create Composite Image******************

c2_data = c2_bs_data
cd,'/Users/eoincarley/Data/22sep2011_event/LASCO_C2/L0.5/L1'

;*********				C2 DATA				*************
junk= lasco_readfits('24373729.fts',hdr) 
rsun = get_solar_radius(hdr)
pixrad=rsun/hdr.cdelt1
suncenter=get_sun_center(hdr)
index = circle_mask(c2_data, suncenter.xcen, suncenter.ycen, 'le',pixrad*2.1)
c2_data[index] = 0.0

mapc2 = make_map(bytscl(c2_data,-5.0e-10,1.5e-9)  )
mapc2.dx = 11.9
mapc2.dy = 11.9
mapc2.xc = 14.4704
mapc2.yc = 61.2137 
loadct,3
plot_map,mapc2,/limb,/notitle,/nolabels,fov = [50.0,50.0],center = [-1500.0,0.0]
loadct,39
xyouts,0.17,0.17,'LASCO C2 '+anytim(c2_hdr_struc.date_obs,/yoh,/trun),color=255,/normal,charsize=2.0,charthick=1
;xyouts,0.61,0.31,'NRH 150.9 MHz',color=255,/normal,charsize=1.2,charthick=1
;xyouts,0.53,0.28,'Contours: NRH 445.9 MHz ',color=255,/normal,charsize=1.2,charthick=1


loadct,3
stretch,0,200
cd,'/Users/eoincarley/Data/22sep2011_event/SWAP'
data_swap = readfits('swap_lv1_20110922_104442.fits',hdr_swap)
result = congrid(gauss_2d(10,10),1024,1024)
result = (smooth(result,20)/max(smooth(result,5)) )*1000.0


data_swap = data_swap/result

ppixrad=955.986/3.16226783969

index = circle_mask(data_swap, 516.090, 504.480, 'le',pixrad)
result[index] = 1.0
;shade_surf,result,charsize=2


map_swap = make_map(sigrange(data_swap))
map_swap.dx = 3.16
map_swap.dy = 3.16
map_swap.xc = 7.05902659038
map_swap.yc = 0.00242213308144
plot_map,map_swap,/composite,/average






stop



;*********                MASK THE NRH DATA           *************
nrh_data = nrh_data[*,*,index_nrh]
rsun = nrh_struc_hdr[index_nrh].solar_r
pixrad_nrh = nrh_struc_hdr[index_nrh].solar_r ;rsun/nrh_struc_hdr[0].cdelt1
;;suncenter=get_sun_center(nrh_struc_hdr)
index = circle_mask(nrh_data, 64.0, 64.0, 'ge', pixrad_nrh*2.1)
nrh_data[index] = 0.0

loadct,5
!p.color=255
!p.background=0
map_nrh = make_map(nrh_data)
map_nrh.dx = 29.9410591125
map_nrh.dy = 29.9410591125
map_nrh.xc = 64 
map_nrh.yc = 64  
levels=(dindgen(7.0)*(max(nrh_data) - max(nrh_data)*0.7)/6.0)+max(nrh_data)*0.7
loadct,39
plot_map,map_nrh,/overlay,/cont,levels=levels,lcolor=200
;plot_map,map_nrh,/composite,/average,/interlace





;***********		Second NRH      ****************

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



plot_helio,file2time('20110922_104600'),/over,gstyle=1,gthick=1,gcolor=150,grid_spacing=10.0
levels=(dindgen(7.0)*(max(nrh_data) - max(nrh_data)*0.7)/6.0)+max(nrh_data)*0.7
plot_map,map_nrh,/overlay,/cont,levels=levels,lcolor=5

x2png,anytim(c2_hdr_struc.date_obs,/yoh)




;*******************************************************;	
;		Now show location of the radio bursts			;

loadct,39
;plot_freq_height,222.95e6,result,170
;xyouts,0.415,0.56,'445.9 MHz ('+string(result,FORMAT='(f4.2)')+') R!Lsun!N',$
;color=160,/normal,charsize=1.2,charthick=1

plot_freq_height,60.45e6,result,170
;xyouts,0.39,0.59,'150.9 MHz ('+string(result,FORMAT='(f4.2)')+') R!Lsun!N',$
;color=160,/normal,charsize=1.2,charthick=1

plot_freq_height,20.0e6,result,170
;xyouts,0.35,0.62,'30.0 MHz ('+string(result,FORMAT='(f4.2)')+') R!Lsun!N',$
;color=160,/normal,charsize=1.2,charthick=1
	
END


pro plot_freq_height,f,result,color

rad_sim = (dindgen(10001)*(5.0 - 1.0)/10000.0 )+1.0
ne_sim = dblarr(n_elements(rad_sim))
ne_sim[*] = 7.3e8*exp( -1.0*(rad_sim[*] - 1.0 )/0.12) + $
  			1.3e6*exp( -1.0*(rad_sim[*] - 1.0 )/0.85) ;fit using hydrostatic equilibrium models
  									
     ;10.0^(4.0 + 41.3955*exp( -2.12782*rad_sim[*]^0.494212   ) ) ; this is the old fit
	 ;see plot_em_and_pb_density for these equations

n_value = (f/8980.0)^2.0

result = interpol(rad_sim, ne_sim, n_value)
loc = result*960.0 ;960 arcsecs to 1Rsun

;get x and y coords (in arcsecs)
angles = (dindgen(101)*(360.0+0.0)/100.0 )-0.0
x = dindgen(n_elements(angles))
y = dindgen(n_elements(angles))
x = loc*cos(!DTOR*angles)*(-1.0)
y = loc*sin(!DTOR*angles)
plots,x,y,linestyle=0,thick=1.5,color=color

END