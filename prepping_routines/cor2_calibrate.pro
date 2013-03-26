function cor2_calibrate, im, hdr, calfac_off=calfac_off, bias_off=bias_off, $
    	    	    exptime_off=exptime_off, calimg_off=calimg_off, sebip_off=sebip_off, $
		    silent=silent,_EXTRA=ex
		    
; This is an attempt to fit a background subtraction into cor_calibrate
; similar to what's done in cor1_calibrate (E. Carley 2012-Sep-18)
		    
;+
; $Id: cor_calibrate.pro,v 1.14 2007/09/25 16:23:14 thompson Exp $
;
; Project   : STEREO SECCHI
;                   
; Name      : cor_calibrate
;               
; Purpose   : This function returns calibrated images.
;               
; Explanation: The default calibration procedure involves; subtracting
;        the CCD bias, multiplying by the calibration factor and vignetting
;        function, and dividing by the exposure time. Any of these operations
;        can turned off using the keywords. 
;               
; Use       : IDL> cal_image = cor_calibrate(image,hdr)
;    
; Inputs    : image - level 0.5 image in DN (long)
;             hdr -image header, either fits or SECCHI structure
;
; Outputs   :  cal_image - image convert from  DN (long) to physical
;                          units (float)
;
; Keywords  :calfac_off - set to return image without calibration
;                         factor applied
;            bias_off - set to return image without bias subtraction applied
;            exptime_off - set to return image without exposure time normalized
;            calimg_off - set to return image without vignetting
;                        (flat-field) correction 
;            sebip_off - set to return image without SEB IP correction
;                        applied
;
; Common    : 
;
; Calls     : SCC_FITSHDR2STRUCT, SCC_SEBIP, GET_EXPTIME,
;             GET_BIASMEAN, GET_CALFAC, GET_CALIMG, RATIO, SCC_UPDATE_HISTORY
;               
; Category    : Calibration
;               
; Prev. Hist. : None.
;
; Written     : Robin C Colaninno NRL/GMU July 2006
;               
; $Log: cor_calibrate.pro,v $
; Revision 1.14  2007/09/25 16:23:14  thompson
; Put _EXTRA back in GET_EXPTIME call
;
; Revision 1.13  2007/09/25 16:14:23  thompson
; Removed _EXTRA from get_exptime call
;
; Revision 1.12  2007/09/24 21:29:46  nathan
; Add _EXTRA to subpro calls to propagate /SILENT
;
; Revision 1.11  2007/08/24 19:26:34  nathan
; updated info messages and hdr history
;
; Revision 1.10  2007/08/23 23:57:20  nathan
; added info messages
;
; Revision 1.9  2007/05/21 20:16:06  colaninn
; added silent keyword
;
; Revision 1.8  2007/03/12 21:56:03  nathan
; update version handling in history
;
; Revision 1.7  2007/02/02 15:23:13  colaninn
; added scc_update_history.pro
;
; Revision 1.6  2007/01/31 22:03:05  nathan
; update message; set hdr.OFFSETCR
;
; Revision 1.5  2006/12/06 20:08:43  colaninn
; added RATIO to avoid division errors
;
; Revision 1.4  2006/12/05 21:04:57  colaninn
; corrected hdr.summed code
;
; Revision 1.3  2006/11/27 19:54:49  colaninn
; cor/cor_calibrate.pro
;
; Revision 1.2  2006/11/21 22:14:49  colaninn
; made updates for Beta 2
;
; Revision 1.1  2006/10/03 15:29:44  nathan
; moved from dev/analysis/cor
;
; Revision 1.11  2006/09/29 19:02:27  colaninn
; fixed calimg_off bug
;
; Revision 1.10  2006/09/27 16:24:37  colaninn
; changed calimg to float
;
; Revision 1.9  2006/09/26 20:34:16  colaninn
; changed for correct history
;
; Revision 1.8  2006/09/22 18:34:57  colaninn
; added scc_sebip.pro and expanded history output
;
; Revision 1.7  2006/09/15 21:25:59  colaninn
; added HISTORY values
;
; Revision 1.6  2006/09/08 20:09:16  colaninn
; added _extra keyword
;
; Revision 1.5  2006/09/08 19:51:24  colaninn
; changed keyword from no to off
;
; Revision 1.4  2006/09/05 20:51:54  colaninn
; added no_sebip keyword
;
; Revision 1.3  2006/08/24 18:02:16  colaninn
; changed get_vignet to get_calimg
;
; Revision 1.2  2006/08/23 20:32:18  colaninn
; added temporary to image math
;
; Revision 1.1  2006/08/09 21:36:04  colaninn
; moved to /cor
;
; Revision 1.2  2006/08/04 19:41:49  colaninn
; added correction for SEB IP
;
; Revision 1.1  2006/07/28 16:17:12  colaninn
; Renamed secchi_calibrate.pro to cor_calibrate.pro
;
; Revision 1.1  2006/07/25 21:10:57  colaninn
; first draft
;
;-     

