	pro tvcon, Image, x_arg, y_arg, xstyle=xstyle, ystyle=ystyle, $
color=color, xticklen=xticklen, subtitle=subtitle,	$
yticklen=yticklen, xmargin=xmargin, ymargin=ymargin, title=title, $
xtitle=xtitle, ytitle=ytitle, xthick=xthick, ythick=ythick, $
noerase=noerase, background=background, scale=scale, $
charsize=charsize, position=position, xticks=xticks, yticks=yticks, $
xtickformat=xtickformat, ytickformat=ytickformat, $
xtickname=xtickname, ytickname=ytickname, $
xtickv=xtickv, ytickv=ytickv, xminor=xminor, yminor=yminor, $
xrange = xrange, yrange = yrange, $
xgridstyle=xgridstyle,ygridstyle=ygridstyle, sample = sample, $
fit_window = fit_window, resize = resize


;+
;  NAME:
; 	TVCON
;
;  PURPOSE:
; 	Displays an image in the brightness representation surrounded with coordinate axes to fit 
; 	current graphics device (TV + CONgrid). Similar to the standard routine 
; 	IMAGE_CONT, but without contours. Various keyword parameters added.
; 
;  CATEGORY:
; 	General graphics.
; 
;  CALLING SEQUENCE:
;  	TVCON, Image [, X_arg, Y_arg]
;    
;   INPUTS:
; 	Image: Array to be displayed. This array may be of any type.
; 
;  OPTIONAL INPUT PARAMETERS:
;	X_arg: 	Argument along X axis. If supplied, then Y_arg must be supplied also. 
;		The dimensions of X_arg, Y_arg must correspond to the dimensions of the Image. 
;		Usage of these arguments is the same as for the CONTOUR routine.
;
;	Y_arg:  Argument along Y axis. If supplied, then X_arg must be supplied also. The 
;		dimensions of X_arg, Y_arg must correspond to the dimensions of the Image.
; 
;  KEYWORD PARAMETERS:
; 	Scale: 	If set and equal to zero, then the array Image is displayed as is, without scaling 
; 		of brigthness (TV). Otherwise (by default), scaling is performed (TVSCL).
; 
;	Resize: Scalar integer or floating-point number specifying the number of pixels 
; 		to resize the Image when output to PostScript is performed. By default, 
;		the Image is not resized if its least dimension exceed 500, otherwise
;		its dimensions are resized in such a way that the least dimension becomes 500.
;		This enhances the quality of the image in the printout. 
;
;		If many images are sent to the PostScript file, then its size can become huge
;		when all of them are resized in such a way. To prevent this, set Resize to a 
;		less value.
;		
;	Fit_window: If set and nonzero, then the plotting region fits displayable area similar to
;		setting xmargin = [0,0] and ymargin = [0,0]
;
; 	Standard keywords: background charsize color noerase position subtitle title [xy]margin 
; 		[xy]minor [xy]style [xy]thick [xy]tickformat [xy]ticklen [xy]tickname
; 		[xy]ticks [xy]tickv [xy]title
; 
;  OUTPUTS:
; 	None.
;
;  COMMON BLOCKS:
; 	None.
;
;  SIDE EFFECTS:
; 	The array is displayed on the current graphics device.
;
;  RESTRICTIONS:
; 	If either of X_arg, Y_arg is supplied, then both of them must present. The dimensions of 
; 	X_arg, Y_arg must correspond to the dimensions of the Image.
; 
; 	The image always fits the displayable region of the graphics device, and the aspect ratio 
; 	is not maintained.
; 
;  PROCEDURE:
; 	TV(SCL) + CONGRID are used. In case of PostScript device, pixels of the Image are 
; 	scaled, instead of use the CONGRID routine.
; 
; MODIFICATION HISTORY:
;
;	ISTP SD RAS, 1999.
;	Victor Grechnev (grechnev@iszf.irk.ru): Initially written.
;
;	ISTP SD RAS, 2000, Jan.
;	Victor Grechnev (grechnev@iszf.irk.ru)
;	Keyword parameters FREQUENCY and PIXEL_SIZE added.
;
;	ISTP SD RAS, Jul, 2002.
;	Natalia Meshalkina (nata@iszf.irk.ru): Help added.
;-


Sz=size(Image)

if Sz(0) ne 2 then message, 'The argument must be 2-d array'


