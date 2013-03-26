pro figure4_20110922_paper

;Compare NRH and RSTO lightcurves.


t1 = anytim(file2time('20110922_103900'),/utim)
t2 = anytim(file2time('20110922_105700'),/utim)

;***************  		CALLISTO DATA		********************;
cd,'/Users/eoincarley/Data/CALLISTO/20110922'

files = findfile('*.fit')
radio_spectro_fits_read,files[0], low1data, l1time, lfreq
radio_spectro_fits_read,files[2], low2data, l2time, lfreq
radio_spectro_fits_read,files[1], mid1data, m1time, mfreq
radio_spectro_fits_read,files[3], mid2data, m2time, mfreq


;Put in the FM band blackout
low_FM_index = where(lfreq gt 90.0)
low_data = [low1data, low2data]
low_times = [l1time, l2time]

;Put in the FM band blackout
mid_FM_index = where(mfreq lt 112.0)
mid_data = [mid1data, mid2data]
mid_times = [m1time, m2time]

low_data_bg = constbacksub(low_data, /auto)
mid_data_bg = constbacksub(mid_data, /auto)
;low_data_bg[*,  low_FM_index[0] : low_FM_index[n_elements(low_FM_index)-1] ] = -15.0
;mid_data_bg[*,  mid_FM_index[0] : mid_FM_index[n_elements(mid_FM_index)-1] ] = -10.0


mid_light_curve = avg(mid_data_bg,1) 



cd,'/Users/eoincarley/Data/22sep2011_event/NRH'
restore,'intensity_v_time_150MHz.sav',/verb
intensity_150 = alog10(intensity)
restore,'intensity_v_time_450MHz.sav',/verb
intensity_445 = alog10(intensity)
window,0
utplot, anytim(nrh_times,/utim), (intensity_150)/max(intensity_150), /xs, /ys, $
xr=[t1,t2], charsize=1.0, tick_unit = 5.0*60.0, xticklen=-0.01, yticklen=-0.01,$
thick=1.5,$
ytitle='!6log(T!Lb!N) [K]'

window,1
set_line_color
utplot,mid_times,smooth(mid_light_curve/max(mid_light_curve),30)*0.15 +0.8, /xs, /ys, $
xr=[t1,t2], charsize=1.0, tick_unit = 5.0*60.0, xticklen=-0.01, yticklen=-0.01, yr=[0.7,1],$
color=3

;utplot,mid_times,smooth(mid_light_curve/max(mid_light_curve),30), /xs, /ys, $
;xr=[t1,t2], charsize=1.0, tick_unit = 5.0*60.0, xticklen=-0.01, yticklen=-0.01, yr=[0.6,1]


cd,'/Users/eoincarley/Data/22sep2011_event/NRH'
restore,'s_position_20110922.sav'
source_peak_Tb = alog10(source_peak_Tb)
oplot, anytim(nrh_times,/utim), ((source_peak_Tb)/max(source_peak_Tb))
;utplot, anytim(nrh_times,/utim), (source_peak_Tb)/max(source_peak_Tb), /xs, /ys, $
;xr=[t1,t2], charsize=1.0, tick_unit = 5.0*60.0, xticklen=-0.01, yticklen=-0.01,$
;thick=1.5,yr = [0.7,1]


stop
END