pro nda_polarization
loadct,5
t1 = anytim(file2time('20110922_103500'), /utim)
t2 = anytim(file2time('20110922_111000'), /utim)

restore,'NDA_20110922_1015_left.sav', /verb
spec1l = spectro_l
tim1l = tim_l 
restore,'NDA_20110922_1045_left.sav', /verb
spec2l = spectro_l
tim2l = tim_l

specl = [spec1l, spec2l]
timl = [tim1l, tim2l]



restore,'NDA_20110922_1015_right.sav', /verb
spec1r = spectro_r
tim1r = tim_r 
restore,'NDA_20110922_1045_right.sav', /verb
spec2r = spectro_r
tim2r = tim_r 

specr = [spec1r, spec2r]
timr = [tim1r, tim2r]

device, retain=2
window,0
spectro_plot, constbacksub(specl, /auto), timl, freq, /xs, /ys, title='LHCP', xr=[t1,t2],$
ytitle='Frequency (MHz)'
x2png,'LHCP'
window,1
spectro_plot, constbacksub(specr, /auto), timr, freq, /xs, /ys, title='RHCP', xr=[t1,t2],$
ytitle='Frequency (MHz)'
x2png,'RHCP'

l_lc = average(constbacksub(specl, /auto),2)
r_lc = average(constbacksub(specr, /auto),2)


r_lc = r_lc + 20
l_lc = l_lc +20

window,2
utplot, timl, l_lc, /xs, /ys, xr=[t1,t2]

set_line_color
oplot,  timr, r_lc, color=3




window,3
utplot, timl, ((l_lc - r_lc)/(l_lc + r_lc))*100.0, /xs, /ys, xr=[t1,t2],$
ytitle='Percent Polarization'
x2png,'Percent_Pol'

stop

END