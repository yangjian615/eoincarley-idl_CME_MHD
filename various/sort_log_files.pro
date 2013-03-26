pro sort_log_files

;cd,'C:\Inetpub\wwwroot\callisto\log'
get_utc, propgram_start

files = findfile('2*.txt')
tstart = anytim(file2time(files[0]), /utim, /date_only)
tend = anytim( file2time(files[ n_elements(files)-1] ), /utim, /date_only)

;Parse date file
;Does year exist no->make it, cd into it
sec_in_day = 24.0*60.0*60.0
i=0.0
;Build the years
WHILE tstart lt tend DO BEGIN
	
	t = tstart + i*sec_in_day
	print,anytim(t, /yoh)
	date_split = anytim(t, /ex)
	year = string(date_split[6], format='(I4)')
	month = string(date_split[5], format='(I02)')
	day = string(date_split[4], format='(I02)')
	
	
	IF file_test( year ) eq 0 THEN BEGIN 
		spawn,'mkdir '+ year
		cd,year
	ENDIF ELSE BEGIN
		cd,year
	ENDELSE	
	
	IF file_test( month ) eq 0 THEN BEGIN
		spawn,'mkdir '+ month
		cd,month
	ENDIF ELSE BEGIN
		cd,month
	ENDELSE	
	
	IF file_test( day ) eq 0 THEN BEGIN
		spawn,'mkdir '+ day
		cd,'../../'
	ENDIF

	i = i+1.0

ENDWHILE

get_utc, propgram_end
print,'Program run time: '+string(program_start - program_end) 

END