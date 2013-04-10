pro simulate_dirty_beam

;-------- Define Telescope Positions ------------;
pos = dblarr(100,100)

FOR i =10, 80, 5 DO BEGIN
	pos[50, i] = 1.0
	pos[i,80] = 1.0
ENDFOR

plot_image, pos


;------- Derive UV sampling -----------;

indices  = where(pos gt 0.0)
posxy = array_indices(pos, indices)

npoints = n_elements(indices);n_elements(posxy[*,*])
points = dindgen(npoints)

combos = dblarr(2, npoints*(npoints-1.0)/2.0 )
count=0

;-------- Produce Unique Combinations of Points -----------;
FOR i = 0, n_elements(points)-1 DO BEGIN
	a = points[i]	
	FOR j=0, n_elements(points)-1 DO BEGIN
		b = points[j]
		set = [a,b]
		indices = sort(set)
		set0 = set[indices[0]]
		set1 = set[indices[1]]
		set = [set0,set1]
		
		IF set0 ne set1 THEN BEGIN
			FOR k=0, n_elements(combos[0,*])-1 DO BEGIN
				IF combos[0,k] eq set[0,0] and combos[1,k] eq set[1,0] THEN BEGIN
	   		    	found_a_match=1
	   		    	BREAK
	   			ENDIF ELSE BEGIN
	   				found_a_match=0
	   			ENDELSE	
			ENDFOR
			IF found_a_match eq 0 THEN BEGIN
	   			combos[*,count] = set
	   			count=count+1
			ENDIF
		ENDIF
	ENDFOR	
ENDFOR

;--------
Bx = dblarr(n_elements(combos[0,*]))
By = dblarr(n_elements(combos[0,*]))
FOR i=0, n_elements(combos[0,*])-1 DO BEGIN
	Bx[i] = posxy[0, combos[0,i]] - posxy[0, combos[1,i]]
	By[i] = posxy[1, combos[0,i]] - posxy[1, combos[1,i]]
ENDFOR	




;UV coverage
u = dblarr(n_elements(By))
v = dblarr(n_elements(By))
h = !DTOR*0.0
d = !DTOR*10.0
lam=2.0
u[*] = (sin(h)*Bx[*] + cos(h)*By[*])/lam
v[*] = (-1.0*sin(d)*cos(h)*Bx[*] + sin(d)*sin(h)*By[*])/lam

uv_plane = dblarr(40,40)

plot_image,uv_plane
plots,u+40,v+5, /data, psym=1

;uv_plane = 

stop
END