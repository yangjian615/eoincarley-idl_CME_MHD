pro aia_nrh_c2_fig

;-------------------------------------------------------------------------------------;
;	   Final version of the code to plot Figure 1 for Nat Phys paper (8-Aug-2013)	  ;
;																		     		  ;

	COMMON shared,  mapc2, t1, t2, nrh_hdr_150, nrh_data_150,$
		   			nrh_hdr_445, nrh_data_445, nrh_times_150,$
		   			nrh_times_445, suncenter, pixrad, c2_data,$
		   			c2_hdr_struc, f



t1 = anytim(file2time('20110922_103500'),/utim)
t2 = anytim(file2time('20110922_111000'),/utim)


;-------------------------------------;
;			Read AIA data   
cd,'~/Data/22sep2011_event/AIA'
aia_files = findfile('aia*.fits')
mreadfits_header, aia_files, ind, only_tags='exptime'
f = aia_files[where(ind.exptime gt 1.)]


;-------------------------------------;
;	  		READ C2 DATA		   	
cd,'~/Data/22sep2011_event/LASCO_C2/L0.5/L1'
files=findfile('*.fts')
file = files[4]
c2_data = readfits(file,c2_hdr) 
pre_data = readfits('24373725.fts',pre_hdr)
c2_bs_data = c2_data - pre_data
junk = lasco_readfits(file,c2_hdr_struc)
print,'C2 time: '+anytim(c2_hdr_struc.date_obs,/yoh)
c2_data = c2_bs_data
;		MASK C2 DATA
junk = lasco_readfits('24373729.fts',hdr) 
rsun = get_solar_radius(hdr)
pixrad = rsun/hdr.cdelt1
suncenter = get_sun_center(hdr)


;-------------------------------------;
; 		   Read NRH Data (Cube)      
	
tstart = anytim(anytim(t1,/utim),/yoh,/trun,/time_only)
tend   = anytim(anytim(t2,/utim),/yoh,/trun,/time_only)
freq = '1509'
cd,'~/Data/22sep2011_event/nrh'                       
read_nrh,'nrh2_'+freq+'_h70_20110922_081556c06_i.fts', nrh_hdr_150, nrh_data_150, hbeg=tstart, hend=tend
index2map, nrh_hdr_150, nrh_data_150, nrh_struc_150  
nrh_struc_hdr_150 = nrh_hdr_150
nrh_times_150 = nrh_hdr_150.date_obs


;------------------------------------------------------------;
; 					 SET DEVIVCE PARAMS 

cd,'~/Data/22sep2011_event/NRH/NRH_AIA_pdf'    ;Location of the postscript
set_plot,'ps'
!p.font=0
!p.charsize=1.0
device,filename = 'aia_nrh_c2_fig.ps', /color, /inches, /landscape, /encapsulate,$
yoffset=13,ysize=8,xsize=13, bits_per_pixel=8, /helvetica


;------------------------------------------------------------;
;					   Begin plotting
;[x1,y1,x2,y2]
FOV = [40.0,40.0]
CENTER = [-1300.0, 50.0]
lasco_label=1.0
create_composite, 60, [0.64, 0.53, 0.925, 0.99], FOV, CENTER, 'c', 2.1, lasco_label
lasco_label=0.0
DISK = 2.1

create_composite, 27, [0.06, 0.53, 0.34, 0.99], FOV, CENTER, 'a', DISK, lasco_label, /yaxis
create_composite, 41, [0.345, 0.53, 0.635, 0.99], FOV, CENTER, 'b', DISK, lasco_label
create_composite, 87, [0.06, 0.065, 0.34, 0.525], FOV, CENTER, 'd', DISK, lasco_label, /yaxis, /xaxis
create_composite, 88, [0.345, 0.065, 0.635, 0.525], FOV, CENTER, 'e', DISK, lasco_label, /xaxis
create_composite, 95, [0.64, 0.065, 0.925, 0.525], FOV, CENTER, 'f', DISK, lasco_label, /xaxis

