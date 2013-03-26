pro parse_burst_list,marker

;   Name: parse_burst_list
;
;   Purpose:
;		-Read in the NOAA radio burst list at 
;		 http://www.swpc.noaa.gov/ftpdir/lists/radio/radio_bursts.txt and parse to 
;		 obtain times and frequencies of radio burst. These (f,t) are to be used
;		 as markers on the summariy dynamic spectra 
;
;   Input parameters:
;      -None
;
;   Keyword parametrs:
;      -
;   Outputs:
;      -marker: Set of (f,t) values giving location of bursts
;      
;   Calls on:
;   
;	Written: 23-Nov-2011 (Eoin Carley)
;   Last Modified:
;

url = 'http://www.swpc.noaa.gov/'
root = '/ftpdir/lists/radio/'
text_file = 'radio_bursts.txt'
burst_list = sock_find(url,text_file,path=root)
sock_copy,burst_list

get_utc,ut
date = time2file(ut,/date_only)

FMT = 'A,A,A,A,A,A'
readcol,'radio_bursts.txt',year,month,day,tstart,max_intensity,tend,$;,observatory,Q,type,freq,type,sw_speed,register
							format=FMT,stringskip='#'
any_u = strarr(n_elements(tstart))
FOR i=0,n_elements(tstart)-1 DO BEGIN
any_u[i] = strsplit(tstart[i],'U',/extract,/regex)
ENDFOR
tstart=any_u
date_start = year+month+day+'_'+tstart
date_end = year+month+day+'_'+tend

stop
END