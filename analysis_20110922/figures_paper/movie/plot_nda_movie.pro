pro plot_nda_movie, t1, t2, xright, xleft, tline

;This is a module of plot_all_radio_movie


cd,'/Users/eoincarley/Data/CALLISTO/20110922/rsto_20110922_forfigure/'
restore,'all_low_data4plot.sav'
spectro_plot, low_data_bs >(-5.0), low_times, lfreq, /xs, ystyle=4, xr=[t1,t2], $
position=[xleft, 0.33, xright, 0.43], /normal, /noerase, /ylog, yr=[13, 100], $
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
position=[xleft, 0.33, xright, 0.43], /normal, /noerase, /ylog, yr=[13, 100], $
xtickname=[' ', ' ', ' ', ' ', ' ', ' ', ' '], xtitle=' ', tick_unit=20.0*60.0

set_line_color
rect_x = anytim(file2time('20110922_103900'),/utim)
rectangle, rect_x, 8.0, 60.0*19.0, 180.0, thick=3, linestyle=0, color=0
rectangle, rect_x, 8.0, 60.0*19.0, 180.0, thick=3, linestyle=2, color=1


vline, tline, color=254, linestyle=0, thick=3
END
