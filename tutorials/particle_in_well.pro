pro particle_in_well

close,/all
data = dblarr(1000)
openr,1,'Psi.dat'
readf,1,data     
plot,data
close,/all

END