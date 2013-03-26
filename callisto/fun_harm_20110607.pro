pro fun_harm_20110607
j=6

cd,'/Users/eoincarley/Data/CALLISTO/20110607/type_II
loadct,39
!p.color=0
!p.background=255
spectro = findfile('back_hough_typeII*.sav')
restore,spectro[j]
restore,'times.sav'
restore,'freq.sav'



f0 = closest(freq,36)
f1 = closest(freq,50)
f2 = closest(freq,70)
f3 = closest(freq,92)
ratio = fltarr(n_elements(normal_back[*,0]))
harmonic = fltarr(2,n_elements(normal_back[*,0]))
fundamental = fltarr(2,n_elements(normal_back[*,0]))

;type_II_mpeg = mpeg_open([100,100])

window,0
loadct,1
stretch,255,0
!p.color=255
!p.background=0
spectro_plot,bytscl((normal_back),0.4,0.8),times,freq,/xs,/ys,ytitle='Frequency (MHz)',$
title='Back projected Hough trasnform of type II',charsize=1.5


loadct,39
!p.color=0
!p.background=255
window,1
FOR i =0, n_elements(normal_back[*,0])-1 DO BEGIN
	plot,freq,normal_back[i,*],/xs,ytitle='Normalised Intensity',xtitle='Frequency (MHz)',$
	charsize=1.5;,title='Intensity v. Frequency'

	first_max = max(normal_back[i,f1:f0])
	fund_pos = closest(normal_back[i,*], first_max)
	fund = freq[fund_pos]

	second_max = max(normal_back[i,f3:f2])
	harm_pos = closest(normal_back[i,*], second_max)
	harm = freq[harm_pos]
	
	plots,[fund,fund],[0,first_max],/data,color=240,linestyle=3,thick=1
	plots,[harm,harm],[0,second_max],/data,color=240,linestyle=3,thick=1
	ratio[i] = harm/fund
    harmonic[0,i]=times[i]
    harmonic[1,i] = harm
    fundamental[0,i]= times[i]
    fundamental[1,i]= fund
    
	xyouts,0.12,0.95,'Fundamental Harmonic ratio: '+STRTRIM(STRING(ratio[i], FORMAT='(f10.2)'), 2),$
	/normal,charsize=1.5
	xyouts,0.68,0.95,anytim(times[i],/yoh),charsize=1.5,/normal
	cd,'/Users/eoincarley/Data/CALLISTO/20110607/type_II/animation/'
	x2png,i+'.png'
	cd,'/Users/eoincarley/Data/CALLISTO/20110607/type_II/'
     
	;mpeg_put,type_II_mpeg,window=1,frame=i
	wait,0.25
ENDFOR
mean_ratio = mean(ratio)


;==============Plot harmonic versus time===================
window,2
utplot,times[*],harmonic[1,*]/mean_ratio,psym=1,charsize=1.5,$
ytitle='Frequency of Emission (MHz)',/xs,/ys
oplot,times[*],fundamental[1,*],psym=2


;stop
lin_har = linfit(times[0:n_elements(times)-2],harmonic[1,*]/mean_ratio)
print,'================================================================'
print,'================================================================'
print,'Back projected Hough transform used :' +spectro[j]
print,'Mean of the ratio of fundamental to harmonic :'+STRTRIM(STRING(mean_ratio, FORMAT='(f10.2)'), 2)

print,'Harmonic drift rate :'+string(lin_har[1])+' MHz/s'
lin_fun = linfit(times[0:n_elements(times)-2],fundamental[1,*])
print,'Fundamental drift rate :'+string(lin_fun[1])+' MHz/s'
altitude=fltarr(n_elements(harmonic[1,*]))
altitude[*] = 4.32/alog10(((harmonic[1,*]*1.0e6/mean_ratio)^2) /3.385e12)

lin_alt = linfit(times[0:n_elements(times)-2],altitude[*])
print,'Velocity :'+string(lin_alt[1]*6.6955e5)+' km/s (Using 1*Newkirk density model)'
print,'================================================================'
print,'================================================================'


END
