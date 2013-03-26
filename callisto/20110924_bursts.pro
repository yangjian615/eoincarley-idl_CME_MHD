pro 20110924_bursts

cd,'dektop'

radio_spectro_fits_read,'BIR_20110924_124459_01.fit',data,time,freq

loadct,39
!p.color=0
!p.background=255

window,1

ts =anytim(file2time('20110924_124500'),/utim)
te =anytim(file2time('20110924_125800'),/utim)


loadct,9
spectro_plot,constbacksub(data,/auto),time,freq,/xs,/ys,$
xr = [ts,te],yr=[60,10]

END