IF datatype(ex) EQ 'UND' THEN ex = create_struct('blank',-1)
IF keyword_set(silent) THEN ex = CREATE_STRUCT('silent',1,ex)
info="$Id: cor_calibrate.pro,v 1.14 2007/09/25 16:23:14 thompson Exp $"
len=strlen(info)
version='Applied '+strmid(info,5,len-10)
IF ~keyword_set(silent) THEN message,version,/inform

;--Check Header-------------------------------------------------------
 IF(DATATYPE(hdr) NE 'STC') THEN hdr=SCC_FITSHDR2STRUCT(hdr)

IF (tag_names(hdr, /STRUCTURE_NAME) NE 'SECCHI_HDR_STRUCT') THEN $
 message,'ONLY SECCHI HEADER STRUCTURE ALLOWED'

IF (hdr[0].DETECTOR NE 'COR1') AND (hdr[0].DETECTOR NE 'COR2') THEN $
message,'Calibration for COR1 or COR2 DETECTOR only'
;----------------------------------------------------------------------

;--Add file version to header history
hdr = scc_update_history(hdr,version)

;------------------------------------------------------------------------
;--Correct for SEB IP(ON)
IF ~keyword_set(sebip_off) THEN im = SCC_SEBIP(im,hdr,ip_flag, _extra=ex)
; hdr modified in sebip


;--Convert to DN/S (ON)
IF keyword_set(exptime_off) THEN exptime = 1.0 ELSE BEGIN
  exptime = GET_EXPTIME(hdr,_EXTRA=ex)
  IF exptime NE 1.0 THEN BEGIN
    hdr = SCC_UPDATE_HISTORY(hdr,'Exposure Normalized to 1 Second',value=exptime)
    IF ~keyword_set(SILENT) THEN message,'Exposure Normalized to 1 Second',/info
  ENDIF
ENDELSE

;-- Bias Subtraction(ON)
IF keyword_set(bias_off) THEN biasmean = 0.0 ELSE BEGIN
  biasmean =GET_BIASMEAN(hdr,_EXTRA=ex)
  IF biasmean NE 0.0 THEN BEGIN
    hdr = SCC_UPDATE_HISTORY(hdr,'Bias Subtracted',value=biasmean)
    hdr.OFFSETCR=biasmean
    IF ~keyword_set(SILENT) THEN message,'Bias Subtracted',/info
  ENDIF
ENDELSE

; Added as a test by Eoin Carley 2011-Sep-18
	bkgimg = scc_getbkgimg(hdr, outhdr=bkghdr, match=0, _extra=ex)

;--Correction for flat field and vignetting (ON)
If keyword_set(calimg_off) THEN calimg = 1.0 ELSE BEGIN
  calimg = GET_CALIMG(hdr,fn,_EXTRA=ex)
  IF (size(calimg))(0) GT 1 THEN BEGIN
    hdr = SCC_UPDATE_HISTORY(hdr,'Applied Vignetting '+fn)
  ENDIF
ENDELSE

;--Apply Photometric Calibration - DN to MSB
IF keyword_set(calfac_off) THEN calfac=1.0 ELSE BEGIN
  calfac = GET_CALFAC(hdr,_EXTRA=ex)
  IF calfac NE 1.0 THEN BEGIN
    hdr = SCC_UPDATE_HISTORY(hdr,'Applied Calibration Factor',value=calfac)
    IF ~keyword_set(SILENT) THEN message,'Applied Calibration Factor '+trim(calfac),/info
  ENDIF
ENDELSE 

;----------------------------------------------------------------------
;--Apply Calibration
im = RATIO(  ((temporary(im)-biasmean[0])*calfac[0]/exptime[0] - bkgimg*calfac[0]) ,float(calimg))
;
print,'-----------------------------------------'
print,' '
print,'N.B. Test background subtraction employed'
print,' '
print,'-----------------------------------------'

;----------------------------------------------------------------------


RETURN,im
END

