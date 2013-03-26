pro plot_masses_jason_other_masks, toggle = toggle

date = 'all'
folder = '/20100227-0305/C3/'+date								
cd,'~/Data/jason_catalogue'+folder
C = 1e15

IF keyword_set(toggle) THEN BEGIN
	set_plot,'ps'
	device,filename='compare_masks_c2c3.ps', /color, /inches, /encapsulate, $
	ysize=20, xsize=20
ENDIF


restore,'c2c3_massVtime_mask.sav'
mask_mass2 = mass_c2
mask_mass3 = mass_c3
restore,'c2c3_massVtime_NOmask.sav'
no_mask_mass2 = mass_c2
no_mask_mass3 = mass_c3
restore,'c2c3_massVtime_INVERTmask.sav'
inv_mask_mass2 = mass_c2
inv_mask_mass3 = mass_c3

mass_c2 = no_mask_mass2 - inv_mask_mass2
mass_c3 = no_mask_mass3 - inv_mask_mass3


set_line_color	   		  	   		  
!p.multi=[0,1,1]
utplot, t_c2, no_mask_mass2/C, xr=[tstart, tend], yr=[-10, 10], $;(max_mass + 0.5*max_mass)/C+0.5], $
/xs, /ys, ytitle='CME Mass x1e15 (g)' ,color=6, charsize=2.0, thick=6,$
	title='CME Mass v Time: Mask, No Mask, Inverse Mask (C2)', position=[0.07, 0.55, 0.95, 0.95],$
	/noerase, /normal
	;
	;position=[0.12, 0.68, 0.99, 0.99], xtickname=[' ',' ',' ',' ',' ', ' '],xtit=' '

;oplot, t_c2, mass_c2/C  , color=5, psym=1
;oplot, t_c3, mass_c3/C  < 6e15/C, psym=8, color=4
;oplot, t_c3, mass_c3/C, color=4, thick=6

oplot, t_c2, inv_mask_mass2/C, color=5, thick=6
;oplot, t_c3, mask_mass3/C, color=6, thick=6

legend,['No Mask','Inverse Mask'], linestyle=[0,0], charsize=2.0, box=0, color=[6,5]
;legend,['Mask', 'No Mask', 'Invert Mask'], linestyle=[0,0,0], color=[5,6,4], /right, box=0
;--------------------------------;
;
;--------------C3----------------;
;
;--------------------------------;

y = fltarr(n_elements(t_c2))
y[*] = 0.0
oplot,t_c2, y, linestyle=1
y[*] = -5 ;2.0
oplot,t_c2, y, linestyle=1
y[*] = 5 ;4.0
oplot,t_c2, y, linestyle=1

utplot, t_c3, no_mask_mass3/C, xr=[tstart, tend], yr=[-20, 20], $;(max_mass + 0.5*max_mass)/C+0.5], $
/xs, /ys, ytitle='CME Mass x1e15 (g)' ,color=6, charsize=2.0, thick=6,$
	title='CME Mass v Time: No Mask, Inverse Mask (C3)', position=[0.07, 0.07, 0.95, 0.45],$
	/noerase, /normal
	;
	;position=[0.12, 0.68, 0.99, 0.99], xtickname=[' ',' ',' ',' ',' ', ' '],xtit=' '

;oplot, t_c2, mass_c2/C  , color=5, psym=1
;oplot, t_c3, mass_c3/C  < 6e15/C, psym=8, color=4
;oplot, t_c3, mass_c3/C, color=4, thick=6

oplot, t_c3, inv_mask_mass3/C, color=5, thick=6
;oplot, t_c3, mask_mass3/C, color=6, thick=6
legend,['No Mask','Inverse Mask'], linestyle=[0,0], charsize=2.0, box=0, color=[6,5]
;legend,['Mask', 'No Mask', 'Invert Mask'], linestyle=[0,0,0], color=[5,6,4], /right, box=0


y = fltarr(n_elements(t_c2))
y[*] = 0.0
oplot,t_c2, y, linestyle=1
y[*] = -10 ;2.0
oplot,t_c2, y, linestyle=1
y[*] = 10 ;4.0
oplot,t_c2, y, linestyle=1


IF keyword_set(toggle) THEN BEGIN
	device,/close
	set_plot,'x'
ENDIF
stop
loadct,3
date = 'all'
folder = '/20100227-0305/C2/'+date								
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
	plot_image, img > (-2.0) <1.0, title=i
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