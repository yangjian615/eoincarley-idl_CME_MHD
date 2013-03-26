pro xwavesds
;+
; NAME:
;       xwavesds
; PURPOSE:
;       Read and display WIND/WAVES data
; CALLING SEQUENCE:
;       xwavesds
; MODIFICATION HISTORY:
; Original  Jan. 1997
; Minor correction to DOY labelling Feb. 1997
; Minor correction to correct filename construction Mar 31, 1997
; Minor correction to fix long plots April 29, 1997
; Addition of log scales for rads May 16, 1997
; Fix of tnr intensities (x2 error --> 20 log not 10 log) June 4, 1997
; Fix fractional hour plots bug  June 24, 1997  [RJM calls this version 1.2]
; Added capability to plot single time series a la RAR.  1/25/98 RJM
; Version 2.0:  Modified to use CASE statement, added RJM stuff.   1/26/98 RJM
; Version 2.01: Corrected up/low freq limits when < full range.    1/30/98 RJM
; Version 2.02:  Removed some of MacDowall's modifications
; Version 3.0:  New rad formats and new file names                 8/17/98 MLK
; Version 3.01  Fix color problem for non Sun 8-bit machines       8/25/98 MLK
; Version 3.02  Fix tnr fixed frequency plot                       9/01/98 MLK
; Version 4.0  Use of shade_surf to do the spectra
;              add log capabilty for frequency axis
;              clean up B&W printing a bit                         1/21/99 MLK
; Version 4.01 Fixed B&W printing bug (Oops!)                      1/25/99 MLK
; Version 4.1  Added comnbined dynamic spectra                     3/10/99 MLK
; Version 4.11 Fixed minor freq labelling bug in fixed freq plot   3/23/99 MLK
; Version 5.0  Crude widget replacement of WMENU                   8/21/00 MLK
; Version 5.1  Addition of RAD1+RAD2 capability                   11/14/01 MLK
; Version 5.2  Addition of 1/f capability                         11/27/01 MLK
; Version 5.3  Addition of gif and png capability                 05/08/02 MLK
; Version 6.0  Use environment variables for data directories
;              and use GET_SCREEN_SIZE                            03/21/05 WTT
;-
;
common xwavesds_common,cpu,ncolors,array,hour,freqlo,xlabel,hints,tickv,$
  hlabels,funit,scale1,scale2,p_title,linlog,xdim,yymmdd1,yymmdd2,ohour1,ohour2,$
  av_interval,plot_type,freq_00,rcvr,fhz1,fhz2,fspace,hour1,hour2,chan1
;
common xwavesds_files,frad1,frad2,ftnr
;
;######  Define all system-dependent data file directories here  #####
;
; Determine which operating system we're running on, Windows or Unix/Linux
;
if(!version.os eq 'Win32') then cpu='win' else cpu='x'
;
frad1 = getenv('WAVES_RAD1')
frad2 = getenv('WAVES_RAD2')
ftnr  = getenv('WAVES_TNR')
;
;  Set the screen size:
;
device, get_screen_size=screensize
       xsize=screensize(0)*.95
        ysize=screensize(1)*.5

;
;  ###########
;
; Pick the initial color table
;
loadct,39
;
mainbase=widget_base(title='Wind/WAVES',column=2,tlb_size_events=1,$
                     mbar=menubaseid)
fileid=widget_button(menubaseid,value='File')
plotid=widget_button(fileid,value='New Plot',event_pro='xwavesds_plot',$
                     uvalue='Plot')
;
;  Don't use print button until debugged
;
;printid=widget_button(fileid,value='Print to ...',$event_pro='xwavesds_plot',uvalue='Print')
psid=widget_button(fileid,value='Save as PS',event_pro='xwavesds_ps')
gifid=widget_button(fileid,value='Save as gif',event_pro='xwavesds_gif')
pngid=widget_button(fileid,value='Save as png',event_pro='xwavesds_png')
quitid=widget_button(fileid,value='Quit',event_pro='xwavesds_quit')
optid=widget_button(menubaseid,value='Options',menu=1)

nsid=widget_button(optid,value='Rescale',event_pro='xwavesds_plot',$
                   uvalue='Scale')
ncid=widget_button(optid,value='New Colors',event_pro='xwavesds_colors')
subid=widget_button(optid,value='Sub-interval',event_pro='xwavesds_plot',$
                    uvalue='Sub-interval')
onefrqid=widget_button(optid,value='Frequency cut',event_pro='xwavesds_plot',$
                       uvalue='Time series')
drawid=widget_draw(mainbase,xsize=xsize,ysize=ysize)
widget_control,mainbase,/realize
widget_control,drawid,get_value=wid
wset,wid
xmanager,'xwavesds',mainbase,/No_Block
end
