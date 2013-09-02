pro extract_tseries, data, time, freq, f = f

; Input parameters:
;   -data (float array): The dynamic spectra between
;   -time (float_array): The time array
;   -freq (float_array): The frequency array of sitched spectra
;
; Keywords:
;   -f: The frequency of descired time series (MHz)
;
; Outputs:
;	-None
;
;   Calling sequence example:
;   -extract_tseries, data, time, freq, f = 40.0

IF keyword_set(f) THEN BEGIN
	index_tseries = closest(freq, f)
	tseries = data[*, index_tseries]
	utplot, time, tseries, ytitle='Intesnity', title='Time series at: '+string(f)+' MHz', /xs, /ys
stop
ENDIF ELSE BEGIN
	print,'Please input desired frequency'
ENDELSE
END




;----------------------------------------------------------------------------
  function closest, array, value
;+
; NAME:
; CLOSEST
;
; PURPOSE:
; Find the element of ARRAY that is the closest in value to VALUE
;
; CATEGORY:
; utilities
;
; CALLING SEQUENCE:
; index = CLOSEST(array,value)
;
; INPUTS:
; ARRAY = the array to search
; VALUE = the value we want to find the closest approach to
;
; OUTPUTS:
; INDEX = the index into ARRAY which is the element closest to VALUE
;
;   OPTIONAL PARAMETERS:
; none
;
; COMMON BLOCKS:
; none.
; SIDE EFFECTS:
; none.
; MODIFICATION HISTORY:
; Written by: Trevor Harris, Physics Dept., University of Adelaide,
;   July, 1990.
;
;-

  if (n_elements(array) le 0) or (n_elements(value) le 0) then index=-1 $
  else if (n_elements(array) eq 1) then index=0 $
  else begin
    abdiff = abs(array-value)  ;form absolute difference
    mindiff = min(abdiff,index)  ;find smallest difference
  endelse

  return,index
  end