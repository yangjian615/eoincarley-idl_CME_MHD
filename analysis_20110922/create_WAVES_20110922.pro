pro create_WAVES_20110922

cd,'/Users/eoincarley/Data/22sep2011_event/WAVES'
restore,'20110922.R1', /verb

length = n_elements(arrayb[*,0])
time_array = dblarr(length)
time_array[0] = anytim(file2time('20110922_000000'),/utim)

FOR i = 1.0, length-1 DO BEGIN
	time_array[i] = time_array[0] + i*60.0
ENDFOR	

n_channels = 256
freq = (dindgen(n_channels)*(1.04 - 0.02)/(n_channels-1))+0.02

freq = reverse(freq)
arrayb = transpose(reverse(transpose(arrayb)))
t1 = anytim(file2time('20110922_100000'),/utim)
t2 = anytim(file2time('20110922_110000'),/utim)
spectro_plot, filter_image(sigrange(arrayb),fwhm=2), time_array, freq, /xs, /ys, xr=[t1, t2]
save, arrayb, time_array, freq, filename='WAVES_RAD1_20110922.sav'





END

