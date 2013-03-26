pro plot_low_mid_20110922,time_bar, goes, low_data_bg, low_times, mid_data_bg, mid_times,$
   	low_data, mid_data, lfreq, mfreq, mean_low, mean_mid, mean_all


;This is used in create_composite_img_v2

;*******		       GOES 			***********
t1 = anytim(file2time('20110922_103500'),/utim)
t2 = anytim(file2time('20110922_105900'),/utim)


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
restore,'nrh_total_flux_150.sav'
stop_ind = n_elements(nrh_total_flux_150) - 1

restore,'moving_peak_max_intesnity_vs_time.sav'



utplot,time_nrh_total_flux[1:stop_ind], nrh_total_flux_150[1:stop_ind]/$
max(nrh_total_flux_150[1:stop_ind]),/xs, /ys,$
xr=[t1,t2],charsize=1.0,ytitle='Mean Intensity',tick_unit = 2.0*60.0,xticklen=-0.01,yticklen=-0.01,$
position=[0.05,0.55,0.45,0.75],/noerase, color=240,yr=[0,1.4],thick=2.0

oplot,low_times,(smooth(mean_low/max(mean_low),10) - 0.85)*7, color=0

oplot,low_times,(smooth(mean_mid/max(mean_mid)-0.08,10) - 0.85)*7,color = 130

legend,['Mean Radio Intensity 10 - 100 MHz','Mean Radio Intensity 110 - 150 MHz',$
'Total NRH flux (150MHz)'],color=[0,130,240],$
linestyle=[0,0,0],charsize=1.0,box=0

sim_flux = (dindgen(101)*(1.4 - 0.0)/100.0 ) + 0.0
sim_tim = dblarr(n_elements(sim_flux))
sim_tim[*] = anytim(time_bar,/utim)
plots,sim_tim,sim_flux,/data,color=0,thick=2,linestyle=2



;**********************************************************;

;*******		Dynamic Spectra			********
loadct,5
stretch,60,240
spectro_plot,low_data_bg,low_times,lfreq,/xs,/ys,$
xr=[t1,t2],charsize=1.0,yr=[100,10],yticks=9,yminor=4,$
ytitle='Frequency [MHz]',tick_unit = 2.0*60.0,xticklen=-0.01,yticklen=-0.01,$
;position=[0.05,0.43,0.45,0.95]
position=[0.05,0.22,0.45,0.525],/noerase,xtitle=' '

sim_freq = (dindgen(101)*(100.0-10.0)/100.0 ) +10.0
sim_tim = dblarr(n_elements(sim_freq))
sim_tim[*] = anytim(time_bar,/utim)
plots,sim_tim,sim_freq,/data,color=255,thick=2,linestyle=2


loadct,5
stretch,30,140
spectro_plot,mid_data_bg,mid_times,mfreq,/xs,/ys,$
xr=[t1,t2],charsize=1.0,yr=[150,110],yticks=4,yminor=4,$
ytitle='Frequency [MHz]',tick_unit = 2.0*60.0,xticklen=-0.01,yticklen=-0.01,$
;position=[0.05,0.1,0.45,0.37],/noerase
position=[0.05,0.05,0.45,0.19],/noerase

sim_freq = (dindgen(101)*(200.0-100.0)/100.0 ) + 100.0
sim_tim = dblarr(n_elements(sim_freq))
sim_tim[*] = anytim(time_bar,/utim)
plots,sim_tim,sim_freq,/data,color=255,thick=2,linestyle=2

;x2png,'20110922_burst_all.png'

END