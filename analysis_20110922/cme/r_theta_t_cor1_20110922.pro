pro r_theta_t_cor1_20110922

cd,'/Users/eoincarley/Data/22sep2011_event/secchi/COR1/b/24540411/l1
restore,'cor1_20110922_r_theta_t.sav'
cor1_data = r_theta_t



t1 = anytim(file2time('20110922_105000'),/utim)
t2 = anytim(file2time('20110922_114000'),/utim)




utplot,cor1_data[0,0,*],cor1_data[1,0,*],psym=6,charsize=1.5,$
		ytitle='Heliocentric Distance [R/R!Lsun!N]',xr=[t1,t2],yr=[1,5],/xs
oplot,cor1_data[0,0,*],cor1_data[1,0,*]
times = dblarr(n_elements(cor1_data[0,0,*]))
times[*] = abs(transpose(cor1_data[0,0,0] - cor1_data[0,0,*]))
result = linfit(times[*], cor1_data[1,0,*])

velocity = result[1]*6.955e5
legend,[string(cor1_data[2,0,0],format='(f5.1)')+' deg: '+string(velocity,format='(f6.1)')+' km s!U-1!N'],$
linestyle=[0], color=[0], charsize=1.4, box=0,position=[0.60,0.93],/normal
vel_all = velocity
loadct,39
FOR i =1,18 DO BEGIN
	inc=0.02
	oplot,cor1_data[0,i,*],cor1_data[1,i,*],psym=6;,color=i*17
	oplot,cor1_data[0,i,*],cor1_data[1,i,*],color=i*17

	result = linfit(times[*], cor1_data[1,i,*])
    
	velocity = result[1]*6.955e5
	legend,[string(cor1_data[2,i,0],format='(f5.1)')+' deg: '+string(velocity,format='(f6.1)')+' km s!U-1!N'],$
	linestyle=[0], color=[i*17], charsize=1.4, box=0,position=[0.60,0.93-(inc*i)],/normal

    vel_all = [vel_all,velocity]
ENDFOR

new_angles = acos(cos( (cor1_data[2,*,0]-90.0+360)*!DTOR))
;window,1,xs=600,ys=600
wset,1
plot,vel_all,(cor1_data[2,*,0]+90.0)*!DTOR, xsty=4,YSTY=4, /POLAR ,psym=6,xr=[-1500.0,1500.0],$
yr=[-1500.0,1500.0],xticks=4,symsize=1.5

AXIS, 0, 0, XAX=0, charsize=1.5
; Draw the x and y axes through (0, 0):  
AXIS, 0, 0, YAX=0, charsize=1.5
oplot,vel_all,(cor1_data[2,*,0]+90.0)*!DTOR,/POLAR,thick=3
xyouts,0.55,0.63,'500 km/s',/normal,color=250,charsize=1.3
xyouts,0.55,0.76,'1000 km/s',/normal,color=250,charsize=1.3
xyouts,0.55,0.87,'1500 km/s',/normal,color=250,charsize=1.3
;dataMax = Max(vel_all)
    a = Circle(0, 0, 500.0);0.25*dataMax)
    b = Circle(0, 0, 400.0);0.75*dataMax)
    c = Circle(0, 0, 1000.0);0.75*dataMax)
    d = Circle(0, 0, 1500.0);0.75*dataMax)
    ;e = Circle(0, 0, 1500.0);0.75*dataMax)
    ;e = Circle(0, 0, 1400.0);0.75*dataMax)
    cgPlotS, a, Color='red'
    ;cgPlotS, b, Color='red'
	cgPlotS, c, Color='red'
	cgPlotS, d, Color='red'
	;cgPlotS, e, Color='red'
	;cgPlotS, b, Color='red'
	
x2png,'cme_cor1_velocity_polar.png'	

END