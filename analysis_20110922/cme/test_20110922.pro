pro test_20110922

cd,'/Users/eoincarley/Data/22sep2011_event/secchi/COR1/b/24540411/l1'

restore,'radius_angle_1stRun.sav'
times_sec = dblarr(n_elements(file_times))
velocities = dblarr(35)
angles = dblarr(35)
times_sec[*] = abs(file_times[0] - file_times[*] )
FOR i=0, 34 DO BEGIN 
	utplot,file_times,radius_angle[0,i,10:16]

	velocity = linfit(times_sec,radius_angle[0,i,10:16])
	velocities[i] = velocity[1]*6.955e5
	angles[i] = (i+1)*10.0
ENDFOR
stop
END