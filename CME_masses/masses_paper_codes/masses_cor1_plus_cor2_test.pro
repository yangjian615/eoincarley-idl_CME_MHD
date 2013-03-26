function add_masses,array1,array2,A=A,B=B

start_of_add = closest(array1[2,*], array2[2,0])

print,anytim(array1(2,start_of_add),/yoh)

q = size(array1)
q = q[2]
end_of_add = closest(array2[2,*], array1[2,q-1])

;add section here that replaces masses in array1 and array2 with the mean of the mass

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
    								 ;also the indices of h_manual that coinc_cor1height width error
    								 ;is to be added to    
ENDFOR

IF Keyword_set(A) THEN BEGIN 
	cor1_indices = cor1_indices[1:n_elements(cor1_indices)-1]
	save,cor1_indices,filename='cor1a_indices.sav'

	coincident_mass = array1[1,cor1_indices]
	pos = where(coincident_mass gt 0.0)
	coinc_cor1height = array1[0,cor1_indices]
	coinc_cor1height = coinc_cor1height[pos] ;Use these heights to calculate angular width
										 ;uncertainty for COR1
	save,coinc_cor1height,filename='coinc_cor1aheight.sav'

ENDIF
IF KEYWORD_SET(B) THEN BEGIN
	cor1_indices = cor1_indices[1:n_elements(cor1_indices)-1]
	save,cor1_indices,filename='cor1b_indices.sav'
	
	coincident_mass = array1[1,cor1_indices]
	pos = where(coincident_mass gt 0.0)
	coinc_cor1height = array1[0,cor1_indices]
	coinc_cor1height = coinc_cor1height[pos] ;Use these heights to calculate angular width
										 	 ;uncertainty for COR1
	save,coinc_cor1height,filename='coinc_cor1bheight.sav'
ENDIF


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
master1 = add_masses(cor1b,cor2b,/B);note heights in these arrays are uncorrected for projection effects
master2 = add_masses(cor1a,cor2a,/A);

save,master1,filename='COR1and2B_mass_height_time.sav'
save,master2,filename='COR1and2A_mass_height_time.sav'


indexB0 = where(master1(0,*) gt 0.0d)
indexB1 = where(master1(1,*) gt 0.0d)
indexA0 = where(master2(0,*) gt 0.0d)
indexA1 = where(master2(1,*) gt 0.0d)


;==================The following calculates the uncertainties=========================
;=====================Firstly it's angular width uncertainty=========================
;================COR2======================
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

;===========The angular width uncertainty for COR1 added to COR2==============

	restore,'coinc_cor1bheight.sav'
	coinc_cor1height = coinc_cor1height/COS(45*!DTOR)
	angles = 2*(26*coinc_cor1height^0.22)	
	cor1_ang_error = dblarr(n_elements(coinc_cor1height))

	FOR q=0,n_elements(coinc_cor1height)-1 DO BEGIN
		cor1_ang_error[q] = masses_width_error3(coinc_cor1height[q],angles[q])
	ENDFOR	
	restore,'cor1b_indices.sav'
	FOR q = 0,n_elements(coinc_cor1height)-1 DO BEGIN
		B_error[cor1_indices[0]+q] = $
		sqrt(B_error[cor1_indices[0]+q]^2 +cor1_ang_error[q]^2)
	ENDFOR

	restore,'coinc_cor1aheight.sav'
	coinc_cor1height = coinc_cor1height/COS(45*!DTOR)
	angles = 2*(26*coinc_cor1height^0.22)	
	cor1_ang_error = dblarr(n_elements(coinc_cor1height))

	FOR q=0,n_elements(coinc_cor1height)-1 DO BEGIN
		cor1_ang_error[q] = masses_width_error3(coinc_cor1height[q],angles[q])
	ENDFOR	

	restore,'cor1a_indices.sav'
	FOR q = 0,n_elements(coinc_cor1height)-1 DO BEGIN
		A_error[cor1_indices[0]+q] = $
		sqrt(A_error[cor1_indices[0]+q]^2 +cor1_ang_error[q]^2)
	ENDFOR
	;B_error_add = B_error_add + masses_width_error(coinc_cor1_height,angles)

	save,A_error,filename='A_mass_error_20081212.sav'	
	save,B_error,filename='B_mass_error_20081212.sav'

