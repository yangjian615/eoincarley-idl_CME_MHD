pro get_height,frequency,fold,height

;convert to density

e_density = (frequency/8982)^2

;models to convert to height
N0 = 4.2e4
height = fold*4.32*(  1/alog(e_density/N0) )

print,'Using the'+fold+'Newkirk desnity model,'+frequency+'MHz corresponds to'$
+height+'Solar radii'
end