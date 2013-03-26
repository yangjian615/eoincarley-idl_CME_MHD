pro move_all_pngs

;to be run once off to move all pngs to grian

cd,'/Volumes/rsto/Sites/callisto/data'
url='http://www.rosseobservatory.ie'
master_directory='/callisto/data/'

root = sock_find(url,'*',path=master_directory)
year = strarr(n_elements(root))


FOR i=206, n_elements(root)-1 DO BEGIN
year[i] = strsplit(root[i],'http://www.rosseobservatory.ie/callisto/data/',/extract,/regex)
year[i] = strsplit(year[i],'/',/extract)
   
    remote_directory=strsplit(root[i],'http://www.rosseobservatory.ie',/extract,/regex)
    folders = sock_find(url,'*',path=remote_directory)
    check = url+remote_directory+'png/'
    exists = where(folders eq check[0])
    
    
    If exists ne -1 THEN BEGIN
 
    	png_directory =remote_directory+'png/'
    	folders = sock_find(url,'*',path=png_directory)
    	check = url+png_directory+'high_freq/'
    	exists = where(folders eq check[0])
    	If exists eq -1 THEN BEGIN
    	   spawn,'mkdir '+year[i]
    	   cd,year[i]
    	   spawn,'mkdir png'
    	   cd,'png'
    	   
    	   sock_copy,folders
    	ENDIF ELSE BEGIN
    	 hi_png_directory = png_directory+'high_freq'
		 pngs_hi = sock_find(url,'*.png',path=hi_png_directory)
		 spawn,'mkdir '+year[i]
		 cd,year[i];locally
		 spawn,'mkdir png'
    	 cd,'png'
		 spawn,'mkdir high_freq'
		 cd,'high_freq'
		 sock_copy,pngs_hi,/verbose ;into local directory
		ENDELSE 
         check = url+png_directory+'low_freq/'
         exists = where(folders eq check[0])
			If exists ne -1 THEN BEGIN
				lo_png_directory =png_directory+'low_freq/'
				pngs_low = sock_find(url,'*.png',path=lo_png_directory)
				cd,'..;locally
		 		spawn,'mkdir low_freq'
		 		cd,'low_freq'
		 		sock_copy,pngs_low,/verbose ;into local directory
			ENDIF	
	ENDIF
cd,'/Volumes/rsto/Sites/callisto/data'

ENDFOR	
	
END	