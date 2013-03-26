pro get_rsto_data,time1,time2,freq


url='http://data.rosseobservatory.ie'
rootdir = '/callisto/data/'

sock_ping,'86.47.107.67',server_ready
IF server_ready THEN BEGIN

get_utc,ut
today=time2file(ut,/date)
datedir=anytim(ut,/ecs,/date_only)
savedir='~/Data/CALLISTO/'
cd,savedir

date1=time2file(file2time(time1),/date)
date2=time2file(file2time(time2),/date)


spawn,'mkdir -p '+date1
cd,date1
listurls='./urls2download_'+date1

ut_time1=anytim(file2time(time1),/utime)
ut_time2=anytim(file2time(time2),/utime)

IF date1 eq date2 THEN date=date1

remote_directory='/callisto/data/'+date+'/fts/'+freq

files = sock_find(url,'*.fit',path=remote_directory) 
file_times_birr = strarr(n_elements(files))

FOR i=0,n_elements(files)-1 DO BEGIN

file_times_birr[i] = anytim(file2time(strsplit(files[i],'http://data.rosseobservatory.ie',/extract,/regex)),/utime)

ENDFOR

start_index = where(file_times_birr gt ut_time1)
stop_index = where(file_times_birr lt ut_time2)

sock_copy,files[start_index[0]:stop_index[n_elements(stop_index)-1]],/verb

openw,lun,listurls,/get_lun	
printf, lun, files[start_index[0]:stop_index[n_elements(stop_index)-1]]
close,lun
;spawn,'curl -i '+listurls+' -P '
ENDIF
END
