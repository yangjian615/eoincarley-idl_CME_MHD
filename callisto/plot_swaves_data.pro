pro plot_swaves_data,filename_hi,filename_low

restore,filename_hi,/verbose

freq_MHz = freq_Hz/1.0e6
MHz_convert=1.0;1.0e6

loadct,5
!p.color=0
!p.background=255
!p.charsize=1.5


;=========Other variables===========
MHz_convert=1.0;1.0e6


;======================Plot high SWAVES A array========================

ticks = loglevels([0.179*(MHz_convert),16.025*(MHz_convert)],/fine);remove 1e6 to plot in MHz
nticks=n_elements(ticks)

spectro_plot,bytscl(smooth(data_array[*,0:n_elements(freq_MHz)-2],5),0,20),$
times,freq_MHz[0:n_elements(freq_MHz)-2]*(MHz_convert),$ ;remove MHZ_convert to plot in MHz
	/xs,xticklen=-0.03,yticklen=-0.01, YTICKS=nticks-1,YTICKV=Reverse(ticks),/ys,/ylog,ytitle='Frequency (MHz)',$
	;ytickname=['10!U7!N',' ',' ','10!U6!N',' ',' ']
    position=[0.1,0.12,0.98,0.55],/normal;,/NOERASE
    

restore,filename_low,/verb
freq_MHz = freq_Hz/1.0e6
MHz_convert=1.0;1.0e6

ticks = loglevels([0.01*(MHz_convert),0.125*(MHz_convert)],/fine) 
nticks=n_elements(ticks)

;lo_array and hi_array are indexd to remove some frequencies so that 
;there's a smoother transition between plots

spectro_plot,bytscl(data_array[*,0:n_elements(freq_MHz)-2],0,20),times,$
freq_MHz[0:n_elements(freq_MHz)-1]*(MHz_convert),$					  
	/ylog,YTICKS=nticks-1,YTICKV=Reverse(ticks),/ys,$;ytickname=['10!U5!N',' ',' ','10!U4!N'],$				  
	xticks=1,xtickname=[' ',' ',' ',' ',' ',' '],xtitle = '  ',/xs, $
 	position=[0.1,0.55,0.98,0.95],/normal,/NOERASE    
    
END
