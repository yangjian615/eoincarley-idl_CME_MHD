function range, x1, x2, step = step, nsteps = nsteps
	
	one = 1.0d
	x1 = x1*one
	x2 = x2*one
	
	IF keyword_set(step) THEN BEGIN
		step = step*one
		nsteps = nsteps*one
		nsteps = abs(x2-x1)/step
		y = x1 + dindgen(nsteps)*(x2 - x1)/(nsteps-1.0)
		return, y
	ENDIF
	
	IF keyword_set(nsteps) THEN BEGIN
		nsteps = nsteps*one
		y = x1 + dindgen(nsteps)*(x2 - x1)/(nsteps-1.0)
		return, y
	ENDIF
	

END