;------------------------------------------------------------;
;					Plot Colour Bar
loadct,33
intens = (dindgen(9)*(9.0 - 7.0)/8) + 7.0 ;intesnities scaled between 10^7 K to 10^9 K
labels = string(intens, format='(f4.2)')
colors = reverse([120, 136, 152, 168, 184, 200, 216, 232, 250])
cgDCBar, colors, labels = labels, color='black', position=[0.932, 0.065, 0.942, 0.99], $
charsize=1.0, /vertical, spacing=0.16, rotate=-45, title='log!L10!N(T!LB!N [K])', tcharsize=1.0, /right


device,/close
set_plot,'x'

END



;------------------------------------------------------------;
;-------------------C2 AND AIA PLOTTER-----------------------;
;------------------------------------------------------------;

pro create_composite, image_num, pos, FOV, CENTER, tag, occulter, lasco_label, yaxis=yaxis, xaxis=xaxis
	
	COMMON shared
	
	; Similar to create_composite_img but now with AIA. Intended use: make movie of AIA and NRH
	; create_composite_img still useful for plotting LASCO, NRH, SWAP
	; v3 the NRH map creation is functionalised in this version 
	; v4 calls plot_low_mid_20110922_v2, which doesn't plot goes

   	loadct,0
	stretch,0,170
	
	;---------------   Plot the C2 image   -------------------; 
	;	In this version (create_composite_img_v3) it doesn't matter what C2 image.
	;	It's only used as base onto which AIA and NRH can be overplot
	
	index = circle_mask(c2_data, suncenter.xcen, suncenter.ycen, 'le', pixrad*occulter)
	IF tag eq 'c' THEN BEGIN
		c2_data[index] = 0.0
		mapc2 = make_map(bytscl(c2_data,-5.0e-10,1.5e-9)  )
	ENDIF
	IF tag eq 'a' THEN BEGIN
		c2_data[*,*] = mean(c2_data/max(c2_data))-0.3
		c2_data[index]= -0.1
		mapc2 = make_map(c2_data)
	ENDIF

	mapc2.dx = 11.9
	mapc2.dy = 11.9
	mapc2.xc = 14.4704
	mapc2.yc = 61.2137
	axes_thickness=3
	loadct,0

	
	IF tag eq 'c' THEN BEGIN
		plot_map, mapc2,/notitle, /nolabels, fov = FOV,center = CENTER,$
		position = pos, /noerase, /noaxes, /noxticks
	ENDIF ELSE BEGIN
		plot_map, mapc2,/notitle, /nolabels,fov = FOV,center = CENTER,$
		position = pos,  /noerase, /noaxes, dmin=-0.5,dmax=1
	ENDELSE
	
	IF keyword_set(yaxis) THEN BEGIN
		axis, yaxis=0, ythick=axes_thickness, yticklen=-0.025, ytitle=''
	ENDIF
	IF keyword_set(xaxis) eq 1 THEN BEGIN
		IF tag eq 'd' or tag eq 'e' THEN BEGIN
			axis, xaxis=0, xthick=axes_thickness, xticklen=-0.025, xtitle='X (arcsecs)', $
				xtickname=['-2500','-2000','-1500','-1000','-500',' ']
		ENDIF ELSE BEGIN
			axis, xaxis=0, xthick=axes_thickness, xticklen=-0.025, xtitle='X (arcsecs)'
		ENDELSE
	ENDIF	
	
	points = (FINDGEN(1001)*(214.5 - 142.0)/1000.0 ) + 142.0
   	x = 0.0 + 2025 * COS(points*!Dtor)
   	y = 0.0 + 2025 * SIN(points*!Dtor)
   	plots, TRANSPOSE([[x],[y]]), /data, thick=7, color=70
 	
   	
	;---------------        Make the AIA map and plot         ---------------;
	cd,'~/Data/22sep2011_event/AIA'
	
	read_sdo, f[image_num], he_aia, data_aia
	read_sdo, f[image_num-5], he_aia_pre, data_aia_pre
	index2map, he_aia_pre, smooth(data_aia_pre,5)/he_aia_pre.exptime, map_aia_pre, outsize = 1024
	index2map, he_aia, smooth(data_aia,5)/he_aia.exptime, map_aia, outsize = 1024

	loadct,1
	plot_map, diff_map(map_aia, map_aia_pre), /composite, /average, $
	dmin = -7.0, dmax = 5.0, /noaxes  
	set_line_color
	plot_helio, he_aia.date_obs, /over, gstyle=0, gthick=2.0, gcolor=1, grid_spacing=15.0


	;-------------         NRH DATA          --------------;
	
	overplot_nrh, nrh_times_150, nrh_data_150, nrh_hdr_150, he_aia, 2, pos, tag, c2_hdr_struc, lasco_label, 0

	sun_sym = sunsymbol()
	IF tag eq 'c' THEN BEGIN
		plot_circles, 1.47
		xyouts, -1600, 800, ' 1.5 R!L   !N', color = 7, /data, charsize=1.0, charthick=3
		xyouts, -1610, 800, '    !L!9n!X!N', /data, charsize=1.5, color=7, charthick=3, font=-1
		plot_circles, 2.1
		xyouts, -1650, 1100, '2.1 R!L  !N', color = 7, /data, charsize=1.0, charthick=4
		xyouts, -1615, 1100, '   !L!9n!X!N', /data, charsize=1.5, color=7, charthick=3, font=-1
	ENDIF
	
   
