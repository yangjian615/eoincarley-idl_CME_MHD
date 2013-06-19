pro read_sept_data

; 19-June-2013 
; Plot up electron flux at STEREO B for 22-Sep-2011 event
loadct,0
!p.color=0
!p.background=255
;window,0

readcol, 'sept_behind_ele_sun_2011_265_1min_l2_v03.dat', juldat, year, doy, h, m, s, $
	e45, e55, e65, e75, e85, e105, e125, e145, e165, e195, e225, e255, e295, e335, e375 ;electron energies in keV
time_string = string(year, format='(I4)') + '0922_' + string(h, format='(I02)') + string(m, format='(I02)') + string(s, format='(I02)')

time = anytim(file2time(time_string), /utim)
t1 = anytim(file2time('20110922_100000'), /utim)
t2 = anytim(file2time('20110922_120000'), /utim)
energies = [45.0, 55.0, 65.0, 75.0, 85.0, 105.0, $
			125.0, 145.0, 165.0, 195.0, 225.0, 255.0,$
			295.0, 335.0, 375.0]
		
intens = dblarr(15, n_elements(e45))		
intens[0,*] = e45 
intens[1,*] = e55 
intens[2,*] = e65 
intens[3,*] = e75 
intens[4,*] = e85 
intens[5,*] = e105 
intens[6,*] = e125 
intens[7,*] = e145
intens[8,*] = e165
intens[9,*] = e195
intens[10,*] = e225
intens[11,*] = e255
intens[12,*] = e295
intens[13,*] = e335
intens[14,*] = e375


!p.font=0
set_plot, 'ps'
device, filename='impact_sept.ps', /helvetica, /color, /inches, /landscape, /encapsulate,$
xs=10, ys=10, bits_per_pixel=8, yoffset=10
!p.charthick=0.5

set_line_color
utplot, time, smooth(e45,2), /xs, /ys, /ylog, xr=[t1, t2], yr=[1e2, 1e5], thick=5, title='STEREO IMPACT SEPT Electron Flux', $
ytitle='electrons cm!U-2!N s!U-1!N sr!U-1!N MeV!U-1!N', color=0, xtitle='Start time: '+anytim(t1, /yoh, /trun)+' (UT)'


loadct,39
colors=0
FOR i=1, n_elements(intens[*,0])-1 DO BEGIN
	oplot, time, smooth(intens[i,*], 2), color=i*18, thick=5
	colors = [colors, i*18]
ENDFOR	

;window,1
;FOR i=0, n_elements(intens[0,*])-1 DO BEGIN
;	plot, energies, intens[*,i], /xlog, /ylog, yr=[10,1e6], xr=[40, 400], /xs, /ys, psym=6;
;	wait,0.05
;ENDFOR

;colors = reverse([150, 162, 175, 187, 200, 212, 224, 236, 248])
cgDCBar, reverse(colors), labels=reverse(round(energies)), color='black', position=[0.15, 0.6, 0.18, 0.95], $
charsize=1.0, /vertical, spacing=0.2, title=' ', tcharsize=1.0, /right
xyouts, 0.23, 0.775, 'Electron Energy (keV)', orientation=90, alignment=0.5, /normal, charsize=1.0

eta_typeIII = anytim(file2time('20110922_110352'), /utim)
vline, eta_typeIII, thick=4

;xyouts, 0.5, 0.8, 'ETA of SA type III electrons', orientation=90, /normal, charsize=1.0


device, /close
set_plot, 'x'

END