pro mass_calc_manual,mass_array

;        
;  Assumes that fts files in current directory are mass images i.e. pixel units of grams
;
;        
loadct,9

list = findfile('mass45*.fts')
pre_event = sccreadfits(list[0],he_pre)
time_pre_event = he_pre.date_obs
mass_array = fltarr(3,n_elements(list)-1);========3 columns if /sector is chosen


FOR i=1,n_elements(list)-1 DO BEGIN
     print,'Image number :' +string(i)
     object_img = sccreadfits(list[i],he_ob)
     bkgnd_sub_image = object_img - pre_event
     ;neg = where(bkgnd_sub_image le 0.0)
     ;bkgnd_sub_image[neg] = 0.0
     
     bkgnd_sub_image = filter_image(bkgnd_sub_image,/median)
     sccwritefits,'bkgnd_sub_image.fts',bkgnd_sub_image,he_ob   
    
     print,'!!!!!!!!! Pre-event: '+time_pre_event
     print,'!!!!!!!!! Object: '+he_ob.date_obs

     IF i lt 28 THEN BEGIN
     	info = scc_cme_massimg2totalCOR('bkgnd_sub_image.fts',maxscl = 2.0e10, minscl=-7e09,/sector);minscl=-7.0e9);,/sector)
     ENDIF ELSE BEGIN
     	info = scc_cme_massimg2totalCOR('bkgnd_sub_image.fts', radii=[R1,R2], angles=[T1,T2], maxscl = 2.0e10,minscl=-7.0e9);,maxscl = maxSCL,minscl=minSCL)
     ENDELSE
    ;======================================================================
    ;================Put this in only when sector keyrod is chosen=========
	;R1 = info[0]
	;R2 = info[1]
	;T1 = info[2] ;Must be T1 if CME is off west limb
	;T2 = info[3] ;Must be T2 if CME is off west limb
	;mass = info(4)
	;print,''
	;print,'Inner radius=' +string(R1)
	;print,'Outer radius=' +string(R2)
	;print,''
	;mass_array[0,i-1]=R2 ; can be either timeArray or R2
	;mass_array[1,i-1]=mass
	;mass_array[2,i-1]=anytim(he_ob.date_obs,/utim)
   ;========================================================================
   ;================Put this in only when sector keyword is not chosen======
   ;mass_array[0,i-1]= anytim(he_ob.date_obs,/utim)
   ;mass_array[1,i-1]= info
   ;print,'Mass of front :'+string(info)+' [g]'
 stop
ENDFOR

;cd,'/Users/eoincarley/Data/secchi_l1/20081212/20081212_cor1/20081212_cor1b_B/mass_images'
;save, mass_array,filename='COR1Bmht_below3.1.sav'
;cd,'/Users/eoincarley/Data/secchi_l1/20081212/COR1+COR2'
;save, mass_array,filename='COR2A_mht_above4dot37rsun.sav'

END
