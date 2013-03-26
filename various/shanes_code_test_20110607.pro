pro shanes_code_test_20110607

goto,here

;Code to test the best plotting procedure for the
;coronagraph plots for 20110607 paper

;--------- Read and Base Difference ----------;

cd,'/Users/eoincarley/Data/secchi_l1/20110607/for_shanes_plot/l1/cor1/a/'
cor1files = findfile('*.fts')
cor1apre = sccreadfits(cor1files[0], cor1ahdr_pre)
cor1aimg = sccreadfits('20110607_081009_1B4c1A.fts', cor1ahdr)
cor1abs = cor1aimg - cor1apre

cd,'/Users/eoincarley/Data/secchi_l1/20110607/for_shanes_plot/l1/cor2/a/'
cor2files = findfile('*.fts')
cor2apre = sccreadfits(cor2files[0], cor1ahdr_pre)
cor2aimg = sccreadfits('20110607_080815_1B4c2A.fts', cor2ahdr)
cor2abs = cor2aimg - cor2apre

;--------- Mask the data ----------------;

		inner_mask_cor1 = get_smask(cor1ahdr)
    	cor1abs = cor1abs*inner_mask_cor1
    	;wset,9
    	
    	outer_mask_cor1 = dblarr(cor1ahdr.NAXIS1, cor1ahdr.NAXIS2)
		outer_mask_cor1[*,*] = 1.0
		rsun = get_solar_radius(cor1ahdr)
		pixrad=rsun/cor1ahdr.CDELT1
		sun = scc_SUN_CENTER(cor1ahdr)
		index_outer = circle_mask(inner_mask_cor1, sun.XCEN, sun.YCEN, 'ge', pixrad*4.5)
		outer_mask_cor1[index_outer] = 0.0
		cor1abs = cor1abs*outer_mask_cor1
		
		
		
		inner_mask_cor2 = get_smask(cor2ahdr)
    	cor2abs = cor2abs*inner_mask_cor2
    	;wset,9
    	
    	outer_mask_cor2 = dblarr(cor2ahdr.NAXIS1, cor2ahdr.NAXIS2)
		outer_mask_cor2[*,*] = 1.0
		rsun = get_solar_radius(cor2ahdr)
		pixrad=rsun/cor2ahdr.CDELT1
		sun = scc_SUN_CENTER(cor2ahdr)
		index_outer = circle_mask(inner_mask_cor2, sun.XCEN, sun.YCEN, 'ge', pixrad*15.0)
		outer_mask_cor2[index_outer] = 0.0
		cor2abs = cor2abs*outer_mask_cor2
		
		
		
		
		
	stop
;---------- Make the map -------------------;

	index2map, cor1ahdr, cor1abs, cor1amap
	index2map, cor2ahdr, cor2abs, cor2amap
	
	cor1amap.data = (cor1amap.data - mean(cor1amap.data))/stdev(cor1amap.data)
	cor2amap.data = (cor2amap.data - mean(cor2amap.data))/stdev(cor2amap.data)
	
	imapa = merge_map(cor2amap, cor1amap, /add, use_min=0)
	
	xrr=[-15000d, 15000d]
	yrr=xrr
	loadct, 0
	title4 = 'ST-A '+cor2ahdr.DETECTOR+' '+strmid(cor2ahdr.date_obs, 11, 5) $
		+' / ' +cor1ahdr.DETECTOR+' '+strmid(cor1ahdr.date_obs, 12, 4)+' UT'
	plot_map, imapa, dmin=-1.5d, dmax=3.0d, /limb, /noa, /nolabe, $
		title=title4, xr=xrr, yr=yrr
		
	here:
	cd,'/Users/eoincarley/Data/lasco/20110607/level_1/c2/total_brightness'
	
	files = findfile('*.fts')
	tims = strarr(n_elements(files))
	FOR i=0,n_elements(files)-1 DO BEGIN
		hdr = headfits(files[i])
		tims[i] = hdr[8]
	ENDFOR	
	
	

	cd,'/Users/eoincarley/Data/lasco/20110607/level_1/c3/total_brightness'
	
	files = findfile('*.fts')
	tims = strarr(n_elements(files))
	FOR i=0,n_elements(files)-1 DO BEGIN
		hdr = headfits(files[i])
		tims[i] = hdr[8]
	ENDFOR	
	
	



stop

END