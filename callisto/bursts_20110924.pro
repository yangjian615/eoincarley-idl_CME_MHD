pro bursts_20110924

cd,'~/desktop'

radio_spectro_fits_read,'BIR_20110924_124500_02.fit',data,time,freq

loadct,39
!p.color=255
!p.background=0

window,1

ts =anytim(file2time('20110924_124600'),/utim)
te =anytim(file2time('20110924_130000'),/utim)


loadct,9
stretch,100,50
spectro_plot,constbacksub(data,/auto),time,freq,/xs,/ys,$
xr = [ts,te],yr=[200,100],charsize=1.5,ytitle='Frequency (MHz)'

END