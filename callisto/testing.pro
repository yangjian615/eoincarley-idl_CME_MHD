pro testing 

cd,'/Users/eoincarley/Data/CALLISTO/20110922'

restore,'peak_times.sav'
wtd = fltarr(28)
FOR i=2,n_elements(peak_times)-1 DO BEGIN
	wtd[i-2] = peak_times[i] - peak_times[i-1]
ENDFOR
loadct,39
!p.color=0
!p.background=255


cumu = dindgen(1001)*(6.0)/1000.0
p = dblarr(n_elements(cumu))

FOR j=0.,n_elements(cumu)-1 DO BEGIN
time = cumu[j]

	FOR i=0.,n_elements(wtd)-1 DO BEGIN
	
  		IF wtd[i] lt time THEN p[j] = p[j]+1.0
	ENDFOR
	
ENDFOR
plot,cumu,p

lambda =2.0
cdf = dblarr(n_elements(p))
FOR i=0, n_elements(p)-1 DO BEGIN
   k = cumu[i]
   summ=0
   FOR j=0.0,k,0.01 DO BEGIN
   summ = summ+ (lambda^j)/factorial(j)
   ENDFOR
   cdf[i] = exp(-2.0)*summ
ENDFOR
oplot,cumu,(cdf/100.0)*28.0

stop
END