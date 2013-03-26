pro coronal_heating

	R_photo = 6.9e10	; cm
	R_corona = 1.1 * R_photo
	n = 1e9		; cm^-3
	T = 1e6		; K
	k = 1.38e-16	; ergs K^-1

	V = 4./3. * !pi * ( R_corona^3. - R_photo^3. )	; cm^3
	A = 4. * !pi * R_photo^2			; cm^2

	E = n * k * T * V	; ergs

	print, 'Total thermal energy: ', E, ' ergs'

	dt = 100.	; Typical nanoflare duration 
	P = E / dt
	F = P / A

	print, 'Total power: ', P, ' ergs/s'

	print, 'Flux: ', F, ' ergs/cm^2/s'

end