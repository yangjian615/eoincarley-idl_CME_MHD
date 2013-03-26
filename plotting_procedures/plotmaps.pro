;restore,filename='02-08-24_c.sav'
;       add needed system variables
	;imagelib                                ; Image Tool definitions
	;devicelib
	;uitdblib                                ; UIT data base definitions

	;def_yssysv                              ; System Variables
	;!quiet=0

loadct,5

levelsm=[0.5,0.7,0.8,0.9,0.95]*max(datanha(*,*,160))
;norh_plot,indexnhz(160),datanhz(*,*,160)
;norh_plot,indexnha(160),datanha(*,*,160), /over;,levelsp=levelsm

norh_index2map,indexnha,datanha,mapnha
plot_map,mapnha(160),grid=10

;plot_map,mapnha(260),/over


norh_index2map,indexnhs,datanhs,mapnhs
;plot_map,mapnhs(160),/over,levelsp=levelsp


norh_index2map,indexnhz,datanhz,mapnhz
plot_map,mapnhz(260),/over

end