pro plot_callisto_movie, t1, t2, xright, xleft, tline

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

files = findfile('*03.fit')
radio_spectro_fits_read,files[0], hi1data, h1time, hfreq
radio_spectro_fits_read,files[1], hi2data, h2time, hfreq
radio_spectro_fits_read,files[2], hi3data, h3time, hfreq

;Put in the FM band blackout
low_FM_index = where(lfreq gt 90.0)
;-------Read in remaining -------
cd,'/Users/eoincarley/Data/CALLISTO/20110922/rsto_20110922_forfigure/'
restore,'low_20110922_10.sav'
restore,'low_20110922_11.sav'
;
low_data = [temporary(low_data10), temporary(low1data), temporary(low2data), temporary(low3data), temporary(low_data11)]
low_times = [temporary(low_time10), temporary(l1time), temporary(l2time), temporary(l3time), temporary(low_time11)]

;Put in the FM band blackout
mid_FM_index = where(mfreq lt 112.0)
mid_data= [temporary(mid1data), temporary(mid2data), temporary(mid3data)]
mid_times = [temporary(m1time), temporary(m2time), temporary(m3time)]

restore,'high_20110922_10.sav'
restore,'high_20110922_11.sav'
hi_data = [temporary(high_data10), temporary(hi1data), temporary(hi2data), temporary(hi3data), temporary(high_data11)]
hi_times = [temporary(high_time10), temporary(h1time), temporary(h2time), temporary(h3time), temporary(high_time11)]


mid_data_bg = constbacksub(mid_data, /auto)
low_data_bg = constbacksub(low_data, /auto)
hi_data_bg = constbacksub(hi_data, /auto)
low_data_bg[*,  low_FM_index[0] : low_FM_index[n_elements(low_FM_index)-1] ] = -15.0


restore,'mid_20110922_10.sav'
restore,'mid_20110922_11.sav'
cd,'/Users/eoincarley/Data/CALLISTO/20110922'
restore, 'new_mid_data_bg.sav'


mid_data= [temporary(constbacksub(mid_data10, /auto)), new_mid_data_bg, temporary(constbacksub(mid_data11, /auto))]

mid_times = [temporary(mid_time10), mid_times, temporary(mid_time11)]
mid_data[*,  mid_FM_index[0] : mid_FM_index[n_elements(mid_FM_index)-1] ] = -10.0
;plot_image,congrid(mid_data, 200, 200)


loadct,5
stretch, 51, 230, 1.2

cd,'/Users/eoincarley/Data/CALLISTO/20110922/rsto_20110922_forfigure/'
restore,'all_mid_data4plot.sav'
new_mid_data = rebin(new_mid_data, 3600,200)
mid_times = rebin(mid_times, 3600)

spectro_plot, new_mid_data*2.0 > (-20.0) < 40.0, mid_times, mfreq, /xs, /ys, $
yr=[200,100], yticks=1, ytickv=[200, 100], ytickname=[' ',' '], yticklen=-0.01, /ylog, $
xr=[t1,t2], tick_unit = 20.0*60.0, xticklen=-0.03, xtitle=' ', xtickname=[' ',' ', ' ', ' ', ' ',' ', ' ', ' ', ' '], $
position=[xleft, 0.285, xright, 0.33], /noerase
set_line_color

set_line_color
rect_x = anytim(file2time('20110922_103900'),/utim)
rectangle, rect_x, 10.0, 60.0*19.0, 190.0, thick=3, linestyle=0, color=0
rectangle, rect_x, 10.0, 60.0*19.0, 190.0, thick=3, linestyle=2, color=1

vline, tline, color=254, linestyle=0, thick=3


hi_data_bg = rebin(hi_data_bg, 3600,200)
hi_times = rebin(hi_times, 3600)
loadct,5
stretch, 51, 230, 1.2
spectro_plot, hi_data_bg*2.0 > (-10.0) < 40.0, hi_times, hfreq, /xs, /ys,$
yr=[400,200], yticks=2, ytickv=[400, 300, 200], ytickname=['400', ' ', '200'], yticklen=-0.01, /ylog, $
tick_unit = 20.0*60.0, xticklen=-0.03, xr=[t1,t2], xtitle='Time (UT)', $
position=[xleft, 0.25, xright, 0.285], /noerase

vline, tline, color=254, linestyle=0, thick=3

END

