pro mann_freq_dist

; Compute distance versus time for the 20110607 type III event
; Uses relationship between frequency and distance from Mann et al 1999b:
;		"A heliospheric density model and type III radio bursts"
;
;
cd,'/Users/eoincarley/Data/CALLISTO/20110607'

restore,'ft_typeIII_20110607.sav'
print,ft_typeIII

;Convert frequencies to distances
Rsun = 6.955d*(1e8)
mu = 0.6d
G = 6.67384d*(1e-11)
Msun=1.9891d*(1e30)
kb=1.380648d*(1e-23)
T=1e5
mH = 1.660538e-27
A = (mu*mH*G*Msun)/(kb*T)
R = dblarr(n_elements(ft_typeIII[1,*]))

R[*] = Rsun/(1 +(2*Rsun/A)*alog(ft_typeIII[1,*]/644))

print,R

END