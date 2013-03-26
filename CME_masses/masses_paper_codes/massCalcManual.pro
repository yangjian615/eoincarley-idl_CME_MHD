function massCalcManual,posAngle,COLOUR=COLOUR,FIXED_DIFF=fixed_diff

;        This function takes a text file containing a list of images and CME         
;        position angle as input and displays the image in mean solar brightness 
;        units and the same image in grams per pixel. 
;	     It then calls scc_cme_massimg2totalCOR which allows an interactive 
;        calculation of the CME mass for the list of images and outputs CME mass 
;        as a function of height
;
;
;        
;
;
;   Calling sequence:
;   A = totalMass(imgArray,posAngle)
;
;   imgArray must be a text file with the list of images
;




     ;number of images in text file

;mass_array = fltarr(2,Nlines-1)

firstImageDone = 0            ;see line 94
index = 1        ;integer to index the image array (read in from the text file)



list = findfile('*.fts')
times = anytim(file2time(list),/utime)
times_sec = times - times[0]
pre_event = sccreadfits(list[0],hePre)
;pre_event = pre_event * get_calfac(hePre) ; cor1 files are already in MSB

Nlines = n_elements(list)

mass_array = fltarr(2,Nlines-1)
;timeArray = ((findgen(Nlines-1)+1)*30)+227
firstImageDone = 0            ;see line 94
index = 1        ;integer to index the image array (read in from the text file)


FOR index=1,Nlines-1 DO BEGIN


image = list[index]
da = sccreadfits(image,ha)
;da = da *get_calfac(ha)

print,''
print,'Pre event image time: ' + hePre.date_obs
print,''
print,'Current image: ' + ha.date_obs
print,''

;
;Subtract pre event image
;
IF KEYWORD_SET (FIXED_DIFF) THEN BEGIN
      da = da - pre_event 
ENDIF
  ;tvim,sigrange(da)  
IF  (KEYWORD_SET(COLOUR))  THEN col=COLOUR ELSE col=0
    loadct,col
;
;   Create image of grams per pixel, call on scc_calc_cme_mass

mass_image = scc_calc_cme_mass(da,ha,/all,pos=posAngle)  ;N.B!!! Don't forget to set polarised brightness or total brightness
;
;Open window of image in mean solar brighness units and image of grams per pixel
;
;
;window,1
;  tvim,sigrange(da),/sc, title='Mean Solar Brightness Units'
;window,2
 ;tvim,sigrange(mass_image),/sc, title='Grams per Pixel Image'
;window,3
  ;contour,mass_image,/fill  
;
;make a fits file of the mass image; N.B this fits file will be over written each the image selection loop is run
;
sccwritefits,'mass_image.fts',mass_image,ha

;scc_cme_massimg2totalCOR is a slight modification of scc_massimg2total, it simply resizes the display screen.

     maxSCL = max(sigrange(mass_image)) 
     minSCL = min(sigrange(mass_image)) 
      ;maxSCL = 3.49e+09 ;use these scalling values for COR2 A 12-12-2008 
      ;minSCL = -5.45e+09
     
;This is brought up initially to allow the user to select the primary roi, the if statement prevents it from coming up for all subsequent images     
print,'max: '+string(maxSCL)
print,'min: '+string(minSCL)
   
window,1
;tvim,sigrange(mass_image)
if (index le 36) then begin ; this if statement is for large amounts of images only, the 36 is beacuse cor1 images of 12-12-2008, the 36th image is where the CME leaves the FOV and no longer requires specification of the ROI
info = scc_cme_massimg2totalCOR('mass_image.fts',/sector,maxscl = maxSCL,minscl=minSCL)
endif
;if (index gt 36) then begin
;info = scc_cme_massimg2totalCOR('mass_image.fts',radii=[R1,R2],angles=[T1,T2],maxscl = masSCL,minscl=minSCL)
;endif

R1 = info(0)
R2 = info(1)
T1 = info(2) ;Must be T1 if CME is off west limb
T2 = info(3) ;Must be T2 if CME is off west limb
mass = info(4) ;should be info(4)
print,''
print,'Inner radius=' +string(R1)
print,'Outer radius=' +string(R2)
print,''
;mass_array(0,index-1)=10*index ;for time
mass_array[0,index-1]=R2 ; can be either timeArray or R2
mass_array[1,index-1]=mass




ENDFOR ; end image selection loop


xerr = fltarr(Nlines-1)
yerr = fltarr(Nlines-1)
yerr(*) = mass_array(1,*)*0.3   ;20.1 for COR2 images
xerr(*) = 0  ;0.4 for COR2 images

loadct,39
!p.color=0
!p.background=255

window,4
plot,mass_array(0,*),mass_array(1,*),/YLOG,psym=4,XTITLE = 'Height of CME (R/Rsun)',$
YTITLE = 'CME Mass (g)',TITLE = 'COR2 B CME Mass vs. Height; 12/12/2008 CME Event',CHARSIZE=1.5,yrange=[1e13,1e16]
oploterror,mass_array(0,*),mass_array(1,*),xerr,yerr,psym=4


save, mass_array,filename='mass_height.sab'


return,mass_array


END