ENDIF ELSE BEGIN
	restore,'A_mass_error_20081212.sav'
	restore,'B_mass_error_20081212.sav'
ENDELSE
restore,'coinc_cor1aheight.sav'
restore,'cor1a_indices.sav'
;====================END angular width uncertainty============================	
;=============================================================================

;==================Standard error on the mean of various values=================
;============================Height values======================================
cd,'/Users/eoincarley/Data/secchi_l1/20081212/20081212_cor1/20081212_cor1a_B/mass_images'
restore,'COR1a_height_5runs.sav',/verb
cor1a_mean_height = fltarr(n_elements(height_array[0,*]))
FOR i=0,n_elements(cor1a_mean_height)-1 DO BEGIN 
	cor1a_mean_height[i]=mean(height_array[*,i])/COS(45.0*!DTOR)
ENDFOR
restore,'std_dev_height_error_cor1a.sav'
std_height_err_cor1a = fltarr(n_elements(std_dev_height_error_cor1a))
std_height_err_cor1a[*]=( std_dev_height_error_cor1a[*]/COS(45.0*!DTOR) )/sqrt(5.0)
	
cd,'/Users/eoincarley/Data/secchi_l1/20081212/20081212_cor2a/mass_images'
restore,'COR2a_height_5runs.sav',/verb
cor2a_mean_height = fltarr(n_elements(height_array[0,*]))
std_height_err_cor2a=fltarr(n_elements(height_array[0,*]))
FOR i=0,n_elements(cor2a_mean_height)-1 DO BEGIN 
	cor2a_mean_height[i]=mean(height_array[*,i])/COS(45.0*!DTOR)
	std_height_err_cor2a[i]=( stddev(height_array[*,i])/COS(45.0*!DTOR) )/sqrt(5.0)
ENDFOR

cd,'/Users/eoincarley/Data/secchi_l1/20081212/20081212_cor1/20081212_cor1b_B/mass_images'
restore,'COR1b_height_5runs.sav',/verb
cor1b_mean_height = fltarr(n_elements(height_array[0,*]))
std_height_err_cor1b = fltarr(n_elements(height_array[0,*]))
FOR i=0,n_elements(cor1b_mean_height)-1 DO BEGIN 
	cor1b_mean_height[i]=mean(height_array[*,i])/COS(45.0*!DTOR)
	std_height_err_cor1b[i]= ( stddev(height_array[*,i])/COS(45.0*!DTOR) )/sqrt(5.0)
ENDFOR

cd,'/Users/eoincarley/Data/secchi_l1/20081212/20081212_cor2b/mass_images'
restore,'COR2b_height_5runs.sav',/verb
cor2b_mean_height = fltarr(n_elements(height_array[0,*]))
std_height_err_cor2b=fltarr(n_elements(height_array[0,*]))
FOR i=0,n_elements(cor2b_mean_height)-1 DO BEGIN 
	cor2b_mean_height[i]=mean(height_array[*,i])/COS(45.0*!DTOR)
	std_height_err_cor2b[i]=( stddev(height_array[*,i])/COS(45.0*!DTOR) )/sqrt(5.0)
ENDFOR

    
corA_user_errors = add_errors_sig_corA()
corB_user_errors = add_errors_sig_corB()
   
    
;===================END standard error on mean calculations====================   
;=====================MSB to grams uncertainty=================================
    ;Add six percent because of conversion to grams from masb error. See Vourlidas 2010 ApJ 722
	mass_convert_error = dblarr(n_elements(master2(1,indexA1)))
	mass_convert_error[0:cor1_indices[0]-1]=0.06
	mass_convert_error[cor1_indices[0]:cor1_indices[0]+n_elements(coinc_cor1height)-1]=0.085 ;in this region the mass
               ;calculation comes from both cor1 and cor2, so the 6% error is added in quadrature
	mass_convert_error[cor1_indices[0]+n_elements(coinc_cor1height)-1:n_elements(mass_convert_error)-1]=0.06
	
;=========================Add all uncertainties together==========================	
streamer_mass = 7.0e14
A_error_pos = (A_error/100.0)*master2(1,indexA1)+streamer_mass+$
(mass_convert_error[*])*master2(1,indexA1)+corA_user_errors[1,*]

