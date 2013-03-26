pro callisto_20110922

;code to pout together the remaining spectra for dyn spectra figure
cd,'/Users/eoincarley/Data/CALLISTO/20110922/rsto_20110922_forfigure/1000-1030'

;------ Low Frequency --------;
low_files = findfile('*01.fit')
radio_spectro_fits_read, low_files[0], data0, time0, freq0
radio_spectro_fits_read, low_files[1], data1, time1, freq1
;radio_spectro_fits_read, low_files[2], data2, time2, freq2
;radio_spectro_fits_read, low_files[3], data3, time3, freq3

low_data10 = [data0, data1];, data2];, data3]
low_time10 = [time0, time1];, time2];, time3]
save, low_data10, low_time10, filename='low_20110922_10.sav'


;------ Mid Frequency ---------;
mid_files = findfile('*02.fit')
radio_spectro_fits_read, mid_files[0], data0, time0, freq0
radio_spectro_fits_read, mid_files[1], data1, time1, freq1
;radio_spectro_fits_read, mid_files[2], data2, time2, freq2
;radio_spectro_fits_read, mid_files[3], data3, time3, freq3

mid_data10 = [data0, data1];, data2];, data3]
mid_time10 = [time0, time1];, data2];, data3]
save, mid_data10, mid_time10, filename='mid_20110922_10.sav'


;------ high Frequency ---------;
high_files = findfile('*03.fit')
radio_spectro_fits_read, high_files[0], data0, time0, freq0
radio_spectro_fits_read, high_files[1], data1, time1, freq1
;radio_spectro_fits_read, high_files[2], data2, time2, freq1
;radio_spectro_fits_read, high_files[3], data3, time3, freq1

high_data10 = [data0, data1];, data2];, data3]
high_time10 = [time0, time1];, data2];, data3]
save, high_data10, high_time10, filename='high_20110922_10.sav'




END