pro nancay_decametric_array, create_dynspec=create_dynspec

IF keyword_set(create_dynspec) THEN BEGIN

	files = findfile('*.RT1')
	result = read_binary(files[0], data_start=405)
	
	nsteps = 8000
	nfreq = 402
	dyn_spec_r=dblarr(nfreq, nsteps)
	dyn_spec_l=dblarr(nfreq, nsteps)
	times = dblarr(nsteps)
	freq = (dindgen(nfreq)*(82.0 - 8.0)/(nfreq-1.0))+8.0
	
	set_line_color

	loadct,5
	start_pos = 0
	inc = 405.0	
	j=0.0
	FOR i=start_pos*inc, (start_pos+2.0*nsteps)*inc-1.0, (2.0*inc) DO BEGIN

		t = '20110922_'+string(result[i],format='(I02)') + string(result[i+1],format='(I02)') $
			+ string(result[i+2],format='(I02)');+string(result[i+3],format='(I02)')
		print,t
		light_curve_right = reverse(result[i+4 : i+inc])
		light_curve_left = reverse(result[i+inc+4.0 : i+2.0*inc])
		plot, light_curve_right, yr=[0,250], title=anytim(file2time(t), /yoh), charsize=2
		oplot, light_curve_left, color=5
		stop
	
		;Only every second step
		times[j] = anytim(file2time(t), /utim)
		;print,anytim(times[j], /yoh)
		dyn_spec_r[*,j] = light_curve_right
		dyn_spec_l[*,j] = light_curve_left
		wset,0
		;plot_image,congrid(transpose(dyn_spec_r), 800, 400), title=anytim(times[j], /yoh)

		print, light_curve_left
		print, light_curve_right
		
		j=j+1	
		print,'------------'
		print, i, j
		print,'------------'

	ENDFOR
	
	
times = times
dyn_spec_r = transpose(dyn_spec_r)
dyn_spec_l = transpose(dyn_spec_l)
;save,dyn_spec_r,times,freq,filename='20110922_dyn_spec_r.sav'
;save,dyn_spec_l,times,freq,filename='20110922_dyn_spec_l.sav'
ENDIF
!p.multi=[0,1,2]
!p.charsize=2
loadct,5
restore,'20110922_dyn_spec_r.sav'
z_bs_r = constbacksub(dyn_spec_r, /auto)
a = anytim(file2time('20110922_100000'), /utim)
b = anytim(file2time('20110922_111500'), /utim)
spectro_plot, z_bs_r >(-10), times, reverse(freq), /xs, /ys, xr=[a,b],$
title='Nancay Deca Array: Right Hand Polarised', ytitle = 'Frequency (MHz)'


restore,'20110922_dyn_spec_l.sav'
z_bs_l = constbacksub(dyn_spec_l, /auto)
spectro_plot, z_bs_l >(-10), times, reverse(freq), /xs, /ys, xr=[a,b], $
title='Nancay Deca Array: Left Hand Polarised',  ytitle = 'Frequency (MHz)'

!p.multi=[0,1,1]
window,1
spectro_plot, z_bs_l + z_bs_r >(-10) <210, times, reverse(freq), /xs, /ys, xr=[a,b], $
title='Nancay Deca Array: Left Hand Polarised',  ytitle = 'Frequency (MHz)'


stop
END