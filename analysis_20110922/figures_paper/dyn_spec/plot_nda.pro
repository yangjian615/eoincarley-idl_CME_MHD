pro plot_nda , t1, t2, xright, xleft

;This is a module of figure_dyn_spec_20110922.pro



;rfi_removal_nda, z_raw, z_bs, z_new
;readme = 'Created with plot_nda'
;save,z_new,readme,filename='RFI_rmv_nda.sav'
cd,'/Users/eoincarley/Data/CALLISTO/20110922/rsto_20110922_forfigure/'
restore,'all_low_data4plot.sav'
spectro_plot, low_data_bs >(-5.0), low_times, lfreq, /xs, ystyle=4, xr=[t1,t2], $
position=[xleft, 0.32, xright, 0.45], /normal, /noerase, /ylog, yr=[13, 100], $
xtickname=[' ', ' ', ' ', ' ', ' ', ' ', ' '], xtitle=' ', tick_unit=20.0*60.0



cd,'/Users/eoincarley/Data/22sep2011_event/NDA'
restore,'20110922_dyn_spec_r.sav'
z_bs_r = constbacksub(dyn_spec_r, /auto)


restore,'20110922_dyn_spec_l.sav'
z_bs_l = constbacksub(dyn_spec_l, /auto)

z_raw = dyn_spec_r + dyn_spec_l
z_bs = z_bs_l + z_bs_r

restore,'RFI_rmv_nda.sav'
spectro_plot, z_new >(-15.0), times, reverse(freq), /xs, /ys, xr=[t1,t2], $
position=[xleft, 0.32, xright, 0.45], /normal, /noerase, /ylog, yr=[13, 100], $
xtickname=[' ', ' ', ' ', ' ', ' ', ' ', ' '], xtitle=' ', tick_unit=20.0*60.0


END

pro rfi_removal_nda, raw, bs, bs_new

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
		surround = 3
		array_size = size(raw_new)
		xsize = array_size[1]
		ysize = array_size[2]
	
		section = raw_new[(x_index-surround)>0.0:(x_index+surround)<(xsize-1), (y_index-surround)>0.0:(y_index+surround)<(ysize-1)]
		raw_new[(x_index-1)>0.0:(x_index+1)<(xsize-1), (y_index-1)>0.0:(y_index+1)<(ysize-1)] = mean(section >0.0)
	ENDFOR
bs_new = constbacksub(raw_new, /auto)


END
