pro test_aia_nrgf

window,1,xs=700, ys=700
	cd,'/Users/eoincarley/Data/22sep2011_event/AIA'
	aia_files = findfile('aia*.fits')

	;           Read in data proper AIA         
	mreadfits_header, aia_files, ind, only_tags='exptime'
	f = aia_files[where(ind.exptime gt 1.)]
	i=60
	read_sdo, f[i], he_aia, data_aia_orig
	read_sdo, f[i-5], he_aia_pre, data_aia_pre_orig
	;data_aia = disk_nrgf(temporary(data_aia), he_aia, 0, 0)
	;data_aia_pre = disk_nrgf(temporary(data_aia_pre), he_aia_pre, 0, 0)
	index2map, he_aia_pre, smooth(temporary(data_aia_pre_orig), 7)/he_aia_pre.exptime, map_aia_pre_orig, outsize = 1024
	index2map, he_aia, smooth(temporary(data_aia_orig), 7)/he_aia.exptime, map_aia_orig, outsize = 1024
	diff_orig = diff_map(map_aia_orig, map_aia_pre_orig)
	;save, data_aia, data_aia_pre, filename='test_aia_nrgd.sav'
	
	
	restore,'test_aia_nrgd.sav'
	index2map, he_aia_pre, smooth(temporary(data_aia_pre), 7)/he_aia_pre.exptime, map_aia_pre_mod, outsize = 1024
	index2map, he_aia, smooth(temporary(data_aia), 7)/he_aia.exptime, map_aia_mod, outsize = 1024
	diff_mod = diff_map(map_aia_mod, map_aia_pre_mod)
	diff_mod.data = (diff_mod.data)*20.0 + diff_orig.data
	
	map_aia_mod.dx = he_aia.CDELT1*4.0	
	map_aia_mod.dy = he_aia.CDELT2*4.0
	map_aia_mod.xc = he_aia.SAT_Y0/4.0
	map_aia_mod.yc = he_aia.SAT_Z0/4.0 
	
	loadct,1
	;gamma_ct,2.0
	;aia_lct, rr, gg, bb, wave=211, /load
	;
	

	plot_map, diff_mod, $
	dmin = -4.0, dmax = 4.0, /noaxes  ;usually dmin=-6, dmax=3
	;axis, xaxis=0, xthick=axes_thickness, ythick=axes_thickness, xticklen=-0.025, xtitle='X (arcsecs)'
	set_line_color
	plot_helio, he_aia.date_obs, /over, gstyle=0, gthick=0.5, gcolor=1, grid_spacing=15.0
	
END	