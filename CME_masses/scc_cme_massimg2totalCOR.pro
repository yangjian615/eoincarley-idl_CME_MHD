function scc_cme_massimg2totalCOR,fn,MAXSCL=maxscl,MINSCL=minscl,SAVE=save, $
         SECTOR=SECTOR,RADII=RADII,ANGLES=ANGLES
;+
; N.B. this is a modified version of scc_cme_massimg2totalCOR so that the output is an array (see
; last few lines for array outpout. It is used in massAutomatic.pro



; NAME:
;	scc_CME_MASSIMG2TOTAL
;
; PURPOSE:
;	This function calculates the mass of a CME from mass images.
;
; CATEGORY:
;	CME
;
; CALLING SEQUENCE:
;	Result = scc_CME_MASSIMG2TOTAL(Fn)
;
; INPUTS:
;	Fn:	String containing the filename of the CME mass image
;
; KEYWORD PARAMETERS:
;	MINSCL:	Set this keyword with the value to use for the minimum value
;		in scaling the image. The default value is to use -1.e-11 msb
;
;	MAXSCL:	Set this keyword with the value to use for the maximum value
;		in scaling the image. The default value is to use +1.e-11 msb
;
;	SAVE:	Set this keyword with the filename to save the mass information to
;	SECTOR:	Set this keyword if the ROI is a sector, centered on the sun
;		The default is to draw the boundary of the CME using the cursor
;	RADII:	Set this keyword with a 2-element array of the inner and
;		outer radii (in solar radii) for the sector ROI
;	ANGLES:	Set this keyword with a 2-element array of the left and right
;		hand boundaries (viewed from sun-center) for the sector ROI
;
; OUTPUTS:
;	This function returns the mass calculated for the ROI selected
;
; RESTRICTIONS:
;	Only tested on C3, but should work for any telescope
;
; EXTERNAL CALLS:
;       sccREADFITS, scc_SUN_CENTER, scc_ROI_SECTOR, AWIN
;
; PROCEDURE:
;	The files for the CME mass image is read in.  The image is displayed and XLOADCT
;	is called to permit the contrast to be adjusted.  Then RDPIX is called to permit
;	individual pixel values to be displayed.
;	If neither SECTOR, RADII, nor ANGLES are set, then the ROI is selected using the
;	cursor to draw the boundary by using DEFROI.
;	If only SECTOR is set then the ROI is an annular sector whose vertex is the sun 
;	center and the radii and angles of the sector are determined interactively.  If
;	RADII is set then the radial values are set to the input and similarly if ANGLES
;	is set.
;	
; EXAMPLE:
;	To find the mass of a CME, where the CME mass image is in
;	'320005.fts', and saving the mass information in 'mass.lst':
;
;		Mass = scc_CME_MASSIMG2TOTAL ('320005.fts',save='mass.lst')
;
;	To use an annular sector, with boundaries defined interactively:
;
;		Mass = scc_CME_MASSIMG2TOTAL (''320005.fts',save='mass.lst',/SECTOR)
;
;	To use an annular sector, with angular boundaries pre-set :
;
;		Mass = scc_CME_MASSIMG2TOTAL ('320005.fts',save='mass.lst',/SECTOR,ANGLES=[250,280])
;
;	or, since the SECTOR keyword is not necessary:
;
;		Mass = scc_CME_MASSIMG2TOTAL ('320005.fts',save='mass.lst',ANGLES=[250,280])
;
; MODIFICATION HISTORY:
; 	Written by:	RA Howard, NRL, 5/19/97
;	Modified:	RAH, NRL, 3/14/98, comments added
;                       RCC, NRL, 10/31/08 adapted for SECCHI
;
;	@(#)scc_cme_massimg2total.pro	1.0 10/31/08 LASCO IDL LIBRARY
;-
PRINT,'PROCESSING File: ',fn
a = sccREADFITS(fn,ha)
;
;  Check for MASS image
;
tags = TAG_NAMES(ha)
w = WHERE (tags EQ 'BUNIT',nw)
IF (nw EQ 0)  THEN BEGIN
   PRINT,'The units of the input file are not defined.'
   PRINT,'Continuing anyway'
ENDIF ELSE IF (STRMID(ha.bunit,0,5) NE 'GRAMS')  THEN BEGIN
   PRINT,'The units of the input file is not mass:  ',ha.bunit
   PRINT,'Continuing anyway'
ENDIF
PRINT,'TIME             ',ha.date_OBS
nx = ha.naxis1
ny = ha.naxis2
;
;  Display the byte scale difference image
;

IF (KEYWORD_SET(minscl))  THEN mn=minscl ELSE mn=-1.e-10
IF (KEYWORD_SET(maxscl))  THEN mx=maxscl ELSE mx=1.e-10

;IF (nx gt 1024) or (ny gt 1024) THEN BEGIN
  SLIDE_IMAGE,bytscl(a,min=mn,max=mx),xvisible=900,yvisible=700,show_full=0,slide_window=sw_a
  wset,sw_a
  junk = ''
 read,'Center CME in window. When done press return:',junk
;ENDIF ELSE BEGIN
; IF ((!d.x_size NE nx) OR (!d.y_size NE ny))  THEN AWIN,a
;  tv,bytscl(a,min=mn,max=mx)
;ENDELSE

;=================================================     

;window,10,xs=900,ys=700
;plot_image,bytscl(a,mn,mx)

;
;  Select a region of interest, compute the size and
;  location of the ROI.
;
pixrad = ha.rsun/ha.cdelt1
sun = scc_SUN_CENTER(ha)
;
;  Is a sector desired?
;
IF (KEYWORD_SET(SECTOR) OR KEYWORD_SET(RADII) OR KEYWORD_SET(ANGLES)) THEN BEGIN
;
;  An annular sector is desired.
;  Get the inner and outer radii of the annulus
;  Repeat to make sure they are not equal
;
   roitype = 'SECTOR'
   REPEAT BEGIN
      r1 = 0
      r2 = 0
      IF (KEYWORD_SET(RADII))  THEN BEGIN
         sz = SIZE(radii)
         IF (sz(1) EQ 2)  THEN BEGIN
            r1 = radii(0)
            r2 = radii(1)
         ENDIF
      ENDIF
      IF (r1 EQ r2)  THEN BEGIN
         PRINT,'SELECT INNER AND OUTER RADII'
         CURSOR,x,y,3,/data
         r1 = SQRT((x-sun.xcen)^2+(y-sun.ycen)^2)/pixrad
         CURSOR,x,y,3,/data
         r2 = SQRT((x-sun.xcen)^2+(y-sun.ycen)^2)/pixrad
      ENDIF
      IF (r1 GT r2) THEN BEGIN
         x = r1
         r1 = r2
         r2 = x
      ENDIF
   ENDREP UNTIL (r1 NE r2)
   ar = 0.5*(r1+r2)		; the center distance
   ht = r2-r1			; the height of the annulus
;
;  Get the left and right boundaries of the sector
;  Repeat to make sure they are not equal
;
   REPEAT BEGIN
      t1 = 0
      t2 = 0
      IF (KEYWORD_SET(ANGLES)) THEN BEGIN
         sz = SIZE(angles)
         IF (sz(1) EQ 2)  THEN BEGIN
            t1 = angles(0)
            t2 = angles(1)
         ENDIF
      ENDIF
      IF (t1 EQ t2) THEN BEGIN
         PRINT,'SELECT LEFT AND RIGHT HAND BOUNDARIES (ANGLES)'
         CURSOR,x,y,3,/data
         t1 = ATAN(x-sun.xcen,y-sun.ycen)*!radeg
         IF (t1 LT 0)   THEN t1=t1+360.
         IF (t1 GT 360)   THEN t1=t1-360.
         t1 = 360-t1		; convert to position angles
         CURSOR,x,y,3,/data
         t2 = ATAN(x-sun.xcen,y-sun.ycen)*!radeg
         IF (t2 LT 0)   THEN t2=t2+360.
         IF (t2 GT 360)   THEN t2=t2-360.
         t2 = 360-t2		; convert to position angles
print,'ANGLES = ',t1,t2
      ENDIF
   ENDREP UNTIL (t1 NE t2)
   ac = 0.5*(t1+t2)		; the central angle
   wt = t1-t2			; the width of the sector
   IF (wt LT 0)  THEN wt=wt+360
;
;  Convert the definition of the annular sector into pixel numbers
;


   roi =scc_ROI_SECTOR(ha,r1,r2,t1,t2,/draw)
   
ENDIF ELSE BEGIN
;
;  Since a sector is not desired, define the ROI using the cursor
;
   roitype = 'DEFROI'
   roi = DEFROI (nx,ny,/NOFILL)
   help,roi  
   
   
   rows = roi/ny
   cols = roi - ny*rows
help,rows
;
;  Calculate the central row and column numbers in radii from sun center
;  Calculate the maximum height and width in radii
;
   ar = (sun.ycen-AVERAGE(rows))/pixrad
   ac = (AVERAGE(cols)-sun.xcen)/pixrad
   ht = ( max(rows) - min(rows) )/pixrad
   wt = ( max(cols) - min(cols) )/pixrad
   
  ;height = sqrt(((max(cols) - sun.xcen)/pixrad)^2 + ((max(rows) - sun.ycen)/pixrad)^2)
   
ENDELSE
np = n_elements(roi)
;
;  Finally, compute the mass (grams) and print out the mass,
;  median and average values of grams/cm^2
;
stop
mass = a(roi)
mass = TOTAL(mass)
dte = ha.date_obs
PRINT,'     Date-Obs       Cen-PA  Width Height ROI-Type '+ $
                '(R1     R2    T1     T2      Pts) PixRad     Mass' 
 PRINT, dte, ac,wt,ht,roitype, np, pixrad, mass, $; cm_r, cm_a, $
     FORMAT='(a19,3f7.2,a7,4f7.2,i8,f7.2,1e11.3)'
;r1, r2, t2, t1,

IF (KEYWORD_SET(SAVE)) THEN BEGIN
   sz = SIZE(save)
  ff = ha.filename
  len = strlen(ff)
  SAVE, file=STRMID(ff, 0, len-4) + '.roi', roi
  IF (sz(1) EQ 7)  THEN file=save ELSE $
    file = PICKFILE(/write,FILTER='*.mas')
  
  ff= FIND_FILE(file)

  OPENW,lu,file,/get_lun,/append
  IF((SIZE(ff))(0) EQ 0) THEN $ 
     PRINTF, lu,'     Date-Obs       Cen-PA  Width Height ROI-Type '+ $
                '(R1     R2    T1     T2      Pts) PixRad     Mass';    Cm_R   Cm_A'
     PRINTF, lu, dte,ac,wt,ht,roitype,r1, r2, t2, t1,np, pixrad, mass, $; cm_r, cm_a, $
     FORMAT='(a19,3f7.2,a7,4f7.2,i8,f7.2,1e11.3)'

  CLOSE,lu
  FREE_LUN,lu
ENDIF

;info = [r1,r2,t1,t2,mass]; <-----put this in only when /sector keyword is chosen
info = [mass]

RETURN,info
END
