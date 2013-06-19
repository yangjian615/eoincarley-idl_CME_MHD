pro nancay_decametric_array_v2

; v2 now implements a much neater construction of the data
; It also saves 30 minute segemtns of the data

	data_block=405
	files = findfile('*.RT1')
	result = read_binary(files[0], data_start=data_block) ;skip header in first 405 entries
	dimen_result = size(result)
	n_time_steps = dimen_result[1]/(data_block*2)         ;There's a left and right channel so x2
	nfreq = 400
	
	spectro_duration = 1800                               ;Half hour long files
	spectro_r=dblarr(nfreq, spectro_duration)
	spectro_l=dblarr(nfreq, spectro_duration)
	tim_l = dblarr(spectro_duration)
	tim_r = dblarr(spectro_duration)
	
	freq = (dindgen(nfreq)*(82.0 - 8.0)/(nfreq-1.0))+8.0
	
	inc = data_block*1.0d
	j=0
	FOR i=0, n_time_steps, 2 DO BEGIN
		
		indeces1 = dindgen(inc) + i*inc
		indeces2 = dindgen(inc) + (i+1)*inc
		
		left_channel = result[indeces1]	
		right_channel = result[indeces2]

		left_t = left_channel[0:3]
		right_t = right_channel[0:3]
		
		left_flux = left_channel[4:403]
		right_flux = right_channel[4:403]
		
		spectro_l[*,j] = reverse(left_flux)
		spectro_r[*,j] = reverse(right_flux)

		tim_l[j] = proper_t_format(left_t)
		tim_r[j] = proper_t_format(right_t)
		
		print, anytim(proper_t_format(left_t), /yoh)
		print, anytim(proper_t_format(right_t), /yoh)
		j=j+1
		
		
		plot, left_flux
		print, i
		print,' '
		print,' '
	
		IF j gt spectro_duration-1 THEN BEGIN
			spectro_l = transpose(spectro_l)
			spectro_r = transpose(spectro_r)
			window,0
			spectro_plot, spectro_l, tim_l, freq, /xs, /ys, title = 'LHCP'
			window,1
			spectro_plot, spectro_r, tim_r, freq, /xs, /ys, title = 'RHCP'
			
			save, spectro_l, tim_l, freq, filename = 'NDA_'+time2file(tim_l[0])+'_left.sav'
			save, spectro_r, tim_r, freq, filename = 'NDA_'+time2file(tim_r[0])+'_right.sav'
			
			spectro_r=dblarr(nfreq, spectro_duration)
			spectro_l=dblarr(nfreq, spectro_duration)
			tim_l = dblarr(spectro_duration)
			tim_r = dblarr(spectro_duration)
			j = 0	
		ENDIF
		
	ENDFOR
	
END



function proper_t_format, t

tnew = '20110922_'+string(t[0],format='(I02)') + string(t[1],format='(I02)') $
			+ string(t[2],format='(I02)') + string(t[3],format='(I02)')
			
tnew = anytim(file2time(tnew), /utim)			

return, tnew
END

