pro plot_callisto_zoom_movie, t1, t2, xright, xleft, tline

;This is a module of figure_dyn_spec_20110922.pro


cd,'/Users/eoincarley/Data/CALLISTO/20110922'

files = findfile('*01.fit')
radio_spectro_fits_read,files[0], low1data, l1time, lfreq
radio_spectro_fits_read,files[1], low2data, l2time, lfreq
radio_spectro_fits_read,files[2], low3data, l3time, lfreq

files = findfile('*02.fit')
radio_spectro_fits_read,files[0], mid1data, m1time, mfreq
radio_spectro_fits_read,files[1], mid2data, m2time, mfreq
radio_spectro_fits_read,files[2], mid3data, m3time, mfreq


;Put in the FM band blackout
mid_FM_index = where(mfreq lt 112.0)
mid_data= [temporary(mid1data), temporary(mid2data), temporary(mid3data)]
mid_times = [temporary(m1time), temporary(m2time), temporary(m3time)]
low_FM_index = where(lfreq gt 90.0)
low_data = [temporary(low1data), temporary(low2data), temporary(low3data)]
low_times = [temporary(l1time), temporary(l2time), temporary(l3time)]


mid_data_bg = constbacksub(mid_data, /auto)
low_data_bg = constbacksub(low_data, /auto)
;mid_data_bg = constbacksub(mid_data, /auto)
low_data_bg[*,  low_FM_index[0] : low_FM_index[n_elements(low_FM_index)-1] ] = -15.0
mid_data_bg[*,  mid_FM_index[0] : mid_FM_index[n_elements(mid_FM_index)-1] ] = -10.0

;----------------- Zoom1 ---------------------;

restore,'new_mid_data_bg.sav'

t1_bs = anytim(file2time('20110922_103800'),/utim)
t2_bs = anytim(file2time('20110922_105800'),/utim)

spectro_plot, smooth(low_data_bg,3) > (-30.0) < 100.0, low_times, lfreq, /xs, ystyle=4, $
xr=[t1_bs,t2_bs], yr=[100,20], yticks=7, yminor=2, $
xticklen=-0.01, yticklen=-0.01, ytitle=' ', $
position=[xleft, 0.68, xright, 0.85], /noerase, xtitle=' '
vline,tline



loadct,5
cd,'/Users/eoincarley/Data/22sep2011_event/NDA'
restore,'20110922_dyn_spec_r.sav'
z_bs_r = constbacksub(dyn_spec_r, /auto)


restore,'20110922_dyn_spec_l.sav'
z_bs_l = constbacksub(dyn_spec_l, /auto)
z_raw = dyn_spec_r + dyn_spec_l
z_bs = z_bs_l + z_bs_r
loadct,5
;stretch, 0, 210, 1.3

restore,'RFI_rmv_nda.sav'
spectro_plot, z_new >(-30.0) , times, reverse(freq), /xs, /ys, xr=[t1_bs,t2_bs], $
position = [xleft, 0.68, xright, 0.85], /normal, /noerase, yr=[13, 100], yminor=2, $
xtickname=[' ', ' ', ' ', ' ', ' ', ' ', ' '], ytickname=[' ', '80', '60', '40', '20' ]

vline, tline, color=254, linestyle=0, thick=3

set_line_color
rect_x = anytim(file2time('20110922_105120'),/utim)
rectangle, rect_x, 20.0, 100.0, 70.0, thick=3, linestyle=0, color=0
rectangle, rect_x, 20.0, 100.0, 70.0, thick=3, linestyle=2, color=1

loadct,5
stretch, 51, 230, 1.3

spectro_plot, new_mid_data_bg*2.0 > (-15.0) < 40.0, mid_times, mfreq, /xs, /ys,$
xr=[t1_bs,t2_bs], yminor=2, yr=[180,100],$
xticklen=-0.01, yticklen=-0.01, ytitle=' ', ytickname=['180','160','140','120',' '],$
position=[xleft, 0.53, xright, 0.68], /noerase, xtitle='Time (UT)'
xyouts, 0.258, 0.673, '100', /normal, alignment=0.5
vline, tline, color=254, linestyle=0, thick=3

;----------------- Zoom2 ---------------------

t1_hb = anytim(file2time('20110922_105120'),/utim)
t2_hb = anytim(file2time('20110922_105300'),/utim)

spectro_plot, low_data_bg > (-7.0) , low_times, lfreq, /xs, /ys,$
xr=[t1_hb,t2_hb], yr=[90,20], yticks=7, yminor=2, $
xticklen=-0.01, yticklen=-0.01, ytitle='Frequency (MHz)',$
position=[xleft, 0.25, xright, 0.46], /noerase, xtitle='Time (UT)'

vline, tline, color=254, linestyle=0, thick=3

END