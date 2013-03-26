pro ACE_sw_data

cd,'/Users/eoincarley/Data/CALLISTO/20110607/ACE_data'

readcol,'201106_ace_swepam_1h.txt',yyyy,mm,dd,hrmm,mjd,sod,S,dens,speed,temp,format='A,A,A,A,A,D,D,D,D,D'

time_string = strarr(n_elements(yyyy))
time_string[*] = yyyy[*]+mm[*]+dd[*]+'_'+hrmm[*]+'00'
times = anytim(file2time(time_string),/utim)

loadct,3

set_plot,'ps'
device,filename = 'ace_solwind.eps',/color,/inches,/encapsulate,ysize=6,xsize=4.5,yoffset=7


tstart = anytim(file2time('20110606_000000'),/utim)
tend = anytim(file2time('20110611_000000'),/utim)

pos1 = 0.15
pos3 = 0.935
smooth_param=10.0
;************** Proton Density **************
utplot,times,dens,/ys,ytitle='Protons cm!U-3!N',yr=[0.0,20.0],color=140,$
/xs, xtitle=' ',xticks=5,xtickname=[' ',' ',' ',' ',' ',' '],xr=[tstart,tend],$
position=[pos1, 0.71, pos3, 0.98],/normal,/noerase
draw_constants,0.0,20.0

;************** SW Speed **************
utplot,times,speed,/ys,ytitle='Sol Wind Speed [km s!U-1!N]',yr=[330.0,600.0],color=140,$
/xs, xtitle=' ',xticks=5,xtickname=[' ',' ',' ',' ',' ',' '],xr=[tstart,tend],$
position=[pos1, 0.41, pos3, 0.70],/normal,/noerase
draw_constants,100.0,1000.0

;************** Ion Temperature **************
utplot,times,temp,/ys,/ylog,ytitle='Ion Temperature [K]',yr=[1.0e4,1.0e6],color=140,$
/xs,xticks=5,xr=[tstart,tend],xtitle='Start Time: ('+anytim(tstart,/yoh,/trun)+') UT',$
position=[pos1, 0.11, pos3, 0.40],/normal,/noerase
draw_constants,1.0e4,1.0e6


device,/close
set_plot,'x'

END

pro draw_constants,starts,ends

B_range=(dindgen(100)*(ends-starts)/99.0)-starts
tim_a = dblarr(n_elements(b_range))
tim_a[*] = anytim(file2time('20110607_000000'),/utim)
tim_b = dblarr(n_elements(b_range))
tim_b[*] = anytim(file2time('20110608_000000'),/utim)
tim_c = dblarr(n_elements(b_range))
tim_c[*] = anytim(file2time('20110609_000000'),/utim)
tim_d = dblarr(n_elements(b_range))
tim_d[*] = anytim(file2time('20110610_000000'),/utim)

oplot,tim_a,B_range,linestyle=1
oplot,tim_b,B_range,linestyle=1
oplot,tim_c,B_range,linestyle=1
oplot,tim_d,B_range,linestyle=1


END
