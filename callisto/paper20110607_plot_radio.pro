pro paper20110607_plot_radio

plot_allcallisto_swaves
cd,'/Users/eoincarley/Data/CALLISTO/20110607'
restore,'spec_x_20110607.sav'
restore,'spec_y_20110607.sav'
restore,'spec_z_20110607.sav'
multiplot,ygap=5
spectro_plot,spec_z_20110607,spec_x_20110607,spec_y_20110607,/xs,/ys,charsize=1.5

END