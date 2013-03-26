pro pdf_callisto_instr_paper

cd,'/Users/eoincarley/Data/CALLISTO/instrument_paper
radio_spectro_fits_read,'BIR_20110922_103000_01.fit',z,x,y
running_mean_background,z,back
zb=z-back

a = anytim(file2time('20110922_103800'),/utim)
b = anytim(file2time('20110922_134500'),/utim)

set_plot,'ps'
device,filename = 'callisto_instr_paper1.ps',/color,bits=8,/inches,/encapsulate,$
xsize=5,ysize=6,xoffset=1.0

spectro_plot,zb,x,y,/xs,/ys,charsize=1.5,ytitle='Frequency [MHz]'

;loadct,5
;!p.color=0
;!p.background=255
;stretch,255,0
;spectro_plot,zb,x,y,/xs,/ys,charsize=1.5,ytitle='Frequency [MHz]'

device,/close
set_plot,'x'

END