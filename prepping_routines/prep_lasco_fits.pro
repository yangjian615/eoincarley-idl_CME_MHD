pro prep_lasco_fits

; Reduce all lasco fits in current directory to level 1

files = findfile('*.fts')
FOR i=0, n_elements(files)-1 DO BEGIN
	print,'Prep image: '+files[i]
	reduce_level_1, files[i], savedir='L1'
ENDFOR	
print,' '
print,'Finsihed!'
print,' '
END