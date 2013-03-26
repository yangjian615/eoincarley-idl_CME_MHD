function massCalcManualCOM,directory,posAngle,COLOUR=COLOUR,FIXED_DIFF=fixed_diff

;        This function is the same as massCalcManual except it has a routine to find the 
;        centre of mass
;
;
;
;        This function takes a text file containing a list of images and CME         ;        position angle as input and displays the image in mean solar brightness 
;        units and the same image in grams per pixel. 
;	     It then calls scc_cme_massimg2totalCOR which allows an interactive 
;        calculation of the CME mass for the list of images and outputs CME mass ;        as a function of height
;
;
;        
;
;
;   Calling sequence:
;   A = totalMass(directory,posAngle)
;
;   directory must be a text file with the list of images
;




Nlines = 17       ;number of images in text file

mass_array = fltarr(2,Nlines-1)
COMarray = fltarr(3,Nlines-1)
timeArray = ((findgen(Nlines-1)+1)*30)+227
firstImageDone = 0            ;see line 94
index = 1        ;integer to index the image array (read in from the text file)



;Create array of files, 100 is arbitrary
openr,100,directory
imageArray = strArr(Nlines)
readf,100,imageArray
close,100
;
;
;read in pre event image
pre_event_image = imageArray(0)
pre_event = sccreadfits(pre_event_image,hePre)
;pre_event = pre_event * get_calfac(hePre) ; cor1 files are already in MSB
;
;
;Start image sequence loop, end of loop on line 223
;
WHILE (index lt Nlines) DO BEGIN


image = imageArray(index)
da = sccreadfits(image,ha)
;da = da *get_calfac(ha)

tvim,da
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
   

if (index le 36) then begin
info = scc_cme_massimg2totalCOR('mass_image.fts',/sector,maxscl = maxSCL,minscl=minSCL)
endif
if (index gt 36) then begin
info = scc_cme_massimg2totalCOR('mass_image.fts',radii=[R1,R2],angles=[T1,T2],maxscl = maxSCL,minscl=minSCL)
endif

R1 = info(0)
R2 = info(1)
T1 = info(2) ;Must be T1 if CME is off west limb
T2 = info(3) ;Must be T2 if CME is off west limb
mass = info(4) ;should be info(4)

;Centre of Mass calculation
wcs = fitshead2wcs(ha)  
   ;
   ;   create a distance array
   ;
   dist=wcs_get_coord(wcs)
   dist =reform(sqrt(dist[0,*,*]^2 + dist[1,*,*]^2))/ha.rsun
   
   a = scc_ROI_SECTOR(ha,R1,R2,T1,T2)

hh = size(a)
term = hh(1)

massDist=0
i=0.0   
While (i lt term-1) do begin
     
     
     massPixels = mass_image(a)
     pixel = a[i]
     sum1 = (massPixels[i]*dist[pixel])
     massDist = massDist + sum1
     i = i + 1  
 
endwhile
COM = massDist/mass
COMarray[0,index-1] = COM
COMarray[1,index-1] = R2
;end COM calculation
print,''
print,''
print,'Centre of Mass height' +string(COM)
print,'Front height' +string(R2)
print,''
print,''



;mass_array(0,index-1)=10*index ;for time
mass_array[0,index-1]=R2 ; change to COM or R2 accordingly
mass_array[1,index-1]=mass


index = index + 1

ENDWHILE ; end image selection loop


xerr = fltarr(Nlines-1)
yerr = fltarr(Nlines-1)
yerr(*) = mass_array(1,*)*0.301   ;20.1 for COR2 images
xerr(*) = 0.2  ;0.4 for COR2 images

loadct,39
!p.color=0
!p.background=255

window,4
plot,mass_array(0,*),mass_array(1,*),MIN_VALUE=1e+13,/YLOG,psym=4,XTITLE = 'CME Front Height (R/Rsun)',YTITLE = 'CME Mass (g)',TITLE = 'COR1 B CME Mass vs. Height of CME front; 12/12/2008 CME Event',CHARSIZE=1.5
oploterror,mass_array(0,*),mass_array(1,*),xerr,yerr,psym=4

window,5
plot,timeArray(*),COMarray(0,*),psym=4,TITLE='Height vs. Time; 12-12-2008 CME',XTITLE='Time (mins)',YTITlE='Poisiton (R/Rsun)
oplot,timeArray(*),COMarray(0,*),linestyle=2
plot,timeArray(*),COMarray(1,*),psym=6,color=254
oplot,timeArray(*),COMarray(1,*),linestyle=3
legend, ['COM','Front'],psym=[4,6],color=[0,254],box=0

COMarray[2,*] = timeArray[*] 
openw,90,'COMcor2B'
printf,90,COMarray
close,90


return,COMarray


END
