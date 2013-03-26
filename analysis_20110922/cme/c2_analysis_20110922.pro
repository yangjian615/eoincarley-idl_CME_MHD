pro c2_analysis_20110922,create_rtheta_space = create_rtheta_space



cd,'/Users/eoincarley/Data/22sep2011_event/LASCO_C2/L0.5/L1'
files = findfile('*.fts')
n_points_rad = 600
angle1 = 90.0
angle2 = 270.0
nsteps = 0.1
nrads = abs(angle2 - angle1)/nsteps
	
IF keyword_set(create_rtheta_space) THEN BEGIN
  loadct,3
  window,0
    
  
  profiles_c2 = dblarr(nrads, n_points_rad)
  data_cube = dblarr(nrads, n_points_rad, n_elements(files)-1)

	FOR j=1,n_elements(files)-1 DO BEGIN
	  data = lasco_readfits(files[j],he)
      pre_event = lasco_readfits(files[j-1],he_pre)
	  data_bs = data - pre_event
	  ;data_bs_scl = smooth(bytscl(data_bs,1e-10,5e-10),2)
	 
	  rsun = get_solar_radius(he)
	  pixrad=rsun/he.cdelt1
	  sun = scc_SUN_CENTER(he)
	  index = circle_mask(data_bs, sun.xcen, sun.ycen, 'le', pixrad*2.2)
	  data_bs[index] = 0.0
	  
	  data_bs_scl = (bytscl(data_bs,-1.0e-11, 5.0e-11))
	  suncenter=GET_SUN_CENTER(he)	
	  sunradius=GET_SOLAR_RADIUS(he)
	  pixrad = he.rsun/he.cdelt1
	  rhos = dindgen(n_points_rad)
	  
	  plot_image,data_bs_scl
	  tvcircle, (he.rsun/he.cdelt1), suncenter.xcen, suncenter.ycen, 254, /data, color=255, thick=1
	
	  
		FOR i = angle1, angle2, nsteps DO BEGIN
  			eta = i*!DTOR
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
   		 	profiles_c2[abs((i*(1.0/nsteps))-angle1*(1.0/nsteps)),*] = origline
   		 	
		ENDFOR	
	
	  data_cube[*,*,j-1] = profiles_c2[*,*]
	ENDFOR
	
  xstepper,data_cube,xs=1000,ys=500
  save,data_cube,filename='c2_RTheta_imageplots_rd.sav'
ENDIF ELSE BEGIN
  restore,'c2_RTheta_imageplots_rd.sav',/verb
ENDELSE



window,1,xs=1000,ys=600

data = lasco_readfits(files[5],he)
pixrad = he.rsun/he.cdelt1

stretch,200,10

radius_angle = dblarr(2,36,24)
times = dblarr(24)

stop
;Prompt for height at each ten degrees
y_sim = dindgen(100)*(n_points_rad)/99.0
FOR j=0,n_elements(files)-1 DO BEGIN     
	array = data_cube[*,*,j]
	
		FOR i=10.0,350.0,10.0 DO BEGIN
			plot_image,congrid(bytscl(array,10,170), nrads/10.0, n_points_rad)
			x_sim = dblarr(n_elements(y_sim))
			x_sim[*] = i
   			plots,x_sim,y_sim
			print,'                     '
			print,'Choose front at '+string(i,format='(f6.2)')+' degrees'
			print,'                     
			cursor,angle,y_axis
			radius_angle[0,i/10.0, j] = y_axis/pixrad
			radius_angle[1,i/10.0, j] = i
			times[j] = anytim(file2time(files[j]),/utim) ;check that the image time are correct!
			wait,0.5
   		ENDFOR
   		stop
ENDFOR








END