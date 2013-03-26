function sector_increase,R1,R2,T1,T2

;img must be a fits file of grams per pixel


mass1 = 0
mass2 = 1
img = sccreadfits('mass_image.fts',ha)

WHILE (mass1 le mass2) DO BEGIN
    
    
    R2 = R2 + 0.05
    mass1 = mass2
    mass2 = massCalculator(img,ha,/sector,radii = [R1,R2], angles = [T2,T1])
    ;print,mass1
    ;print,mass2
END    

print,'Maximum Mass occurs at' + string(R2)
print,'Maximum mass is' + string(mass1)

END
