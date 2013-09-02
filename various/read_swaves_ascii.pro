pro read_swaves_ascii,filename,data_array,freq_Hz,times,SAVE_DATA=SAVE_DATA

;   Name: 
;	   -read_swaves_ascii
;
;   Purpose:
;	   -Read in the .dat format file for swaves data and generate data, freq, and time
;		arrays. These are convenient for use in spectro_plot.pro
;
;   Input parameters:
;      -filename: String of name of file  e.g., 'swaves_average_YYYYMMDD_a_hfr.dat'
;
;   Outputs:
;      -data_array: The swaves data array
;	   -freq_Hz: Array of freq values corresponding to the rows of data_array
;	   -times: Array of time values corresponding to the columns of data_array
;
;	Keywords:
;	   -save_data: save all data arrays in .sav file
;      
;   Written:
;	   -June-2011 (Eoin Carley)
;   Last Modified:
;	   -22-Nov-2011 Added an option to save data to .sav file (Eoin Carley)
;


;============Read in SWAVES ASCII and convert to data,frequency and time arrays=========
;=======Expected file format is the .dat file e.g.,swaves_average_YYYYMMDD_a_hfr.dat====

freq_grab=read_ascii(filename,delimiter=' ')
data=read_ascii(filename,delimiter=' ',data_start=2)
band = strsplit(filename,'swaves_average_20110922_',/extract,/regex)

;*********high frequency band of swaves
IF band eq 'a_hfr.dat' or band eq 'b_hfr.dat' THEN BEGIN
	freq_kHz = reverse(reform(freq_grab.field001[*,0]))
	freq_MHz = freq_kHz/1000.
	freq_Hz = freq_kHz*1000.

	data_size = size(data.field001)
	data_array = dblarr(data_size[2],data_size[1]-1)
	FOR i=0,data_size[2]-1 DO BEGIN
 		 data_array(i,*) = reverse(data.field001[1:n_elements(data.field001[*,0])-1,i])  
	ENDFOR
ENDIF

;*********low frequency band of swaves has slightly different ascii
IF band eq 'a_lfr.dat' or band eq 'b_lfr.dat' THEN BEGIN
 	freq_kHz = reverse(reform(freq_grab.field01[*,0]))
	freq_MHz = freq_kHz/1000.
	freq_Hz = freq_kHz*1000.

	data_size = size(data.field01)
	data_array = dblarr(data_size[2],data_size[1]-1)
	FOR i=0,data_size[2]-1 DO BEGIN;usually -1
  		data_array(i,*) = reverse(data.field01[1:n_elements(data.field01[*,0])-1,i])
	ENDFOR
ENDIF

;*********SWAVES data usually has one minute time bins
time0 = anytim(file2time(filename),/utim)
times=dblarr(data_size[2])
times[0]=time0
FOR i=1,data_size[2]-1 DO BEGIN
  	times[i]=time0+(i*60.)
ENDFOR 

;===================Save format is swaves_average_YYYYMMDD_a_hfr.sav ====================
IF keyword_set(save_data) THEN BEGIN
	result = strsplit(filename,'.dat',/extract,/regex)
	save,data_array,freq_Hz,times,filename=result+'.sav'
ENDIF

END