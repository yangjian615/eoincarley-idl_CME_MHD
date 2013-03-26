pro radio_height_time20110607_v2,run_model=run_model

;v2 now correctly calcultes arrival along parker spiral

cd,'/Users/eoincarley/Data/CALLISTO/20110607'
restore,'ft_typeIII_20110607.sav' ;array name is ft_typeIII
e_charge = 4.803e-10
e_mass = 9.109e-28
utimes = ft_typeIII[0,*]
freq = ft_typeIII[1,*]/2.0
n_data = ((freq*1.0e6)/8980.0)^2.0
;print,n_data

IF keyword_set(run_model) THEN BEGIN
	;grid of Rsun values from 1-215 in 100000 steps
	rsun_model = (dindgen(100000)+465.116)*0.00215
	sw_mann, rsun_model, vs=vs, n=n_model, va=va, vms=vms
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

a = anytim(file2time('20110607_062500'),/utim)
b = anytim(file2time('20110607_070000'),/utim)
;stop_index = closest(utimes, anytim(file2time('20110607_070000'),/utim))


;===========================================================================
stop_index = where(freq gt 0.05); Choose frequency cut off!!!!!!!!!!!!!!!!!!
stop_index  = stop_index[n_elements(stop_index)-1]
; 0.05MHz is cut off for IP type III 20110607
;===========================================================================

!p.multi=[0,1,1]
window,11,xs=500,ys=400

utplot, utimes[0:stop_index], r_data[0:stop_index], $
/xs,/ys,charsize=1.5,ytitle='Height of electron beam (Rsun)',psym=1,$
ytickinterval=20,yr=[0,max(r_data[0:stop_index ] ) ],$
title='Electron beam height using Mann model'
oplot,utimes[*],r_data[*],linestyle=1

;stop_index = where(freq gt 0.050)
print,stop_index


print,where(utimes lt b)
lin = linfit(utimes[0:stop_index], r_data[0:stop_index])
h = lin[0] +lin[1]*utimes
print,'lin[1]'+string(lin[1])
oplot,utimes,h

time_1AU = (215.0-lin[0])/lin[1]
 ;!!!!!!!!!!!!!!!!!!
;=======================================================================
;Now make a calculation using the a distance corrected for Parker spiral
;=======================================================================

v_sw = 450.0 ;km/s
arc_length = parker_spiral_length(r_data, v_sw)

print,arc_length
utplot, utimes[0:stop_index], arc_length[0:stop_index],$
/xs,/ys,charsize=1.5,ytitle='Distance of electron beam along spiral (Rsun)',psym=1,$
ytickinterval=20,yr=[0,max(arc_length[0:stop_index] ) ],$
title='Electron beam height using Mann model'
oplot,utimes[*],arc_length[*],linestyle=1


; DO THE FIT
times_particles = utimes[0:stop_index]
arc_particles = arc_length[0:stop_index]

times_p_mean = times_particles - mean(times_particles)
arc_p_mean = arc_particles - mean(arc_particles)


lin_parker = linfit(times_p_mean, arc_p_mean, sigma = verr)
tim_sim = (dindgen(100.0)*(times_p_mean[n_elements(times_p_mean)-1] -times_p_mean[0])/99.00 )+times_p_mean[0]
h = dblarr(n_elements(tim_sim))
h = lin_parker[0] +lin_parker[1]*tim_sim
print,'lin[1]  '+string(lin_parker[1])
oplot, tim_sim + mean(times_particles), h + mean(arc_particles)

;Calculate distance along parker spiral to 0.99 A.U.

AU = 149.60e9 ;meters
rsun = 6.955e8 ;meters
au_in_rsun = AU/rsun
c = 2.99792e8

;This  part is not in v1. In v1 I incorrectly divided 1AU by speed on parker spiral
parker_length = parker_spiral_length(0.99*au_in_rsun, v_sw)
print,'Parker spiral length for '+string(v_sw)+' solar wind speed and 0.99AU: '+string(parker_length)
time_1AU_parker = parker_length/lin_parker[1]
eta_parker = utimes[0] + time_1AU_parker
;******
print,'======================================================================='
print,'======================================================================='
print,'=================Asume purely radial proapagation======================'
print,'Electron arrival time at 1 A.U: '+anytim(time_1AU,/yoh)
print,'Electron velocity :' +string((lin[1]*6.955e8)/c)+'c'
print,'Electron energy :'  +string(0.5*9.1e-31*(lin[1]*6.955e8)^2/1.6e-19)+' eV'
print,' '
print,'=============Corrected for parker spiral arc length===================='
print,'Electron arrival time at 0.99 A.U: '+anytim(eta_parker,/yoh) ;!!!!!!!!!!!!!!!!!!
print,'Electron velocity (corrected) :' +string((lin_parker[1]*6.955e8)/c) + ' +/- '+string( (verr[1]*6.955e8)/c)+'c'
print,'Electron energy :'  +string(0.5*9.1e-31*((lin_parker[1]*6.955e8)^2.0)/1.6e-19)+' eV'
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