END


;------------------------------------------------------------;
;------------------------NRH PLOTTER-------------------------;
;------------------------------------------------------------;

pro overplot_nrh, nrh_times, nrh_data, nrh_hdr, he_aia, c_color, pos, tag, c2_hdr_struc, lasco_label, lin
	
	index_nrh = closest(anytim(nrh_times,/utim), anytim(he_aia.date_obs,/utim)  )

	nrh_data_select = alog10( smooth(nrh_data[*,*,index_nrh],3) )
	map_nrh = make_map(nrh_data_select)
	map_nrh.dx = 29.9410591125
	map_nrh.dy = 29.9410591125
	map_nrh.xc = 64.0
	map_nrh.yc = 64.0
	
	max_val = max( alog10(nrh_data[*,*,index_nrh]) ,/nan)  ;to scale to max of each image: nrh_data[*,*,index_nrh] 
														   ;to scale to max of each image: nrh_data[*,*,*] 
														   
	nlevels=5.0   ; 5 contours for nrh_data[*,*,index_nrh], 10 contours nrh_data[*,*,*] 
	levels = (dindgen(nlevels)*(max_val - max_val*0.95)/(nlevels-1.0)) + max_val*0.95  ;scale to 0.95 of max for nrh_data[*,*,index_nrh], 0.9 nrh_data[*,*,*]
	loadct,33

	intens = (dindgen(101)*(0.9 - 0.7)/100.0) + 0.7   ;intesnities scaled between 10^7.5 K to 10^9 K
	cols = reverse((dindgen(101)*(250. - 120.)/100.) + 120.);cols = reverse((dindgen(101)*(250. - 120.)/100.) + 120.)  		;choose the color range to represent these intensities.
	colors = round(interpol(cols, intens, levels/10.0))  ;convert intensity values (levels) into corresponding color values
	print,colors
	print,levels

	
	plot_map, map_nrh, /overlay, /cont, levels=levels, c_color=colors, $
		/noxticks, /noyticks, xticklen=0.0, /noaxes, thick=3		

	
	set_line_color 
	angstrom='A'
	text_size=1.0
