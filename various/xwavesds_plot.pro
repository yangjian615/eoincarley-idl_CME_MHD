pro xwavesds_plot,event

;
;  Save all values so we don't have to recompute them on 'Print' entry
;
common xwavesds_common,cpu,ncolors,array,hour,freqlo,xlabel,hints,tickv,$
hlabels,funit,scale1,scale2,p_title,linlog,xdim,yymmdd1,yymmdd2,ohour1,ohour2,$
av_interval,plot_type,freq_00,rcvr,fhz1,fhz2,fspace,hour1,hour2,chan1
;
common xwavesds_files,frad1,frad2,ftnr
;
common colors,rold,gold,bold,rnow,gnow,bnow

set_plot,cpu
ncolors=!d.table_size-1


;
; Set plotting background to white, labelling to black (most color tables)
;
!p.background=255
!p.color=0



;
; Determine which button got us here
;
widget_control,event.id,get_uvalue=whocall
case whocall of
'Scale': begin
read,prompt='enter new min and max in dB :',scale1,scale2
scale=scale2-scale1
if(scale le 10) then nticks=scale
if((scale gt 10) and (scale lt 20)) then begin
scale=2*fix(scale/2+.9)
scale2=scale1+scale
nticks=scale/2
endif
if(scale ge 20) then begin
scale=10*fix(scale/10+.9)
scale2=scale1+scale
nticks=10
iplt=2
endif
goto,replot
end
'Print': begin
ok=dialog_printersetup()
set_plot,'printer'
device,/index_color,/true_color
tvlct,rnow,gnow,bnow
goto,replot
end
'Sub-interval': begin
  print, "Click cursor at start and end times"
  cursor, hour1, freqx, /down
  cursor, hour2, freqx, /down
  if (hour2-hour1) lt 2.0 then begin
    print, "The program labeling does not work for less than 2 hrs"
    print, "Resetting to 2 hours"
    hour1 = (hour1+hour2)/2.0 - 1.
    hour2 = hour1 + 2.
  endif
; need to recalculate date labels
  if(yymmdd1 lt yymmdd2) then begin
    new_iday = fix((hour1+hour1_start)/24.)
    yymmdd1 = oyymmdd1
    addymd, yymmdd1, new_iday
    doy1 = odoy1 + new_iday;  needed for labels
    if (hour1 mod 24 ne 0.00) then doy1 = doy1 + 1
    new_iday = fix((hour2+hour1_start)/24.)
    yymmdd2 = oyymmdd1
    addymd, yymmdd2, new_iday
    if (yymmdd1 eq yymmdd2) then begin
      datefm,yymmdd1,date
      dates = date
    endif else begin
      datefm,yymmdd1,date1
      datefm,yymmdd2,date2
      dates = date1+' to '+date2
    end
  p_title = ' Wind Waves ' + strupcase(rcvr) + ' receiver: '+ dates
  endif
  ihr1 = long((hour1-ohour1)*3600./av_interval) > 0
  ihr2 = long((hour2-ohour1)*3600./av_interval) < (xdim-1)
  ohour1 = hour1
  xdim = ihr2-ihr1 + 1
  print, " selecting subset of data..."
  array = array(ihr1:ihr2,*)
  hour =  hour(ihr1:ihr2+1)
  sub_interval = "TRUE"
  goto, redo_labels
end
'Time series': begin
 print, "Select frequency with cursor"
     cursor, hourxx, freq1, /down
   plot_type = "time_series"

   if(rcvr eq 'tnr') then begin  ; note fhz1 & freq1 are in log(freq) for TNR
     freq1 = (10.^fhz1 > freq1) < 10.^fhz2
     chan1=fix((alog10(freq1)-fhz1)/fspace)+1
     freq1=fhz1+chan1*fspace
     freq_00=long(100.*10.^freq1)/100.
   endif else begin
     freq1 = (fhz1 > freq1) < fhz2
     chan1=fix((freq1-fhz1)/fspace)
     freq1=fhz1+chan1*fspace
     freq_00=long(1000.*freq1)/1000.
   endelse

   goto, redo_labels
   end

'Plot': begin
erase
end
endcase

