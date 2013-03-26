function freqdrift,timeArray,freqArray

;openr,100,timeArray
;timeArray= fltarr(150000)
;readf,100,timeArray
;close,100

;openr,100,freqArray
;freqArray = fltarr(150000)
;readf,100,freqArray
;close,100

newFreq5 = fltarr(150000)
newFreq10 = fltarr(150000)
newFreq20 = fltarr(150000)
for i=35, 265, 5 do begin

     index = closest(freqArray, i)
     newFreq5[index] = i
     
endfor

for i=35, 265, 10 do begin

     index = closest(freqArray, i)
     newFreq10[index] = i
     
endfor

for i=35, 265, 20 do begin

     index = closest(freqArray, i)
     newFreq20[index] = i
     
endfor

loadct,39
!p.color=0
!p.background=255

!p.multi=[0,3,1]


plot,timeArray(*),newFreq5(*),psym = 1,yrange=[800,40], $
xtitle='Time (s)',ytitle = 'Frequency (MHz)', title = 'Freq resolution: 5 MHz',charsize=3, $
min_value = 1, thick = 2, /xs, /ys

plot,timeArray(*),newFreq10(*),psym = 1,yrange=[800,40], $
xtitle='Time (s)',ytitle = 'Frequency (MHz)', title = 'Freq resolution: 10 MHz',charsize=3, $
min_value = 1, thick = 2, /xs, /ys

plot,timeArray(*),newFreq20(*),psym = 1,yrange=[800,40], $
xtitle='Time (s)',ytitle = 'Frequency (MHz)', title = 'Freq resolution: 20 MHz',charsize=3, $
min_value = 1, thick = 2, /xs, /ys


end

