function add_errors_sig

cd,'/Users/eoincarley/Data/secchi_l1/20081212/COR1+COR2'
restore,'std_dev_mass_error_cor1a.sav',/verb
array1=std_dev_mass_error_cor1a
cd,'/Users/eoincarley/Data/secchi_l1/20081212/20081212_cor1/20081212_cor1a_B/total_brightness'
list=findfile('*.fts')
times1 = anytim(file2time(list[1:n_elements(list)-1]),/utim)

cd,'/Users/eoincarley/Data/secchi_l1/20081212/COR1+COR2'
restore,'std_dev_mass_error_cor2a.sav',/verb
array2=std_dev_mass_error_cor2a
cd,'/Users/eoincarley/Data/secchi_l1/20081212/20081212_cor2a/total_brightness'
list=findfile('*.fts')
times2 = anytim(file2time(list[1:n_elements(list)-1]),/utim)

start_of_add = closest(times1[*], times2[0])

print,anytim(times1(start_of_add),/yoh)

q = size(array1)
q = q[1]
end_of_add = closest(times2[*], times1[q-1])


elements = start_of_add + q
master_array = dblarr(2,elements)

master_array[0,0:start_of_add-1]=times1[0:start_of_add-1]
master_array[1,0:start_of_add-1]=array1[0:start_of_add-1]



FOR i=0, end_of_add DO BEGIN

    index = closest(times1[*], times2[i])
    master_array[0,index] = times2[i]
    master_array[1,index] = sqrt(array1[index]^2+array2[i]^2)
    print,index
ENDFOR

times = master_array[0,*]
zeros = where(times eq 0.0)
remove,zeros,times

mass_errors = master_array[1,*]
zeros = where(mass_errors eq 0.0)
remove,zeros,mass_errors

master_array = dblarr(2,n_elements(times))
master_array[0,*]=times
master_array[1,*]=mass_errors

return,master_array

END