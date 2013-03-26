;+
; NAME:
;       gauss_2d
; CALLING SEQUENCE:
;       f=gauss_2d(n,r0,rmax=rmax, corner=corner)
; PURPOSE:
;       generates an nXn pixel array, which has the form
;       of a 2d gaussian with a width of r0 pixels, normalized
;       to a total of 1.0, unless the corner keyword is set
; INPUT:
;       n = array dimensions
;       r0 = width of gaussian in pixels
; KEYWORDS:
;       rmax = beyond rmax, set the function to 0.0
;       corner = if set, the maximum is at (0,0), the
;                default is to have the max at (n-1)/2
; OUTPUT:
;       f = the 2d gaussian
; HISTORY:
;       Written Apr 93, by JM
;       Added corner keyword, 8-9-95, jmm
;-
FUNCTION Gauss_2d, n, r0, rmax=rmax, corner=corner
   n2 = fix((n-1)/2) & r02 = r0^2
   IF(KEYWORD_SET(corner)) THEN x2 = findgen(n)^2 ELSE x2 = (findgen(n)-float(n2))^2
   y2 = x2
   r2 = fltarr(n, n)
   FOR j = 0, n-1 DO r2(*, j) = x2+y2(j)
   f = exp(-r2/r02)/(!Pi*r02)
   IF(KEYWORD_SET(rmax)) THEN BEGIN
      rmax2 = rmax^2
      jjj = where(r2 GT rmax2)
      IF(jjj(0) NE -1) THEN f(jjj) = 0.0
   ENDIF
   RETURN, f
END