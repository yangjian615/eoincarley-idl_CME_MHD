function add_masses,array1,array2

start_of_add = closest(array1[2,*], array2[2,0])

print,anytim(array1(2,start_of_add),/yoh)

q = size(array1)
q = q[2]
end_of_add = closest(array2[2,*], array1[2,q-1])


elements = start_of_add + q
master_array = dblarr(3,elements)

master_array[1,0:start_of_add-1]=array1[1,0:start_of_add-1]
master_array[0,0:start_of_add-1]=array1[2,0:start_of_add-1]
master_array[2,0:start_of_add-1]=array1[0,0:start_of_add-1]
cor1_indices=[0]

FOR i=0, end_of_add DO BEGIN

    index = closest(array1[2,*], array2[2,i])
    master_array[1,index] = array1[1,index]+array2[1,i]
    master_array[0,index] = array2[2,i] ;the COR2 times
    master_array[2,index] = array2[0,i] ;the COR2 heights
    
    cor1_indices=[cor1_indices,index];the indices of the COR1 data that are added to COR2 
    
ENDFOR

return,master_array
END

pro masses_cor1_plus_cor2_test,master1,master2,calc_error=calc_error,plotcore_front=plotcore_front

cd,'/Users/eoincarley/Data/secchi_l1/20081212/COR1+COR2'

restore,'COR1Bmass_height_time.sav',/verb
cor1b = mass_array
restore,'COR2B_mht_above4dot5rsun.sav',/verb
cor2b = mass_array
restore,'COR1Amass_height_time.sav',/verb
cor1a = mass_array
restore,'COR2A_mht_above4dot37rsun.sav',/verb
cor2a = mass_array
cor1a[1,1]=1.0d


;restore,'COR1Bmht_below3.1.sav',/verb
;cor1b = mass_array
;restore,'COR2B_mht.sav',/verb
;cor2b = mass_array
;restore,'COR1Amht_below2.6.sav',/verb
;cor1a = mass_array
;restore,'COR2Amass_height_time.sav',/verb
;cor2a = mass_array


;=====negative values need to be zerod in the cor1 arrays=======

temporary_mass = cor1b[1,*]
neg=where(temporary_mass lt 0.0)
temporary_mass[neg] =0.0
cor1b[1,*]=temporary_mass[*]

temporary_mass = cor1a[1,*]
neg=where(temporary_mass lt 0.0)
temporary_mass[neg] =0.0
cor1a[1,*]=temporary_mass[*]

;===============================================================
master1 = add_masses(cor1b,cor2b);note heights in these arrays are uncorrected for projection effects
master2 = add_masses(cor1a,cor2a);

save,master1,filename='COR1and2B_mass_height_time.sav'
save,master2,filename='COR1and2A_mass_height_time.sav'

;loadct,39
;!p.color=0
;!p.background=255
;window,20,xs=1000,ys=500
;!p.multi=[0,2,1]

indexB0 = where(master1(0,*) gt 0.0d)
indexB1 = where(master1(1,*) gt 0.0d)
indexA0 = where(master2(0,*) gt 0.0d)
indexA1 = where(master2(1,*) gt 0.0d)

;===============Code is working perfectly on 23-Aug-2011======================
;===============If it stops working remove the following======================
IF keyword_set(calc_error) THEN BEGIN
h_manual = master2[2,*] 
zeros = where(h_manual eq 0.0)
remove,zeros,h_manual
h_manual = h_manual/COS(45*!DTOR)
save,h_manual,filename='STR_A_manual_h.sav'

h_manualB = master1[2,*] 
zeros = where(h_manualB eq 0.0)
remove,zeros,h_manualB
h_manualB = h_manualB/COS(45*!DTOR)
save,h_manualB,filename='STR_B_manual_h.sav'

restore,'STR_A_manual_h.sav',/verb
restore,'STR_B_manual_h.sav',/verb

angles = 2*(26*h_manual^0.22) ;times 2 to estimate the upper limit to the error
							  ;assumption is that angular width along LOS is no           
							  ;more that 2 times the latitudinal angular width 
	A_error = dblarr(n_elements(h_manual))						  
	FOR q=0,n_elements(h_manual)-1 DO BEGIN								  
		A_error[q] = masses_width_error3(h_manual[q],angles[q])
	ENDFOR
	
angles = 2*(26*h_manualB^0.22)	
	B_error = dblarr(n_elements(h_manualB))						  
	FOR q=0,n_elements(h_manualB)-1 DO BEGIN								  
		B_error[q] = masses_width_error3(h_manualB[q],angles[q])
	ENDFOR
	A_error = A_error ;these errors are based on the heights of COR2, need width of COR1 added on also
	B_error = B_error
save,A_error,filename='A_mass_error_20081212.sav'	
save,B_error,filename='B_mass_error_20081212.sav'
	
	
ENDIF ELSE BEGIN
;=============================================================================	

