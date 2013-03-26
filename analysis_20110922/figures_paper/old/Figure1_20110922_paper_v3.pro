pro Figure1_20110922_paper_v3

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
!p.font=0
device,filename = 'Figure1_20110922_dyn_spec.ps',$
	/color, /inches, /encapsulate, $
	ysize=10, xsize=6, bits_per_pixel=8, xoffset=0, yoffset=0,/helvetica


;------------- First Dynamic Spectra ----------------------

loadct,5
stretch, 51, 230, 1.1


spectro_plot, low_data_bg > (-20.0) < 100.0, low_times, lfreq, /xs, /ys, $
xr=[t1,t2], charsize=1.0, yr=[100,20], yticks=8, yminor=2, $
xticklen=-0.01, yticklen=-0.01, $
xtickame=['A ',' ',' '], $
;position=[0.1, 0.63, 0.9, 0.95], /noerase, xtitle='!6 '
position=[0.1, 0.28, 0.9, 0.6], /noerase


set_line_color
x_rec = anytim(file2time('20110922_105120'),/utim)
rectangle,x_rec,20,100,70,color=1,thick=5,linestyle=0
rectangle,x_rec,20,100,70,color=0,thick=5,linestyle=2

;sim_freq = (dindgen(101)*(100.0-10.0)/100.0 ) +10.0
;sim_tim = dblarr(n_elements(sim_freq))
;sim_tim[*] = anytim(time_bar,/utim)
;plots,sim_tim,sim_freq,/data,color=255,thick=2,linestyle=2

;------------- Second Dynamic Spectra ----------------------


loadct,5
stretch, 51, 230, 1.2


spectro_plot, mid_data_bg*2.0 > (-20.0) < 50.0, mid_times, mfreq, /xs, $
xr=[t1,t2], charsize=1.0, yr=[150,100], $
tick_unit = 5.0*60.0, xticklen=-0.03, yticklen=-0.01, ytickname=['150','140','130','120','110',' '],yticks=5, yminor=2,$
;position=[0.1, 0.45, 0.9, 0.63], /noerase
position=[0.1, 0.1, 0.9, 0.28], /noerase, xtitle='Time (UT)' 

;axis,yaxis=0, ytickname=['!6 150','!6 140','130','120','110',' '],yticks=5, yminor=2,$
;yticklen=-0.01



;-------------- Plot lines and points ----------------------
set_line_color

xyouts,0.03,0.265,'Frequency (MHz)',/normal, orientation=90.0, charthick=3.0, color=0

plots,[0.1,0.65],[0.69,0.6], /normal, thick=5, linestyle=0,color=0;======[x1,x2],[y1,y2]=====
plots,[0.1,0.65],[0.69,0.6], /normal, thick=5, linestyle=2,color=1

plots,[0.72,0.9],[0.6,0.69],/normal, thick=5,linestyle=0,color=0
plots,[0.72,0.9],[0.6,0.69],/normal, thick=5,linestyle=2,color=255


;------------- Oplot NRH Radio light curve ----------------

;oplot_nrh, t1, t2

;------------- Zoom Dynamic Spectra ----------------------


loadct,5
stretch, 51, 230, 1.3


t1_hb = anytim(file2time('20110922_105120'),/utim)
t2_hb = anytim(file2time('20110922_105300'),/utim)

spectro_plot, low_data_bg > (-7.0), low_times, lfreq, /xs, /ys,$
xr=[t1_hb,t2_hb], charsize=1.0, yr=[90,20], yticks=7, yminor=2, $
xticklen=-0.01, yticklen=-0.01, ytitle='Frequency (MHz)',$
position=[0.1, 0.69, 0.9, 0.95], /noerase, xtitle='Time (UT)'




xyouts, 0.11, 0.93,'a',/normal, charthick=1.2, color=255
xyouts, 0.11, 0.57,'b',/normal, charthick=1.2, color=255
;xyouts, 0.11, 0.34,'(c)',/normal, charthick=4.0, color=255


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






