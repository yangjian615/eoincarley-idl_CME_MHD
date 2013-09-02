pro plot_callisto, t1, t2, xright, xleft

;This is a module of figure_dyn_spec_20110922.pro


cd,'~/Data/CALLISTO/20110922'

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
low_data = [temporary(low1data), temporary(low2data), temporary(low3data)]
low_times = [temporary(l1time), temporary(l2time), temporary(l3time)]

;Put in the FM band blackout
mid_FM_index = where(mfreq lt 112.0)
mid_data= [temporary(mid1data), temporary(mid2data), temporary(mid3data)]
mid_times = [temporary(m1time), temporary(m2time), temporary(m3time)]


hi_data = [temporary(hi1data), temporary(hi2data), temporary(hi3data)]
hi_times = [temporary(h1time), temporary(h2time), temporary(h3time)]


mid_data[*,  mid_FM_index[0] : mid_FM_index[n_elements(mid_FM_index)-1] ] = -10.0
low_data[*,  low_FM_index[0] : low_FM_index[n_elements(low_FM_index)-1] ] = -15.0
;hi_data_bg = constbacksub(hi_data, /auto)

;--------------Add in the remaining data--------------------;

cd,'/Users/eoincarley/Data/CALLISTO/20110922/rsto_20110922_forfigure/'

;restore,'low_20110922_10.sav'
;restore,'low_20110922_11.sav'
;low_data10[*,  low_FM_index[0] : low_FM_index[n_elements(low_FM_index)-1] ] = -15.0
;low_data11[*,  low_FM_index[0] : low_FM_index[n_elements(low_FM_index)-1] ] = -15.0
;low_data= [temporary(low_data10), temporary(low_data), temporary(low_data11)]
;low_data_bs = constbacksub(low_data, /auto)
;low_times = [temporary(low_time10), low_times, temporary(low_time11)]

;save, low_data_bs, low_times, lfreq, filename='all_low_data4plot.sav'

;restore,'mid_20110922_10.sav'
;restore,'mid_20110922_11.sav'
;mid_data10[*,  mid_FM_index[0] : mid_FM_index[n_elements(mid_FM_index)-1] ] = -10.0
;mid_data11[*,  mid_FM_index[0] : mid_FM_index[n_elements(mid_FM_index)-1] ] = -10.0
;mid_data= [temporary(mid_data10), temporary(mid_data), temporary(mid_data11)]
;mid_data_bs = constbacksub(mid_data, /auto)
;rfi_removal_v1, mid_data, mid_data_bs, mid_FM_index, new_mid_data
;mid_times = [temporary(mid_time10), mid_times, temporary(mid_time11)]
;save, new_mid_data, mid_times, mfreq, filename='all_mid_data4plot.sav'
restore,'all_mid_data4plot.sav'



restore,'high_20110922_10.sav'
restore,'high_20110922_11.sav'
hi_data = [temporary(high_data10), temporary(hi_data), temporary(high_data11)]
hi_data_bg = constbacksub(hi_data, /auto)
hi_times = [temporary(high_time10), hi_times, temporary(high_time11)]



loadct,5
stretch, 51, 230, 1.2

spectro_plot, new_mid_data*2.0 > (-20.0) < 40.0, mid_times, mfreq, /xs, /ys, $
yr=[200,100], yticks=1, ytickv=[200, 100], ytickname=[' ',' '], yticklen=-0.005, /ylog, $
xr=[t1,t2], tick_unit = 20.0*60.0, xticklen=-0.05, xtitle=' ', xtickname=[' ',' ', ' ', ' ', ' ',' ', ' ', ' ', ' '], $
position=[xleft, 0.28, xright, 0.32], /noerase, charsize=1.0

set_line_color
rect_x = anytim(file2time('20110922_103900'),/utim)
rectangle, rect_x, 10.0, 60.0*19.0, 190.0, thick=1, linestyle=0, color=0
;rectangle, rect_x, 10.0, 60.0*19.0, 190.0, thick=3, linestyle=2, color=1


loadct,5
stretch, 51, 230, 1.2
spectro_plot, hi_data_bg*2.0 > (-10.0) < 40.0, hi_times, hfreq, /xs, /ys,$
yr=[400,200], yticks=2, ytickv=[400, 300, 200], ytickname=['400', '300', '200'], yticklen=-0.005, /ylog, $
tick_unit = 20.0*60.0, xticklen=-0.05, xr=[t1,t2], xtitle='Time (UT)', $
position=[xleft, 0.23, xright, 0.28], /noerase, charsize=1.0

END


pro rfi_removal_v1, raw, bs, mid_FM_index, bs_new

	rfi_array = abs(sobel(bs)) > 20 <100
	;set_line_color
	indeces = where(rfi_array gt 3.0*stdev(rfi_array))
	rfi_xy = array_indices(rfi_array, indeces)
	;plots,mid_times(rfi_xy[0,*]),mfreq(rfi_xy[1,*]), psym=3, color=3

	;---------------------Do a 10 point average around every RFI point ---------------;
	raw_new = raw
	FOR i = 0.0, n_elements(rfi_xy[0,*])-1 DO BEGIN
		x_index = rfi_xy[0,i]
		y_index = rfi_xy[1,i]
		print,x_index, y_index
		;mid_data_new[(x_index-5)>0.0:(x_index+5)<7199, (y_index-5)>0.0:(y_index+5)<199] = mean(mid_data)
		surround = 10
		array_size = size(raw_new)
		xsize = array_size[1]
		section = raw_new[(x_index-surround)>0.0:(x_index+surround)<(xsize-1), (y_index-surround)>0.0:(y_index+surround)<199]
		raw_new[(x_index-1)>0.0:(x_index+1)<(xsize-1), (y_index-1)>0.0:(y_index+1)<199] = mean(section >0.0)
	ENDFOR
bs_new = constbacksub(raw_new, /auto)
bs_new[*,  mid_FM_index[0] : mid_FM_index[n_elements(mid_FM_index)-1] ] = -10.0


END