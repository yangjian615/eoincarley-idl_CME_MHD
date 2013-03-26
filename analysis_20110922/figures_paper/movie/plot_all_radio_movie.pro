pro plot_all_radio_movie, tline

; This is basically just a copy of of figure_dyn_spec_20110922 that goes into 
; the postscripts for the movie.

; Only the plot positions need be changed.

t1 = anytim(file2time('20110922_100000'),/utim)
t2 = anytim(file2time('20110922_120000'),/utim)


loadct,5
xleft=0.04
xright=0.22
!p.charsize=0.8
!y.ticklen=-0.01

;---------- SWAVES ------------
RESOLVE_ROUTINE, 'plot_swaves_movie'
plot_swaves_movie, t1, t2, xright, xleft, tline



;---------- NDA ---------------
RESOLVE_ROUTINE, 'plot_nda_movie'
plot_nda_movie, t1, t2, xright, xleft, tline

set_line_color
rect_x = anytim(file2time('20110922_103900'),/utim)
rectangle, rect_x, 8.0, 60.0*19.0, 180.0, thick=3, linestyle=0, color=0
rectangle, rect_x, 8.0, 60.0*19.0, 180.0, thick=3, linestyle=2, color=1

;---------- CALLISTO ------------ 
RESOLVE_ROUTINE, 'plot_callisto_movie'
plot_callisto_movie, t1, t2, xright, xleft, tline

draw_labels1, xright, xleft

;---------- CALLISTO ZOOMS ------------ 
xleft=0.5
xright=0.27
RESOLVE_ROUTINE, 'plot_callisto_zoom_movie'
plot_callisto_zoom_movie, t1, t2, xleft, xright, tline

xyouts, 0.245, 0.68, 'Frequency (MHz)', orientation=90, alignment=0.5, /normal
xyouts, 0.015, 0.534, 'Frequency (MHz)', orientation=90, alignment=0.5, /normal


draw_labels2, xright, xleft
draw_lines

END

pro draw_lines
set_line_color
plots, [0.126, 0.27], [0.43, 0.85], /normal,thick=3,linestyle=0,color=0;======[x1,x2],[y1,y2]=====
plots, [0.126, 0.27], [0.43, 0.85], /normal,thick=3,linestyle=2,color=1
plots, [0.126, 0.27], [0.288, 0.531], /normal,thick=3,linestyle=0,color=0;======[x1,x2],[y1,y2]=====
plots, [0.126, 0.27], [0.288, 0.531], /normal,thick=3,linestyle=2,color=1


plots, [0.423, 0.27], [0.70, 0.46], /normal,thick=3,linestyle=0,color=0;======[x1,x2],[y1,y2]=====
plots, [0.423, 0.27], [0.70, 0.46], /normal,thick=3,linestyle=2,color=1
plots, [0.442, 0.5], [0.7, 0.461], /normal,thick=3,linestyle=0,color=0;======[x1,x2],[y1,y2]=====
plots, [0.442, 0.5], [0.7, 0.461], /normal,thick=3,linestyle=2,color=1


END
pro draw_labels1, xright, xleft
set_line_color
xyouts,xright-0.005, 0.83, 'S/WAVES', /normal, color=1, align=1.0, charsize=0.7

xyouts,xright-0.005, 0.41, 'Nancay DA', /normal, color=1, align=1.0, charsize=0.7

xyouts,xright-0.005, 0.30, 'RSTO Callisto', /normal, color=1, align=1.0, charsize=0.7

END


pro draw_labels2, xleft, xright
set_line_color

xyouts,xright-0.005, 0.55, 'RSTO Callisto', /normal, color=1, align=1, charsize=0.7

xyouts,xright-0.005, 0.7, 'Nancay DA', /normal, color=1, align=1, charsize=0.7

xyouts,xleft+0.005, 0.26, 'RSTO Callisto', /normal, color=1, charsize=0.7


END