lltype=['[lin]','[log]','[1/f]']
;resetfig ; these ensure that I don't have stuff setfrom another program.  RJM
;resetidl

not_open1 = "TRUE"
not_open2 = "TRUE"
sub_interval = "FALSE"
plot_type = "dynamic_spec"

rcvr=' '
read,prompt=' Enter rcvr name rad1, rad2, both (rad1+rad2), tnr, or all: ', rcvr
rcvr = strlowcase(rcvr)
if(rcvr eq 'both') then rcvr='RAD1+RAD2'
case rcvr of
'rad1': begin
flow=20
fhigh=1040
fspace=4.
funit='kHz'
linlog=1
    end
'rad2': begin
flow=1.075
fhigh=13.825
fspace=.050
funit='MHz'
linlog=1
    end
'tnr':  begin
flow=4.
fhigh=245.146
fspace=.188144e-1
funit='kHz'
linlog=1
    end
'all': begin
flow=4.
fhigh=13825.
funit='kHz'
linlog=1
yll='log'
chan1=0
chan2=563
    end
'RAD1+RAD2':begin
linlog=1
funit='kHz'
flow=20.
fhigh=13825.
end
endcase

ymd=0l
hms=0l
yymmdd1=0l
read,prompt=' Enter start YYYYMMDD: ',yymmdd1

year1ok:
hour1=' '
read,prompt=' Enter start time in hours [0]: ',hour1
if (hour1 eq '') then begin
hour1=0.
endif else begin
hour1=float(hour1)
endelse
oyymmdd1 = yymmdd1
ohour1 = hour1
hour1_start = hour1
yymmdd2=' '
read, prompt=' Enter stop YYYYMMDD [' + strtrim(yymmdd1,2) + ']: ', yymmdd2
if (yymmdd2 eq '') then begin
yymmdd2=yymmdd1
endif else begin
yymmdd2 = long(yymmdd2)
endelse

year2ok:
oyymmdd2 = yymmdd2
hour2=' '
read,prompt=' Enter stop time in hours [24]: ',hour2
if (hour2 eq '') then begin
hour2=24.
endif else begin
hour2=float(hour2)
endelse
if(rcvr eq 'all') then goto, aveint
fhz1=' '
fhz2=' '
print,' Enter low frequency in ', funit,' [',flow,'] '
read,fhz1
print,' Enter high frequency in ', funit,' [',fhigh,'] '
read,fhz2
if(fhz1 eq '') then begin
fhz1=flow
endif else begin
fhz1=float(fhz1)
endelse
if(fhz2 eq '') then begin
fhz2=fhigh
endif else begin
fhz2=float(fhz2)
endelse
case rcvr of
'tnr':begin
chan1=fix((alog10(fhz1)-alog10(flow))/fspace)+1
chan2=fix((alog10(fhz2)-alog10(flow))/fspace)+1
fhz1=alog10(flow)+chan1*fspace
fhz2=alog10(flow)+chan2*fspace
end
'rad1':begin
chan1=fix((fhz1-flow)/fspace)
chan2=fix((fhz2-flow)/fspace)
fhz1=flow+chan1*fspace
fhz2=flow+chan2*fspace
end
'rad2':begin
chan1=fix((fhz1-flow)/fspace)
chan2=fix((fhz2-flow)/fspace)
fhz1=flow+chan1*fspace
fhz2=flow+chan2*fspace
end
'RAD1+RAD2':begin
chan1=fix((fhz1-20.)/4.)
chan2=fix((fhz2-1075.)/50.)
fhz1=20.+chan1*4.
fhz2=1075.+chan2*50.
end
endcase
yll=' '
read,prompt='Enter frequency axis type, lin, log, or 1/f :',yll
if(yll eq 'lin') then linlog=0
if(yll eq 'log') then linlog=1
if(yll eq '1/f') then linlog=2
aveint:
ydim=(chan2-chan1)+1
if(rcvr eq 'RAD1+RAD2') then ydim=257-chan1+chan2
av_interval=' '
read,prompt=' Enter averaging interval in minutes [1]: ',av_interval
if(av_interval eq '') then begin
av_interval=60
endif else begin
av_interval=fix(av_interval)*60
endelse
print, " collecting data ..."
redo_interval:
; ih1=fix(hour1)*10000l  changed 9/17/97
; ih2=fix(hour2)*10000l
ih1=(fix(hour1*60.)+(fix(hour1*60.)/60l)*40l)*100l
ih2=(fix(hour2*60.)+(fix(hour2*60.)/60l)*40l)*100l
iday=0l
isec=0l
doy1=0l
diff_waves,(yymmdd1/10000l)*10000l+100l,0l,yymmdd1,0l,doy1,isec
if(hour1 gt 0.) then doy1=doy1+1
odoy1 = doy1
diff_waves,yymmdd1,ih1,yymmdd2,ih2,iday,isec
xdim=fix((iday*86400+isec)/av_interval)
; read data
diff_waves,yymmdd1,0l,yymmdd2,0l,iday,isec
; ind1=fix(hour1)*60  changed 9/17/97
; ind2=fix(hour2)*60-1+iday*1440
ind1=fix(hour1*60.)
ind2=fix(hour2*60.)-1+iday*1440
hold=fltarr(1440*(iday+1),ydim)
yymmdd=yymmdd1
for dayno=0,iday do begin
i1=dayno*1440l
i2=i1+1439l
yymmdda=strtrim(string(yymmdd),1)
case rcvr of
 'all': begin
