pro plot_low_mid_20110922_v3,time_bar, goes, low_data_bg, low_times, mid_data_bg, mid_times,$
   	low_data, mid_data, lfreq, mfreq, mean_low, mean_mid, mean_all

;v2 Removed Goes, now plots full time resolution NRH total intensity
;This is used in create_composite_img_v2

;v3 take light curves out. Just dynamic spectra

;*******		       GOES 			***********
t1 = anytim(file2time('20110922_103800'),/utim)
t2 = anytim(file2time('20110922_105801'),/utim)


;*************************************************************;

;-------------		 Dynamic Spectra			--------------;
loadct,5
stretch,60,240
spectro_plot, low_data_bg, low_times, lfreq, /xs, /ys,$
xr=[t1,t2], yr=[100,10], yticks=9, yminor=2, $
xticks=2, xticklen=-0.005, yticklen=-0.01, $
ytickname=['100','90','80','70','60','50','40','30','20','10'], $
position=[0.05, 0.44, 0.45, 0.85], /noerase, xtitle=' ',$
title='RSTO CALLISTO: '+anytim(time_bar, /yoh, /date_only), charsize=0.9

sim_freq = (dindgen(101)*(100.0-10.0)/100.0 ) +10.0
sim_tim = dblarr(n_elements(sim_freq))
sim_tim[*] = anytim(time_bar,/utim)
plots,sim_tim,sim_freq,/data,color=255,thick=4,linestyle=2


a = anytim(file2time('20110922_103800'),/utim)
b = anytim(file2time('20110922_104200'),/utim)
c = anytim(file2time('20110922_104600'),/utim)
d = anytim(file2time('20110922_105000'),/utim)
e = anytim(file2time('20110922_105400'),/utim)
f = anytim(file2time('20110922_105800'),/utim)

loadct,5
stretch,30,140
spectro_plot, mid_data_bg, mid_times, mfreq, /xs, /ys, $
xr=[t1,t2], yr=[150,100], yticks=5, yminor=2, $
xticklen=0.0, yticklen=-0.01, $
ytickname=['150','140','130','120','110',' '], $
position=[0.05, 0.22, 0.45, 0.44], /noerase, xtitle=' ', xticks=1, xtickname=[' ',' ',' ',' ',' ']

axis,xaxis=0,xticks=5,xtickname=['10:38','10:42','10:46','10:50','10:54','10:58'],$
xticklen=-0.015, xtitle='Time in UT', xminor=4

sim_freq = (dindgen(101)*(200.0-100.0)/100.0 ) + 100.0
sim_tim = dblarr(n_elements(sim_freq))
sim_tim[*] = anytim(time_bar,/utim)

plots,sim_tim,sim_freq,/data,color=255,thick=4,linestyle=2
xyouts,0.015,0.535,'Frequency (MHz)',/normal,orientation=90.0, alignment=0.5
;xyouts,0.04,0.26,'100',/normal,charthick=1, charsize
;x2png,'20110922_burst_all.png'

END