pro light_curves_wind_nrh

cd,'/Users/eoincarley/Data/22sep2011_event/NRH'
restore,'nrh_total_flux_150.sav', /verb
nrh_flux = NRH_TOTAL_FLUX_150[1:183]
nrh_times = TIME_NRH_TOTAL_FLUX[1:183]
window,1
utplot, nrh_times, nrh_flux

window,2
cd,'/Users/eoincarley/Data/22sep2011_event/WAVES'
restore,'20110922.R2', /verb
plot_image,sigrange(smooth(congrid(arrayb[600:700,0:70],1000,200),6))
window,3
array_sum = sum(arrayb,1)
plot,sum(arrayb[600:700, 0:70],1)
stop
END