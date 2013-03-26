pro system_status_check,folder,today
;
;
; Name: system_status_check
; 
; Purpose: 
;   -Perform a simple check to see if data has been recorded in past hour. If so then save
;    'On' to status check. In not then save 'Off'. Used for online status check at
;    www.rosseobservatory.ie. Also formats sunrise and sunset time for use by other programs
;
; Input parameters:
;   -folder: The folder to perform the satus check on
;
; Keywords:
;   -None
;
; Ouputs:
;   -Saved text files, see below
;   
;   Last modified:
;   - 10-Nov-2011 (E.Carley) Just a clean up....
;
;


cd,'C:\Inetpub\wwwroot\callisto\data\realtime\fts\'+folder

list = findfile('BIR*.fit')
file_times = file2time(list)
get_utc,current_time
file_times = anytim(file_times,/utime)
current_time = anytim(current_time,/utime)

;   If the last file was 40 minutes ago then notify

IF file_times[n_elements(file_times)-1] lt (current_time - 2400) THEN BEGIN
    cd,'c:\Inetpub\wwwroot\sunrise_sunset'
      openr,1,'system_status.txt'
      status = strarr(4)
      readf,1,status
          status[0] = '<b>Callisto Spectrometer Status: </b><br><br>'
          If folder eq 'low_freq' THEN status[1]='10-100 MHz: Off <br>' 
          If folder eq 'mid_freq' THEN status[2]='100-200 MHz: Off <br>' 
          If folder eq 'high_freq' THEN status[3]='200-400 MHz: Off' 
      status = transpose(status)
      openw,2,'system_status.txt'
      printf,2,status
  close,1
  close,2
ENDIF ELSE BEGIN
  cd,'c:\Inetpub\wwwroot\sunrise_sunset'
      openr,1,'system_status.txt'
      status = strarr(4)
      readf,1,status
          status[0] = '<b>Callisto Spectrometer Status: </b><br><br>'
        If folder eq 'low_freq' THEN status[1]='10-100 MHz: On <br>' 
          If folder eq 'mid_freq' THEN status[2]='100-200 MHz: On <br>' 
          If folder eq 'high_freq' THEN status[3]='200-400 MHz: On'
      status = transpose(status)
      openw,2,'system_status.txt'
      printf,2,status
  close,1
  close,2
ENDELSE  
END


pro system_status
;
;
; Name: system_status
; 
; Purpose: 
;   -Give folder name to system_status_check (above) and put time in correct format
;    for online display
;
; Input parameters:
;   -None
;
; Keywords:
;   -None
;
; Ouputs:
;   -Saved text files, see below
;   
;   Last modified:
;   - 10-Nov-2011 (E.Carley) Just a clean up....
;
;
get_utc,today
today = time2file(today,/date)

system_status_check,'high_freq',today
system_status_check,'mid_freq',today
system_status_check,'low_freq',today


;===========Put Joe's solar ephemeris in appropriate format for online display==================== 

cd,'c:\Inetpub\wwwroot\sunrise_sunset'
openr,100,'suntimes.txt'
suntimes = strarr(3)
readf,100,suntimes
close,100

suntimes[0] = today+'_'+StrMid(suntimes[0],10)
suntimes[1] = today+'_'+StrMid(suntimes[1],9)
suntimes[2] = today+'_'+StrMid(suntimes[2],10)
times4php = strarr(3)
times4php[0] = 'Sunrise: ' +anytim(  file2time(suntimes[0]),/yohkoh,/truncate)+' UT<br>'
times4php[1] = 'Sunset:   ' +anytim(  file2time(suntimes[1]),/yohkoh,/truncate)+' UT<br>'
times4php[2] = 'Transit time: ' +anytim(  file2time(suntimes[2]),/yohkoh,/truncate)+' UT'
times4php =transpose(times4php)

openw,100,'sitetime.txt'
printf,100,times4php
close,100


;***********Check whether email warning system is needed**********
email_warning,/do_check
;*****************************************************************

get_utc,ut
fin_time = anytim(ut,/yoh,/trun)
print,''
print,'system_status finsihed at '+fin_time
print,''

END