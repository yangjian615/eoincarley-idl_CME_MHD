function relativistic_energy, c_fraction

e_mass = 9.10938188D-31  ;kg
e_charge = 1.602D-19	 ;C
c = 2.99792458D8		 ;m/s

rest_E = e_mass*(c^2.0)  ;J


kin_e = rest_E/sqrt(1.0 - c_fraction^2.0) - rest_E
print, (kin_e/(e_charge)) / 1.0D3  ;relativistic kinetic eneregy (keV)
rel_kine = kin_e/(e_charge)

totE = rest_E/sqrt(1.0 - c_fraction^2.0) 
print, (totE/(e_charge)) / 1.0D3 ;total relativistic eneregy (keV), including electron rest mass
rel_tote = totE/(e_charge)


rel_e = [rel_kine, rel_tote]
return, rel_e

END