pro fit_cbf_128trace

;Fit the position angle time data fro the trace taken 1.28 Rsun
loadct,0
window,9
cd,'~/Data/22sep2011_event/AIA/Nature_CME_pos'
restore,'flank_positions_20110922.sav'

tim = transpose(time_array[loc[0,*]] + time[28])
ang128 = transpose(abs(x_arr[loc[2,*]] - 360.0))



;--------------------------------------;
;		Select only part of data	   ;
tstart = anytim(file2time('20110922_104000'), /utim)
index_start = where(tim gt tstart)
tim = tim[index_start[0]: n_elements(tim)-6]
ang128 = ang128[index_start[0]: n_elements(ang128)-6]


utplot, tim, ang128,  psym=4, color=7
err = dblarr(n_elements(ang128))
err[*] = 3.0


oploterror, tim, ang128, err, psym=4, color=7, /nohat


result = linfit(tim, ang128)
y = result[0] + result[1]*tim
oplot, tim, y


;---------------USE MPFITEXPR TO GET EXTRA PARAMS------------------------;
window,10

start = [result[0], result[1]]
fit =  'p[0] + p[1]*x'; + 0.5*p[2]*(x^2.0)'
errors  = ang128 
errors[*] = 2.5
tim = tim - tim[0]

plot, tim, ang128
oploterror, tim, ang128, err, psym=4, color=7, /nohat

fit_params = mpfitexpr(fit, tim, ang128, errors, start, perror=perror, $
						bestnorm=bestnorm, dof=dof)


tsim = (dindgen(1000)*(tim[n_elements(tim)-1] - tim[0])/999.0 ) + tim[0]
asim = dblarr(n_elements(tsim))
asim = fit_params[0] + fit_params[1]*tsim ;+ 0.5*fit_params[2]*tsim^2.0

oplot, tsim, asim
msg = ['Produced using fit_cbf_128trace.pro']
save, tsim, asim, msg, filename='angle_time_fit_128trace.sav'
set_line_color


	print,'	'
	print,'-----------------------------'
	print,'Linear Fit'
	print,'EUV Speed: '+ string(fit_params[1]*!DTOR*(1.27*6.955e5))+$
	'+/-'+string(perror[1]*sqrt(bestnorm)*!DTOR*(1.27*6.955e5)) +'km/s' ;bestnorm usually bestnorm/doff
	;print,'EUV Acceleration: '+ string(fit_params[2]*!DTOR*(1.0*6.955e8))+$
	;' +/-'+string(perror[2]*sqrt(bestnorm/dof)*!DTOR*(1.0*6.955e8)) +'km/s/s'
	print,'-----------------------------'
	print,'	'

stop

END