restore,'A_mass_error_20081212.sav'
restore,'B_mass_error_20081212.sav'
ENDELSE


set_plot,'ps'
device,filename = '20081212_mass_ht.ps',/color,bits=8,/inches,/encapsulate,$
xsize=6,ysize=10,xoffset=1


streamer_mass = 4.5e13

loadct,39
!p.color=0
!p.background=255
;!x.margin=[15,0]
a = anytim(file2time('20081212_040000'),/utim)
b = anytim(file2time('20081212_160000'),/utim)
start_time = anytim(file2time('20081212_040000'),/yoh,/trun)


corA_user_errors = add_errors_sig_corA()
corB_user_errors = add_errors_sig_corB()

print,'Maximum posible error on B :'+string(max(B_error)+(max(corB_user_errors[1,*])/10.0^15.53)*100 + 6.0) 
A_error = (A_error/100.0)*master2(1,indexA1) + streamer_mass + (0.06)*master2(1,indexA1)+corA_user_errors[1,*]
B_error = (B_error/100.0)*master1(1,indexB1) + streamer_mass + (0.06)*master1(1,indexB1)+corB_user_errors[1,*]
save,B_error,filename='final_B_error.sav'
save,A_error,filename='final_A_error.sav'

stop


; Add six percent because of conversion to grams from masb error. See Vourlidas 2010 ApJ 722
print,'Final mass B: '+string(master1[1,indexB1[n_elements(indexB1)-1]])+' +/- '+string(B_error[n_elements(B_error)-1])
print,'Final mass A: '+string(master2[1,indexA1[n_elements(indexA1)-1]])+' +/- '+string(A_error[n_elements(A_error)-1])



utplot,master1(0,indexB0),master1(1,indexB1),/ylog,charsize=1.5,/xs,psym=1,xr=[a,b],$
ytitle='!6CME Mass [g]',yr=[1e13,1e16],position = [0.15, 0.065, 0.94, 0.48],/normal,/noerase,tick_unit=14400,$
xtitle='Start Time ('+start_time+' UT)'
oploterror,master1(0,indexB0),master1(1,indexB1),B_error,psym=1
oplot,master2(0,indexA0),master2(1,indexA1),psym=4
oploterror,master2(0,indexA0),master2(1,indexA1),A_error,psym=4
legend,['STEREO A','STEREO B','COR2 B CME front','COR2 B CME core'],psym=[4,1,7,6],color=[0,0,254,40],$
box=0,charsize=1
stop
;=========Read in and plot core and font masses==============
IF keyword_set(plotcore_front) THEN BEGIN
cd,'/Users/eoincarley/Data/secchi_l1/20081212/20081212_cor2b/mass_images'
restore,'COR2B_frontmass_time.sav'
front = mass_array;
restore,'COR2B_coremass_time.sav'
core = mass_array


oplot,front[0,3:n_elements(front[0,*])-1],front[1,3:n_elements(front[0,*])-1],psym=7,color=254
oplot,core[0,3:n_elements(core[0,*])-1],core[1,3:n_elements(core[0,*])-1],psym=6,color=40
front_err = (front[1,*]*0.16) +streamer_mass;10% for unknown angular width + 6% for conv from msb to g error
core_err = (front[1,*]*0.16)  +streamer_mass ; plus the sig error
oploterror,front[0,3:n_elements(front[0,*])-1],front[1,3:n_elements(front[0,*])-1],front_err,psym=7,color=254
oploterror,core[0,3:n_elements(core[0,*])-1],core[1,3:n_elements(core[0,*])-1],core_err,psym=6,color=40
;===============================================================
cd,'/Users/eoincarley/Data/secchi_l1/20081212/COR1+COR2'
ENDIF

indexB2 = where(master1(2,*) gt 0.0)
indexB1 = where(master1(1,*) gt 0.0)
indexA2 = where(master2(2,*) gt 0.0)
indexA1 = where(master2(1,*) gt 0.0)

sun = sunsymbol()
plot,master1(2,indexB2)/COS(45*!DTOR),master1(1,indexB1),/ylog,yr=[1e13,1e16],charsize=1.5,psym=1,$
xtitle='CME Apex Height [R/R!L'+sun+'!N]',ytitle='CME Mass [g]',xticks=5,xminor=4,xr=[2,22],/xs,$
position=[0.15, 0.56, 0.94, 0.98],/normal,/noerase
oploterror,master1(2,indexB2)/COS(45*!DTOR),master1(1,indexB1),B_error,psym=1

oplot,master2(2,indexB2)/COS(45*!DTOR),master2(1,indexB1),psym=4
oploterror,master2(2,indexB2)/COS(45*!DTOR),master2(1,indexB1),A_error,psym=4
legend,['STEREO A','STEREO B'],psym=[4,1],box=0,charsize=1
;x2png,'Both_masses.png'

