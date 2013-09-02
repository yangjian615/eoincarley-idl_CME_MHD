pro nrh_proper_motion

; Written 8-Aug-2013
; Check what the speed of the source is from its proper motion as opposed 
; to its angular motion

cd,'~/Data/22sep2011_event/NRH'
tstart = anytim(file2time('20110922_104000'),/yoh,/trun,/time_only)
tend   = anytim(file2time('20110922_104100'),/yoh,/trun,/time_only)
read_nrh,'nrh2_1509_h70_20110922_081556c06_i.fts', nrh_hdr, nrh_data, hbeg=tstart, hend=tend
index2map, nrh_hdr, nrh_data, nrh_struc  
nrh_struc_hdr = nrh_hdr
nrh_times = nrh_hdr.date_obs

img = nrh_data[*, *, 0]
loadct,3
window,0
plot_image, img
tvcircle, (nrh_struc_hdr[0].SOLAR_R), $
64.0, 64.0, 254, /data,color=255,thick=1

restore,'s_position_20110922.sav'
xpos = source_position[0,*]
ypos = source_position[1,*]
n = n_elements(xpos)

xpos = xpos[0:n-7];-60]
ypos = ypos[0:n-7];-60]

set_line_color
plots, xpos, ypos, color=4, psym=1, symsize=3
j = 0
i=80
plots, xpos[j], ypos[j], psym=7, color=5, symsize=2
plots, xpos[i], ypos[i], psym=7, color=5, symsize=2

delr = sqrt((xpos[i] - xpos[j])^2.0 + (ypos[i] - ypos[j])^2.0)
delr = delr/nrh_hdr[0].solar_r
delr = delr*6.955e5
print, delr/(10.0*i)
stop
; Get delta_x and delta_y
delr = fltarr(n-8)
nsteps = 5
FOR i=1, n_elements(delr)-1 DO BEGIN
	delx = xpos[i+1] - xpos[i]
	dely = ypos[i+1] - ypos[i]
	delr[i-1] = sqrt( delx^2.0 + dely^2 )
ENDFOR	

delr = delr/nrh_hdr[0].solar_r
delr = delr*6.955e5
r = delr
FOR i=0, n_elements(delr)-1 DO BEGIN
	r[i] = sum(delr[0:i], 0)
ENDFOR

t = dindgen(n_elements(r))*10.0

window,1
plot, t, r/6.955e5

result = linfit(t,r)
print, result

;delr = delr/nrh_hdr.solar_r
;delr = delr*6.955e5
;v = delr/10.0

;del_as = delr*nrh_hdr.cdelt1
;delr_prop = del_as*722.0
;v = delr_prop/(10.0*nsteps)

;index = where(v gt 0.0)
;v = v[index]



stop
hist = HISTOGRAM(delr) 
bins = FINDGEN(N_ELEMENTS(hist)) + MIN(delr) 
PRINT, MIN(hist) 
PRINT, bins 
window,1
PLOT, bins, hist, YRANGE = [MIN(hist)-1, MAX(hist)+1], PSYM = 10, $ 
   XTITLE = 'Bin Number', YTITLE = 'Density per Bin' 

stop
END