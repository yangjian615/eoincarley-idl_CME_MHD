pro cor1_analysis_20110922_v2,create_rtheta_space = create_rtheta_space



cd,'/Users/eoincarley/Data/22sep2011_event/secchi/COR1/b/24540411/l1'
files = findfile('*.fts')
n_points_rad = 600
angle1 = 0.0
angle2 = 360.0
nsteps = 20.0
nrads = abs(angle2 - angle1)/nsteps
	
IF keyword_set(create_rtheta_space) THEN BEGIN
  loadct,3
  window,0,xs=700,ys=700
    
  
  profiles_c2 = dblarr(nrads, n_points_rad)
  data_cube = dblarr(nrads, n_points_rad, n_elements(files)-1)
  r_theta_t = dblarr(3,19,6)
  
	FOR j=14,15 DO BEGIN
	  data = sccreadfits(files[j],he)
      pre_event = sccreadfits(files[0],he_pre)
	  data_bs = data - pre_event
	  ;data_bs_scl = smooth(bytscl(data_bs,1e-10,5e-10),2)
	 
	  rsun = get_solar_radius(he_pre)
	  pixrad=rsun/he.cdelt1
	  sun = scc_SUN_CENTER(he_pre)
	  index = circle_mask(data_bs, sun.xcen, sun.ycen, 'le', pixrad*1.4)
	  data_bs[index] = 0.0
	  index = circle_mask(data_bs, sun.xcen, sun.ycen, 'ge', pixrad*4.1)
	  data_bs[index] = 0.0
	  data_bs_scl = (bytscl(data_bs,-1.0e-10, 3.0e-9))
	  ;data_bs_scl = sigrange(data_bs)
	  suncenter=GET_SUN_CENTER(he)	
	  sunradius=GET_SOLAR_RADIUS(he)
	  pixrad = he.rsun/he.cdelt1
	  rhos = dindgen(n_points_rad)
	  plot_image,data_bs_scl
	  tvcircle, (he.rsun/he.cdelt1), suncenter.xcen, suncenter.ycen, 254, /data, color=255, thick=2
	stop
	  
		FOR i = angle1, angle2, nsteps DO BEGIN
  			eta = (i+90.0)*!DTOR ;take 0 degrees to be solar north
  			xs = COS(eta) * rhos + suncenter.xcen
  			ys = SIN(eta) * rhos + suncenter.ycen
  			wset,0
  			plots,xs,ys,color=240
  			origline = INTERPOLATE(data_bs_scl,xs,ys) ;do bilinear interpolation to pick up the line

			rloc = dindgen(n_elements(xs))
   			rloc[*] = SQRT((xs[*]-suncenter.xcen)^2.+(ys[*]-suncenter.ycen)^2.)/pixrad
    			;wset,1
   	    		;index_neg = where(origline lt 0.0)
    			;origline[index_neg] = 0.0
    			;plot,rloc,smooth(origline,5),charsize=2
   		 	;profiles_c2[abs((i*(1.0/nsteps))-angle1*(1.0/nsteps)),*] = origline
   			print,'                     '
   			print,' Choose Radius'
   			print,'						'
   			cursor,x,y 	
   			pixrad = he.rsun/he.cdelt1
			sun = scc_SUN_CENTER(he)
   			r1 = SQRT((x-sun.xcen)^2+(y-sun.ycen)^2)/pixrad
   			
			r_theta_t[0, *, j-10] = anytim(he.date_obs,/utim)
			r_theta_t[1, abs(i-angle1)/nsteps, j-10] = r1
			print,i
			r_theta_t[2, abs(i-angle1)/nsteps, j-10] = i
		wait,0.3
		ENDFOR	
	
	  ;data_cube[*,*,j-1] = profiles_c2[*,*]
	ENDFOR
save,r_theta_t,'cor1_20110922_r_theta_t.sav'

  
ENDIF ELSE BEGIN
  print,'Nothing'
ENDELSE

END