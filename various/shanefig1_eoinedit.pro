pro shanefig1_eoinedit, tog=tog

	window, xs=600, ys=800
	
	;----------------------------------------------------
	; Select and read and and prep files for figure
	;----------------------------------------------------
	
	;EUV A, B, AIA    20110607_063030_14euB.fts
	aimg = sccreadfits('~/Data/temp/A/EUVI/195/20110607_063030_14euA.fts', ahdr)
	bimg = sccreadfits('~/Data/temp/B/EUVI/195/20110607_063030_14euB.fts', bhdr)
	
	;AIA/193/aia.lev1.193A_2011-06-07T06:30:10.33Z.image_lev1.fits
	;Need to download this (EOIN)
	read_sdo, ['~/Data/temp/SDO/193/aia.lev1.193A_2011-06-07T06-26-10.08Z.image_lev1.fits'], aiahdr, aiaimg
	aia_prep, aiahdr, aiaimg, oaiahdr, oaiaimg 
	

	
	;--------------- COR1 and COR2 -------------- (EOIN EDIT)--------;
	
	;COR1 and COR2
	;cor1aimg = sccreadfits('A/COR1/20110607_082500_0B4c1A_RAW.fts', cor1ahdr)
	;cor1bimg = sccreadfits('B/COR1/20110607_082500_0B4c1B_RAW.fts', cor1bhdr)
	;(EOIN)  Monthlt bs and base-diff that I made
	cd,'/Users/eoincarley/Data/secchi_l1/20110607/for_shanes_plot/l1/cor1/a/'
	cor1files = findfile('*.fts')
	cor1apre = sccreadfits(cor1files[0], cor1ahdr_pre)
	cor1aimg = sccreadfits('20110607_081009_1B4c1A.fts', cor1ahdr)
	cor1aimg = temporary(cor1aimg) - temporary(cor1apre)
	
	
	cd,'/Users/eoincarley/Data/secchi_l1/20110607/for_shanes_plot/l1/cor1/b/'
	cor1files = findfile('*.fts')
	cor1bpre = sccreadfits(cor1files[0], cor1bhdr_pre)
	cor1bimg = sccreadfits('20110607_080000_1B4c1B.fts', cor1bhdr)
	cor1bimg = temporary(cor1bimg) - temporary(cor1bpre)
	
	;Try use COR1 totalb 08:05/08:10 and COR2 08:08 Totalb  (or closest in time whatever)
	
	
	;cor2aimg = sccreadfits('A/COR2/20110607_082400_d4c2A_DIFF.fts', cor2ahdr)
	;cor2bimg = sccreadfits('B/COR2/20110607_082400_d4c2B_DIFF.fts', cor2bhdr)
	;(EOIN)  Monthlt bs and base-diff that I made
	cd,'/Users/eoincarley/Data/secchi_l1/20110607/for_shanes_plot/l1/cor2/a/'
	cor2files = findfile('*.fts')
	cor2apre = sccreadfits(cor2files[0], cor2ahdr_pre)
	cor2aimg = sccreadfits('20110607_080815_1B4c2A.fts', cor2ahdr)
	cor2aimg = temporary(cor2aimg) - temporary(cor2apre)
	
	cd,'/Users/eoincarley/Data/secchi_l1/20110607/for_shanes_plot/l1/cor2/b/'
	cor2files = findfile('*.fts')
	cor2bpre = sccreadfits(cor2files[0], cor2bhdr_pre)
	cor2bimg = sccreadfits('20110607_080815_1B4c2B.fts', cor2bhdr)
	cor2bimg = temporary(cor2bimg) - temporary(cor2bpre)
	
	;-----------------------------------------------------------------'
	

		
	;HI1 and 2
	ahi1 = sccreadfits('~/Data/temp/A/HI1/20110607_192901_b4h1A_FLTND.fts', ahi1hdr)  ;Make all HI black-white
	bhi1 = sccreadfits('~/Data/temp/B/HI1/20110607_192901_b4h1B_FLTND.fts', bhi1hdr)
	
	ahi2 = sccreadfits('~/Data/temp/A/HI2/20110609_020921_14h2A_BCKSFT_RD.fts', ahi2hdr)
	bhi2 = sccreadfits('~/Data/temp/B/HI2/20110609_020921_14h2B_BCKSFT_RD.fts', bhi2hdr)
	
	bad = where(finite(ahi2, /nan))
	ahi2[bad] = mean(ahi2, /nan)
	
	bad = where(finite(bhi2, /nan))
	bhi2[bad] = mean(bhi2, /nan)
	
	; LASCO C2 and C3
	
	;mreadfits, 'c2_test.fts', c2hdr, c2img ;
	;mreadfits, 'c3_test.fts', c3hdr, c3img ;Need to enter my own lasco images here.
											;Check that they are closest in time to STA and STB (EOIN)
											;Also try a base difference on these.
											
	cd,'/Users/eoincarley/Data/lasco/20110607/level_1/c2/total_brightness'
	
	c2files = findfile('*.fts')
	mreadfits, c2files[0], c2hdrpre, c2pre
	mreadfits, c2files[31], c2hdr, c2img  ;
	c2img = temporary(c2img) - temporary(c2pre)
	
	cd,'/Users/eoincarley/Data/lasco/20110607/level_1/c3/total_brightness'
	c3files = findfile('*.fts')
	mreadfits, c3files[0], c3hdrpre, c3pre
	mreadfits, c3files[33], c3hdr, c3img  ;
	c3img = temporary(c3img) - temporary(c3pre)
	
	

	;----------------------------------------------------
	; Scale make maps etc
	;----------------------------------------------------
	
	aimg = disk_nrgf(temporary(aimg), ahdr)
	bimg = disk_nrgf(temporary(bimg), bhdr)
	aiaimg = disk_nrgf(temporary(aiaimg), aiahdr)
	
	
	cor1aimg = disk_nrgf(temporary(cor1aimg), cor1ahdr, 0, 0)
	cor2aimg = disk_nrgf(temporary(cor2aimg), cor2ahdr, 0, 0)
	
	cor1bimg = disk_nrgf(temporary(cor1bimg), cor1bhdr, 0, 0)
	cor2bimg = disk_nrgf(temporary(cor2bimg), cor2bhdr, 0, 0)
	
	c2img = disk_nrgf(temporary(c2img), c2hdr, 0, 0)
		;c3img = disk_nrgf(c3img, c3hdr, 0, 0)
	
		;aimg = (aimg)/ahdr.dataavg
		;bimg = (bimg)/bhdr.dataavg
		;aiaimg = (aiaimg)/oaiahdr.datamean

	wcsaia=fitshead2wcs(aiahdr)
	wcsa=fitshead2wcs(ahdr)
	wcsb=fitshead2wcs(bhdr)
	
	;xr=[500, 1100], yr=[-100, -500]
	xxc = 744.55327
	yyc	=-351.13451
	WCS_CONVERT_FROM_COORD, wcsaia, [xxc, yyc], 'HG', X, Y, Z,  /ARCSECONDS
	WCS_CONVERT_TO_COORD, wcsa, acoord, 'HG', X, Y, Z
	WCS_CONVERT_TO_COORD, wcsb, bcoord, 'HG', X, Y, Z
	
	;---------- The masking by rm_inner/outer isn't workin-----------;
	;           Put in my own code here (EOIN)


	cor1_mask = masks_for_20110607(cor1ahdr)
	cor2_mask = masks_for_20110607(cor2ahdr)
	
	cor1aimg = temporary(cor1aimg)*cor1_mask

	
	cor2aimg = temporary(cor2aimg)*cor2_mask


	cor1bimg = temporary(cor1bimg)*temporary(cor1_mask)

	
	cor2bimg = temporary(cor2bimg)*temporary(cor2_mask)
	

	;-------------PRODUCE MAPS ----------------
	print,''
	print,'Mapping EUVI'
	index2map, ahdr, temporary(aimg), amap
	index2map, bhdr, temporary(bimg), bmap
	print,''
	print,'Mapping AIA'
	index2map, aiahdr, temporary(aiaimg), aiamap

	print,''	
	print,'Maping CORs'
	index2map, cor1ahdr, temporary(cor1aimg), cor1amap
	index2map, cor2ahdr, temporary(cor2aimg), cor2amap

	index2map, cor1bhdr, temporary(cor1bimg), cor1bmap
	index2map, cor2bhdr, temporary(cor2bimg), cor2bmap
	
	cor1amap.data = (cor1amap.data - mean(cor1amap.data))/stdev(cor1amap.data)
	cor2amap.data = (cor2amap.data - mean(cor2amap.data))/stdev(cor2amap.data)
	
	cor1bmap.data = (cor1bmap.data - mean(cor1bmap.data))/stdev(cor1bmap.data)
	cor2bmap.data = (cor2bmap.data - mean(cor2bmap.data))/stdev(cor2bmap.data)
	print,''
	print,'Merging COR maps'
	imapa = merge_map(temporary(cor2amap), temporary(cor1amap), /add, use_min=0)
	imapb = merge_map(temporary(cor2bmap), temporary(cor1bmap), /add, use_min=0)	
	print,''
	print,'Mapping c2 and c3'
	index2map, c2hdr, temporary(c2img), c2map
	index2map, c3hdr, temporary(c3img), c3map	
	
	c2map.data = (c2map.data - mean(c2map.data))/stdev(c2map.data)
	c3map.data = (c3map.data - mean(c3map.data))/stdev(c3map.data)
	
	;c2map.data = c2map.data + abs(min(c2map.data))
	;c3map.data = c3map.data + abs(min(c3map.data))
	
	;c2map.data = rm_inner(c2map.data, c2hdr, 170.0d) 
	;c2map.data = rm_outer(c2map.data, c2hdr, 512.0d)
	;c3map.data = rm_inner(c3map.data, c3hdr, 108.80d)
	
	c2mask = masks_for_20110607(c2hdr)
	c3mask = masks_for_20110607(c3hdr)
	c2map.data = c2map.data*temporary(c2mask)
	c3map.data = c3map.data*temporary(c3mask)
	
	print,''
	print,'Merging c2 and c3 map'
	c2c3map = merge_map(temporary(c2map), temporary(c3map), /add, use_min=0)
	

	
	;----------------------------------------------------
	; Actually make the plot
	;----------------------------------------------------
	
	
	if keyword_set(tog) then toggle, f='imgplot.eps', xs=6.0d, ys=8.0d, /color
	!p.multi=[0, 2, 5]
	
	
	; Set up pos values for top 3x2 plots
	;aspect = 8.5d/11.0d
	;tm=0.05
	;bm=0.05
	;mhs = (((1.0d - (tm + bm))/4.0))*(findgen(4)+1.0) + bm
	;fh = ((1.0d - (tm + bm))/5.0)
	;hfh = (fh/2.0)*0.95
	;bts = mhs - hfh
	;tps = mhs + hfh
	;bts = [0.05, 0.2875, 0.5250, 0.7525]
	;tps = [0.2375, 0.4750, 0.7125, 0.95]
	
	
	; Now that vertical space if fixed work out horizotal spacing
	;lm = tm
	;rm = tm
	;fw = (hfh*2.0)/aspect
	;lm = ((1.0 - (fw*3.0d))/3.0)/2.0
	;rm=lm
	;hfw = fw/2.0d
	;mws = (((1.0d - (lm + rm))/3.0))*(findgen(3)+1.0) + lm
	;lfs = mws-hfw
	;rhs = mws+hfw
	
	;stop
	
	
	
	!p.multi=[0, 3, 4]
	!p.charsize=1.2
	mg = 0.02
	;	Row one
	;load_secchi_color, ahdr
	;title1 = ahdr.OBSRVTRY+' '+ahdr.DETECTOR+' '+arr2str(ahdr.WAVELNTH, /trim)+' '+strmid(ahdr.date_obs, 11, 8) 
	;plot_map, amap, /log, dmin=0.5d, dmax=10.d, xr=[-1200, 1200], yr=[-1200, 1200], $
	;plot_map, amap, dmin=-1.5d, dmax=2.5d, xr=[-1600, 1600], yr=[-1600, 1600], $
	;	/noa, /nolab, title='!6'+title1;, pos=[lfs[0], bts[3], rhs[0], tps[3]]
	;oplot, [-500, -1500], [-200, -200]
	;oplot, [-500, -500], [-200, -1200]
	;oplot, [-500, -1500], [-1200, -1200]
	;oplot, [-1500, -1500], [-200, -1200]
	
	
	;aia_lct,wavelnth=aiahdr.WAVELNTH,/load
	;title2 = aiahdr.origin+' AIA '+arr2str(aiahdr.WAVELNTH, /trim) +' '+strmid(aiahdr.date_obs, 11, 8)
	;plot_map, aiamap, /log, dmin=0.5d, dmax=10.d, xr=[-1200, 1200], yr=[-1200, 1200], $
	;plot_map, aiamap, dmin=-0.5, dmax=2.5d, xr=[-1250, 1250], yr=[-1250, 1250],$
	;	/noa, /nolab, title='!6'+title2;, pos=[lfs[1], bts[3], rhs[1], tps[3]]
	;oplot, [200, 1200], [200, 200]
	;oplot, [200, 200], [200, -1000]
	;oplot, [200, 1200], [-1000, -1000]
	;oplot, [1200, 1200], [-200, -1000]
	
	;load_secchi_color, ahdr	
	;title3 = bhdr.OBSRVTRY+' '+bhdr.DETECTOR+' '+arr2str(ahdr.WAVELNTH, /trim)+' '+strmid(bhdr.date_obs, 11, 8) 
	;plot_map, bmap, /log, dmin=0.5d, dmax=10.d, xr=[-1200, 1200], yr=[-1200, 1200], $
	;plot_map, bmap, dmin=-1.5d, dmax=2.5d, xr=[-1600, 1600], yr=[-1600, 1600], $
	;	/noa, /nolab, title='!6'+title3;,  pos=[lfs[2], bts[3], rhs[2], tps[3]]
	;oplot, [500, 1500], [-100, -100]
	;oplot, [1500, 1500], [-100, -1200]
	;oplot, [500, 1500], [-1200, -1200]
	;oplot, [500, 500], [-100, -1200]
	
	; Row two

	
	load_secchi_color, ahdr
	title1 = 'ST-A '+ahdr.DETECTOR+' '+arr2str(ahdr.WAVELNTH, /trim)+' '+strmid(ahdr.date_obs, 11, 8)+' UT'
	;plot_map, amap, /log, dmin=0.5d, dmax=10.d, xr=[-900, -300], yr=[-100, -500], $
	plot_map, amap, dmin=-0.50, dmax=1.8d, xr=[-500, -1500], yr=[-1200, -200], $
		 title='!6'+title1, pos=[0.68+mg, 0.757+mg, 1.0-mg, 1.0-mg], ytitle=' ', /noytic 
	
	aia_lct,wavelnth=aiahdr.WAVELNTH,/load
	title2 = aiahdr.origin+' AIA '+arr2str(aiahdr.WAVELNTH, /trim) +' '+strmid(aiahdr.date_obs, 11, 8)+' UT'
	plot_map, aiamap, dmin=-0.5, dmax=1.5d, xr=[200, 1200], yr=[200, -1000], $
		  title='!6'+title2, /noytic, pos=[0.36+mg, 0.757+mg, 0.68-mg, 1.0-mg], ytitle=' '

	 
	r1 = [[500, 500, 1100, 1100], [150, 160, 160, 150]]
	r2 = [[500, 500, 1100, 1100], [190, 200, 200, 190]]	
	r3 = [[500, 500, 1100, 1100], [227, 237, 237, 227]]
	
	rta = -40.0d*(!dpi/180.0d)
	r1p = [[cos(rta), -sin(rta)],[sin(rta), cos(rta)]] ## r1
	r2p = [[cos(rta), -sin(rta)],[sin(rta), cos(rta)]] ## r2
	r3p = [[cos(rta), -sin(rta)],[sin(rta), cos(rta)]] ## r3
	                                                 
	plots, r1p[*,0], r1p[*,1]                                          
 	plots, r1p[*,0], r1p[*,1], /cont
	plots, r2p[*,0], r2p[*,1]       
	plots, r2p[*,0], r2p[*,1], /cont
	plots, r3p[*,0], r3p[*,1]       
	plots, r3p[*,0], r3p[*,1], /cont

		 
	load_secchi_color, ahdr	
	title3 = 'ST-B '+bhdr.DETECTOR+' '+arr2str(ahdr.WAVELNTH, /trim)+' '+strmid(bhdr.date_obs, 11, 8)+' UT'
	;plot_map, bmap, /log, dmin=0.5d, dmax=10.d, xr=[300, 900], yr=[-100, -500], $
	plot_map, bmap, dmin=-1.0, dmax=1.0d, xr=[500, 1500], yr=[-1200, -100], $
		 title='!6'+title3, pos=[0.04+mg, 0.757+mg, 0.36-mg, 1.0-mg], yticknames=replicate(' ', 5)

	
	mg2=0.015
	;------------------------Coronagraphs------------------------;
	; Row three
	;load_secchi_color, cor2ahdr
	xrr=[-15000d, 15000d]
	yrr=xrr
	loadct, 0
	title4 = 'ST-A '+cor2ahdr.DETECTOR+' '+strmid(cor2ahdr.date_obs, 11, 5) $
		+'/' +cor1ahdr.DETECTOR+' 0'+strmid(cor1ahdr.date_obs, 12, 4)+' UT'
	plot_map, imapa, dmin=-1.5d, dmax=4.0d, /limb, lcolor=254, /noa, /nolabe, $
		title=title4, xr=xrr, yr=yrr, pos=[0.68+mg, 0.49+mg, 1.0-mg, 0.7325-mg], lthick=3
		
		
	title5 = 'LASCO '+c3hdr.DETECTOR+' '+strmid(c3hdr.date_obs, 11, 5) $
		+'/' +c2hdr.DETECTOR+' 0'+strmid(c2hdr.date_obs, 12, 4)+' UT'
	plot_map, c2c3map , xs=13, ys=13, tit=title5, xr=xrr, yr=yrr, $
		dmin=-0.25d, dmax=1.2d, /limb, lcolor=254, /noa, /nolabe, $
		pos=[0.36+mg, 0.49+mg, 0.68-mg, 0.7325-mg], lthick=3
	
	;load_secchi_color, cor2bhdr
	title6 = 'ST-B '+cor2bhdr.DETECTOR+' '+strmid(cor2bhdr.date_obs, 11, 5) $
		+'/' +cor1bhdr.DETECTOR+' 0'+strmid(cor1bhdr.date_obs, 12, 4)+' UT'
	plot_map, imapb, dmin=-1.5d, dmax=4.0d, /limb, lcolor=254,/noa, /nolabe, $
		title=title6, xr=xrr, yr=yrr, pos=[0.04+mg, 0.49+mg, 0.36-mg, 0.7325-mg], lthick=3
		

	;mws = (((1.0d - (lm + rm))/3.0))*(findgen(2)+1.0) + lm
	;lfs = mws-hfw
	;rhs = mws+hfw
	
	
	
	!p.multi=[4,2,5]
	;load_secchi_color, ahi1hdr
	loadct,0
	title7 = 'ST-A '+ahi1hdr.DETECTOR+' June 7 '+strmid(ahi1hdr.date_obs, 11, 5)+' UT'
	plot_image, ahi1, min=0.5, max=2.0, xs=13, ys=13, tit=title7, pos=[0.68+mg, 0.2475+mg, 1.0-mg, 0.49-mg]
	
	!p.multi=[3,2,5]
	title8 = 'ST-B '+bhi1hdr.DETECTOR+' June 7 '+strmid(bhi1hdr.date_obs, 11, 5)+' UT'
	plot_image, bhi1, min=0.5, max=2.0, xs=13, ys=13, tit=title8, pos=[0.04+mg, 0.2475+mg, 0.36-mg, 0.49-mg]
	
	;load_secchi_color, ahi2hdr
	loadct,0
	!p.multi=[2,2,5]
	title9 = 'ST-A '+ahi2hdr.DETECTOR+' June 9 '+strmid(ahi2hdr.date_obs, 11, 5)+' UT'
	plot_image, sigrange(filter_image(ahi2, fwhm=4), /use, frac=0.97), xs=13, ys=13, tit=title9, pos=[0.68+mg, 0.0075+mg, 1.0-mg, 0.25-mg]
	
	!p.multi=[1,2,5]
	title10 = 'ST-B '+bhi2hdr.DETECTOR+' June 9 '+strmid(bhi2hdr.date_obs, 11, 5)+' UT'
	plot_image, sigrange(filter_image(bhi2, fwhm=4), /use, frac=0.95), xs=13, ys=13, tit=title10, pos=[0.04+mg, 0.0075+mg, 0.36-mg, 0.25-mg]
	
	if keyword_set(tog) then toggle

end