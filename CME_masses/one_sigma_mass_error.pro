pro one_sigma_mass_error,std_dev_mass

mass_calc_manual,mass_array
mass = mass_array[1,*]
all_masses = fltarr(5,n_elements(mass))
all_masses[0,*]=mass

FOR i=1,4 DO BEGIN
	mass_calc_manual,mass_array
	mass = mass_array[1,*]
	all_masses[i,*]=mass
ENDFOR
;restore,'5runs_of_mht.sav'
std_dev_mass = fltarr(n_elements(all_masses[0,*]))

FOR i=0,n_elements(std_dev_mass)-1 DO BEGIN
	std_dev_mass[i] = stddev(all_masses[*,i])
ENDFOR	
std_dev_mass_error_cor1b=std_dev_mass
save,std_dev_mass_error_cor1b,filename='std_dev_mass_error_cor1b.sav'


END