PRO coldISM
;+
;
;  Sample IDL code to illustrate Newton-Raphson's Method to 
;  find the maximum of the frequency form of the Planck 
;  (Blackbody) Function Bnu(T)
;
;
;  Solve for x=h*nu/(k*T)  - so for a given T find nu at max
;
;  N-R Scheme:  x[i+1] = x[i] - f(x[i])/dfdx(x[i])
;
;  where f(x) is the derivative of Bnu(T)
;  Peak is where the gradient of Planck function = zero 
;
;  Need to solve f(x)=exp(x)*(3 - x) - 1
;  where x = h*nu/(k*T)
;
;  Use analytic derivatives (always best when possible)
;
;  Dr. Graham M. Harper, School of Physics
;  Trinity College, Dublin
;  Version 1.0: January 31st 2011
;
;-

itmax = 500   ;  maximum # of iterations 
eps = 1.d-05  ;  when fractional change in x is < eps then 
              ;  it is converged and stop

x_guess= 55.   ; initial guess (a careful guess is required)
PRINT, ' eps and initial x', eps, x_guess

; solution loop
;
x = x_guess    ; start with guess
FOR iter=1, itmax DO BEGIN
  fx   = ( ( exp(-92/x) )/x^0.5 )- 0.025
  dfdx = ( (92*exp(-92/x))/x + (0.5*exp(-92/x))/sqrt(x))/x
  xcorr = -fx/dfdx
  IF (ABS(xcorr/x) LT eps) THEN GOTO, CONV 
  x = x + xcorr
  PRINT, 'Iter,x,xcorr',iter, x, xcorr
ENDFOR
PRINT, '*** WARNING *** UNCONVERGED'
GOTO, OUTRO
CONV: PRINT,' Converged at iter #',iter
PRINT, ' y is xero at T =',x
  
OUTRO:

; eos
;
END
