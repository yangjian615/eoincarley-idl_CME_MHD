pro wtd_herringbones

cd,'/Users/eoincarley/Data/CALLISTO/20110922
files = findfile('*MHz_t.sav')

restore,files[0],/verb
all_times = user_times

FOR i=1,n_elements(files)-1 DO BEGIN
	restore,files[i]
	all_times = [all_times, user_times]
ENDFOR	


loadct,9
!p.color=255
!p.background=0
stretch,255,60
;window,6,xs=500,ys=500

wtd = dblarr(n_elements(all_times))
FOR i=2,n_elements(all_times)-1 DO BEGIN
 wtd[i-2] = all_times[i] - all_times[i-1]
ENDFOR 



hist = HISTOGRAM(wtd,binsize=0.24) 
bins = FINDGEN(N_ELEMENTS(hist)) + MIN(wtd) 
loadct,9
!p.color=0
!p.background=255
window,7,xs=500,ys=500
plot,bins,hist,psym=10,charsize=1.5,xtitle='Waiting time [s]',$
ytitle='No. of burts',xr=[0,25],yr=[0,20],title='Waiting Time Distribution, Herringbone Bursts'
;stop
;loadct,39
;!p.color=0
;!p.background=255
;oploterror,bins,hist,sqrt(hist),color=240,psym=1

;x = dindgen(101)*(30.0-0.0)/100.0
;pois = dblarr(n_elements(x))
;aver = 8.0
;pois[*] = (aver^x[*])*exp(-aver)/factorial(x[*])
;loadct,39
;!p.color=0
;!p.background=255
;oplot,x,pois*n_elements(all_times),color=240,thick=2;*n_elements(times_from_interp)
;stop

END