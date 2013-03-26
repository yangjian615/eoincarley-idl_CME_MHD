pro relativistic_energy

e_mass = 9.10938188D-31  ;kg
e_charge = 1.602D-19	 ;C
c = 2.99792458D8		 ;m/s

rest_E = e_mass*(c^2.0)  ;J


kin_e = rest_E/sqrt(1.0 - 0.18^2.0) - rest_E
print, (kin_e/(e_charge)) / 1.0D3  ;relativistic kinetic eneregy (keV)


totE = rest_E/sqrt(1.0 - 0.18^2.0) 
print, (totE/(e_charge)) / 1.0D3 ;total relativistic eneregy (keV), including electron rest mass


END