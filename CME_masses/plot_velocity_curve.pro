pro plot_velocity_curve

;from Byrne et al. 2010 (Nature Paper)


R = dindgen(1001)*((40.0-7.0)/1000.0)+7

Ra = 8.1
Rb = 2.8
v0= 298.3
v_swind = sqrt(1 - exp(-1.0*(R - Rb)/Ra))

alph = 4.55e-5
bet = -2.02
gam = 2.27

vcme = dindgen(n_elements(R))
;vcme[*] = (-1.0*alph/(gam - bet))*((v_swind[*] - 1)^gam)*R[*]^(gam-bet)


vcme[*] = (-1.0*alph*R^(1-bet) + v_swind[*]*(1-bet))/(1-bet)*( (v_swind[*]+1)/(gam-1) )  ;^((gam-1)/(2-gam))
plot,R,vcme
;plot,R,v_swind

END