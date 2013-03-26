pro figure_dyn_spec_20110922, toggle=toggle

; This is an update on Figure1_20110922_paper_v. Had to include Nancay data and Waves data.
; Written on Jan 14th 2013

t1 = anytim(file2time('20110922_100000'),/utim)
t2 = anytim(file2time('20110922_120000'),/utim)

loadct,5
cd,'/Users/eoincarley/Data/22sep2011_event/WAVES'


IF keyword_set(toggle) THEN BEGIN
	set_plot,'ps'
	!p.font=0
	device,filename = 'figure_dyn_spec_20110922.ps',$
	/color, /inches, /encapsulate, $
	ysize=10, xsize=12, bits_per_pixel=8, xoffset=0, yoffset=0, /helvetica
ENDIF ELSE BEGIN
	window, xs=1200, ys=1000
ENDELSE
xleft=0.05
xright=0.5
!y.ticklen=-0.01
!p.charsize=1.0


;---------- SWAVES ------------
RESOLVE_ROUTINE, 'plot_swaves'
plot_swaves, t1, t2, xright, xleft

;---------- NDA ---------------
;t1 = anytim(file2time('20110922_103000'),/utim)
;t2 = anytim(file2time('20110922_111000'),/utim)
RESOLVE_ROUTINE, 'plot_nda'
plot_nda, t1, t2, xright, xleft

set_line_color
rect_x = anytim(file2time('20110922_103900'),/utim)
rectangle, rect_x, 8.0, 60.0*19.0, 180.0, thick=3, linestyle=0, color=0
rectangle, rect_x, 8.0, 60.0*19.0, 180.0, thick=3, linestyle=2, color=1


;---------- CALLISTO ------------ 
RESOLVE_ROUTINE, 'plot_callisto'
plot_callisto, t1, t2, xright, xleft

set_line_color
xyouts,xright-0.01, 0.88, 'S/WAVES', /normal, color=0, align=1.0, charthick=4
xyouts,xright-0.01, 0.88, 'S/WAVES', /normal, color=1, align=1.0

xyouts,xright-0.01, 0.43, 'Nancay DA', /normal, color=0, align=1.0, charthick=4
xyouts,xright-0.01, 0.43, 'Nancay DA', /normal, color=1, align=1.0

xyouts,xright-0.01, 0.30, 'RSTO Callisto', /normal, color=0, align=1.0, charthick=4
xyouts,xright-0.01, 0.30, 'RSTO Callisto', /normal, color=1, align=1.0


xyouts,0.09, 0.515, 'SA Type III', /normal, color=0, charthick=4
xyouts,0.09, 0.515, 'SA Type III', /normal, color=1, charthick=1

arrow, 0.16, 0.52, 0.19, 0.52, color=1, /normal, thick=4, hthick=0.2, hsize=1.1,/solid

;------------ CALLISTO Zooms -------------
t1 = anytim(file2time('20110922_104700'),/utim)
t2 = anytim(file2time('20110922_105600'),/utim)
xleft=0.57
xright=0.97
RESOLVE_ROUTINE, 'plot_callisto_zoom'
plot_callisto_zoom, t1, t2, xright, xleft


;---------------------------------------;
;           Labels and Lines 			;
;---------------------------------------;
set_line_color
xyouts,xright-0.01,0.54, 'RSTO Callisto', /normal, color=0, align=1, charthick=4
xyouts,xright-0.01,0.54, 'RSTO Callisto', /normal, color=1, align=1


xyouts,xleft+0.01,0.29, 'RSTO Callisto', /normal, color=0, charthick=4
xyouts,xleft+0.01,0.29, 'RSTO Callisto', /normal, color=1

xyouts,xright-0.01, 0.72, 'Nancay DA', /normal, color=0, align=1, charthick=4
xyouts,xright-0.01, 0.72, 'Nancay DA', /normal, color=1, align=1

plots,[0.2675, xleft], [0.45, 0.88], /normal,thick=3,linestyle=0,color=0;======[x1,x2],[y1,y2]=====
plots,[0.2675, xleft], [0.45, 0.88], /normal,thick=3,linestyle=2,color=1
plots,[0.2675, xleft], [0.281, 0.531], /normal,thick=3,linestyle=0,color=0;======[x1,x2],[y1,y2]=====
plots,[0.2675, xleft], [0.281, 0.531], /normal,thick=3,linestyle=2,color=1

hb_box_y = 0.724
plots,[xright, 0.865], [0.481, hb_box_y], /normal,thick=3,linestyle=0,color=0;======[x1,x2],[y1,y2]=====
plots,[xright, 0.865], [0.481, hb_box_y], /normal,thick=3,linestyle=2,color=1
plots,[xleft, 0.83], [0.48, hb_box_y], /normal,thick=3,linestyle=0,color=0;======[x1,x2],[y1,y2]=====
plots,[xleft, 0.83], [0.48, hb_box_y], /normal,thick=3,linestyle=2,color=1

xyouts, 0.6383, 0.699, 'Type II', /normal, color=0, charthick=4
xyouts, 0.6383, 0.699, 'Type II', /normal, color=1
arrow, 0.62, 0.75, 0.65, 0.71, color=1, /normal, thick=4, hthick=0.2, hsize=1.1, /solid

xyouts, 0.61, 0.901, 'SA Type III', /normal, color=0, charthick=10
;xyouts, 0.61, 0.901, 'SA Type III', /normal, color=1, charthick=0.1

arrow, 0.63, 0.899, 0.6, 0.868, color=0, /normal, thick=4, hthick=0.2, hsize=1.1, /solid
arrow, 0.63, 0.899, 0.6, 0.868, color=1, /normal, thick=1, hthick=0.2, hsize=1.1, /solid

xyouts, 0.055,  0.881, 'a', /normal, color=1
xyouts, 0.572,  0.861, 'b', /normal, color=1
xyouts, 0.575,  0.459, 'c', /normal, color=1
xyouts, 0.014,  0.539, 'Frequency (MHz)', /normal, color=0, alignment=0.5, orientation=90.0
xyouts, 0.530,  0.695, 'Frequency (MHz)', /normal, color=0, alignment=0.5, orientation=90.0

IF keyword_set(toggle) THEN BEGIN
	device,/close
	set_plot,'x'
ENDIF
END
