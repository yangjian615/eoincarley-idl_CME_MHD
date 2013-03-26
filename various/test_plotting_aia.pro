pro test_plotting_aia

cd,'/Users/eoincarley/Data/22sep2011_event/AIA'
	aia_files = findfile('aia*.fits')
	read_sdo,aia_files[0], he_aia_pre, data_aia_pre

	;           Read in data proper AIA         
	mreadfits_header, aia_files, ind, only_tags='exptime'
	f = aia_files[where(ind.exptime gt 1.)]
	restore,'22_09_2011_xy_pulse_distance_160_arc.sav',/verb
	read_sdo, f[1], he_aia, data_aia
	read_sdo, f[0], he_aia_pre, data_aia_pre
	data_aia_bs = data_aia/he_aia.exptime - data_aia_pre/he_aia_pre.exptime
	map_aia = make_map( smooth(rebin(data_aia_bs,1024,1024),7) )
	map_aia.dx = he_aia.CDELT1*4.0
	map_aia.dy = he_aia.CDELT2*4.0
	map_aia.xc = he_aia.SAT_Y0/4.0
	map_aia.yc = he_aia.SAT_Z0/4.0 

	plot_map, map_aia, dmin = -10, dmax = 10, /limb, /normal, $
 /noaxes, title=' ', fov=[30.0,25.0], CENTER = [-1000.0, -300.0]
	
	set_line_color
	plot_helio, he_aia.date_obs, /over, gstyle=0, gthick=0.5, gcolor=1, grid_spacing=15.0	
	
	set_line_color
	!p.thick=2
	plots,x,y, color=7, thick=7, linestyle=2
	
	
END	