pro height_fit, n, r_fit, v_fit, a_fit, plot = plot
  

; Set up dummy height data

  r_0 = 150.		; Mm
  v_0 = 400. * 1e-3	; Mm/s
  a_0 = -100 * 1e-6	; Mm/s/s

  t = findgen( 20 ) * 250.
  
  r = r_0 + v_0 * t + 0.5 * a_0 * t^2
  
  ; Add noise
   
  err = randomn( seed, 8 ) * 20. 
  r_err = r + err
    	
  ; Fit noisy data
  
  fit = 'P[0] + P[1] * x + P[2] * x^2'
  fit_params = mpfitexpr( fit, t, r_err, err, perror = fit_sigmas, yfit = yfit, /quiet )
  
  print, ' '
  print, 'Dummy Model Values:'
  print, 'r0 = ', r_0, ' Mm'
  print, 'v0 = ', v_0 * 1000, ' km/s'
  print, 'a0 = ', a_0 * 1e6, ' m/s/s'
  print, ' '

  print, 'Fit Values and 1-sigma Uncertainties:'
  print, 'r0 = ', round( fit_params[ 0 ] ), ' +/- ', arr2str( round( fit_sigmas[ 0 ] ), /trim ), ' Mm'
  print, 'v0 = ', round( fit_params[ 1 ] * 1000.),  ' +/- ' + arr2str( round( fit_sigmas[ 1 ] * 1000. ), /trim), ' km/s'
  print, 'a0 = ', round( 2. * fit_params[ 2 ] * 1e6 ),  ' +/- ' + arr2str( round( fit_sigmas[ 2 ] * 1e6 ), /trim), ' m/s/s'  
  print, ' '
  
  r_fit = fit_params[ 0 ]
  v_fit = fit_params[ 1 ] * 1000.
  a_fit = 2. * fit_params[ 2 ] * 1e6
   
; Plot dummy data with statistical errors

  ploterr, t, r_err, err, xtitle = 'Times (sec)', ytitle = 'Height (Mm)', $
          psym = 4, xrange = [ -100, 2000 ], /xs, $
	  title = 'Model: r0 = 150 Mm, v0 = 400 km/s, a0 = -100 m/s/s ', $
	  yrange = [ 0, 800 ], /ys

; Overplot the dummy data without errors
  
  oplot, t, r, line = 2

; Overplot the fit
  
  oplot, t, yfit
 

end
