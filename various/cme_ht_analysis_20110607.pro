pro cme_ht_analysis_20110607

rsun = 6.955e5
n = 17.0 ; the circle will be "created" with 17 data points (vertices)
theta = findgen(n)/(n-1.0)*360.0*!DtoR ; 
x = 1.0*sin(theta)
y = 1.0*cos(theta)
usersym, x, y


cd,'/Users/eoincarley/Data/secchi_l1/20110607/cor1'
restore,'COR1_ht_20110607.sav'
cor1_ht = height_time

cd,'/Users/eoincarley/Data/secchi_l1/20110607/cor2'
restore,'COR2_ht_20110607.sav'
cor2_ht = height_time

cd,'/Users/eoincarley/Data/secchi_l1/20110607/cor2/doubles'
restore,'COR2_doubles_ht_20110607.sav'
cor2d_ht = height_time


time = [transpose(cor1_ht[0,*]), transpose(cor2_ht[0,*]), transpose(cor2d_ht[0,*])]
height = [transpose(cor1_ht[1,*]), transpose(cor2_ht[1,*]), transpose(cor2d_ht[1,*]) ]
errs = [transpose(cor1_ht[2,*]), transpose(cor2_ht[2,*]), transpose(cor2d_ht[2,*])]
time = time[0:n_elements(time)-2]
height = height[0:n_elements(height)-2]
errs = errs[0:n_elements(errs)-2]

set_plot,'ps'
device, filename = '20110607_CME_ht.ps',/color,bits=8,/inches, /landscape
!x.margin=[0,0]
!y.margin=[0,0]


loadct,39
!p.color=0
!p.background=255

a = anytim(file2time('20110607_062000'),/utim)
b = anytim(file2time('20110607_084000'),/utim)
sun = SUNSYMBOL()
;******   Original Plot
utplot, time, height, psym=6, charsize=1.0, ytitle='!6CME  Height (R!L'+sun+'!N)',$
/ys, yr=[0,24], symsize=1.0, yticks=4, ytickv = [0,5,10,15,20],yminor=5, $
xtitle='!6Time in UT on 2011 June 7',tick_unit=30.0*60.0, $
position=[0.55,0.55,1,1], /normal, /NOERASE, xr=[a,b], /xs

oploterr, time, height, errs*2, psym=6, symsize=1.0


;****** Fitting Routine *******
time_avg = time[*] - mean(time)
height_avg = height[*] - mean(height)
fit = linfit(time_avg, height_avg, measure_errors = errs*2.0, sigma = sigma )
time_sim = (dindgen(101)*( time_avg[n_elements(time_avg)-1] - time_avg[0])/100.0)+time_avg[0]
height_sim = fit[0] + fit[1]*time_sim
;***** Plot fit ******
oplot,time_sim+mean(time), height_sim + mean(height)
print,'CME velocity: ' +string(fit[1]*rsun, format='(f6.1)')+' +/- '$
+string(sigma[1]*rsun, format='(f4.1)')+' km/s'


;**********************************************
;	 De-Projected height and velocity


cd,'/Users/eoincarley/Data/secchi_l1/20110607/cor2'
files = findfile('*.fts')
data = sccreadfits(files[0],hdr)
hel_long = hdr.HGLN_OBS
act_reg = 53.0
POS_angle = act_reg - (hel_long - 90.0)
print,POS_ANGLE
deproj_h = height/COS(POS_ANGLE*!DTOR)
oplot,time,deproj_h,psym=8,symsize=1.0
oploterr, time, deproj_h, (errs*2)/COS(POS_ANGLE*!DTOR), psym=8,symsize=1.0

;**** Fitting Routine ****
height = deproj_h
time_avg = time[*] - mean(time)
height_avg = height[*] - mean(height)
fit_dp = linfit(time_avg, height_avg, measure_errors = (errs*2.0)/COS(POS_ANGLE*!DTOR), sigma = sigma_dp )
time_sim = (dindgen(101)*( time_avg[n_elements(time_avg)-1] - time_avg[0])/100.0)+time_avg[0]
height_sim = fit_dp[0] + fit_dp[1]*time_sim
;*** Plot fit *****
oplot,time_sim+mean(time), height_sim + mean(height), linestyle=5

print,'CME velocity: ' +string(fit_dp[1]*rsun, format='(f6.1)')+' +/- '$
+string(sigma[1]*rsun, format='(f4.1)')+' km/s'


vel1 = fit[1]*rsun
vel1 = round(vel1)

err1 = sigma[1]*rsun
err1 = round(err1)

vel2 = fit_dp[1]*rsun
vel2 = round(vel2)

err2 = sigma_dp[1]*rsun
err2 = round(err2)
plm = cgsymbol('+-')
;			Legend
legend,['!6POS', 'D-P',$
'Fit POS: '+' '+string(vel1, format='(I3)')+' '+plm+' ' $
+string(err1, format='(I2)')+' km s!U-1!N', $

'Fit D-P: '+string(vel2, format='(I4)')+' '+plm+' ' $
+string(err2, format='(I2)')+' km s!U-1!N'], $

linestyle=[0,0,0,5],psym=[6,8,0,0],charsize=1.0 , box=0
device,/close
set_plot,'x'

END