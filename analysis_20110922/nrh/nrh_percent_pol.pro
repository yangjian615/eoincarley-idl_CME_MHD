pro nrh_percent_pol

; Written 17-May-2013, plot percent polarization of radio burst on 22-Sep-2011

cd,'/Users/eoincarley/Data/22sep2011_event/NRH/hi_time_res/pngs'
restore,'stoke_light_curves.sav', /verb

;------------------ Plot Total I ---------------------;
loadct,0
set_line_color
utplot, times, max_I, /xs, /ylog, ytitle='Brightness Temperature (K)'
abline, 1e6, linestyle=1
abline, 1e7, linestyle=1
abline, 1e8, linestyle=1
abline, 1e9, linestyle=1

set_line_color

oplot, times, max_V_pos, color=5
oplot, times, max_V_neg, color=3
legend, ['Max Total Intensity', 'Right Circular', 'Left Circular'], linestyle=[0,0,0], color=[1,5,3], box=0


window,1


utplot, times, max_V_pos/max_I


stop

END