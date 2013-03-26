pro cme_velocity_20110922,select_points=SELECT_POINTS

cd,'/Users/eoincarley/Data/22sep2011_event/LASCO_C2/L0.5/L1'
files = findfile('*.fts')

IF keyword_set(select_points) THEN BEGIN
pre = lasco_readfits(files[0],he_pre)
loadct,1
window,0,xs=700,ys=700
cme_height_time = dblarr(2,3)

	FOR i = 4,6 DO BEGIN
		object = lasco_readfits(files[i],he)
		back_sub = object - pre
	
		rsun = get_solar_radius(he)
		pixrad=rsun/he.cdelt1
		sun = scc_SUN_CENTER(he)
		index = circle_mask(back_sub, sun.xcen, sun.ycen, 'le', pixrad*2.1)
		back_sub[index] = 0.0
		plot_image,bytscl(back_sub,-1.0e-11, 5.0e-12)
   	 	print,i
		tvcircle, (he.rsun/he.cdelt1), sun.xcen, sun.ycen, 254, color=250, thick=2
		wait,0.5
		print,'*******************'
		print,'  Choose Height    '
		print,'*******************'
	
		CURSOR,x,y,/data
	
		pixrad = he.rsun/he.cdelt1
		sun = scc_SUN_CENTER(he)
   		r1 = SQRT((x-sun.xcen)^2+(y-sun.ycen)^2)/pixrad
		plots,[x,sun.xcen],[y,sun.ycen],linestyle=0
    	cme_height_time[0,i-4] = anytim(he.date_obs,/utim)
    	cme_height_time[1,i-4] = r1

	ENDFOR    
save,cme_height_time,filename='cme_ht_c2_20110922.sav'
ENDIF


;**************Read in the data****************

cd,'/Users/eoincarley/Data/22sep2011_event/LASCO_C2/L0.5/L1'
restore,'cme_ht_c2_20110922.sav',/verb
c2_ht = cme_height_time
cd,'/Users/eoincarley/Data/22sep2011_event/LASCO_C3/L0.5/L1'
restore,'cme_ht_c3_20110922.sav',/verb
c3_ht = cme_height_time

cme_time = [transpose(c2_ht[0,*]), transpose(c3_ht[0,*])]
h2 = h2
cme_height = [transpose(c2_ht[1,*]), transpose(c3_ht[1,*])]

utplot,cme_time,cme_height,psym=1,charsize=2.0,ytitle='CME front height [R/R!Lsun!N]'
times = cme_time[*] - cme_time[0]

params = linfit(times, cme_height)

tim_sim = (dindgen(1001)*(times[n_elements(times)-1] - times[0])/1000.0 )+times[0]

y = params[0] + params[1]*tim_sim
oplot,tim_sim+cme_time[0],y

print,'CME velocity : '+string(params[1]*6.95e5)+' [km/s]'


stop
END