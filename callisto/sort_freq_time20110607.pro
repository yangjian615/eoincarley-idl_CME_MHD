pro sort_freq_time20110607

; Take the output of plot_callisto_swaves,/choose_points, frequency time values', and
; sort them into a single array

cd,'/Users/eoincarley/Data/CALLISTO/20110607'
restore,'cal_x.sav'
restore,'cal_y.sav'
restore,'strhi_x.sav'
restore,'strhi_y.sav'
restore,'strlo_x.sav'
restore,'strlo_y.sav'

strhi_y= strhi_y/1.0e6
strlo_y= strlo_y/1.0e6

ft_typeIII = dblarr(2,n_elements(cal_y)+n_elements(strlo_y)+n_elements(strhi_y))

ft_typeIII[1,0]=cal_y[*]
ft_typeIII[1,n_elements(cal_y):n_elements(strhi_y)] = strhi_y[*]
ft_typeIII[1,n_elements(cal_y)+n_elements(strhi_y):n_elements(ft_typeIII[1,*])-1]=strlo_y[*]

ft_typeIII[0,0]=cal_x[*]
ft_typeIII[0,n_elements(cal_x):n_elements(strhi_x)] = strhi_x[*]
ft_typeIII[0,n_elements(cal_x)+n_elements(strhi_x):n_elements(ft_typeIII[0,*])-1]=strlo_x[*]

save,ft_typeIII,filename='ft_typeIII_20110607.sav'
END