	pro timeprof, Array, device=device, data=data, $
		logarithmic=log, ynozero = ynozero

;+
; NAME:
; 	TIMEPROF
; 
; PURPOSE:
; 	Interactively plot profile of a 3-dimensional array along the
; 	third dimension through the pixel where the cursor is currently
; 	placed. The profile is displayed in a separate window.
; 
; CATEGORY:
; 	Image analysis.
;
; CALLING SEQUENCE:
; 	TIMEPROF, Array
;
; INPUTS:
; 	Array:	The array to be analyzed.  This array may be of any type.
;
; OPTIONAL INPUT PARAMETERS:
; 	None
;
; KEYWORD PARAMETERS:
; 	DATA:   If set and non-zero, DATA coordinate system is processed.
;
; 	DEVICE: If set and non-zero, DEVICE coordinate system is processed (by default).
;
; 	LOGARITHMIC: If set and non-zero, Y axis is of logarithmic type.
;
; 	YNOZERO: If set and non-zero, prevents setting the minimum Y axis value to zero.
; 
; OUTPUTS:
; 	None.
;
; COMMON BLOCKS:
; 	None.
;
; SIDE EFFECTS:
; 	New window is created and used for the profile. When done, the new window 
; 	is deleted. The X and Y of the pixel under the cursor are continuously displayed.
;
; RESTRICTIONS:
; 	None.
;
; PROCEDURE:
; 	Press the right mouse button to exit the procedure.
;
; MODIFICATION HISTORY:
;
;	ISTP SD RAS, 1999.
;	Victor Grechnev (grechnev@iszf.irk.ru): Initially written.
;
;	ISTP SD RAS, Jul, 2002.
;	Natalia Meshalkina (nata@iszf.irk.ru): Help added.
;-


Sz=size(Array)

orig_win=!d.window
X_orig = !X
Y_orig = !Y

wset,orig_win

tvcrs,Sz(1)/2,Sz(2)/2,/dev

window,/free

new_win=!d.window

amax=max(Array, min=amin)

	if keyword_set(log) then begin
if amax le 0 then amax = amax > 1
if amin le 0 then amin = amin > 1
	endif

	old_font=!p.font
	!p.font = 0


vecx = findgen(Sz(3))

	old_data=' '

while 1 do begin
        wset,orig_win		;Image window

!X = X_orig
!Y = Y_orig


if keyword_set(data) then cursor,x,y,2,/data else $
	cursor,x,y,2,/dev	;Read position


first=1

        wset,new_win

plot,[0, Sz(3)-1],[amax, amin],/nodata,title='Time Profile', ytype= $
	keyword_set(log), ynozero = keyword_set(ynozero), $
	col = !d.table_size-1

prof=Array(x > 0 < (Sz(1)-1), y > 0 < (Sz(2)-1), *)


 if !err eq 4 then begin         ;Quit
	wset,orig_win
	tvcrs,Sz(1)/2, Sz(2)/2,/dev    ;curs to old window
	tvcrs,0                 ;Invisible
	wdelete, new_win
	!p.font = old_font

	!X = X_orig
	!Y = Y_orig
print,x,y
	return
	endif

if first eq 0 then plots, vecx, prof, col=0 else first=0

plots, vecx, prof, $
	col = !d.table_size-1

Yout = (Xout=3)

aa = string(x > 0 < (Sz(1)-1), y > 0 < (Sz(2)-1), format = '(i6, i6)')

xyouts, Xout, Yout, old_data, /dev, font=0, col=!p.background
xyouts, Xout, Yout, aa, /dev, font=0, col = !d.table_size-1

old_data=aa

endwhile

	end
