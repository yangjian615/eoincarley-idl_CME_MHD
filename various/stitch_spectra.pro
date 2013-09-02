pro stitch_spectra, data, time, freq, save_spec = save_spec

;------------------------------------------------------;
;       STITCH_SPECTRA
;------------------------------------------------------;
; Name: sitch_spectra
;
;   Purpose:
;   -To stitch together latest spectra in input folder into hour long spectra
;
; Input parameters:
;	-None
;
; Keywords:
;   -save_spec: Option to save dynamic spectrum to a .sav file.
;
; Outputs:
;   -data (float array): The dynamic spectra between
;   -time (float_array): The time array
;   -freq (float_array): The frequency array of sitched spectra
;
;   Calling sequence example:
;   -stitch_spectra, /save_spec
; 
;   Last modified:
;   -10-Nov-2011 (E.Carley) Just a clean up....
;   -08-Jan-2013 (E.Carley) See comment on same date below.
;                           New directory structure puts ALL fits in same fts folder -> Need an extra criterion
;                           in findfile argument.

get_utc,ut
today=time2file(ut,/date)
list = findfile('*.fit')
file_times = anytim(file2time(list),/utime)

IF n_elements(list) gt 0 THEN BEGIN

  index_stop = n_elements(list)-1
  radio_spectro_fits_read, list[0], data, time, freq

  ;----------- Loop to 'stitch together' all spectra from last hour -----------
    FOR i = 1, n_elements(list)-1 DO BEGIN
        filename = list[i]
        radio_spectro_fits_read, filename, run_data, run_time, freq    
        data = [data, run_data]
        time = [time, run_time]
    ENDFOR
    
  spectro_plot, data, time, freq, /xs, /ys, ytitle='Frequency (MHz)'

  IF keyword_set(save_spec) THEN BEGIN
		save, data, time, freq, filename='stitch_spectra_'+anytim(file_times[0], /yoh, /trun)+'.sav'
  ENDIF
ENDIF ELSE BEGIN
	print,' Did not detect any fits files'
ENDELSE

END