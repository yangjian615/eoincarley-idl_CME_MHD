pro band_splitting_20110922, loop=loop, normalised=normalised
window,0, xs=700, ys=1000
t1 = anytim(file2time('20110922_104115'),/utim)
t2 = anytim(file2time('20110922_104210'),/utim)

;***************  		CALLISTO DATA		********************;
cd,'/Users/eoincarley/Data/CALLISTO/20110922'

files = findfile('*.fit')
radio_spectro_fits_read,files[0], low1data, l1time, lfreq
radio_spectro_fits_read,files[2], low2data, l2time, lfreq
radio_spectro_fits_read,files[1], mid1data, m1time, mfreq
radio_spectro_fits_read,files[3], mid2data, m2time, mfreq


;Put in the FM band blackout
low_FM_index = where(lfreq gt 90.0)
low_data = [low1data, low2data]
low_times = [l1time, l2time]

;Put in the FM band blackout
mid_FM_index = where(mfreq lt 112.0)
mid_data= [mid1data, mid2data]
mid_times = [m1time, m2time]
mid_data_bg = constbacksub(mid_data, /auto)
low_data_bg = constbacksub(low_data, /auto)


loadct,5
stretch, 51, 230, 1.1


spectro_plot, smooth(low_data_bg,3) > (-30.0) < 100.0, low_times, lfreq, /xs, /ys, $
xr=[t1,t2], charsize=2.0, yr=[90,20], yticks=8, yminor=2, $
xticklen=-0.01, yticklen=-0.01



	index1 = closest(low_times, t1)
	index2 = closest(low_times, t2)


gradient_normalise, low_data_bg, index1, index2, result

spectro_plot, smooth(result,3) >(-5.0) <9.0 , low_times, lfreq, /xs, /ys, $
		xr=[t1,t2], charsize=1.5, yr=[90,20], yticks=7, yminor=2, $
		xticklen=-0.01, yticklen=-0.01, ytitle='Frequency (MHZ)'
		
spectro_plot, smooth(low_data_bg,3) > (-30.0) < 100.0 , low_times, lfreq, /xs, /ys, $
		xr=[t1,t2], charsize=1.5, yr=[90,20], yticks=7, yminor=2, $
		xticklen=-0.01, yticklen=-0.01, ytitle='Frequency (MHZ)'		




;point,x,y
;print,y[0]/y[1]

;spawn,'mkdir band_splitting'
cd,'band_splitting'

freq_line = -0.30110324*(low_times)

IF keyword_set(loop) THEN BEGIN
	tims = dblarr(n_elements(lfreq))
	FOR i = index1, index2 DO BEGIN
		Device, RETAIN=2
		!p.multi=[0,1,2]
		wset,0
		IF keyword_set(normalised) THEN BEGIN
			spectro_plot, smooth(result,3) >(-5.0) <9.0 , low_times, lfreq, /xs, /ys, $
			xr=[t1,t2], charsize=1.5, yr=[90,20], yticks=7, yminor=2, $
			xticklen=-0.01, yticklen=-0.01, ytitle='Frequency (MHZ)'
			tims[*] = low_times[i]
			plots,tims,lfreq,linestyle=0
		
			plot, lfreq, smooth(result[i,*],5), /xs, /ys, xtitle='Frequency (MHZ)', $
			ytitle='Intensity', charsize=1.5, xr=[20,90], yr=[-1,4]
			;x2png,anytim(low_times[i],/yoh,/trun)+'.png'
		ENDIF ELSE BEGIN	
			spectro_plot, smooth(low_data_bg,3) > (-30.0) < 100.0 , low_times, lfreq, /xs, /ys, $
			xr=[t1,t2], charsize=1.5, yr=[90,20], yticks=7, yminor=2, $
			xticklen=-0.01, yticklen=-0.01, ytitle='Frequency (MHZ)'
			tims[*] = low_times[i]
			plots, tims, lfreq, linestyle=0
	
			
			plot, lfreq, smooth(low_data_bg[i,*],3), /xs, /ys, xtitle='Frequency (MHZ)', $
			ytitle='Intensity', charsize=1.5, xr=[20,90], thick=2
		
				;point, freq_interval, junk
				IF low_times[i] lt anytim('22-Sep-11 10:41:51.415', /utim) THEN BEGIN
					freq_peak_guess = -0.30110324*(low_times[i]-low_times[index1]) +70.0
					print,freq_peak_guess
					freq_interval=[freq_peak_guess - 5.0, freq_peak_guess+5.0]
				ENDIF ELSE BEGIN
					stop
					;point, freq_interval, junk
				ENDELSE	
				gaussian, smooth(low_data_bg[i,*],3), lfreq, low_times[i], freq_interval
				wait,0.2
		ENDELSE
	
		

	ENDFOR	
ENDIF
END

pro gradient_normalise, data, ind_start, ind_end, result
result=data
block=10
FOR i = ind_start, ind_end, block DO BEGIN

	slice = data[i: i+block-1, *] 
	average = avg(slice, 0)
	average = average - mean(average)
	devi = stdev(average)
	
	result[i: i+block-1, *]  = data[i: i+block-1, *] /devi
	

ENDFOR

END

pro gaussian, prof, freqs, time, f_inter

	indexf1 = closest(freqs, f_inter[1])
	indexf2 = closest(freqs, f_inter[0])
	!p.multi=[0,1,1]
	window,3
	fs = freqs[indexf1:indexf2]
	section =  prof[0,indexf1:indexf2]
	intens = prof
	intens[0, 0:indexf1]  = min(section)
	intens[0, indexf2:n_elements(freqs)-1] = min(section)

	plot, freqs, intens, /xs

	Result = GAUSSFIT(freqs, intens, a, nterms=4, sigma=sigma)
	oplot,freqs,result, thick=3

text_file='har2_gauss_test.txt'
IF file_test(text_file) eq 1 THEN BEGIN
	readcol,text_file, t, a0, a1, a2, a3, sigma0, sigma1, sigma2, sigma3, $
	format = 'A,D,D,D,D,D,D,D,D'
	
	t = [t, anytim(time, /CCSDS)]
	a0 = [a0, a[0]]
	a1 = [a1, a[1]]
	a2 = [a2, a[2]]
	a3 = [a3, a[3]]
	
	sigma0 = [sigma0,sigma[0]]
	sigma1 = [sigma1,sigma[1]]
	sigma2 = [sigma2,sigma[2]]
	sigma3 = [sigma3,sigma[3]]
	
	
ENDIF ELSE BEGIN
	t = anytim(time, /CCSDS)
	a0 = a[0]
	a1 = a[1]
	a2 = a[2]
	a3 = a[3]
	
	sigma0 = sigma[0]
	sigma1 = sigma[1]
	sigma2 = sigma[2]
	sigma3 = sigma[3]
ENDELSE	

writecol,text_file, t, a0, a1, a2, a3, sigma0, sigma1 ,sigma2 ,sigma3, $
fmt = '(A,D,D,D,D,D,D,D,D)'

END




