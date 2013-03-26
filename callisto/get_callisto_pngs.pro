pro get_callisto_pngs

;To be run hourly o GRIAN
;Assumes that at the start of the day a directory /callisto/data/YYMMDD/png/high_freq/ is made
;assume root on GRIAN is the same as on BIRR

get_utc,ut
today = time2file(ut,/date)
url = 'http://www.rosseobservatory.ie'
path1='/callisto/data/realtime/png/high_freq/'
path2='/callisto/data/realtime/png/low_freq/'


cd,'/callisto/data/'+today+'/png/high_freq/'

  remote_pngs_high = sock_find(url,'*.png',path=path1)
  local_pngs = findfile('*.png')
  start_pos = where(remote_pngs_high eq local_pngs)
  
  IF start_pos eq -1 THEN BEGIN
  		sock_copy,remote_pngs_high
  ENDIF ELSE BEGIN
  		sock_copy,remote_pngs_high[start_pos[n_elements(start_pos)-1]:n_elements(remote_pngs_high)-1]
  ENDELSE
  
cd'/callisto/data/'+today+'/png/low_freq/'
 
  remote_pngs_low = sock_find(url,'*.png',path=path2)
  local_pngs = findfile('*.png')
  start_pos = where(remote_pngs_low eq local_pngs)
  
  IF start_pos eq -1 THEN BEGIN
  		sock_copy,remote_pngs_low
  ENDIF ELSE BEGIN
  		sock_copy,remote_pngs_low[start_pos[n_elements(start_pos)-1]:n_elements(remote_pngs_high)-1]
  ENDELSE
  
END  
  
  
  