file=ftnr+yymmdda+'.tnr'
restore,filename=file
hold(i1:i2,0:63)=arrayb(0:1439,0:63)
file=frad1+yymmdda+'.R1'
restore,filename=file
hold(i1:i2,64:307)=arrayb(0:1439,12:255)
file=frad2+yymmdda+'.R2'
restore,filename=file
hold(i1:i2,308:563)=arrayb(0:1439,0:255)
end
'RAD1+RAD2':begin
file=frad1+yymmdda+'.R1'
restore,filename=file
hold(i1:i2,0:255-chan1)=arrayb(0:1439,chan1:255)
file=frad2+yymmdda+'.R2'
restore,filename=file
hold(i1:i2,256-chan1:ydim-1)=arrayb(0:1439,0:chan2)
end
'tnr': begin
file=ftnr+yymmdda+'.tnr'
restore,filename=file
hold(i1:i2,0:*)=arrayb(0:1439,chan1:chan2)
end
'rad1': begin
file=frad1+yymmdda+'.R1'
restore,filename=file
hold(i1:i2,0:*)=arrayb(0:1439,chan1:chan2)
end
'rad2': begin
file=frad2+yymmdda+'.R2'
restore,filename=file
hold(i1:i2,0:*)=arrayb(0:1439,chan1:chan2)
end
endcase
addymd,yymmdd,1l
endfor
; form array
array=rebin(hold(ind1:ind2,0:*),xdim,ydim)

lt1=where(array lt 1.)
; array(lt1)=1.   changed 9/17/97
; array=10.*alog10(array)
if(lt1(0) ne -1) then array(lt1)=1.
array=20.*alog10(array)


plot_data:
scale1=0.5
scale2=20.
nticks=10
;******
if(yymmdd1 eq yymmdd2) then begin
  datefm,yymmdd1,date
  dates = date
endif else begin
  datefm,yymmdd1,date1
  datefm,yymmdd2,date2
  dates = date1+' to '+date2
endelse
hour=findgen(xdim+1)*av_interval/3600.+hour1
hour2=hour1+float(xdim)*av_interval/3600.
ohour2 = hour2 ; save for plotting subintervals
redo_labels:
hints=fix(hour2-hour1)
xlabel='GMT (HRS)'
if(hints gt 24) then begin
  htics=fix(float(hints)/12.+1.)
  if(htics eq 5) then htics=6
  if(htics gt 6) then htics=24
  midnoon=where((hour mod htics) eq 0)
  tickv=hour(midnoon)
  if(htics lt 24) then $
    hlabels=strtrim(string(fix(hour(midnoon)) mod 24),1) $
  else hlabels=strtrim(string(doy1+indgen(iday+2)),1)
  if(htics gt 6) then xlabel='DOY'
  ok=size(tickv)
  hints=ok(1)-1
