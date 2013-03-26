pro Figure1_20110922_paper

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
mid_data= [mid1data, mid2data]
mid_times = [m1time, m2time]
mid_data_bg = constbacksub(mid_data, /auto)
low_data_bg = constbacksub(low_data, /auto)
;mid_data_bg = constbacksub(mid_data, /auto)
low_data_bg[*,  low_FM_index[0] : low_FM_index[n_elements(low_FM_index)-1] ] = -15.0
mid_data_bg[*,  mid_FM_index[0] : mid_FM_index[n_elements(mid_FM_index)-1] ] = -10.0



set_plot,'ps'
device,filename = 'Figure1_20110922_dyn_spec.ps',$
	/color,/inches, /encapsulate ,$
	ysize=8,xsize=6, bits_per_pixel=8, xoffset=0, yoffset=0


;------------- First Dynamic Spectra ----------------------

loadct,5
!p.color=255
!p.background=0
!p.thick=1
reverse_ct

spectro_plot, low_data_bg > (-10.0) <50.0, low_times, lfreq, /xs, /ys,$
xr=[t1,t2], charsize=1.0, yr=[100,20], yticks=8, yminor=2, $
xticklen=-0.01, yticklen=-0.01, $
xtickame=['!6A ','!6 ',' '], $
position=[0.1, 0.63, 0.9, 0.95], /noerase, xtitle='!6 '

set_line_color
x_rec = anytim(file2time('20110922_105120'),/utim)
rectangle,x_rec,20,100,70,color=8,thick=3,linestyle=0
rectangle,x_rec,20,100,70,color=0,thick=3,linestyle=2

;sim_freq = (dindgen(101)*(100.0-10.0)/100.0 ) +10.0
;sim_tim = dblarr(n_elements(sim_freq))
;sim_tim[*] = anytim(time_bar,/utim)
;plots,sim_tim,sim_freq,/data,color=255,thick=2,linestyle=2

;------------- Second Dynamic Spectra ----------------------


loadct,5
!p.color=255
!p.background=0
reverse_ct
spectro_plot, mid_data_bg*2.0 > (-10.0) < 40.0, mid_times, mfreq, /xs, ystyle=4, $
xr=[t1,t2], charsize=1.0, yr=[150,100], $
tick_unit = 5.0*60.0, xticklen=-0.03, $
position=[0.1, 0.45, 0.9, 0.63], /noerase
axis,yaxis=0, ytickname=['!6 150','!6 140','130','120','110',' '],yticks=5, yminor=2,$
yticklen=-0.01, charthick=3



;-------------- Plot lines and points ----------------------

freq_sim = (dindgen(101)*(150.0-100.0)/100.0)+100.0
time_sim1 = dblarr(n_elements(freq_sim))
time_sim1 = anytim(file2time('20110922_104306'),/utim)
time_sim2 = dblarr(n_elements(freq_sim))
time_sim2 = anytim(file2time('20110922_105316'),/utim)
set_line_color
plots,time_sim1,freq_sim,linestyle=0,thick=5,color=5
;plots,time_sim1,freq_sim,linestyle=2,thick=5, color=0
plots,time_sim2,freq_sim,linestyle=0,thick=5,color=5
;plots,time_sim2,freq_sim,linestyle=2,thick=5, color=0


xyouts,0.03,0.62,'Frequency (MHz)',/normal, orientation=90.0, charthick=3.0, color=0
xyouts, 0.74, 0.61,'P2',/normal, charthick=4.0, color=5
xyouts, 0.29, 0.61,'P1',/normal, charthick=4.0, color=5

;------------- Oplot NRH Radio light curve ----------------

;oplot_nrh, t1, t2

;------------- Zoom Dynamic Spectra ----------------------

loadct,5
!p.color=255
!p.background=0
reverse_ct
t1_hb = anytim(file2time('20110922_105120'),/utim)
t2_hb = anytim(file2time('20110922_105300'),/utim)

spectro_plot, low_data_bg > (-10.0) <50.0, low_times, lfreq, /xs, /ys,$
xr=[t1_hb,t2_hb], charsize=1.0, yr=[90,20], yticks=7, yminor=2, $
xticklen=-0.01, yticklen=-0.01, ytitle='Frequency (MHz)',$
position=[0.1, 0.1, 0.9, 0.36], /noerase

;stretch,120,0
;t1_hb = anytim(file2time('20110922_105120'),/utim)
;t2_hb = anytim(file2time('20110922_105600'),/utim)
;spectro_plot, mid_data_bg, mid_times, mfreq, /xs, /ys,$
;xr=[t1_hb,t2_hb], charsize=1.0, yr=[150,110], yticks=4, yminor=2, $
;xticklen=-0.01, yticklen=-0.01, $ $
;position=[0.75, 0.1, 0.99, 0.38], /noerase

;sim_freq = (dindgen(101)*(200.0-100.0)/100.0 ) + 100.0
;sim_tim = dblarr(n_elements(sim_freq))
;sim_tim[*] = anytim(time_bar,/utim)

;plots,sim_tim,sim_freq,/data,color=255,thick=2,linestyle=2
;xyouts,0.03,0.26,'Frequency [MHz]',/normal,orientation=90.0
;xyouts,0.04,0.26,'100',/normal,charthick=2


xyouts, 0.11, 0.93,'(a)',/normal, charthick=4.0, color=255
xyouts, 0.11, 0.61,'(b)',/normal, charthick=4.0, color=255
xyouts, 0.11, 0.34,'(c)',/normal, charthick=4.0, color=255


device,/close
set_plot,'x'


END


pro oplot_nrh, t1, t2

print,'Plotting NRH light curve'
cd,'/Users/eoincarley/Data/22sep2011_event/NRH'
restore,'s_position_20110922.sav',/verb
peak_tb = dblarr(n_elements(source_peak_tb))
peak_tb[*] = source_peak_tb[*]
peak_tb = transpose(peak_tb)


nrh_times = anytim(nrh_times,/utim)
index1 = closest(nrh_times, t1)
index2 = closest(nrh_times, t2)

index_max = where(peak_tb eq max(peak_tb))
print, anytim(nrh_times[index_max], /yoh)


utplot, nrh_times, peak_tb, $
yr=[1.0e7,max(peak_tb)], ystyle=1, /ylog, yticklen=0.001, ytickname=[' ',' ',' '], $

xr=[t1,t2], xstyle=1, xtitle=' ', xticklen=-0.0001, xtickname=[' ',' ',' ',' ',' '], $

position=[0.1, 0.45, 0.9, 0.63], /normal, /noerase, color=5, thick=3
axis,yaxis=0,ystyle=4
axis,yaxis=1,ystyle=1, color=5, ytitle='T!LB!N (K)'



cd,'/Users/eoincarley/Data/CALLISTO/20110922'
END






