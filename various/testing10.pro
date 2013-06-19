pro testing10
loadct,0
cd,'/Users/eoincarley/Data/22sep2011_event/NRH'
!p.color=0
!p.background=255
window,0
restore,'intensity_v_time_150MHz.sav'
times = anytim(nrh_times, /utim)
utplot, times, intensity , /xs, /ys, /ylog, $
ytitle='Total image brightness temperature (K)', thick=2, yr=[1e10, 1e12]


restore,'moving_peak_max_intesnity_vs_time.sav', /verb
window,1

set_line_color
times = anytim(nrh_times, /utim)
utplot, times, MOVING_PEAK_MAX, /xs, /ys, /ylog, $
ytitle='Brightness Temperature (K)', yr=[1e6, 1e9], color=6, thick=2

restore,'stationary_peak_max_intesnity_vs_time.sav', /verb
times = anytim(nrh_times, /utim)
oplot, times, STATIONARY_PEAK_MAX, color=5, thick=2

END