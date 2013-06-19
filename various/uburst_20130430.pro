pro uburst_20130430

cd,'~/Desktop'

files = findfile('*.fit')
a = anytim(file2time('20130429_192800'), /utim)
b = anytim(file2time('20130429_193000'), /utim)

;----------------------------------;
;			Read files			   ;

radio_spectro_fits_read, files[0], data_lbaA, time_lbaA, freq_lbaA
radio_spectro_fits_read, files[2], data_lbaB, time_lbaB, freq_lbaB
radio_spectro_fits_read, files[1], data_low, time_low, freq_low


dataA = constbacksub(data_lbaA, /auto)
dataB = constbacksub(data_lbaB, /auto)
data_low = constbacksub(data_low, /auto)

loadct,5
window, 0, xs=700, ys=1000
spectro_plot, dataA > (-10), time_lbaA, freq_lbaA, /xs, /ys, xr=[a,b], yr=[80,10], $
ytitle='Frequency (MHz)', title='A_LBA', position = [0.1, 0.55, 0.95, 0.95], /normal,$
/noerase

spectro_plot, dataB > (-10), time_lbaB, freq_lbaB, /xs, /ys, xr=[a,b], yr=[80,10], $
ytitle='Frequency (MHz)', title='B_LBA', position = [0.1, 0.05, 0.95, 0.45], /normal,$
/noerase



window,2
spectro_plot, data_low > (-10), time_low, freq_low, /xs, /ys, xr=[a,b], yr=[80,10], $
ytitle='Frequency (MHz)', title='Bicone'




END