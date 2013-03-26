pro testing10

cd,'/Users/eoincarley/Data/22sep2011_event/LASCO_C2/polarized_brightness'

restore,'pborig.sav',/verb
restore,'pbmod.sav',/verb

FOR i=0, n_elements(pborig)-1 DO BEGIN
  IF pborig[i] eq pbmod[i] THEN BEGIN
    print,'ok'
  ENDIF ELSE BEGIN
    print,'no'
  ENDELSE  
ENDFOR

END