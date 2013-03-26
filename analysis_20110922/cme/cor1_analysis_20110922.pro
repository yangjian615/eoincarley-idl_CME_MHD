pro cor1_analysis_20110922,create_rtheta_space = create_rtheta_space



cd,'/Users/eoincarley/Data/22sep2011_event/secchi/COR1/b/24540411/l1'
files = findfile('*.fts')

IF keyword_set(create_rtheta_space) THEN BEGIN
  loadct,3
  window,0
  profiles_cor1 = dblarr(3600,300)
  data_cube = dblarr(3600,300,n_elements(files)-1)

	FOR j=1,n_elements(files)-1 DO BEGIN
	  data = sccreadfits(files[j],he)
      pre_event = sccreadfits(files[j-1],he_pre)
	  data_bs = data - pre_event
	  ;data_bs_scl = smooth(bytscl(data_bs,1e-10,5e-10),2)
	  data_bs_scl = filter_image(bytscl(data_bs,1e-10,3e-10),fwhm=3)
	  suncenter=GET_SUN_CENTER(he)	
	  sunradius=GET_SOLAR_RADIUS(he)
	  pixrad = he.rsun/he.cdelt1
	  rhos = dindgen(300)
	  plot_image,data_bs_scl

		FOR i = -180.0, 179.0,0.1 DO BEGIN
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
   		 	profiles_cor1[(i*10.0)+1800.0,*] = origline
		ENDFOR	
		
	  data_cube[*,*,j-1] = profiles_cor1[*,*]
	ENDFOR
	
  xstepper,data_cube,xs=1000,ys=500
  save,data_cube,filename='cor1_RTheta_imageplots_rd.sav'
ENDIF ELSE BEGIN
  restore,'cor1_RTheta_imageplots_rd.sav',/verb
ENDELSE
;xstepper,data_cube,xs=500,ys=500
;stop
window,1,xs=1000,ys=600
data = sccreadfits(files[10],he)

	
pixrad = he.rsun/he.cdelt1

stretch,200,10
;plot_image,bytscl(congrid(data_cube[*,*,15], 360, 300),10,200)
;shade_surf,bytscl(congrid(data_cube[*,*,15], 360, 300),10,200)
radius_angle = dblarr(2,36,24)
times = dblarr(24)
;Prompt for height at each ten degrees
y_sim = dindgen(100)*(300)/99.0
FOR j=10,16 DO BEGIN     ;10:16 are the only usefule images
	array = data_cube[*,*,j]
		FOR i=10.0,350.0,10.0 DO BEGIN
			plot_image,congrid(bytscl(array,10,170),360,300)
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



0




END