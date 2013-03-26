pro create_art,array

cd,'/Users/eoincarley/Data/CALLISTO/20110922/art'
;restore,'spec_x_20110607.sav',/verb
;restore,'spec_y_20110607.sav',/verb
;restore,'spec_z_20110607.sav',/verb
;z = spec_z_20110607
;x = spec_x_20110607
;y = spec_y_20110607

list=findfile('*.fit')
radio_spectro_fits_read,list[0],z,x,y
FOR i=1,n_elements(list)-1 DO BEGIN
  radio_spectro_fits_read,list[i],running_z,running_x,y
  z = [z,running_z]
  x = [x,running_x]
ENDFOR

dimen = size(z)

;running_mean_background,z,zback
;z = z - zback
array = dblarr(dimen[2],dimen[1]+1)

FOR i=0,dimen[2]-1 DO BEGIN  
  array[i,0] = y[i]  
END  
FOR i=0,dimen[2]-1 DO BEGIN 
 FOR j=1,dimen[1] DO BEGIN
    array[i,j] = z[j-1,i]
 ENDFOR
ENDFOR 

stop
;plot_image,transpose(z)
cd,'/Users/eoincarley/Data/CALLISTO/20110922/art'
openw,lun,'z_art_20110922.txt',/get_lun,width=dimen[2]*10
printf,lun,array,format='('+string(dimen[2],format='(I3)')+'(F9.2,x))'
free_lun,lun


END    
