function massAutomatic,imageList,posAngle,COLOUR=COLOUR,FIXED_DIFF=fixed_diff

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




Nlines = 17     ;number of images in text file             
mass_array = fltarr(3,Nlines-1)
index = 1         ;integer to index the image array (read in from the text file)



;Create array of files, 100 is arbitrary
openr,100,imageList
imageArray = strArr(Nlines)
readf,100,imageArray
close,100
;
;
;read in pre event image
pre_event_image = imageArray(0)
pre_event = sccreadfits(pre_event_image,hePre)
pre_event = pre_event * get_calfac(hePre) ; cor1 files are already in MSB
;
;
;
;Start image sequence loop, end of loop on line 223



WHILE (index lt Nlines) DO BEGIN


image = imageArray(index)
da = sccreadfits(image,ha)
da = da *get_calfac(ha)

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


sccwritefits,'mass_image.fts',mass_image,ha

;scc_cme_massimg2totalCOR is a slight modification of scc_massimg2total, it simply resizes the display screen.

     maxSCL = max(sigrange(mass_image)) 
     minSCL = min(sigrange(mass_image)) 
     ;maxSCL = 3.49e+09 ;use these scalling values for COR2 A 12-12-2008 
     ;minSCL = -5.45e+09 
     

;This is brought up initially to allow the user to select the primary roi, the if statement prevents it from coming up for all subsequent images  


If (index eq 1) THEN BEGIN     

info = scc_cme_massimg2totalCOR('mass_image.fts',/sector, MAXSCL=maxSCL, MINSCL=minSCL)

R1 = info(0)
R2 = info(1)
T2 = info(2) ;Must be T1 if CME is off west limb
T1 = info(3) ;Must be T2 if CME is off west limb


incAngle = 1.0         ; angle increment. This parameter must be tailored for each set of images i.e. 1 is a good increnement for COR2 B images but it may need to be smaller for COR 1 (approx 0.17)
ENDIF



;mass1 = info(4) 
mass2 = 6e12
mass1 = 0
img = sccreadfits('mass_image.fts',ha)
B = T2
A=T1

       ;If increase in mass in each iteration is not bigger than noise 5e12 for COR2 B (0.4e12 for cor1) then the increase in mass is most likely due to noise and the loop is stopped
noise=5e12

tvscl,sigrange(img)

;While loop to find the upper and lower angles that give the max mass
WHILE (abs(mass1 - mass2) gt noise) DO BEGIN

   
        T1 = T1 - incAngle
        mass1 = mass2
        mass2=massCalculator(img,ha,/sector,RADII=[R1,R2],ANGLES=[T2,T1])
	    print,mass1-mass2
        
        ;If statement to make sure the size of the sector does not grow too far beyong 80 degrees; typical CME max angular width is below 80 degrees (for broadside events). incAngle stands for increment Angle
        If (ABS(B - A) gt 75.00) THEN incAngle = 0.01 ELSE incAngle = incAngle
               
END

mass1=0
mass2=6e12

WHILE (abs(mass1 - mass2) gt noise) DO BEGIN

      
        T2 = T2 + incAngle
        mass1 = mass2
        mass2=massCalculator(img,ha,/sector,RADII=[R1,R2],ANGLES=[T2,T1])
	    print,mass1-mass2
	If (ABS(B - A) gt 75.00) THEN incAngle = 0.01 ELSE incAngle = incAngle
END

print,'Angle increment =' + string(incAngle)

print,R1,R2,T1,T2
mass1=0
mass2=1
massTally=1
CME_height = 0
increment = (T2 - T1)/10
n=1
T2secondary=0
T1original = T1

RadiusInc = 0.06 ;0.06 for cor2 and 0.02 for cor1b, 0.015 cor1a


WHILE (T2secondary ne T2) DO BEGIN


R2 = info(1)
R2original= info(1)
mass1 = 2e+13 ;Arbitrary loop-starting value
massTally = 1

   T1secondary = T1 + increment*(n-1)
   T2secondary = T1 + increment*(n)


       ;4 solar radii for cor1, 15 for cor 2, 0.2 for cor2B
       WHILE (abs(mass1 - massTally) gt 0.2e12) DO BEGIN
           
           If  (R2 gt 16) then RadiusInc = 0.0
           R2 = R2 + RadiusInc
           mass1 = massTally
           print, mass1
             massTally=massCalculator(img,ha,/sector,RADII=[R1,R2],ANGLES=[T2secondary,T1secondary])

       END

   mass2 = mass2 + massTally
   n = n + 1
   CME_height = CME_height + R2
   R2 = info(1)
      
END    

CME_height = CME_height/10 ; Average outer radius of mass segments
print,mass2
print,'CME Height =' + string(CME_height)    
info(1) = CME_height

if (CME_height gt 16) then RadiusInc = 0.0 else RadiusInc = 0.06

print,''
print,'Image being processed:'+string(ha.date_obs)
print,''


time=ha.date_obs
mass_array(0,index-1)=(CME_height/COS(posAngle/!radeg))
mass_array(1,index-1)=mass2
mass_array(2,index-1)=time


index = index + 1

ENDWHILE ; end image selection loop


xerr = fltarr(Nlines-1)
yerr = fltarr(Nlines-1)
yerr(*) = mass_array(1,*)*0.201   ;20.1 for COR2 images
xerr(*) = 0.4  ;0.4 for COR2 images

loadct,39
!p.color=0
!p.background=255

window,4
plot,mass_array(0,*),mass_array(1,*),MIN_VALUE=1e+13,/YLOG,psym=4,XTITLE = 'CME Front Height (R/Rsun)',YTITLE = 'CME Mass (g)',TITLE = 'COR2 B CME Mass vs. Height of CME front; 12/12/2008 CME Event',CHARSIZE=1.5
oploterror,mass_array(0,*),mass_array(1,*),xerr,yerr,psym=4

openw,90,'COR2_B_MassHeightAutomatic_44_65'
printf,90,mass_array
close,90


return,mass_array


END
