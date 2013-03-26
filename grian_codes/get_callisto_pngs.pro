function get_rsto_files,savedir,freq=freq,sunrise=sunrise,sunset=sunset,url=url,date=date,listurls=listurls
if ~keyword_set(date) then date='realtime'
;==========================Get high frequency files============================= 
     savedir = savedir+freq
     spawn,'mkdir -p '+savedir

	   ; cd,'~/Sites/callisto/data/realtime/png/high_freq' ;or whichever directory the realtime pngs are in on grian
		grian_hi_pngs = findfile(savedir+'/BIR*.png')
	
		IF n_elements(grian_hi_pngs) gt 0 THEN BEGIN
			latest_hi_grian = grian_hi_pngs[n_elements(grian_hi_pngs)-1]
			latest_hi_time = anytim(file2time(latest_hi_grian),/utime) ;latest file time locally

			remote_directory='/callisto/data/'+date+'/png/'+freq
			files = sock_find(url,'*BIR*.png',path=remote_directory) 
			file_times_birr = dblarr(n_elements(files))
		
			FOR i=0, n_elements(files)-1 do begin
				file_times_birr[i] = anytim(file2time(strsplit(files[i],'http://www.rosseobservatory.ie',/extract,/regex)),/utime)
			ENDFOR
			latest_time_birr = file_times_birr[n_elements(file_times_birr)-1] ;latest file time remotely
			
			sunrise_file_pos = where(file_times_birr gt sunrise)
			sunset_file_pos = where(file_times_birr lt sunset)

			IF latest_hi_time lt sunrise THEN start_index = sunrise_file_pos $
			ELSE start_index = where(file_times_birr gt latest_hi_time)
			IF latest_hi_time lt latest_time_birr and start_index[0] ne -1 THEN BEGIN
				openw,lun,urllist,/get_lun	
				printf, lun, files[start_index[0]:sunset_file_pos[n_elements(sunset_file_pos)-1]]
				close,lun
				spawn,'wget -f '+listurls+' -P '+savedir
			;sock_copy,files[start_index[0]:sunset_file_pos[n_elements(sunset_file_pos)-1]],/verb,/loud
			ENDIF
         ENDIF
         print,'done'
       
		;Download the hourly files
        summaries = sock_find(url,'*c*c*.png',path=remote_directory)
		openw,lun,urllist,/get_lun	
		printf, lun, summaries
		close,lun
		spawn,'wget -f '+listurls+' -P '+savedir
         ;sock_copy,summaries,/verb,/loud
         return,1

end


pro get_callisto_pngs

; To be run every hour on grian

url='www.rosseobservatory.ie'
listurls='~/urls2download'
rootdir = '~/Sites/callisto/data/'

sock_ping,'86.47.107.67',server_ready
IF server_ready THEN BEGIN


;============================Get sunrise,sunset and current times=======================
   
  
  



  get_utc,ut
  today = time2file(ut,/date)
  cd,'/Volumes/rsto/Sites/callisto/logs'
  logs_directory='/sunrise_sunset/'
  files = sock_find(url,'*.txt',path=logs_directory)
  sock_copy,files,/verb,/oud
  openr,100,'suntimes.txt'
  suntimes = strarr(3)
  readf,100,suntimes
  close,100
  sunrise = anytim(file2time(today+'_'+StrMid(suntimes[0],10)),/utim)
  sunset= anytim(file2time(today+'_'+StrMid(suntimes[1],9)),/utim)
  current_time = anytim(file2time(time2file(ut)),/utim)
  stop
  
  IF current_time gt anytim(file2time(today+'_000000'),/utim) and $
  current_time lt anytim(file2time(today+'_010000'),/utim) THEN BEGIN
     get_utc,ut
     ;time = anytim(ut,/ex)
     ;yyyy=string(time[6])
     ;mm = string(time[5],format='(I2.2)')
     ;dd = string(time[4],format='(I2.2)')
     datedir=anytim(ut,/ecs,/date_only) 
     savedir = rootdir+datedir+'/png/'
     ;cd,'/Volumes/rsto/Sites/callisto/data/'
     spawn,'mkdir -p '+savedir
  ENDIF  
     
  
	IF current_time gt sunrise and current_time lt sunset THEN BEGIN

    	a = get_rsto_files(savedir,freq='high_freq',sunrise=sunrise,sunset=sunset,url=url,listurls=listurls)    
    	a = get_rsto_files(savedir,freq='low_freq',sunrise=sunrise,sunset=sunset,url=url,listurls=listurls)    
	
	ENDIF	;end if statement checking current time is between sunset and sunrise
	
	
	
ENDIF ; end if statement checking RSTO server is online 

;Delete files from realtime after 23:00 every night
;del_tim = anytim(file2time(today+'_230000'),/utim)
;IF current_time gt del_tim THEN BEGIN
;spawn,'rm BIR*'+today+'*.png'
;cd,'/Volumes/rsto/Sites/callisto/data/realtime/png/high_freq'
;spawn,'rm BIR*'+today+'*.png'
;ENDIF

END