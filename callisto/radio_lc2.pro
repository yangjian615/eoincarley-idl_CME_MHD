pro radio_lc2,z,times,y,summed_freq,num_of_sigmas

array_size = size(z)

summed_freq=fltarr(array_size[1])

FOR i=0., array_size[1]-1,1 DO BEGIN
    nan = where(finite(z(i,*)) eq 0)
    if nan[0] ne -1 then begin
       z[i,nan] = 0
    endif
     summed_freq[i] = total(z(i,*))
ENDFOR


mu = mean(summed_freq)
median1 = median(summed_freq)
sigmaa = sig_array(summed_freq)
num_of_sigmas = fltarr(n_elements(summed_freq))
num_of_sigmas(*) = (summed_freq(*)-median1)/sigmaa
num_of_sig_squared = num_of_sigmas^2

print,'Maximum number of sigmas is: ' + string(max(num_of_sigmas))
print,'Median of standard deviation throughout time :' +string(median(num_of_sigmas))


time = anytim(times,/ex)
julian = julday(time[5,*],time[4,*],time[6,*],time[0,*],time[1,*],time[2,*])
;print,julian
date_label = LABEL_DATE(DATE_FORMAT = ['%H:%I'])

start_time = anytim(times[0],/yohkoh)
print,'start time: '+start_time


normal = summed_freq/max(summed_freq)

;window,0,xs=1400,ys=500
loadct,39
!p.color=0
!p.background=255

plot,julian,normal,/ynozero,XTICKFORMAT = 'LABEL_DATE',XTICKUNITS = 'minutes',$
xtickinterval=2,/xs,charsize=1.5,ytitle='Intensity normalised to max',$
xtitle='Start time: '+start_time,title='Total radio flux between 20-90MHz',psym=3,thick=2
oplot,julian,normal,color=50

;window,1,xs=1400,ys=500
;plot,julian,num_of_sigmas,/ynozero,XTICKFORMAT = 'LABEL_DATE',XTICKUNITS = 'minutes',$
;xtickinterval=2,/xs,charsize=1.5,ytitle='Number of standard deviations',$
;xtitle='Start time: '+start_time,title='Number of standard deviations away from the mean flux vs. Time for Type II burst',$
;psym=1,thick=1


image3d = TVRD(TRUE=1)
WRITE_JPEG, 'backsubbed&raw_lc.jpg', image3d, TRUE=1, QUALITY=100

end