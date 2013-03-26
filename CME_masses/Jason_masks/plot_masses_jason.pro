pro plot_masses_jason, toggle = toggle

date = 'all'
folder = '/20100227-0305/C3/'+date								
cd,'~/Data/jason_catalogue'+folder
C = 1e15

IF keyword_set(toggle) THEN BEGIN
	set_plot,'ps'
	device,filename='test.ps', /color, /inches, /encapsulate, $
	ysize=20, xsize=20
ENDIF


restore,'c2c3_massVtime_mask.sav'
set_line_color	   		  	   		  

utplot, t_c2, mass_c2/C, xr=[tstart, tend], yr=[-2, 6], $;(max_mass + 0.5*max_mass)/C+0.5], $
/xs, /ys, ytitle='CME Mass x1e15 (g)' ,color=5, charsize=2.0, thick=6,$
	title='CME Mass v Time: Masks Applied', position=[0.07,0.55, 0.95, 0.95], /normal, /noerase
	;,$
	;position=[0.12, 0.68, 0.99, 0.99], xtickname=[' ',' ',' ',' ',' ', ' '],xtit=' '

;oplot, t_c2, mass_c2/C  , color=5, psym=1
;oplot, t_c3, mass_c3/C  < 6e15/C, psym=8, color=4
oplot, t_c3, mass_c3/C  < 6e15/C, color=4, thick=6
legend,['LASCO C2','LASCO C3'], psym=[1,8], charsize=2.0, box=0, color=[5,4]
;legend,['Mask', 'No Mask', 'Invert Mask'], linestyle=[0,0,0], color=[5,6,4], /right, box=0


y = fltarr(n_elements(t_c2))
y[*] = 0.0
oplot,t_c2, y, linestyle=1
y[*] = 2.0
oplot,t_c2, y, linestyle=1
y[*] = 4.0
oplot,t_c2, y, linestyle=1


restore,'c2c3_massVtime_mask.sav'

utplot, t_c2, mass_c2, xr=[tstart, tend], /ylog, yr=[1e13, 1e16],$;(max_mass + 0.5*max_mass)/C+0.5], $
/xs, /ys, ytitle='CME Mass (g)' ,color=5, charsize=2.0, thick=6,$
	title='CME Mass v Time: Masks Applied', position=[0.07,0.1, 0.95, 0.45], /normal, /noerase
	;,$
	;position=[0.12, 0.68, 0.99, 0.99], xtickname=[' ',' ',' ',' ',' ', ' '],xtit=' '

;oplot, t_c2, mass_c2/C  , color=5, psym=1
;oplot, t_c3, mass_c3/C  < 6e15/C, psym=8, color=4
oplot, t_c3, mass_c3, color=4, thick=6
legend,['LASCO C2','LASCO C3'], psym=[1,8], charsize=2.0, box=0, color=[5,4]
;legend,['Mask', 'No Mask', 'Invert Mask'], linestyle=[0,0,0], color=[5,6,4], /right, box=0


y = fltarr(n_elements(t_c2))
y[*] = 1e14;0.0
oplot,t_c2, y, linestyle=1
y[*] = 1e15;0.0
oplot,t_c2, y, linestyle=1
y[*] = 1e16;0.0
oplot,t_c2, y, linestyle=1



device,/close
set_plot,'x'
stop
loadct,3
date = 'all'
folder = '/20100227-0305/C3/'+date								
cd,'~/Data/jason_catalogue'+folder

files = findfile('*.fts')
pre = lasco_readfits(files[0], he_pre)

mask = lasco_get_mask(he_pre)

FOR i = 1, n_elements(files)-1 DO BEGIN
	data = lasco_readfits(files[i], he)
	pre = lasco_readfits(files[i-1], he_pre)
	img = data - pre
	img = img/stdev(img)
	img = img *mask
	plot_image, img > (-2.0) <1.0, title=he.date_obs
ENDFOR


;date = 'dets'
;;folder = '/20100227-0305/C3/'+date								
;cd,'~/Data/jason_catalogue'+folder

;files = findfile('*.sav')
;FOR i = 0, n_elements(files)-1 DO BEGIN
;	resote,files[i]
;	plot_image,
;ENDFOR



END