streamer_mass = 5.0e14
B_error_pos = (B_error/100.0)*master1(1,indexB1) +  streamer_mass + $
		(mass_convert_error)*master1(1,indexB1)+corB_user_errors[1,*]
		
A_error_neg	= (mass_convert_error[*])*master2(1,indexA1)+corA_user_errors[1,*]
B_error_neg = (mass_convert_error)*master1(1,indexB1)+corB_user_errors[1,*]

save,B_error_pos,filename='final_B_error.sav'
save,A_error_pos,filename='final_A_error.sav'

;====================END UNCERTAINTY CALCULATIONS==============================

;print,'Maximum posible error on B :'+string(max(B_error)+(max(corB_user_errors[1,*])/10.0^15.53)*100 + 6.0) 
;print,'Final mass B: '+string(master1[1,indexB1[n_elements(indexB1)-1]])+' +/- '+string(B_error[n_elements(B_error)-1])
;print,'Final mass A: '+string(master2[1,indexA1[n_elements(indexA1)-1]])+' +/- '+string(A_error[n_elements(A_error)-1])


cd,'/Users/eoincarley/Data/secchi_l1/20081212/COR1+COR2'

;=================Define device and start plot==================================
set_plot,'ps'
device,filename = '20081212_mass_ht_test.ps',/color,bits=8,/inches,/encapsulate,$
xsize=6.5,ysize=10,xoffset=-2.3


loadct,39
!p.color=0
!p.background=255
;!x.margin=[15,0]
a = anytim(file2time('20081212_040000'),/utim)
b = anytim(file2time('20081212_160000'),/utim)
start_time = anytim(file2time('20081212_040000'),/yoh,/trun)
!p.charsize=1.2


utplot,master1(0,indexB0),master1(1,indexB1),/ylog,/xs,psym=1,xr=[a,b],$
ytitle='!6CME Mass [g]',yr=[1e13,1e16],position = [0.11, 0.065, 0.92, 0.48],/normal,/noerase,tick_unit=14400,$
xtitle='Start Time ('+start_time+' UT)'
oploterror,master1(0,indexB0),master1(1,indexB1),B_error_pos,psym=1,/hibar
oploterror,master1(0,indexB0),master1(1,indexB1),B_error_neg,psym=1,/lobar
oplot,master2(0,indexA0),master2(1,indexA1),psym=4
oploterror,master2(0,indexA0),master2(1,indexA1),A_error_pos,psym=4,/hibar
oploterror,master2(0,indexA0),master2(1,indexA1),A_error_neg,psym=4,/lobar
legend,['STEREO A','STEREO B','COR2 B CME front','COR2 B CME core'],psym=[4,1,7,6],color=[0,0,254,40],$
box=0,charsize=1,position=[0.12,0.47],/norm

;=========Read in and plot core and font masses==============
IF keyword_set(plotcore_front) THEN BEGIN
	cd,'/Users/eoincarley/Data/secchi_l1/20081212/20081212_cor2b/mass_images'
	restore,'COR2B_frontmass_time.sav'
	front = mass_array;
	restore,'COR2B_coremass_time.sav'
	core = mass_array
	oplot,front[0,3:n_elements(front[0,*])-1],front[1,3:n_elements(front[0,*])-1],psym=7,color=254
	oplot,core[0,3:n_elements(core[0,*])-1],core[1,3:n_elements(core[0,*])-1],psym=6,color=40
	
	front_err_pos = (front[1,*]*0.10) +streamer_mass + 0.08*front[1,*]  ;10% for unknown angular width + 6% for conv from msb to g error
	core_err_pos = (front[1,*]*0.10)  +streamer_mass + 0.08*core[1,*]           ; plus the sig error
	front_err_neg = 0.08*front[1,*]  ;6% from msb to g error, 2% from use sig errors
	core_err_neg =  0.08*core[1,*]  
	
	
	oploterror,front[0,3:n_elements(front[0,*])-1],front[1,3:n_elements(front[0,*])-1],front_err_pos,psym=7,color=254,/hibar
	oploterror,core[0,3:n_elements(core[0,*])-1],core[1,3:n_elements(core[0,*])-1],core_err_pos,psym=6,color=40,/hibar
	oploterror,front[0,3:n_elements(front[0,*])-1],front[1,3:n_elements(front[0,*])-1],front_err_neg,psym=7,color=254,/lobar
	oploterror,core[0,3:n_elements(core[0,*])-1],core[1,3:n_elements(core[0,*])-1],core_err_neg,psym=6,color=40,/lobar