endif else begin
  hrs=where((hour mod 1.) eq 0)
  tickv=hour(hrs)
  hlabels=strtrim(string(fix(hour(hrs)) mod 24),1)
  ok=size(tickv)
  hints=ok(1)-1
endelse
if (plot_type eq "time_series") then goto, plot_timeser
if (sub_interval eq "TRUE") then goto, replot
case rcvr of
'all':begin
freqlo=findgen(564)
freqlo(0:63)=10.^(findgen(64)*.188144e-1+alog10(4.))
freqlo(64:307)=findgen(244)*4.+68.
freqlo(308:563)=findgen(256)*50.+1075.
end
'RAD1+RAD2':begin
nr1=256-chan1
nr2=ydim-nr1
freqlo=findgen(ydim)
freqlo(0:nr1-1)=findgen(nr1)*4.+fhz1
freqlo(nr1:ydim-1)=findgen(nr2)*50.+1075.
end
'rad1': freqlo=findgen(ydim)*fspace+fhz1
'rad2': freqlo=findgen(ydim)*fspace+fhz1
'tnr':begin
freqlo=findgen(ydim)*fspace+fhz1
freqlo=10.^freqlo
end
endcase


p_title = ' Wind Waves ' + strupcase(rcvr) + ' receiver: '+ dates
erase
main:


replot:
plot_type = "dynamic_spec"
sub_interval = "FALSE"
erase
ncolors=!d.table_size-1
if(ncolors gt 255) then ncolors=255
colors=indgen(ncolors)
bar=intarr(ncolors,5)
for j=0,4 do begin
bar(*,j)=colors
endfor
contour,bar,position=[.2,.075,.8,.1],xrange=[scale1,scale2],xticks=nticks,$
xstyle=1,ystyle=4,font=0,$
xtitle='intensity (dB) relative to background',/nodata,/noerase
px=!x.window*!d.x_vsize
py=!y.window*!d.y_vsize
sx=px(1)-px(0)+1
sy=py(1)-py(0)+1
tv,poly_2d(byte(bar),[[0,0],[ncolors/sx,0]],[[0,5/sy],$
[0,0]],0,sx,sy),px(0),py(0)
xyouts,.4,.81,/normal,font=0,p_title,charsize=2.0
arrayb=bytscl(array,min=scale1,max=scale2,top=(!d.table_size<256)-2)
case linlog of
0: begin
shade_surf,array,hour(0:xdim-1),freqlo,position=[.1,.2,.9,.8],$
xstyle=1,ystyle=1,az=0.,ax=90.,/data,shades=arrayb,font=0,$
xtitle=xlabel,xticks=hints,xtickv=tickv,xtickname=hlabels,$
ztickformat='no_label',ytitle=funit,ticklen=-.01,/noerase
end
1: begin
shade_surf,array,hour(0:xdim-1),freqlo,position=[.1,.2,.9,.8],$
xstyle=1,ystyle=1,az=0.,ax=90.,/data,shades=arrayb,font=0,$
xtitle=xlabel,xticks=hints,xtickv=tickv,xtickname=hlabels,$
ztickformat='no_label',ytitle=funit,ticklen=-.01,/noerase,/ylog
end
2: begin
shade_surf,array,hour(0:xdim-1),1./freqlo,position=[.1,.2,.9,.8],$
xstyle=1,ystyle=1,az=0.,ax=90.,/data,shades=arrayb,font=0,/save,$
xtitle=xlabel,xticks=hints,xtickv=tickv,xtickname=hlabels,$
ztickformat='no_label',ytitle='1/f ('+funit+')',ticklen=-.01,/noerase,$
yrange=[1./freqlo(0),0.]
plots,[hour(0),hour(xdim-1),hour(xdim-1)],[0.,0.,1./freqlo(0)],[0,0,0],$
color=0,/t3d,/data
end
endcase
goto,done_plot
plot_timeser:
plot, hour(0:xdim-1), array(*,chan1), psym=-1, /xstyle, $
        title=p_title + "   Freq: "+ strtrim(freq_00,2) + " " + funit, $
        ytitle="dB above background", xtitle=xlabel, xtickv=tickv,$
        xticks=hints,xtickname=hlabels, symsize=0.3
done_plot:
if(whocall eq 'Print') then device,/close
set_plot,cpu

end
