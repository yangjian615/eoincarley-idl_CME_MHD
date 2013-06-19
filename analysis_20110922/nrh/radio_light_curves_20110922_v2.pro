pro radio_light_curves_20110922_v3

; v3 now using the Stokes light curves 17-May-2013

cd,'/Users/eoincarley/Data/CALLISTO/20110922'
t1 = anytim(file2time('20110922_103500'),/utim)
t2 = anytim(file2time('20110922_110000'),/utim)
files = findfile('*.fit')

radio_spectro_fits_read,files[1], low1data, l1time, lfreq
radio_spectro_fits_read,files[4], low2data, l2time, lfreq
radio_spectro_fits_read,files[2], mid1data, m1time, mfreq
radio_spectro_fits_read,files[5], mid2data, m2time, mfreq

low_data = [low1data, low2data]
low_times = [l1time, l2time]

mid_data = [mid1data, mid2data]
mid_times = [m1time, m2time]

low_data_bg = constbacksub(low_data, /auto)
mid_data_bg = constbacksub(mid_data, /auto)

mean_low = fltarr(n_elements(low_times))
mean_mid = fltarr(n_elements(mid_times))
mean_all = fltarr(n_elements(low_times))
FOR i=0, n_elements(low_times)-1 DO BEGIN
	mean_low[i] = mean(low_data[i,*])
	mean_mid[i] = mean(mid_data_bg[i,*])
	mean_all[i] = mean([mean_low[i], mean_mid[i]])
ENDFOR	

index = closest(mfreq, 150)

mean_mid = sum(mid_data_bg[*, index-20:index+20],1)

;-------------- Plot Moving Peak  ------------------;

cd,'/Users/eoincarley/Data/22sep2011_event/NRH/hi_time_res/pngs'
restore,'stoke_light_curves.sav'

loadct,39
!p.color=0
!p.background=255
window,10,xs=1000,ys=400
!p.multi=[0,1,1]

axis, yaxis=1, ystyle=4
utplot, times, alog10(MAX_V_POS), /xs, /ys, $
xr=[t1,t2], charsize=2.0, $
/noerase, color=130, thick=2.0, title='Moving Peak'
smoot=30
axis, yaxis=1, ystyle=4
axis, yaxis=1, yr=[-0.5,1], /ys, /save
oplot, low_times, smooth(mean_mid/max(mean_mid), smoot)+0.3, color = 0
stop

;-------------- Plot Stationary Peak  ------------------;


window,11,xs=1000,ys=400
!p.multi=[0,1,1]


utplot, anytim(NRH_TIMES,/utim), alog10(stationary_peak_max), $
xr=[t1,t2], charsize=2, ytitle='Mean Intensity', tick_unit = 2.0*60.0, xticklen=-0.01, yticklen=-0.01, $
/noerase, color=100, thick=2.0, title='Stationary Peak', /ys

axis, yaxis=1, ystyle=4
axis, yaxis=1, yr=[-0.5,1], /ys, /save
oplot, low_times, smooth(mean_mid/max(mean_mid), smoot), color = 0


addition = STATIONARY_PEAK_MAX + MOVING_PEAK_MAX


END