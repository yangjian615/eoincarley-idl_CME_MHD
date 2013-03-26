pro shanes_code_test_20110607_v1

cd,'/Users/eoincarley/Data/secchi_l1/20110607/for_shanes_plot/l1/cor1/a/'
	cor1files = findfile('*.fts')
	cor1apre = sccreadfits(cor1files[0], cor1ahdr_pre)
	cor1aimg = sccreadfits('20110607_081009_1B4c1A.fts', cor1ahdr)
	cor1aimg = cor1aimg - cor1apre
	
	
	cd,'/Users/eoincarley/Data/secchi_l1/20110607/for_shanes_plot/l1/cor1/b/'
	cor1files = findfile('*.fts')
	cor1bpre = sccreadfits(cor1files[0], cor1bhdr_pre)
	cor1bimg = sccreadfits('20110607_080000_1B4c1B.fts', cor1bhdr)
	cor1bimg = cor1bimg - cor1apre
	
	;Try use COR1 totalb 08:05/08:10 and COR2 08:08 Totalb  (or closest in time whatever)
	
	
	;cor2aimg = sccreadfits('A/COR2/20110607_082400_d4c2A_DIFF.fts', cor2ahdr)
	;cor2bimg = sccreadfits('B/COR2/20110607_082400_d4c2B_DIFF.fts', cor2bhdr)
	;(EOIN)  Monthlt bs and base-diff that I made
	cd,'/Users/eoincarley/Data/secchi_l1/20110607/for_shanes_plot/l1/cor2/a/'
	cor2files = findfile('*.fts')
	cor2apre = sccreadfits(cor2files[0], cor2ahdr_pre)
	cor2aimg = sccreadfits('20110607_080815_1B4c2A.fts', cor2ahdr)
	cor2aimg = cor2aimg - cor2apre
	
	cd,'/Users/eoincarley/Data/secchi_l1/20110607/for_shanes_plot/l1/cor2/b/'
	cor2files = findfile('*.fts')
	cor2bpre = sccreadfits(cor2files[0], cor2bhdr_pre)
	cor2bimg = sccreadfits('20110607_080815_1B4c2B.fts', cor2bhdr)
	cor2bimg = cor2bimg - cor2bpre
	
	
	
	cd,'/Users/eoincarley/Data/lasco/20110607/level_1/c2/total_brightness'
	
	c2files = findfile('*.fts')
	mreadfits, c2files[0], c2hdrpre, c2pre
	mreadfits, c2files[31], c2hdr, c2img  ;
	c2img = c2img - c2pre
	
	cd,'/Users/eoincarley/Data/lasco/20110607/level_1/c3/total_brightness'
	c3files = findfile('*.fts')
	mreadfits, c3files[0], c3hdrpre, c3pre
	mreadfits, c3files[33], c3hdr, c3img  ;
	c3img = c3img - c3pre
	
	
	;cor1aimg = disk_nrgf(cor1aimg, cor1ahdr, 0, 0)
	;cor2aimg = disk_nrgf(cor2aimg, cor2ahdr, 0, 0)
	
	cor1bimg = disk_nrgf(cor1bimg, cor1bhdr, 0, 0)
	cor2bimg = disk_nrgf(cor2bimg, cor2bhdr, 0, 0)
	
	;c2img = disk_nrgf(c2img, c2hdr, 0, 0)
	;c3img = disk_nrgf(c3img, c3hdr, 0, 0)
	
	
	;-----------MASK ----------------
	cor1_mask = masks_for_20110607(cor1ahdr)
	cor2_mask = masks_for_20110607(cor2ahdr)
	
	cor1aimg = cor1aimg*cor1_mask 

	
	cor2aimg = cor2aimg*cor2_mask 


	cor1bimg = cor1bimg*cor1_mask 

	
	cor2bimg = cor2bimg*cor2_mask 

	;------------MAPS-----------------
	;index2map, cor1ahdr, cor1aimg, cor1amap
	;index2map, cor2ahdr, cor2aimg, cor2amap

	index2map, cor1bhdr, cor1bimg, cor1bmap
	index2map, cor2bhdr, cor2bimg, cor2bmap
	
	;cor1amap.data = (cor1amap.data - mean(cor1amap.data))/stdev(cor1amap.data)
	;cor2amap.data = (cor2amap.data - mean(cor2amap.data))/stdev(cor2amap.data)
	
	;
	cor1bmap.data = (cor1bmap.data - mean(cor1bmap.data))/stdev(cor1bmap.data)
	;
	cor2bmap.data = (cor2bmap.data - mean(cor2bmap.data))/stdev(cor2bmap.data)
	
	;imapa = merge_map(cor2amap, cor1amap, /add, use_min=0)
	imapb = merge_map(cor2bmap, cor1bmap, /add, use_min=0)	
	
	;------------
	;index2map, c2hdr, c2img, c2map
	;index2map, c3hdr, c3img, c3map	
	
	;c2map.data = (c2map.data - mean(c2map.data))/stdev(c2map.data)
	;c3map.data = (c3map.data - mean(c3map.data))/stdev(c3map.data)
	
	;c2map.data = c2map.data + abs(min(c2map.data))
	;c3map.data = c3map.data + abs(min(c3map.data))
	
	;c2mask = masks_for_20110607(c2hdr)
	;c3mask = masks_for_20110607(c3hdr)
	;c2map.data = c2map.data*c2mask 
	;c3map.data = c3map.data*c3mask 
	
	
	;c2c3map = merge_map(c2map, c3map, /add, use_min=0)
	
	;-----------PLOT---------------------
	
	xrr=[-15000d, 15000d]
	yrr=xrr
	loadct, 0
	;title4 = 'ST-A '+cor2ahdr.DETECTOR+' '+strmid(cor2ahdr.date_obs, 11, 5) $
	;	+' / ' +cor1ahdr.DETECTOR+' '+strmid(cor1ahdr.date_obs, 12, 4)+' UT'
	;plot_map, imapa, dmin=-1.5d, dmax=4.0d, /limb, /noa, /nolabe, $
	;	title=title4, xr=xrr, yr=yrr
	
	
	;title5 = 'LASCO '+c3hdr.DETECTOR+' '+strmid(c3hdr.date_obs, 11, 5) $
	;	+' / ' +c2hdr.DETECTOR+' '+strmid(c2hdr.date_obs, 12, 4)+' UT'
	;plot_map, c2c3map , xs=13, ys=13, tit=title5, xr=xrr, yr=yrr, $
	;	dmin=-0.25d, dmax=1.2d, /limb, /noa, /nolabe
		
		title6 = 'ST-B '+cor2bhdr.DETECTOR+' '+strmid(cor2bhdr.date_obs, 11, 5) $
		+' / ' +cor1bhdr.DETECTOR+' '+strmid(cor1bhdr.date_obs, 12, 4)+' UT'
	plot_map, imapb, dmin=-1.5d, dmax=4.0d, /limb, /noa, /nolabe, $
		title=title6, xr=xrr, yr=yrr
	
	
	stop
	

END