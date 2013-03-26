pro figure_schematic_20110922_v2
	

	
	print,'Stopping!'
	
	
	i=1.0
cd,'/Users/eoincarley/Data/22sep2011_event/LASCO_C2/L0.5/L1'
	set_plot,'ps'
	device,filename = 'figure_schematic_20110922_v2',$
	/color,/inches,/landscape,/encapsulate,$
	ysize=8,xsize=8, bits_per_pixel=8, yoffset=8
	
	
	loadct,0
	DRAW_GRID, tilt=90.0, color=0, thick=2
	
	device,/close
	set_plot,'x'


END