pro testing_spline



;define r values
r = (dindgen(51)*(3.-1.)/50)+1.0
;define density values and convert to logs
n = alog10(1.3e6*r^(-2))

;make sure n is monotonically increasing!
n = reform(reverse(n))
;reverse r because n was reversed
r = reverse(reform(r))

plot,n,r,charsize=1.5,xtitle='log(Density) [cm!U-3!N]',ytitle='Radius R/R!Lsun!N'

;convert desnity value you want to find into log also
n_1 = alog10(501187)
;do spline interpolation
r_1 = spline(n,r,5.72243)



print,'Density value of log(Density)='+string(n_1,format='(f5.2)')+' [cm^-3] occurs at '$
+string(r_1,format = '(f4.2)')+' [R_sun]'

END