fit_mass_curve_cor2b,/plotting

xyouts,0.87,0.45,'(b)',/normal,charsize=1.5
xyouts,0.87,0.95,'(a)',/normal,charsize=1.5

readcol, 'kins_meanspread.txt', mid_a, mid_r, top_a, top_r, bottom_a, bottom_r, midtop_a, midtop_r, mibottom_a, midbottom_r, time, $
       f='D,D,D,D,D,D,D,D,D,D,A'
       
       utbasedata = anytim(time[0])
       t = anytim(time) - utbasedata
       rsun = 6.95508e8
       mid_km = mid_r * rsun / 1000.0d
       mid_vel = deriv(t, mid_km)


master_array = master1      
times1 = anytim(time,/utim)  
index = closest(times1(*), master_array(0,0))
index_stop = closest(master_array(0,*), times1[n_elements(times1)-1])

momentum=0
times3 = 0

FOR i = 0, index_stop DO BEGIN
     index = closest(times1[*], master_array(0,i))
     IF abs(master_array(0,i) - times1[index]) lt 600 THEN BEGIN
     momentum = [momentum,(master_array[1,i])*mid_vel[index]*1e6]
     times3 = [times3,master_array(0,i)]
     ENDIF
ENDFOR

momentum_time1 = fltarr(2,n_elements(momentum))
momentum_time1[0,*] = times3[*]
momentum_time1[1,*] = momentum[*]

index1B = where(momentum_time1(0,*) gt 0.0)
index2B = where(momentum_time1(1,*) gt 0.0)
;============================================================
master_array = master2     
times1 = anytim(time,/utim)  
index = closest(times1(*), master_array(0,0))
index_stop = closest(master_array(0,*), times1[n_elements(times1)-1])

momentum=0
times3 = 0

FOR i = 0, index_stop DO BEGIN
     index = closest(times1[*], master_array(0,i))
     IF abs(master_array(0,i) - times1[index]) lt 600 THEN BEGIN
     momentum = [momentum,(master_array[1,i])*mid_vel[index]*1e6]
     times3 = [times3,master_array(0,i)]
     ENDIF
ENDFOR

momentum_time2 = fltarr(2,n_elements(momentum))
momentum_time2[0,*] = times3[*]
momentum_time2[1,*] = momentum[*]

index1A = where(momentum_time2(0,*) gt 0.0)
index2A = where(momentum_time2(1,*) gt 0.0)

;window,10,xs=1300,ys=500
;!p.multi=[0,3,1]
a = anytim(file2time('20081212_060000'),/utim)
b = anytim(file2time('20081212_150000'),/utim)
print,anytim(time,/yoh)

ut = anytim(time,/utim)
print,ut

;utplot,ut,mid_vel,charsize=3,ytitle='CME velocity (km/s)',title='2008/12/12/ CME velocity',$
;psym=1,/xs,/ys,xr=[a,b]
;oplot,ut,mid_vel,linestyle=1

;utplot,momentum_time1(0,index1B),momentum_time1(1,index2B),/ylog,psym=1,charsize=3,xr=[a,b],$
;ytitle='CME Momentum (g cm/s)',/ys,/xs,title='2008/12/12 CME momentum'
;oplot,momentum_time1(0,index1B),momentum_time1(1,index2B),linestyle=1
;oplot,momentum_time2(0,index1A),momentum_time2(1,index2A),psym=5
;oplot,momentum_time2(0,index1A),momentum_time2(1,index2A),linestyle=2
;legend,['STEREO A', 'STEREO B'],linestyle=[1,2],psym=[1,5],charsize=1.5,box=0,/bottom,/right



;utplot,momentum_time1(0,index1B),deriv(momentum_time1(0,index1B),momentum_time1(1,index2B)),xr=[a,b],$
;/ylog,psym=1,charsize=3,ytitle='Force (dyn)',/xs,/ys,yr=[1e18,1e20],title='Force (dp/dt) vs. Time'
;oplot,momentum_time1(0,index1B),deriv(momentum_time1(0,index1B),momentum_time1(1,index2B)),linestyle=1
;oplot,momentum_time2(0,index1A),deriv(momentum_time2(0,index1A),momentum_time2(1,index2A)),psym=5
;oplot,momentum_time2(0,index1A),deriv(momentum_time2(0,index1A),momentum_time2(1,index2A)),linestyle=2
;legend,['STEREO A', 'STEREO B'],linestyle=[1,2],psym=[1,5],charsize=1.5,box=0,/bottom,/right
;x2png,'vel_mom_for.png'
;print,mean(abs(deriv(momentum_time1(0,index1B),momentum_time1(1,index2B))))

device,/close
set_plot,'x'
END
  