if n_elements(xstyle) le 0 then xstyle=!x.style
if n_elements(ystyle) le 0 then ystyle=!y.style
if n_elements(color) le 0 then color=!P.color
if n_elements(xticklen) le 0 then xticklen=!x.ticklen
if n_elements(yticklen) le 0 then yticklen=!y.ticklen
if n_elements(xmargin) le 0 then xmargin=!x.margin
if n_elements(ymargin) le 0 then ymargin=!y.margin
if n_elements(ytitle) le 0 then ytitle=!y.title
if n_elements(xtitle) le 0 then xtitle=!x.title
if n_elements(title) le 0 then title=!p.title
if n_elements(subtitle) le 0 then subtitle=!p.subtitle
if n_elements(xthick) le 0 then xthick=!x.thick
if n_elements(ythick) le 0 then ythick=!y.thick
if n_elements(noerase) le 0 then noerase=!p.noerase
if n_elements(background) le 0 then background=!p.background
if n_elements(scale) le 0 then scale=1
if n_elements(charsize) le 0 then charsize=!P.charsize
if n_elements(xticks) le 0 then xticks=!x.ticks
if n_elements(yticks) le 0 then yticks=!y.ticks
if n_elements(xtickv) le 0 then xtickv=!x.tickv
if n_elements(ytickv) le 0 then ytickv=!y.tickv
if n_elements(xtickformat) le 0 then xtickformat=!x.tickformat
if n_elements(ytickformat) le 0 then ytickformat=!y.tickformat
if n_elements(xtickname) le 0 then xtickname=!x.tickname
if n_elements(ytickname) le 0 then ytickname=!y.tickname
if n_elements(xminor) le 0 then xminor=!x.minor
if n_elements(yminor) le 0 then yminor=!y.minor
if n_elements(xgridstyle) le 0 then xgridstyle=0
if n_elements(ygridstyle) le 0 then ygridstyle=0
if n_elements(xrange) le 0 then xrange=!x.range
if n_elements(yrange) le 0 then yrange=!y.range

	if keyword_set(fit_window) then begin
xmargin = [0,0]
ymargin = [0,0]

	endif

Pmsave=!P.multi

N=Sz(1) > Sz(2) > 20

arguments=1

	if n_elements(x_arg) le 0 then begin
x_arg=findgen(N)/(N-1)*(Sz(1)-1)
arguments=0
	endif
if n_elements(y_arg) le 0 then y_arg=findgen(N)/(N-1)*(Sz(2)-1)


if n_elements(position) le 0 then $

	plot, x_arg, y_arg, xst=5,yst=5,/nodata,xmargin=xmargin,ymargin=ymargin,	$
noerase=noerase,charsize=charsize, xticks=xticks, yticks=yticks, $
xtickformat=xtickformat, ytickformat=ytickformat, $
background=background,xgridstyle=xgridstyle,ygridstyle=ygridstyle, $
xrange = xrange, yrange = yrange, $
xtickname=xtickname, ytickname=ytickname  else $
	plot, x_arg, y_arg, xst=5,yst=5,/nodata,xmargin=xmargin,ymargin=ymargin,	$
noerase=noerase,charsize=charsize, position=position, xticks=xticks, $
yticks=yticks, xtickformat=xtickformat, ytickformat=ytickformat, $
background=background,xgridstyle=xgridstyle,ygridstyle=ygridstyle, $
xrange = xrange, yrange = yrange, $
xtickname=xtickname, ytickname=ytickname
Pmsave1=!P.multi
!P.multi=Pmsave

int = 1-(keyword_set(sample))

SzN = Sz(1:2)


	if max(SzN/500.) lt 1 or n_elements(resize) gt 0 then begin
if n_elements(resize) le 0 then resize = 500.
if SzN(0) gt SzN(1) then SzN = SzN*float(resize(0))/SzN(0) else SzN = SzN*float(resize(0))/SzN(1)
	endif


if scale then begin


	if !d.name ne 'PS' then $
	tvscl, congrid(Image,	!d.x_size*(!x.window(1)-!x.window(0)),	$
				!d.y_size*(!y.window(1)-!y.window(0)), int=int, /minus),$
			!d.x_size*!x.window(0),!d.y_size*!y.window(0) else $

	tvscl, congrid(Image, SzN(0), SzN(1), int = int),	$
			xsize=!d.x_size*(!x.window(1)-!x.window(0)),	$
			ysize=!d.y_size*(!y.window(1)-!y.window(0)),	$,
			!d.x_size*!x.window(0),!d.y_size*!y.window(0),/dev