cd,'/Users/eoincarley/Data/secchi_l1/20081212/COR1+COR2'
ENDIF
;===============================================================


indexB2 = where(master1(2,*) gt 0.0)
indexB1 = where(master1(1,*) gt 0.0)
indexA2 = where(master2(2,*) gt 0.0)
indexA1 = where(master2(1,*) gt 0.0)

;===============================================================
;==========================Plot Mass vs. Height======================================
;===============================================================

corB_mass = master1[1,*]
zeros = where(corB_mass eq 0.0)
remove,zeros,corB_mass

corB_height = master1[2,*]/COS(45*!DTOR)
zeros = where(corB_height eq 0.0)
remove,zeros,corB_height

corA_mass = master2[1,*]
zeros = where(corA_mass eq 0.0)
remove,zeros,corA_mass

corA_height = master2[2,*]/COS(45*!DTOR)
zeros = where(corA_height eq 0.0)
remove,zeros,corA_height
restore,'cor1a_indices.sav'

	meanAheight=fltarr(n_elements(corA_height)+2)
	meanAheight[0:cor1_indices[0]]=cor1a_mean_height[0:cor1_indices[0]]
	meanAheight[cor1_indices[0]+1:n_elements(meanAheight)-1]=cor2a_mean_height[0:n_elements(cor2a_mean_height)-2]
	
	std_height_errA=fltarr(n_elements(corA_height)+2)
	std_height_errA[0:cor1_indices[0]]=std_height_err_cor1a[0:cor1_indices[0]]
	std_height_errA[cor1_indices[0]+1:n_elements(std_height_errA)-1]=std_height_err_cor2a[0:n_elements(std_height_err_cor2a)-2]
restore,'cor1b_indices.sav'
	meanBheight=fltarr(n_elements(corB_height)+2)
	meanBheight[0:cor1_indices[0]]=cor1b_mean_height[0:cor1_indices[0]]
	meanBheight[cor1_indices[0]+1:n_elements(meanBheight)-1]=cor2b_mean_height[0:n_elements(cor2b_mean_height)-4]
	
	std_height_errB=fltarr(n_elements(corB_height)+2)
	std_height_errB[0:cor1_indices[0]]=std_height_err_cor1b[0:cor1_indices[0]]
	std_height_errB[cor1_indices[0]+1:n_elements(std_height_errB)-1]=std_height_err_cor2b[0:n_elements(std_height_err_cor2b)-4]


sun = sunsymbol()
;plot,corb_height,corB_mass,/ylog,yr=[1e13,1e16],psym=1,$
plot,meanBheight,corB_mass,/ylog,yr=[1e13,1e16],psym=1,$

xtitle='CME Apex Height [R/R!L'+sun+'!N]',ytitle='CME Mass [g]',xticks=9,xminor=2,xr=[2,20],/xs,$
xtickv=[2,4,6,8,10,12,14,16,18,20],position=[0.11, 0.56, 0.92, 0.98],/normal,/noerase
oploterror,meanBheight,corB_mass,std_height_errB,B_error_pos,psym=1,/hibar
oploterror,meanBheight,corB_mass,std_height_errB,B_error_neg,psym=1,/lobar

oplot,meanAheight,corA_mass,psym=4
oploterror,meanAheight,corA_mass,std_height_errA,A_error_pos,psym=4,/hibar
oploterror,meanAheight,corA_mass,std_height_errA,A_error_neg,psym=4,/lobar
legend,['STEREO A','STEREO B'],psym=[4,1],box=0,charsize=1

xyouts,0.85,0.45,'(b)',/normal,charsize=1.2
xyouts,0.85,0.95,'(a)',/normal,charsize=1.2

fit_mass_curve_cor2b,/plotting


device,/close
set_plot,'x'
END
  
