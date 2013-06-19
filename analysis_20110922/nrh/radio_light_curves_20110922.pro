pro radio_light_curves_20110922

cd,'/Users/eoincarley/Data/CALLISTO/20110922'
t1 = anytim(file2time('20110922_104000'),/utim)
t2 = anytim(file2time('20110922_105900'),/utim)
files = findfile('*.fit')
stop
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
	mean_mid[i] = mean(mid_data[i,*])
	mean_all[i] = mean([mean_low[i], mean_mid[i]])
ENDFOR	



;*******     Plot light curves     **********

cd,'/Users/eoincarley/Data/22sep2011_event/NRH'
restore,'nrh_total_flux_150.sav'
stop_ind = n_elements(nrh_total_flux_150) - 1

restore,'moving_peak_max_intesnity_vs_time.sav'
restore,'stationary_peak_max_intesnity_vs_time.sav'
loadct,39
!p.color=0
!p.background=255
window,0,xs=600,ys=600
!p.multi=[0,1,1]

utplot,anytim(NRH_TIMES,/utim),smooth(MOVING_PEAK_MAX/max(MOVING_PEAK_MAX),3),/xs,/ys,$
xr=[t1,t2],charsize=1.5,ytitle='Mean Intensity',tick_unit = 2.0*60.0,xticklen=-0.01,yticklen=-0.01,$
/noerase, color=130,yr=[0,1.0],thick=2.0,title='Moving Peak'
;oplot,congrid(low_times,121),congrid(mean_mid/max(mean_mid),121)^10.0 - 0.55,color = 0
oplot, low_times, smooth((mean_mid/max(mean_mid))^10.0 - 0.55,10), color = 0
result1=correlate(congrid(mean_mid/max(mean_mid),121)^10.0, MOVING_PEAK_MAX/max(MOVING_PEAK_MAX))


;legend,['Mean Radio Intensity 10 - 100 MHz','Mean Radio Intensity 110 - 150 MHz',$
;'Moving NRH flux (150MHz)'],color=[70,200,130],$
;linestyle=[0,0,0],charsize=1.0,box=0


window,1,xs=600,ys=600
!p.multi=[0,1,1]

;******************************************************************

utplot,anytim(NRH_TIMES,/utim),smooth(STATIONARY_PEAK_MAX/max(STATIONARY_PEAK_MAX),1),$
xr=[t1,t2],charsize=1.5,ytitle='Mean Intensity',tick_unit = 2.0*60.0,xticklen=-0.01,yticklen=-0.01,$
/noerase, color=100,yr=[0,1.0],thick=2.0,title='Stationary Peak'
oplot,low_times,(mean_mid/max(mean_mid))^10.0 - 0.55 ,color = 0
result2=correlate(congrid(mean_mid/max(mean_mid),121)^10.0,STATIONARY_PEAK_MAX/max(STATIONARY_PEAK_MAX))
;legend,['Mean Radio Intensity 10 - 100 MHz','Mean Radio Intensity 110 - 150 MHz',$
;'Moving NRH flux (150MHz)'],color=[70,200,130],$
;linestyle=[0,0,0],charsize=1.0,box=0

addition = STATIONARY_PEAK_MAX + MOVING_PEAK_MAX

window,2,xs=600,ys=600
!p.multi=[0,1,1]

;******************************************************************

;utplot,anytim(NRH_TIMES,/utim),addition/max(addition),$
;xr=[t1,t2],charsize=1.5,ytitle='Mean Intensity',tick_unit = 2.0*60.0,xticklen=-0.01,yticklen=-0.01,$
;/noerase, color=240,yr=[0,1.0],thick=2.0,title='Sum'
;oplot,congrid(low_times,121),congrid(mean_mid/max(mean_mid),121),color = 0

utplot,time_nrh_total_flux[1:stop_ind], nrh_total_flux_150[1:stop_ind]/$
max(nrh_total_flux_150[1:stop_ind]),/xs, /ys,$
xr=[t1,t2],charsize=1.0,ytitle='Mean Intensity',tick_unit = 2.0*60.0,xticklen=-0.01,yticklen=-0.01,$
/noerase, color=130,yr=[0,1.4],thick=2.0,title='Total Intesnity'

oplot, congrid(mid_times,121), congrid(smooth(mean_mid/max(mean_mid),50)^10.0,121)-0.55,color = 0

result3=correlate(congrid(mean_mid/max(mean_mid),121)^10.0,addition/max(addition) )
print,result3
stop

END