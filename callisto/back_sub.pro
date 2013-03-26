pro back_sub,bck_subbed

files = findfile('*.fts')
data  = sccreadfits(files,he)

elements = size(data)
pre_event = filter_image(data(*,*,0),/median)

bck_subbed  = fltarr(elements[1],elements[2],elements[3]-1)

msk = get_smask(he[0])


for i = 1,elements[3]-1 do begin
    data(*,*,i) = filter_image(data(*,*,i),/median)
    bck_subbed(*,*,i-1) = ( filter_image( (data(*,*,i) - pre_event),/median))*msk
    bck_subbed(*,*,i-1) = scc_add_datetime(bck_subbed(*,*,i-1),he[i],/circle)
       
endfor

end
    
    