pro neg_streamer_20081212

cd,'/Users/eoincarley/Data/secchi_l1/20081212/20081212_cor2a/mass_images'
spawn,'mkdir movie'


files = findfile('mass45*.fts')
pre = sccreadfits(files[0],hepre)
!p.multi=[0,2,1]
FOR i=1,n_elements(files)-1 DO BEGIN

ob = sccreadfits(files[i],he)
img = ob - pre
loadct,0
sub_pre = pre[0:1100,600:1700]
sub_img = img[0:1100,600:1700]
sub_ob = ob[0:1100,600:1700]


;histogauss,img[1000:1400,300:700],a
;stop
plot_image,sigrange(sub_pre)

plot_image,sigrange(sub_img)

neg0 = where(sub_img lt -7.0e9) ;-1.5e10 is mu-3*sigma for cor1b, for cor2b it's -1e10, for cor2a it's -6.0e9
pixels = array_indices(sub_img,neg0)

loadct,39
plots,pixels,color=230,psym=3

neg1 = where(sub_img lt -1.5e10)
pixels1 = array_indices(sub_img,neg1)
plots,pixels1,color=130,psym=3

neg2 = where(sub_img lt -3.5e10)
pixels2 = array_indices(sub_img,neg2)
plots,pixels2,color=90,psym=3
;IF i eq n_elements(files)-2 THEN stop

print,total(sub_img[neg0])
print,total(sub_pre[neg0])
;print,abs(total(sub_pre[neg0]) - total(ob[neg0]))
;print,total(sub_img[neg0])
print,anytim(file2time(files[i]),/yoh)

wait,1.0
;cd,'movie'
;x2png,'neg_values_'+string(i,format='(I2.2)')+'.png'
;cd,'/Users/eoincarley/Data/secchi_l1/20081212/20081212_cor1/20081212_cor1b_B/mass_images'

ENDFOR
END