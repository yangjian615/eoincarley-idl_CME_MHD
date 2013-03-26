pro plasma_essay
chi=dindgen(101)*((20+20)/100.)-20.
y[*] = (2.0*(2.0-gam)*chi[*]^2.0)+((2.0*beta+(gam-1)*beta*M^2.0+2)*gam*chi[*])-(gam*(gam+1)*beta*M^2.0)
plot,chi,y
END