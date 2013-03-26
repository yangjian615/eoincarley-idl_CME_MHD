;chten+conv.pro reads fits data from archive and makes images
; of Tb and flux/intensity; makes convolution and spectral index
; images (alpha)

;Dir= 'E:\Nirfi\Nobeyama_data_for_solar_flare\2002\norh20020728\'
Dir= 'norh20020824_0100_10s'
file=file_list(dir,'ipa020824*')

print,'number of ipa-files =',n_elements(file)

norh_rd_img,file,indexnha,datanha
norh_index2map,indexnha,datanha,mapnha
fi=norh_tb2flux(datanha,indexnha,/inten)  ; fi - intensity (flux density from 1 sterad)
;fullfi=norh_tb2flux(datanha,indexnha)   ; fi - total flux density in sfu from 64x64 pixels

file=file_list(dir,'ips020824*')

print,'number of ips-files =',n_elements(file)
norh_rd_img,file,indexnhs,datanhs
fv=norh_tb2flux(datanhs,indexnhs,/inten)
;fv=norh_tb2flux(datanhs,indexnhs)
norh_polariz,indexnha,fi,indexnhs,fv,indexnhp,pol,mvdp

file=file_list(dir,'ipz020824*')
print,'number of ipz-files =',n_elements(file)

norh_rd_img,file,indexnhz,datanhz
fz=norh_tb2flux(datanhz,indexnhz,/inten)
;fullfz=norh_tb2flux(datanhz,indexnhz)

print,'image building completed'

norh_convol,indexnhz,indexnha,fi,indexnhac,fic
print,'FIC convolved image completed'
norh_convol,indexnha,indexnhz,fz,indexnhzc,fzc
print,'FZC convolved image completed'
norh_alpha,indexnhac,fic,indexnhzc,fzc,indexnhal,alpha,mvdal
print,'ALPHA image completed'

pixsz=norh_gt_pixsz(indexnha)          ; angle size of 1 pixel in arcsec
print,'pixel size at 17 GHz in arcsec =',pixsz(1)

pixsz=norh_gt_pixsz(indexnhz)
print,'pixel size at 34 GHz in arcsec =',pixsz(1)

pixsz=norh_gt_pixsz(indexnhac)          ; angle size of 1 pixel in arcsec
print,'pixel size at 17 GHz after convolution, in arcsec =',pixsz(1)
omega_per_pix=(pixsz(1)/3600.*!dtor)^2    ; the size of a pixel in sterad
fic=fic*omega_per_pix                ; flux density in sfu from 1 pixel

pixsz=norh_gt_pixsz(indexnhzc)
print,'pixel size at 34 GHz after convolution, in arcsec =',pixsz(1)
omega_per_pix=(pixsz(1)/3600.*!dtor)^2 ;!dtor=pi/180 to convert degrees to rad
fzc=fzc*omega_per_pix ; flux density in SFU from  each pixel

print,'I am ready for saving'
save,datanha,indexnha,indexnhz,datanhz,fic,indexnhac,fzc,indexnhzc,indexnhp,pol,mvdp,indexnhal,alpha,mvdal,filename='02-08-24_c.sav'

print,'sav-file is saved'

end