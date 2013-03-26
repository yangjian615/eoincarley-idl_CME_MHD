pro test_newton_raphspon

iter = 100
x0 = 0.20190841

x = range(-1, 1, nsteps=1000)
y = q(x)
plot,x,y



x=x0	
FOR i = 1, iter DO BEGIN
	f = q(x)
	df = qprime(x)
	dx = f/df
	x = x - dx
	print,x
ENDFOR	
	
print,x
;root should be 0.0054858380
END


function q,x
	y = (x^2)-(2.0d*alog(x)) - 10.411199	
	return,y
END

function qprime,x
	yprime = (2.0*x) - 2.0/x	
	return, yprime
END

