pro testing20


cd,'/Users/eoincarley/Data/CALLISTO/20110607/Fits'
radio_spectro_fits_read,'BIR_20110607_062400_10.fit', z_zoom, x_zoom, y_zoom
z_zoom = constbacksub(z_zoom, /auto)
;loadct,5	

gradient_normalise, z_zoom, result
a = anytim(file2time('20110607_062550'),/utim)
b = anytim(file2time('20110607_062630'),/utim)

spectro_plot, smooth(result,1) >(-20) <45, x_zoom, y_zoom, $
	/xs, xr=[a,b], $
	/ys, yr=[35, 90], charsize=1.5
	

END


pro gradient_normalise, data, result
result=data
block=5
FOR i = 0, n_elements(data[0,*])-1, block DO BEGIN

	slice = data[i: i+block-1, *] 
	average = avg(slice, 1)
	average = average - mean(average)
	devi = stdev(average)
	
	result[i: i+block-1, *]  = data[i: i+block-1, *] /devi
	

ENDFOR

END
