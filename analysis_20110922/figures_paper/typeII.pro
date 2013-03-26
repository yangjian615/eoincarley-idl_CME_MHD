pro typeII

; Widen time axis for sonoma talk. v3 is one for paper

t1 = anytim(file2time('20110922_103500'),/utim)
t2 = anytim(file2time('20110922_104500'),/utim)

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
mid_data= [mid1data, mid2data]
mid_times = [m1time, m2time]
mid_data_bg = constbacksub(mid_data, /auto)
low_data_bg = constbacksub(low_data, /auto)
;mid_data_bg = constbacksub(mid_data, /auto)
low_data_bg[*,  low_FM_index[0] : low_FM_index[n_elements(low_FM_index)-1] ] = -15.0
mid_data_bg[*,  mid_FM_index[0] : mid_FM_index[n_elements(mid_FM_index)-1] ] = -10.0



;set_plot,'ps'
;!p.font=0
;device,filename = 'typeII_20110922.ps',$
;	/color, /inches, /encapsulate, $
;	ysize=6, xsize=8, bits_per_pixel=8, xoffset=0, yoffset=0,/helvetica


;------------- First Dynamic Spectra ----------------------

loadct,5
stretch, 40, 230, 1.1


spectro_plot, low_data_bg > (-25.0) < 100.0, low_times, lfreq, /xs, /ys, $
xr=[t1,t2], charsize=1.0, yr=[90,20], yticks=8, yminor=2, $
xticklen=-0.01, yticklen=-0.01, tick_unit=4.0*60.0, $
xtickame=['A ',' ',' '], $
;position=[0.1, 0.63, 0.9, 0.95], /noerase, xtitle='!6 '
position=[0.1, 0.1, 0.9, 0.9]


;sim_freq = (dindgen(101)*(100.0-10.0)/100.0 ) +10.0
;sim_tim = dblarr(n_elements(sim_freq))
;sim_tim[*] = anytim(time_bar,/utim)
;plots,sim_tim,sim_freq,/data,color=255,thick=2,linestyle=2

END