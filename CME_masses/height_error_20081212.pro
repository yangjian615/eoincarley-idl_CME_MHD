pro height_error_20081212

cd,'/Users/eoincarley/Data/secchi_l1/20081212/20081212_cor1/20081212_cor1b_B/mass_images'

files = findfile('mass45*.fts')
pre_event=sccreadfits(files[0],he_pre)
height_array=dblarr(5,n_elements(files)-1)
loadct,9
stretch,200,70
FOR i=0,4 DO BEGIN

  FOR j=1,n_elements(files)-1 DO BEGIN
  		IF j lt 30 THEN BEGIN
		da = sccreadfits(files[j],he_ob)
		img=da-pre_event
		window,0,xs=700,ys=600
		plot_image,bytscl(img,-3e10,5e10)
		pixrad = he_ob.rsun/he_ob.cdelt1
		sun = scc_SUN_CENTER(he_ob)
		
      	 r1 = 0
    
         PRINT,'SELECT RADIUS'
         CURSOR,x,y,3,/data
         r1 = SQRT((x-sun.xcen)^2+(y-sun.ycen)^2)/pixrad
         height_array[i,j-1] = r1
         
         ENDIF ELSE BEGIN
         height_array[i,j-1] = r1
         ENDELSE
   
 ENDFOR 
ENDFOR
save,height_array,filename='COR1b_height_5runs.sav'

END