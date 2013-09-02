pro solar_alt_az

print,systim(/utc)      
FOR i=0, 60 DO BEGIN	
	juldate,[2013,08,29,16,59,i],jd
	print, i, jd
ENDFOR	

stop
jd=jd+2400000.                                                
sunpos,jd,ra,dec                                              
eq2hor, ra, dec, jd, alt, az, ha, LAT=53.344104, LON=-6.267494
print,alt,az                                                  



END