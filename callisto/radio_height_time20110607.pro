pro radio_height_time20110607,run_model=run_model

cd,'/Users/eoincarley/Data/CALLISTO/20110607'
restore,'ft_typeIII_20110607.sav' ;array name is ft_typeIII
e_charge = 4.803e-10
e_mass = 9.109e-28
utimes = ft_typeIII[0,*]
freq = ft_typeIII[1,*]/2
n_data = ((freq*1.0e6)/8980.0)^2.0
;print,n_data

IF keyword_set(run_model) THEN BEGIN
;grid of Rsun values from 1-215 in 100000 steps
rsun_model = (dindgen(100000)+465.116)*0.00215
sw_mann,rsun_model,vs=vs, n=n_model, va=va, vms=vms
r_data = dindgen(n_elements(n_data))
FOR i = 0, n_elements(n_data)-1 DO BEGIN
	index = closest(n_model, n_data[i])
	r_data[i] = rsun_model[index]
ENDFOR	
save, r_data,filename='r_data_mann_model.sav'
save, n_data,filename='n_data_mann_model.sav'
ENDIF ELSE BEGIN
restore,'r_data_mann_model.sav'
restore,'n_data_mann_model.sav'
ENDELSE


!p.multi=[0,1,1]
loadct,39
!p.color=0
!p.background=255

;plas_freq = (8980.*sqrt(n_model))/1e6
;print,plas_freq
;window,12,xs=600,ys=500
;plot,rsun_model,plas_freq,xtitle='Height in corona (Rsun)',ytitle='Plasma Frequency (MHz)',/ylog,$
;xr=[1,215],/xs
;oplot,r_data,freq,psym=1,color=100
;stop

;print,r_data
a = anytim(file2time('20110607_062500'),/utim)
b = anytim(file2time('20110607_070000'),/utim)
;stop_index = closest(utimes, anytim(file2time('20110607_070000'),/utim))


;===========================================================================
stop_index = where(freq gt 0.1); Choose frequency cut off!!!!!!!!!!!!!!!!!!
; 0.05MHz is cut off for IP type III 20110607
;===========================================================================

!p.multi=[0,1,1]
window,11,xs=500,ys=400

utplot,utimes[0:stop_index[n_elements(stop_index)-1]],r_data[0:stop_index[n_elements(stop_index)-1]],$
/xs,/ys,charsize=1.5,ytitle='Height of electron beam (Rsun)',psym=1,$
ytickinterval=20,yr=[0,max(r_data[0:stop_index[n_elements(stop_index)-1] ] ) ],$
title='Electron beam height using Mann model'
oplot,utimes[*],r_data[*],linestyle=1

;stop_index = where(freq gt 0.050)
print,stop_index


print,where(utimes lt b)
lin = linfit(utimes[0:stop_index[n_elements(stop_index)-1]],$
r_data[0:stop_index[n_elements(stop_index)-1]])
h = lin[0] +lin[1]*utimes
print,'lin[1]'+string(lin[1])
oplot,utimes,h

time_1AU = (215-lin[0])/lin[1]
 ;!!!!!!!!!!!!!!!!!!
;=======================================================================
;Now make a calculation using the a distance corrected for Parker spiral
;=======================================================================

arc_length = testing_spiral(r_data)/6.955e8

print,arc_length
utplot,utimes[0:stop_index[n_elements(stop_index)-1]],arc_length[0:stop_index[n_elements(stop_index)-1]],$
/xs,/ys,charsize=1.5,ytitle='Distance of electron beam along spiral (Rsun)',psym=1,$
ytickinterval=20,yr=[0,max(arc_length[0:stop_index[n_elements(stop_index)-1] ] ) ],$
title='Electron beam height using Mann model'
oplot,utimes[*],arc_length[*],linestyle=1

lin_parker = linfit(utimes[0:stop_index[n_elements(stop_index)-1]],$
arc_length[0:stop_index[n_elements(stop_index)-1]])
h = lin_parker[0] +lin_parker[1]*utimes
print,'lin[1]'+string(lin_parker[1])
oplot,utimes,h

time_1AU_parker = (255-lin_parker[0])/lin_parker[1]

print,'======================================================================='
print,'======================================================================='
print,'=================Asume purely radial proapagation======================'
print,'Electron arrival time at 1 A.U: '+anytim(time_1AU,/yoh)
print,'Electron velocity :' +string((lin[1]*6.955e8)/3.0e8)+'c'
print,'Electron energy :'  +string(0.5*9.1e-31*(lin[1]*6.955e8)^2*1.6e19)+' eV'
print,' '
print,'=============Corrected for parker spiral arc length===================='
print,'Electron arrival time at 1 A.U: '+anytim(time_1AU_parker,/yoh) ;!!!!!!!!!!!!!!!!!!
print,'Electron velocity (corrected) :' +string((lin_parker[1]*6.955e8)/3.0e8)+'c'
print,'Electron energy :'  +string(0.5*9.1e-31*(lin_parker[1]*6.955e8)^2*1.6e19)+' eV'
print,'======================================================================='
print,'======================================================================='



stop



;==================Using the fitted line make a high resolution height grid then
;==================use he Mann model to produce density values from this, turn those 
;==================into frequency and over plot this model on the dynamic spectra.

;     This isn't working yet

;====produce time grid
syn_times = dindgen(10800)+anytim(file2time('20110607_062000'),/utim)
stop
syn_height = lin[0]+lin[1]*syn_times
indexes = where(syn_height gt 0)
sw_mann,syn_height[indexes],vs=vs, n=n_synth, va=va, vms=vms

f_synth = 8980*sqrt(n_synth)/1e6
f_synth_MHz = fltarr(2,n_elements(f_synth))
f_synth_MHz[0,*] = syn_times[indexes]
f_synth_MHz[1,*] = f_synth

save,f_synth_MHz,filename='f_synth_MHz.sav'


END
