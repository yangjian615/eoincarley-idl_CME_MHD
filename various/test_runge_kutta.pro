FUNCTION test_fun,x,y

  y=y
  dydx = 10.0*x

return,dydx
END

pro test_runge_kutta

;*******************Initial Values***********************
y = 5.0 
x = 1.0

;*********************Runge-Kutta***********************

H = 0.1d             ;Step size

nsteps = 100.0/H

yfit = dblarr(2,nsteps)

FOR i=0.0, nsteps-1 DO BEGIN
	yfit[0,i]=x
    yfit[1,i]=y 
    dvdr_i = test_fun(x,y)
	Result = RK4( y, dvdr_i, x, H, 'test_fun', /double)
	x=x+H
    y=Result
ENDFOR

p = dindgen(101)
q = 5.0*(p^2.0)
plot,p,q,psym=4,/ylog

loadct,39
oplot,yfit[0,*],yfit[1,*],color=240


END