pro composite_dyn_spectra,znew,x_master,y_master

files = findfile('*.fit')




radio_spectro_fits_read,files[38],z0,x0,y0
radio_spectro_fits_read,files[39],z1,x1,y1
radio_spectro_fits_read,files[40],z2,x2,y2
radio_spectro_fits_read,files[41],z3,x3,y3



y_master = [y0,y1]
y_master = y_master[sort(y_master)]
y_master = reverse(y_master)
x_master = [x0,x2]
x_master = x_master[sort(x_master)]

x_master1 = [x0,x1]
x_master1 = x_master1[sort(x_master1)]
x_master2 = [x2,x3]
x_master2 = x_master2[sort(x_master2)]

;master_array = dblarr(( x3(n_elements(x3)-1)-x0(0) )/0.25,n_elements(y_master))
master_array = dblarr( n_elements(x_master),n_elements(y_master))


;spectro_plot,master_array,x_master,y_master

start_t1 = where(x_master eq x0[0])
start_f1 = where(y_master eq y0[0])
ypos_all=0
;stop
for j=0,n_elements(x0)-1 do begin
for i = 0, n_elements(y0)-1 do begin

    
          y_pos = where(y_master eq y0[i])
          x_pos = where(x_master1 eq x0[j])
          IF n_elements(y_pos) gt 1 THEN BEGIN
             y_pos =y_pos[1]
          ENDIF 
          value = z0(j,i)
          ;print,i,j
          ;a = where(x_master eq x0[j])
          ;b = where(y_master eq y0[i])
          master_array[j,y_pos]=value
	endfor
	
endfor        


start_t1 = where(x_master1 eq x1[0])
start_f1 = where(y_master eq y1[0])
print,start_f1
;stop
for i = 0., n_elements(y1)-1 do begin
    for j=0,n_elements(x1)-1 do begin
          
          y_pos = where(y_master eq y1(i))
          IF n_elements(y_pos) gt 1 THEN BEGIN
             y_pos =y_pos[1]
          ENDIF   
          ;x_pos = where(x_master eq x1(j))
          value = z1(j,i)
          ;print,i,j
          master_array[start_t1+j,y_pos]=value
	endfor
	
	;stop
endfor 
;stop

;stop
start_t1 = where(x_master2 eq x2[0])
start_t1 = start_t1+3600
;start_f1 = where(y_master eq y2[0])
;stop

for i = 0., n_elements(y2)-1 do begin
    for j=0,n_elements(x2)-1 do begin
          
          y_pos = where(y_master eq y2(i))
          IF n_elements(y_pos) gt 1 THEN BEGIN
             y_pos =y_pos[1]
          ENDIF   
          ;x_pos = where(x_master eq x1(j))
          value = z2(j,i)
          ;print,i,j
          master_array[start_t1+j,y_pos]=value
	endfor
endfor
;stop

start_t1 = where(x_master2 eq x3[0])
start_t1 = start_t1+3600
;start_f1 = where(y_master eq y2[0])
;stop

for i = 0., n_elements(y3)-1 do begin
    for j=0,n_elements(x3)-1 do begin
          
          y_pos = where(y_master eq y3(i))
          IF n_elements(y_pos) gt 1 THEN BEGIN
             y_pos =y_pos[1]
          ENDIF   
          ;x_pos = where(x_master eq x1(j))
          value = z3(j,i)
          ;print,i,j
          master_array[start_t1+j,y_pos]=value
	endfor
endfor        

print,'Here!!!!!!!!!'


;print,closest(x0,x1[n_elements(x1)-1])
;for i = 0, n_elements(x_master)-1 do begin

running_mean_background,master_array,back


;new = master_array-back
;znew = tracedespike(new,stat=3)
znew=master_array
loadct,39
!p.background=255
!p.color=0
window,1,xs=600,ys=500
loadct,5
spectro_plot,znew,x_master,y_master,/xs,/ys,yr=[355,20]
save,znew,filename=anytim(x_master[0],/ccsds)+'_1HRz.sav'
save,x_master,filename=anytim(x_master[0],/ccsds)+'_1HRx.sav'


end