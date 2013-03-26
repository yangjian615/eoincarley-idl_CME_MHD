function radio_lc_freq,f1,f2,t1,t2,backg=backg,save_lc=save_lc
;
; NAME:
;	radio_lc_freq
;
; PURPOSE:
;	Sum desired frequency range and plot light curve between specified times
;	N.B will work for other files but for moment just reads BIR_20110607_062400_10.fit etc
;
; CALLING SEQUENCE:
;	time_freq = radio_lc_freq(f1,f2,t1,t2,backg=backg)
;
; INPUT:
; 	f1 - Start frequency value (type: integer,float or double)
;	f2 - End frequency value (type: integer,float or double)
;	t1 - Start time	(type: string in format YYYYMMDD_HHMMSS)
;	t2 - Ene time (type: string in format YYYYMMDD_HHMMSS)
;
; OPTIONAL KEYWORD INPUT:
; 	BACKG - forces background subtraction
;
; OUTPUT:
;	-A two column array containing time and corresponding intensity values of chosen frequency range
;    N.B Frequency values are normalised
;
; EXAMPLE:
; 	a = radio_lc_freq(50,80,'20110607_062600','20110607_063600')
;
; NOTE:
;	Will display full spectrum, spectrum with selected ranges and lighcurve
;
; AUTHOR:
;	Eoin Carley 2011-June-13
;


cd,'/Users/eoincarley/data/CALLISTO/20110607/fits'
;=======Make sure following are in current directory or move to directory before running=====
radio_spectro_fits_read,'BIR_20110607_062325_59.fit',z0,x0,y0 
radio_spectro_fits_read,'BIR_20110607_063825_59.fit',z1,x1,y1

z = [z0,z1] 
times = [x0,x1]
freq = y0

;======Sub background if needed=============
IF keyword_set(backg) THEN BEGIN
print,'helo!!!!!!!!!!!!'
  running_mean_background,z,zb
  z = z/zb
ENDIF  


array_size = size(z)
!p.multi=[0,1,1]
loadct,39
!p.color=0
!p.background=255
window,0,xs=1000,ys=600
loadct,0
spectro_plot,sigrange(z),times,freq,/xs,/ys,charsize=1.5,ytickinterval=10,ytitle='Frequency (MHz)',$
title='eCallisto Birr Castle, Ireland'
stop
t1 = anytim(file2time(t1),/utim)
t2 = anytim(file2time(t2),/utim)

t_start = closest(times, t1)
t_end = closest(times, t2)
f_start = closest(freq, f1)
f_end = closest(freq,f2)
summed_freq=fltarr(abs(t_start-t_end)+1)
z_aux=z
;=============Sum specified frequencies between specified times==============
FOR i=t_start, t_end DO BEGIN
    j=i-t_start
    nan = where(finite(z_aux(i,f_end:f_start) eq 0))
    if nan[0] ne -1 then begin
       z_aux[i,nan] = 0
    endif
     summed_freq[j] = total(z_aux[i,f_end:f_start])
 
ENDFOR

sum_freq_time = dblarr(2,abs(t_end-t_start)+1)
sum_freq_time[0,*] = times[t_start:t_end]
sum_freq_time[1,*] = summed_freq

;================Plot Spectra along with lighcurve===========================


!p.multi=[0,1,2]
loadct,39
!p.color=0
!p.background=255
window,1,xs=1000,ys=600
loadct,0
spectro_plot,sigrange(z),times,y0,/xs,/ys,xr=[t1,t2],yr=[f2,f1],ytitle='Frequency (MHz)',$
charsize=1.5,ytickinterval=abs(f2-f1)/5,title='eCallisto Birr Castle, Ireland'

sum_freq_time[1,*] = sum_freq_time[1,*]/max(sum_freq_time[1,*])

utplot,sum_freq_time[0,*],sum_freq_time[1,*],/xs,/ys,$
ytitle='Total radio flux (Normalsied)',title='Total radio flux between '+string(f1,format='(I3.2)')$
+'-'+string(f2,format='(I3.2)')+' MHz',$
psym=3,charsize=1.5,xr=[t1,t2]

oplot,sum_freq_time[0,*],sum_freq_time[1,*]
IF keyword_set(save_lc) THEN BEGIN
cd,'light_curves'
save,sum_freq_time,filename='lc_'+string(f1,format='(I3.2)')+'_'+string(f2,format='(I3.2)')+'MHz'
ENDIF
cd,'light_curves'
;=============Return array of time and intensity values=======================
return,sum_freq_time

END