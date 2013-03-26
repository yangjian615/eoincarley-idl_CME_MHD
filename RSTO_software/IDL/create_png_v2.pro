pro create_png_v2

;
;
;	Name: create_png_v2.pro
;	
;	Purpose: 
;		-Make PNGs from latest fits folders in the archive (version 2)
;
;	Input parameters:
;		-None
;
;	Keywords:
;		-None
;
;	Ouputs:
;		-PNG files of latest fits folders saved in the fits archive. They are shifted to a fits archive by 
;		 umbrella routine that runs this code e.g. callisto_hourly_batch.pro run by callisto_hourly.bat
;		
;	Calling sequence:
;		- create_png_v2
;
;   Last modified:
;		- 10-Nov-2011 (E.Carley) Force correct axes display on each spectra.
;
;   Recommended Updates:
;		- Start plotting in z buffer to make things run faster (see v3 of this code; currently not working)
;		- To do list: The code is a bit of a mess of FOR and IF statements, it could do with being 
;		  made more efficient
;


get_utc,YMD
YMD=time2file(YMD,/date)
today_minusi = YMD

FOR q=0,2 DO BEGIN

  IF q eq 0 THEN folder='high_freq' ;Probably more efficient way of doing this but works for now...
   
  IF q eq 1 THEN folder='low_freq'

  IF q eq 2 THEN folder='mid_freq'

  cd,'C:\Inetpub\wwwroot\callisto\data\realtime\fts\'+folder
    list_fits = findfile('*.fit')
    latest_fits_time = anytim(file2time(list_fits[n_elements(list_fits)-1]),/utim)
    fits_times = anytim(file2time(list_fits),/utim)
  cd,'C:\Inetpub\wwwroot\callisto\data\realtime\png\'+folder
    list_pngs = findfile('BIR*.png')
    latest_png_time = anytim(file2time(list_pngs[n_elements(list_pngs)-1]),/utim)
    png_times = anytim(file2time(list_pngs),/utim)

  ;Check to see if new fits have been created
  IF latest_fits_time gt latest_png_time THEN BEGIN
      starting_point = where(fits_times gt png_times[n_elements(png_times)-1])
  ENDIF  

    cd,'C:\Inetpub\wwwroot\callisto\data\realtime\fts\'+folder
    set_plot,'ps'
    ;device,filename = 'single_png.ps',/color,/inches,/landscape,/encapsulate,$
    ;yoffset=8,ysize=6,xsize=8
    
    
  IF starting_point[0] ne -1 THEN BEGIN ;Does not run if no new fits have been created
     starting_point = starting_point[0]
     list = list_fits
     backg = make_daily_background()
     
    
      FOR j=starting_point ,n_elements(list)-1 DO BEGIN
        
        device,filename = 'single_png.ps',/color,/inches,/landscape,/encapsulate,$
        yoffset=8,ysize=6,xsize=8
        radio_spectro_fits_read,list[j],z,x,y
        z = z - backg
        
        newName = strjoin( strsplit(list[j],'fit', /regex,/extract,/preserve_null),'png')
        start_time = anytim(x[0],/yoh,/trun)
        loadct,5
        IF q eq 2 THEN BEGIN
        spectro_plot,bytscl(z,mean(z)-1.5*stdev(z),mean(z)+6.0*stdev(z)),x,y,$
        /xs,/ys,ytitle='Frequency (MHz)',yr=[200,100],$
        title='eCallisto (Birr Castle, Ireland)',xtitle='Start Time ('+$
        start_time+' UT)', position=[0.1,0.11,0.9,0.9],/normal
        ENDIF
        IF q eq 1 THEN BEGIN
        spectro_plot,bytscl(z,mean(z)-1.5*stdev(z),mean(z)+6.0*stdev(z)),x,y,$
        /xs,/ys,ytitle='Frequency (MHz)',yr=[100,10],ytickv=[100,80,60,40,20,10],yticks=5,yminor=4,$
        title='eCallisto (Birr Castle, Ireland)',xtitle='Start Time ('+$
        start_time+' UT)', position=[0.1,0.11,0.9,0.9],/normal
        ENDIF 
        IF q eq 0 THEN BEGIN
        spectro_plot,bytscl(z,mean(z)-1.5*stdev(z),mean(z)+6.0*stdev(z)),x,y,$
        /xs,/ys,ytitle='Frequency (MHz)',$
        title='eCallisto (Birr Castle, Ireland)',xtitle='Start Time ('+$
        start_time+' UT)', position=[0.1,0.11,0.9,0.9],/normal
        ENDIF
        
        spawn,'convert -rotate "-90" single_png.ps '+newName
        device,/close
        spawn,'del C:\Inetpub\wwwroot\callisto\data\realtime\fts\high_freq\single_png.ps /q'
        ;set_plot,'win'
        
      ENDFOR
      
  ENDIF
ENDFOR

cd,'C:\Inetpub\wwwroot\callisto\data\realtime\fts\mid_freq'
spawn,'del C:\Inetpub\wwwroot\callisto\data\realtime\fts\mid_freq\single_png.ps /q'
cd,'C:\Inetpub\wwwroot\callisto\data\realtime\fts\low_freq'
spawn,'del C:\Inetpub\wwwroot\callisto\data\realtime\fts\low_freq\single_png.ps /q'
;device,/close
set_plot,'win'

END