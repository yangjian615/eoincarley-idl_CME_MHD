pro spectrum_movie_maker

cd,'/Users/eoincarley/Data/CALLISTO/20110922'
radio_spectro_fits_read,'BIR_20110922_103000_01.fit',z0,x0,y0
radio_spectro_fits_read,'BIR_20110922_104459_01.fit',z1,x1,y1
;!p.multi=[0,2,1]

cd,'glid_back_sub_movie'

thisDevice = !D.Name
loadct,39
stretch,0,255
FOR i=0,n_elements(x0)-1 DO BEGIN

 set_plot,'z',/copy
 !p.multi=[0,1,2]
 device, set_resolution=[1000,500],z_buffer=0
 erase
		 spectro_plot,z1,x1,y1,/xs,/ys,ytitle='Frequency (MHz)'
		 plots,x1[i],y1[*],thick=1.5,color=240
		 
		 plot,y1[*],reverse(reform(z1( i, * ))),color=255,yr=[100,220],$
		 xtitle='Frequency (MHz)',ytitle='Intensity',/xs
		 oplot,y1[*],reverse(reform(z1( i, * ))),color=240
		 oplot,y1[*],reverse(reform(z1( 0, * ))),color=140
		 
		 xyouts,0.6,0.47,anytim(x1[i],/yoh,/trun),/normal,color=240
		 
		 
		 snapshot = TVRD()
		 TVLCT, r, g, b, /Get
		 Device, Z_Buffer=1
         Set_Plot, thisDevice

		 image24 = BytArr(3, 1000, 500)
		 image24[0,*,*] = r[snapshot]
		 image24[1,*,*] = g[snapshot]
 		 image24[2,*,*] = b[snapshot]
		 write_png,'glid_sub_herbones'+string(i,format='(I4.4)')+'.png',image24,r,g,b
		 
ENDFOR		 

END