endif else begin

	if !d.name ne 'PS' then $
	tv, congrid(Image,	!d.x_size*(!x.window(1)-!x.window(0)),	$
				!d.y_size*(!y.window(1)-!y.window(0)), int=int, /minus),$
			!d.x_size*!x.window(0),!d.y_size*!y.window(0) else $

	tv, congrid(Image, SzN(0), SzN(1), int = int),	$
			xsize=!d.x_size*(!x.window(1)-!x.window(0)),	$
			ysize=!d.y_size*(!y.window(1)-!y.window(0)),	$,
			!d.x_size*!x.window(0),!d.y_size*!y.window(0),/dev

endelse


	CASE arguments OF

0:	begin

	IF n_elements(position) le 0 then $

	plot, x_arg, y_arg, xst=(1 or xstyle), yst=(1 or ystyle),	$
	/noerase, /nodata, color=color, xticklen=xticklen,		$
yticklen=yticklen, xmargin=xmargin,ymargin=ymargin, title=title, 	$
subtitle=subtitle, xtitle=xtitle, ytitle=ytitle, xthick=xthick,		$
charsize=charsize, xticks=xticks, yticks=yticks, ythick=ythick,		$
xtickformat=xtickformat, ytickformat=ytickformat,  			$
xtickname=xtickname, ytickname=ytickname,xgridstyle=xgridstyle,ygridstyle=ygridstyle, $
xrange = xrange, yrange = yrange, $
xtickv=xtickv, ytickv=ytickv, xminor=xminor, yminor=yminor else 				$

	plot, x_arg, y_arg, xst=(1 or xstyle), yst=(1 or ystyle),	$
/noerase, /nodata, color=color, xticklen=xticklen,			$
yticklen=yticklen, xmargin=xmargin, ymargin=ymargin, title=title, 	$
subtitle=subtitle, xtitle=xtitle, ytitle=ytitle, xthick=xthick,		$
charsize=charsize, xticks=xticks, yticks=yticks, ythick=ythick,		$
xtickformat=xtickformat, ytickformat=ytickformat, xtickname=xtickname, 	$
ytickname=ytickname, position=position,xgridstyle=xgridstyle,ygridstyle=ygridstyle,	$
xrange = xrange, yrange = yrange, $
xtickv=xtickv, ytickv=ytickv, xminor=xminor, yminor=yminor

	end

1:	begin

if n_elements(position) le 0 then $

	contour, Image, x_arg, y_arg, xst=(1 or xstyle), yst=(1 or ystyle), $
/noerase, xmargin=xmargin, ymargin=ymargin, title=title, /nodata, 	$
color=color, xticklen=xticklen, yticklen=yticklen, 			$
subtitle=subtitle, xtitle=xtitle, ytitle=ytitle, xthick=xthick,		$
charsize=charsize, xticks=xticks, ythick=ythick,			$
yticks=yticks, xtickformat=xtickformat, ytickformat=ytickformat,	$
xtickname=xtickname, ytickname=ytickname, $
xgridstyle=xgridstyle,ygridstyle=ygridstyle,$
xrange = xrange, yrange = yrange, $
xtickv=xtickv, ytickv=ytickv, xminor=xminor, yminor=yminor  else $

	contour, Image, x_arg, y_arg, xst=(1 or xstyle), yst=(1 or ystyle), $
/noerase, xmargin=xmargin, ymargin=ymargin, title=title, /nodata, 	$
color=color, xticklen=xticklen, yticklen=yticklen, 			$
subtitle=subtitle, xtitle=xtitle, ytitle=ytitle, xthick=xthick, 		$
charsize=charsize, xticks=xticks, ythick=ythick,  			$
yticks=yticks, xtickformat=xtickformat, ytickformat=ytickformat,	$
xtickname=xtickname, ytickname=ytickname, position=position, $
xgridstyle=xgridstyle,ygridstyle=ygridstyle,$
xrange = xrange, yrange = yrange, $
xtickv=xtickv, ytickv=ytickv, xminor=xminor, yminor=yminor

	end

	ENDCASE


!P.multi=Pmsave1


	end
