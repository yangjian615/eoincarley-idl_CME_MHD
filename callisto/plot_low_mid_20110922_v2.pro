pro plot_low_mid_20110922_v2,time_bar, goes, low_data_bg, low_times, mid_data_bg, mid_times,$
   	low_data, mid_data, lfreq, mfreq, mean_low, mean_mid, mean_all

;v2 Removed Goes, now plots full time resolution NRH total intensity
;This is used in create_composite_img_v2

;*******		       GOES 			***********
t1 = anytim(file2time('20110922_103500'),/utim)
t2 = anytim(file2time('20110922_110000'),/utim)


;utplot,goes[0,*], goes[1,*], xr=[t1,t2], /xs, $
;thick=1,yrange=[1e-9,1e-3],/ylog,title='1-minute GOES-15 Solar X-ray Flux',psym=3,$
;position=[0.05,0.75,0.45,0.95],/normal,xtitle=' '

;oplot,goes[0,*],goes[1,*],color=240,thick=2

;xyouts,0.015, 0.78, 'Watts m!U-2!N',/normal,orientation=90

;axis,yaxis=1,ytickname=[' ','A','B','C','M','X',' '];,charsize=1.5
;axis,yaxis=0,yrange=[1e-9,1e-3];,charsize=1.5

;plots, goes[0,*], 1e-8
;plots, goes[0,*], 1e-7
;plots, goes[0,*], 1e-6
;plots, goes[0,*], 1e-5
;plots, goes[0,*], 1e-4
;oplot, goes[0,*], goes[1,*], color=230, thick=1.7
;oplot, goes[0,*], goes[2,*], color=80, thick=1.7 


;sim_flux = (dindgen(101)*(1.0e-3 - 1.0e-9)/100.0 ) +1.0e-9
;sim_tim = dblarr(n_elements(sim_flux))
;sim_tim[*] = anytim(time_bar,/utim)
;plots,sim_tim,sim_flux,/data,color=0,thick=2,linestyle=2

;legend, ['GOES15 0.1-0.8nm','GOES15 0.05-0.4nm'],$
;linestyle=[0,0], color=[220,80], box=0,pos=[0.05,0.935],/normal



;*****************************************************




;*******		Radio Light Curves		*********


cd,'/Users/eoincarley/Data/22sep2011_event/NRH'
restore,'intensity_v_time_150MHz.sav',/verb
intensity_150 = alog10(intensity)
restore,'intensity_v_time_450MHz.sav',/verb
intensity_445 = alog10(intensity)

set_line_color
utplot, anytim(nrh_times,/utim), intensity_150, /xs, /ys, $
xr=[t1,t2], charsize=2.0, tick_unit = 5.0*60.0, xticklen=-0.01, yticklen=-0.01, $
position=[0.07,0.65,0.45,0.97], color=3, thick=1.5, yr=[9.0,12.0],$
ytitle='!6log(T!Lb!N) [K]'

oplot, anytim(nrh_times,/utim), intensity_445, color=5, thick=1.5

legend,['150.9 MHz', '445.0 MHz' ],color=[3, 5],$
linestyle=[0,0], charsize=1.0, box=0, pos=[0.3,0.96], /normal

sim_flux = (dindgen(101)*(12.0 -9.0 )/100.0 ) + 9.0
sim_tim = dblarr(n_elements(sim_flux))
sim_tim[*] = anytim(time_bar,/utim)
plots,sim_tim,sim_flux,/data,color=0,thick=2,linestyle=2



;*************************************************************;

;-------------		 Dynamic Spectra			--------------;
loadct,5
stretch,60,240
spectro_plot, low_data_bg, low_times, lfreq, /xs, /ys,$
xr=[t1,t2], charsize=2.0, yr=[100,10], yticks=9, yminor=2, $
tick_unit = 20.0*60.0, xticklen=-0.01, yticklen=-0.01, $
ytickname=[' ','90','80','70','60','50','40','30','20','10'], $
xtickame=[' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' '], $
position=[0.07,0.267,0.45,0.6], /noerase, xtitle=' '

sim_freq = (dindgen(101)*(100.0-10.0)/100.0 ) +10.0
sim_tim = dblarr(n_elements(sim_freq))
sim_tim[*] = anytim(time_bar,/utim)
plots,sim_tim,sim_freq,/data,color=255,thick=2,linestyle=2


loadct,5
stretch,30,140
spectro_plot, mid_data_bg, mid_times, mfreq, /xs, /ys, $
xr=[t1,t2], charsize=2.0, yr=[150,100], yticks=5, yminor=2, $
tick_unit = 5.0*60.0, xticklen=-0.03, yticklen=-0.01, $
ytickname=['150','140','130','120','110',' '], $
position=[0.07,0.1,0.45,0.267], /noerase

sim_freq = (dindgen(101)*(200.0-100.0)/100.0 ) + 100.0
sim_tim = dblarr(n_elements(sim_freq))
sim_tim[*] = anytim(time_bar,/utim)

plots,sim_tim,sim_freq,/data,color=255,thick=2,linestyle=2
xyouts,0.03,0.26,'Frequency [MHz]',/normal,orientation=90.0,charsize=2.0
;xyouts,0.04,0.26,'100',/normal,charthick=1, charsize
;x2png,'20110922_burst_all.png'

END