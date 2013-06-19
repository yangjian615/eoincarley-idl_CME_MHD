pro lba_first_light

cd,'~/Desktop/first_light'

t1 = anytim(file2time('20130422_102600'), /utim)
t2 = anytim(file2time('20130422_103000'), /utim)

files = findfile('*.fit')

radio_spectro_fits_read, files[0], data_a, time_a, freq
radio_spectro_fits_read, files[1], data_b, time_b, freq



data_a = constbacksub(data_a, /auto)
data_b = constbacksub(data_b, /auto)
!p.multi=[0,1,1]
loadct,5
window,1
spectro_plot, data_a > 2, time_a, freq, /xs, /ys, ytitle='Frequency (MHz)',$
yr=[80,10], xr=[t1,t2], title='LBA A'

window,2
spectro_plot, data_b > 2, time_b, freq, /xs, /ys, ytitle='Frequency (MHz)',$
yr=[80,10], xr=[t1,t2], title='LBA B'

window,3, xs=800, ys=1200
!p.multi=[0,1,2]
data_a = data_a > 2.0
data_b = data_b > 2.0

data_a = filter_image(data_a, /median)
data_b = filter_image(data_b, /median)


polar = (data_a - data_b)/(data_a + data_b)
div_A = data_a/data_b
div_B = data_b/data_a


spectro_plot, div_A > (0.1) <5, time_b, freq, /xs, /ys, ytitle='Frequency (MHz)',$
yr=[80,10], xr=[t1,t2], title=' A/B '
shade_surf, smooth(div_A[2500:3599, *],10), charsize=4, ax=45, xtitle='Time', zr=[1,5]


window,4, xs=800, ys=1200
!p.multi=[0,1,2]
spectro_plot, div_B > (0.1) <5, time_b, freq, /xs, /ys, ytitle='Frequency (MHz)',$
yr=[80,10], xr=[t1,t2], title=' B/A '
shade_surf, smooth(div_B[2500:3599, *],10), charsize=4, ax=45, xtitle='Time', zr=[1,5]

;-------------------------------------------;
;           Plot light curves
;-------------------------------------------;
stop



END