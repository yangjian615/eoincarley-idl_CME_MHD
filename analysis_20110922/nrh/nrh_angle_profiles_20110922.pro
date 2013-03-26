pro nrh_angle_profiles_20110922

t1 = anytim(file2time('20110922_103800'), /yoh, /trun, /time_only)
t2 = anytim(file2time('20110922_110000'), /yoh, /trun, /time_only)

	
	freq = '1509'
	cd,'/Users/eoincarley/data/22sep2011_event/nrh'
	read_nrh,'nrh2_'+freq+'_h70_20110922_081556c06_i.fts', nrh_hdr, nrh_data, hbeg=t1, hend=t2
	index2map, nrh_hdr, nrh_data, nrh_struc  
	nrh_struc_hdr = nrh_hdr
	nrh_times = nrh_hdr.date_obs


	loadct,3
	;plot_image,nrh_image
	;tvcircle, (nrh_hdr[0].solar_r), 64.0, 64.0, 254, /data,color=255,thick=1
	
	angle=( dindgen(101.0)*(170.0 - 10.0)/100.0 ) + 10.0
	j=angle+90.0
  	eta = j*!DTOR
  	
  	;Get average of al angular profiles at a radius of just under
  	; 1 R_sun to ~1.5 Rsun
    rho1 = nrh_hdr[0].solar_r -10.0
    rho2 = 2.0*nrh_hdr[0].solar_r


all_mean_angle_profiles = dblarr(n_elements(nrh_times), n_elements(angle) )
all_angle_profiles = dblarr(n_elements(angle), rho2 - rho1, n_elements(nrh_times))

FOR p=0,n_elements(nrh_times)-1 DO BEGIN	

	nrh_image = nrh_data[*,*,p]
	angle_profiles = dblarr(n_elements(angle),rho2 - rho1)
	FOR k=rho1, rho2 -1.0 DO BEGIN
		print,k
    	xs = COS(eta) * k + 64.0
    	ys = SIN(eta) * k + 64.0
    	;rhos = rhos/nrh_hdr[0].solar_r		;now in solar radii
    	origline = INTERPOLATE(nrh_image,xs,ys)	; do bilinear interpolation to pick up the line
    	angle_profiles[*, k - 22.0] = origline[*]
    	;plots,xs,ys,color=255
    ENDFOR
    all_angle_profiles[*, *, p] = angle_profiles

    
    mean_angle_profiles = dblarr(n_elements(angle))
    FOR i=0, n_elements(angle)-1 DO BEGIN
    	mean_angle_profiles[i] = mean(angle_profiles[i,*])
    ENDFOR	
    all_mean_angle_profiles[p,*] = mean_angle_profiles
ENDFOR    
    rho1 = nrh_hdr[0].solar_r -10.0
    rho2 = 2.0*nrh_hdr[0].solar_r

all_angle_profiles_stacked = dblarr( abs(rho2 - rho1)*n_elements(nrh_times), n_elements(angle) )
FOR i = 0, n_elements(all_angle_profiles[0,0,*])-1 DO BEGIN
	all_angle_profiles_stacked[i*abs(rho2 - rho1): (i+1)*abs(rho2 - rho1)-1, * ]  =  transpose(all_angle_profiles[* , * , i])
ENDFOR
wset,0
loadct,5
plot_image,bytscl( alog10(congrid(all_angle_profiles_stacked,1000,500)), 7, 9)

stop
	
END