IF tag eq 'a' THEN BEGIN
	
	xyouts,pos[0]+0.005,pos[1]+0.025,'AIA  21.1 nm  '+anytim(he_aia.date_obs,/yoh,/trun, /time_only)+' UT', $
		color = 1, /normal, charsize=text_size, charthick=1
		
	xyouts,pos[0]-0.04,pos[1]+0.18,'Y (arcsecs)', $
		color = 0, /normal, charsize=text_size, charthick=1, orientation=90.0
	
	xyouts,pos[0]-0.04,pos[1]-0.29,'Y (arcsecs)', $
		color = 0, /normal, charsize=text_size, charthick=1, orientation=90.0
	
	DEVICE, SET_FONT = 'helvetica-bold'
	xyouts,pos[0]+0.005,pos[3]-0.03,tag, color = 1,/normal,charsize=1.5,charthick=5
	DEVICE, SET_FONT = 'helvetica'
	
	xyouts,pos[0]+0.005,pos[1]+0.005,'NRH 150.9 MHz '+anytim(nrh_hdr[index_nrh].date_obs,/yoh,/trun, /time_only)+' UT',$
		color = 0, /normal,charsize=text_size, charthick=2
	xyouts,pos[0]+0.005,pos[1]+0.005,'NRH 150.9 MHz '+anytim(nrh_hdr[index_nrh].date_obs,/yoh,/trun, /time_only)+' UT',$
		color = 1, /normal,charsize=text_size, charthick=1
		
END ELSE BEGIN

	xyouts,pos[0]+0.005,pos[1]+0.025, 'AIA '+anytim(he_aia.date_obs,/yoh,/trun, /time_only)+' UT', $
		color = 0, /normal, charsize=text_size, charthick=2
	xyouts,pos[0]+0.005,pos[1]+0.025, 'AIA '+anytim(he_aia.date_obs,/yoh,/trun, /time_only)+' UT', $
		color = 1, /normal, charsize=text_size, charthick=1
	
	DEVICE, SET_FONT = 'helvetica-bold'
	xyouts,pos[0]+0.005,pos[3]-0.03,tag, color = 1,/normal,charsize=1.5,charthick=5
	DEVICE, SET_FONT = 'helvetica'
	
	IF lasco_label eq 1 THEN BEGIN
		xyouts,pos[0]+0.005,pos[1]+0.045,'LASCO C2 '+anytim(c2_hdr_struc.date_obs,/yoh,/trun, /time_only)+$
		' UT',/normal,charsize=text_size, charthick=4, color=0
		xyouts,pos[0]+0.005,pos[1]+0.045,'LASCO C2 '+anytim(c2_hdr_struc.date_obs,/yoh,/trun, /time_only)+$
		' UT',/normal,charsize=text_size, charthick=1, color=1
	ENDIF
	
	xyouts, pos[0]+0.005,pos[1]+0.005, 'NRH '+anytim(nrh_hdr[index_nrh].date_obs,/yoh,/trun, /time_only)+' UT',$
		color = 0, /normal,charsize=text_size, charthick=2
	xyouts, pos[0]+0.005,pos[1]+0.005, 'NRH '+anytim(nrh_hdr[index_nrh].date_obs,/yoh,/trun, /time_only)+' UT',$
		color = 1, /normal,charsize=text_size, charthick=1
	
ENDELSE


END
;------------------------------------------------------------;
;					NRH PLOTTER END							 ;
;------------------------------------------------------------;


pro plot_circles, radius

points = (FINDGEN(1001)*(205.0 -145.0)/1000.0 ) + 145.0 
arcsec_per_rsun = 965.80252
x1 = 0.0 + radius*arcsec_per_rsun*COS(points*!Dtor)
y1 = 0.0 + radius*arcsec_per_rsun*SIN(points*!Dtor)
x2 = 0.0 + radius*arcsec_per_rsun*COS(points*!Dtor)
y2 = 0.0 + radius*arcsec_per_rsun*SIN(points*!Dtor)
set_line_color
plots, TRANSPOSE([[x1],[y1]]), /data, thick=6, color=7, linestyle=2
plots, TRANSPOSE([[x2],[y2]]), /data, thick=6, color=7, linestyle=2


END