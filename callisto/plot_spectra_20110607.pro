pro plot_spectra_20110607

; After review of June 7th paper, Shaun asked me to have a closer look at the type 3 spectra
; in callisto to see if there was any fine structure. This code is just take a closer look at
; the spectra
;
;
cd,'~/Data/CALLISTO/20110607/'

restore,'spec_z_20110607.sav'
restore,'spec_x_20110607.sav'
restore,'spec_y_20110607.sav'


a = anytim(file2time('20110607_062500'),/utim)
b = anytim(file2time('20110607_064500'),/utim)
data_bs = constbacksub(spec_z_20110607, /auto)

;data_clean = rfi_removal(spec_z_20110607)
xstart = anytim(a, /yoh, /trun)
xtit = 'Start Time: '+xstart+' (UT)'

loadct,5
!p.color=0
!p.background=255
stretch, 51, 230, 1.1
window,0, xs=700, ys=700
spectro_plot, data_bs > (-20) < 40 , spec_x_20110607, spec_y_20110607, $
	/xs, xr=[a,b], xtitle=xtit, tick_unit=300, $
	/ys, yr=[20, 200], xtickname=[' ',' ',' ',' ',' ',' ',' ',' '],$
	/normal, color=0, position = [0.1, 0.75, 0.95, 0.95], ytickv=[200,100, 20], $
	ytickname=[' ', '100', '20'], yticks=3
	 
xyouts, 0.03, 0.5, 'Frequency (MHz)', /normal, alignment=0.5, orientation=90	 
;-----------------------------------;

;     Plot up the Blein data 		;
	
;-----------------------------------;
cd,'Blein'
files = findfile('*.fit')
radio_spectro_fits_read, files[0], data0, time0, freq, main_header=hdr
radio_spectro_fits_read, files[2], data2, time2, freq, main_header=hdr
data = [data0,data2]
time = [time0, time2]
data_bs = constbacksub(data, /auto)

a = anytim(file2time('20110607_062500'),/utim)
b = anytim(file2time('20110607_064500'),/utim)
;window,1

spectro_plot, data_bs >(-30), time, freq, /xs, /ys, xr=[a,b], yr=[800,200],$
/normal, /noerase, position = [0.1, 0.1, 0.95, 0.75], xticklen=-0.01


;-------------------------------------;

; 		  Next polarization			  ;

;radio_spectro_fits_read, files[1], data0, time0, freq, main_header=hdr
;radio_spectro_fits_read, files[2], data2, time2, freq, main_header=hdr
;data = [data0,data2]
;time = [time0, time2]
;data_bs = constbacksub(data, /auto);

;a = anytim(file2time('20110607_062500'),/utim)
;b = anytim(file2time('20110607_064500'),/utim)
;window,2
;spectro_plot, data_bs >(-30), time, freq, /xs, /ys, xr=[a,b]

cd,'/Users/eoincarley/Data/secchi_l1/20110607/swaves/2011'

xtit='Time in UT on 2011 June 7'





;------------------------Read in high SWAVES A ASCII-----------------------------



freq_grab=read_ascii('swaves_average_20110607_a_hfr.dat',delimiter=' ')
data=read_ascii('swaves_average_20110607_a_hfr.dat',delimiter=' ',data_start=2)

hi_freq_kHz = reverse(reform(freq_grab.field001[*,0]))
hi_freq_MHz = hi_freq_kHz/1000.
hi_freq_Hz = hi_freq_kHz*1000.

data_size = size(data.field001)
hi_array = dblarr(data_size[2],data_size[1]-1)
FOR i=0,data_size[2]-1 DO BEGIN
  hi_array(i,*) = reverse(data.field001[1:n_elements(data.field001[*,0])-1,i])  
ENDFOR

time0 = anytim(file2time('swaves_average_20110607_a_hfr.dat'),/utim)
times=dblarr(data_size[2])
times[0]=time0
FOR i=1,data_size[2]-1 DO BEGIN
  times[i]=time0+(i*60.)
ENDFOR  




MHz_convert=1.0;e6
a = anytim(file2time('20110607_060000'),/utim)  ;CALLISTO-SWAVES plot start time
b = anytim(file2time('20110607_100000'),/utim)  ;CALLISTO-SWAVES plot end time
stop_freq = closest(lo_freq_MHz, 0.01)
constant=fltarr(n_elements(times))
constant[*]=0.045*(MHz_convert)

loadct,5
window,3, xs=700, ys=700

!p.multi = [0,1,2]
spectro_plot,bytscl(smooth(hi_array[*,0:n_elements(hi_freq_MHz)-2],1),0,20),$
times,hi_freq_MHz[0:n_elements(hi_freq_MHz)-2]*(MHz_convert),$;remove MHZ_convert to plot in MHz
	/xs,xr=[a,b],$
	/ys,/ylog,ytitle='Frequency (MHz)', yticklen=-0.01, xticklen=-0.01, $
	/normal
	
a = anytim(file2time('20110607_062000'),/utim)
b = anytim(file2time('20110607_063000'),/utim)	

spectro_plot,bytscl(smooth(hi_array[*,0:n_elements(hi_freq_MHz)-2],1),0,20),$
times,hi_freq_MHz[0:n_elements(hi_freq_MHz)-2]*(MHz_convert),$;remove MHZ_convert to plot in MHz
	/xs,xr=[a,b],$
	/ys,/ylog,ytitle='Frequency (MHz)', yticklen=-0.01, xticklen=-0.01, $
	/normal
	  

END	