pro typeIII_speed_20110922_v2

;v2 uses SWAVES instead of WAVES

t1 = anytim(file2time('20110922_102000'),/utim)
t2 = anytim(file2time('20110922_112000'),/utim)
loadct,5
cd,'/Users/eoincarley/Data/22sep2011_event/SWAVES'
xleft = 0.1
xright = 0.9
!p.charsize=1.5
window,0,xs=600,ys=1000

restore,'swaves_average_20110922_b_lfr.sav',/verb

spectro_plot, smooth(data_array,1) >0.0, times, freq_hz/1.0e6, /xs, /ys,  $
position=[xleft, 0.5, xright, 0.9], /normal, /noerase, $
xtickname=[' ', ' ', ' ', ' ', ' ', ' ', ' '], /ylog, xr=[t1,t2]

restore,'swaves_average_20110922_b_hfr.sav',/verb
spectro_plot, smooth(data_array,1) >0.0 , times, freq_hz/1.0e6, /xs, /ys,  $
position=[xleft, 0.1, xright, 0.54], /normal, /noerase, /ylog, xr=[t1, t2],$
xticklen=-0.03, xminor=2


point, time, freq_p, /data
window,1, xs=500, ys=500
utplot, time, freq_p, xtitle='Time (UT)', ytitle='Frequency (MHz)'

;--------------Calculate Density and Distance --------------

n_e = ((freq_p*1.0e6)/8980.0)^2.0
npoints=1000
rad_sim = (dindgen(1000)*(215-1.0)/(npoints-1))+1.0
sw_mann, rad_sim, n = nsim
rad_ne = interpol(rad_sim, nsim, n_e)

window, 2, xs=500, ys=500
utplot, time, rad_ne, xtitle='Time (UT)', ytitle='Height (Rsun)'
result = linfit(time, rad_ne, yfit=yfit)

tim_sim = (dindgen(1000)*(time[n_elements(time)-1]- time[0])/(npoints-1)) + time[0]
radfit = result[0] + result[1]*tim_sim
oplot,tim_sim,radfit, linestyle=1

;---------- Calculate Velocity -----------;
rsun = 6.955e8
c = 2.98e8
velocity = result[1]*rsun
print,'-------------------------'
print,'Velocity of beam: '+string(velocity/1000.0)+' km/s'
print,'Velocity of beam: '+string(velocity/c)+' c'
me = 9.1e-31
kine_J = 0.5*me*(velocity^2.0) ;J
kine_ev = kine_J/1.6e-19
print,'Energy of beam: '+string(kine_ev/1.0e3)+' keV'
print,'-------------------------'


;-----------------------------------------------------------;
;		Now cconvert to distance along parker spiral        ;
;-----------------------------------------------------------;
v_sw = 450.0 ;km/s see http://fiji.sr.unh.edu/ for the bulk velocity on 22-Sep-2011
arc_len = parker_spiral_length(rad_ne, v_sw)
window,5,xs=500,ys=500
utplot, time, arc_len, xtitle='Time (UT)', ytitle='Distance along Parker spiral (Rsun)'
result = linfit(time, arc_len, yfit=yfit)
tim_sim = (dindgen(1000)*(time[n_elements(time)-1]- time[0])/(npoints-1)) + time[0]
radfit = result[0] + result[1]*tim_sim
oplot,tim_sim,radfit, linestyle=1



;---------- Calculate Velocity -----------;
rsun = 6.955e8
c = 2.99e8
velocity = result[1]*rsun
print,'-------------------------'
print,'Velocity of beam: '+string(velocity/1000.0)+' km/s'
print,'Velocity of beam: '+string(velocity/c)+' c'



rel_e = relativistic_energy(velocity/c)

print,'Energy of beam: '+string(rel_e[0]/1.0e3)+' keV'
print,'-


;-------------------------------------------;
;				ETA at 1AU
;-------------------------------------------;
burst_start = anytim(file2time('20110922_104000'), /utim)
arc_len = parker_spiral_length(215, v_sw)  
tim_flight = (arc_len*6.955e8)/velocity
eta = burst_start +tim_flight
print, 'Time of flight: '+string(tim_flight/60)+' minutes'
print, 'Expected arrival time: '+string(anytim(eta, /yoh))+' UT'

save, time, freq_p, filename='freq_time_points.sav'
END