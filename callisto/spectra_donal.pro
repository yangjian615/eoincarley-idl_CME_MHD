pro spectra_donal

loadct,9
stretch,255,70

radio_spectro_fits_read,'/Users/eoincarley/Data/CALLISTO/20110922/BIR_20110922_104459_01.fit',z0,x0,y0
;radio_spectro_fits_read,'C:\Users\MyLaptop\IDLWorkspace71\Default\22.09.2011\BIR_20110922_104459_01.fit',z,x,y

;background=fltarr(200)
;background=avg(z0,0)

;bk=fltarr(3600,200)
;for i=0,3599 do begin 
;bk[i,*]=background[*]
;endfor

 window,0,xsize=1000,ysize=600

    !p.multi=[0,1,1]
    
    aaa=constbacksub(z0,/auto)
    
    spectro_plot,aaa,x0,y0,/xs,/ys,$
    charsize=1;,xrange='2011-sep-22 '+['10:47:30','10:53:00'],title='Herringbones 22/09/2011' 
    
    print & print,'Please select area of image you would like to observe.' & print
    
    point,t,f,/data
  
    spectro_plot,smooth(aaa,3),x0,y0,/xs,/ys,$
    charsize=1,xrange=[t[0],t[1]],yrange=[f[1],f[0]],title='Herringbones 22/09/2011' 
aa = 1.0d 
bb=1.0d

;====Find time and frequencies====
point,aa,bb

;====For a given y value collected from 'bb' find the pixel index of the y axes that it's located
index = dindgen(200)+1.0
bb1 = interpol(index,y0,bb[0])
bb2 = interpol(index,y0,bb[1])
stop
;=====Same as above but using closest. You can use interpol here if you like but closest seems to work
a1=closest(x0,aa[0])
a2=closest(x0,aa[1])

;bb1=closest(y0,bb[0]) ;obselete lines
;bb2=closest(y0,bb[1])

;====The following draws lines where you chose, to make sure it's looking in the right place
f_gen = (dindgen(101)*((80.-10.)/100.))+50.
plots,x0[a1],f_gen,linestyle=1,thick=2
plots,x0[a2],f_gen,linestyle=1,thick=2

t_gen = (dindgen(101)*((x0[3000]-x0[0])/100.))+x0[0]
interp_freq1 = interpol(y0,index,bb1)
interp_freq2 = interpol(y0,index,bb2)
plots,t_gen,interp_freq1,linestyle=1,thick=2
plots,t_gen,interp_freq2,linestyle=1,thick=2
;plots,t_gen,bb[0],linestyle=1
;plots,t_gen,bb[1],linestyle=1

plots,aa,bb,linestyle=1 ; vertex drawn between selection points (dotted line)

npoints=ABS(aa[1]-aa[0]+1)>ABS(bb[1]-bb[0]+1)

npoints=100000.0 ; you could use above line but the more points ther merrier!
xloc=a1+(a2-a1)*findgen(npoints)/(npoints-1) ;as was before
yloc=bb1+(bb2-bb1)*findgen(npoints)/(npoints-1) ;as was before

stop
;=======The next two lines are important===
;There was a hidden problem besides the one we were stuck on.
;yloc from the above line generetes pixel values in a linear fashion between
;bb1 and bb2. However! The pixels in the dynamic spectrum are unevenly
;spaced, so it samples the array in funny places. To see this run this code on the 
;array with the following two lines commented out. The thick black is where the 
;interpolate agolrithm samples the array. Obviously wrong! Uncomment the following
;two lines and a sample accross the vertex is correctly taken.
freq_test = bb[0]+(bb[1]-bb[0])*findgen(npoints)/(npoints-1) ;<---Comment these out to see error
yloc = interpol(index,y0,freq_test)                          ;<---
stop
;Run the interpolation algorithm...
profile=interpolate(aaa,xloc,yloc)

;plot where the profile was taken (thick black line)

interp_freq_sample1 = interpol(y0,index,yloc)

ind2 = dindgen(3600)+1
interp_freq_sample2 = interpol(x0,ind2,xloc)
plots,interp_freq_sample2,interp_freq_sample1,linestyle=0

;Gaussian fit etc....

window,1
plot,profile,ytitle='Intensity',xtitle='Distance (in indics of xloc and yloc arrays)',psym=2
x_profile=findgen(npoints)
yfit=gaussfit(x_profile,profile,coeff,nterms=4)
;oplot,yfit
y=y0
FWHM = 2*sqrt(2*alog(2))*coeff[2]

t1=coeff[1]-FWHM/2
t2=coeff[1]+FWHM/2

XFWHM=xloc[t2]-xloc[t1]
TFWHM=XFWHM/4

c1=uint(yloc[t1])
d1=uint(yloc[t2])

if c1 lt yloc[t1] then begin
c2=c1+1
difc=y[c1]-y[c2]
cf=(difc*(yloc[t1]-c1))+y[c2]
endif else begin
c2=c1-1
difc=y[c2]-y[c1]
cf=(difc*(yloc[t1]-c2))+y[c2]
endelse

if d1 lt yloc[t2] then begin
d2=d1+1
difd=y[d1]-y[d2]
df=(difd*(yloc[t2]-d1))+y[d2]
endif else begin
d2=d1-1
difd=y[d2]-y[d1]
df=(difd*(yloc[t2]-d2))+y[d2]
endelse

FFWHM=df-cf
print,'Frequency FWHM ='+string(FFWHM)& print
print,'FWHM Points ='+string(df)+string(cf)
print,'Points clicked='+string(bb[0])+string(bb[1])

    stop
    end