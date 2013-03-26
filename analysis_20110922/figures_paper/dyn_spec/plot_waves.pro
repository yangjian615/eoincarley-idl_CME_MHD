pro plot_waves, t1, t2, xright, xleft

;This is a module of figure_dyn_spec_20110922.pro

cd,'/Users/eoincarley/Data/22sep2011_event/WAVES'


restore,'WAVES_RAD1_20110922.sav',/verb
spectro_plot, smooth(arrayb,3) > 0.0 < 25.0, time_array, freq, /xs, /ys,  $
position=[xleft, 0.69, xright, 0.9], /normal, /noerase, $
xtickname=[' ', ' ', ' ', ' ', ' ', ' ', ' '], /ylog, xr=[t1,t2], yr=[1.0, 0.01],$
ytickv=[0.1,1.0]

restore,'WAVES_RAD2_20110922.sav',/verb
spectro_plot, smooth(arrayb,3) > 1.0 < 7.0, time_array, freq, /xs, /ys,  $
position=[xleft, 0.56, xright, 0.69], /normal, /noerase, /ylog, xr=[t1, t2],$
ytickv=[10.0], xticklen=-0.03, xminor=2


END