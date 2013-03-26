pro figure_schematic_20110922
	

	
	print,'Stopping!'
	
	
	i=1.0
	cd,'/Users/eoincarley/Data/22sep2011_event/AIA'
	set_plot,'ps'
	device,filename = 'figure_schematic_20110922',$
	/color,/inches,/landscape,/encapsulate,$
	ysize=8,xsize=8, bits_per_pixel=8, yoffset=8
	
	aia_files = findfile('aia*.fits')
	read_sdo,aia_files[0], he_aia_pre, data_aia_pre

	;           Read in data proper AIA         
	mreadfits_header, aia_files, ind, only_tags='exptime'
	f = aia_files[where(ind.exptime gt 1.)]
	stop
	read_sdo, f[i], he_aia, data_aia
	read_sdo, f[i-1], he_aia_pre, data_aia_pre
	data_aia_bs = data_aia/he_aia.exptime - data_aia_pre/he_aia_pre.exptime
	data_aia_bs[*] = 0.00001

	map_aia = make_map( smooth(data_aia_bs,10) )
	map_aia.dx = he_aia.CDELT1	
	map_aia.dy = he_aia.CDELT2
	map_aia.xc = he_aia.SAT_Y0
	map_aia.yc = he_aia.SAT_Z0 
	plot_map, map_aia, dmin = -10, dmax = 10
	set_line_color
	plot_helio, file2time('20110922_104600'), /over, gstyle=0, gthick=1, gcolor=0, grid_spacing=15.0
	
	device,/close
	set_plot,'x'


END