pro plot_swaves, t1, t2, xright, xleft

;This is a module of figure_dyn_spec_20110922.pro


cd,'/Users/eoincarley/Data/22sep2011_event/SWAVES'


restore,'swaves_average_20110922_b_lfr.sav',/verb	
freq_MHz = freq_hz/1.0e6	
ticks = loglevels([0.01, 0.125], /fine) 
nticks=n_elements(ticks)
stop_index= closest(freq_MHz, 0.01)

spectro_plot, smooth(data_array[*,0:stop_index], 3) > 0.0 , times, freq_MHz[0:stop_index], /xs, /ys,  $
xtickname=[' ', ' ', ' ', ' ', ' ', ' ', ' '], /ylog, xr=[t1,t2], yr=[0.1, 0.01], $
position=[xleft, 0.72, xright, 0.9], /normal, /noerase



restore,'swaves_average_20110922_b_hfr.sav',/verb
freq_MHz = freq_hz/1.0e6	
ticks = loglevels([0.179, 16.025], /fine) ;remove 1e6 to plot in MHz
nticks=n_elements(ticks)
loadct,5

stop_index = n_elements(freq_MHz)-1
spectro_plot, smooth(data_array[*,0:stop_index], 3 ) > 0.0 , times, freq_MHz[0:stop_index], /xs, /ys,  $
position=[xleft, 0.435, xright, 0.75], /normal, /noerase, /ylog, xr=[t1, t2],xtickname=[' ', ' ', ' ', ' ', ' ', ' ', ' '],$
xticklen=-0.03, xminor=2, ytickname=['10.0', '1.0', ' ']


END