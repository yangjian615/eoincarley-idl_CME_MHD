function createSpectraArray, imagelist

;Creates a 3D array of a list of given spectrograph data. Then saves this array in pwd. 
;Can be modified to do the same for images

Nlines = 67

openr,1,imageList
imageArray = strArr(Nlines)
readf,1,imageArray
close,1



pre_event=imageArray[0]
radio_spectro_fits_read,pre_event,z1,x,y
images3D =  fltarr(3600,200,Nlines)

FOR i=1,Nlines-1,1 DO BEGIN

    image = imageArray[i]
    radio_spectro_fits_read,image,z,x,y
    ;z=z-z1
    images3D[*,*,i] = z
    
ENDFOR

openw,2,'spectraArray3D'
printf,2,images3D
close,2


return,images3D
    
end    
    