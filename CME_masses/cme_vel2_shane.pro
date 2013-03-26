function cme_vel2_shane, r, p, aa, bb
       ; Set trial values for solarwind speed, gamma and beta
       w0 = p[0]       ; assymptoic solar wind speed m/s
       v0 = double(p[1]) ; CME velocity m/s
       alph = p[3] ;1/s
       bet = p[4]

       ;Set up some initial stadard paramateres
       rs=6.95508*(10.0d^(5.0d))       ;km
       ;R1 = linspc(p[2], 200, 10000.0) ; Sample point in R_sun
       ;R1 = p[2]
       r1=r
       rkvlin = dblarr(10001, 1)
       rkvlin[0] = v0


       t1 = dblarr(10001,1)
       t2 = dblarr(10001,1)

       ;4th order runge-kutta
       for i =0, 9998 do begin
               h = r1[i+1] - r1[i]

;********************Runge-Kutta Ks*********************

               k0 = ( rs * alph * (R1[i]^(double(bet))) * (1.0d/rkvlin[i,0])*abs(rkvlin[i,0] - (solwin(w0, R1[i]) ) )^P[5] )
               
               k1 = ( rs * alph * ((R1[i]+(h/2.0))^(double(bet))) *$
(1.0d/(rkvlin[i,0]+(h/2.0d)*k0)) * abs((rkvlin[i,0]+(h/2.0d)*k0) - (solwin(w0, R1[i]+(h/2.0)) ) )^P[5] )
               
               k2 = ( rs * alph * ((R1[i]+(h/2.0))^(double(bet))) *$
(1.0d/(rkvlin[i,0]+(h/2.0d)*k1)) * abs((rkvlin[i,0]+(h/2.0d)*k1) - (solwin(w0, R1[i]+(h/2.0)) ) )^P[5] )
               
               k3 = ( rs * alph * ((R1[i]+h)^(double(bet))) *$
(1.0d/(rkvlin[i,0]+(h*k2))) * abs((rkvlin[i,0]+(h*k2)) - (solwin(w0,R1[i]+h)) )^P[5] )

;********************************************************



               if ( max(where(finite([k0, k1, k2, k3]) eq 0)) ne -1) then return, 0

               if ( rkvlin[i,0] - solwin(w0, R1[i])  gt 0.0d) then begin
                       rkvlin[i+1] = rkvlin[i] - h*((k0+2*k1+2*k2+k3)/6)*!dpi
               endif else begin
                       rkvlin[i+1] = rkvlin[i] + h*((k0+2*k1+2*k2+k3)/6)*!dpi
               endelse

               t1[i] = ( rs * alph * (R1[i]^(double(bet))) + rs * alph *((R1[i]+(h/2.0))^(double(bet))) +$
               rs * alph *((R1[i]+(h/2.0))^(double(bet))) + rs * alph *((R1[i]+h)^(double(bet))) )/6.0
               
               
               t2[i] = (1- (solwin(w0, R1[i])/rkvlin[i,0] ) )*abs(rkvlin[i,0] -solwin(w0, R1[i]) ) $
               + (1- (solwin(w0,R1[i]+(h/2.0))/(rkvlin[i,0]+(h/2.0)*k0) ))*abs((rkvlin[i,0]+(h/2.0)*k0) $
               - solwin(w0, (R1[i]+(h/2.0))) ) + $
               (1-(solwin(w0, R1[i]+(h/2.0))/(rkvlin[i,0]+(h/2.0)*k1) ))*abs((rkvlin[i,0]+(h/2.0)*k1) - $
               solwin(w0, (R1[i]+(h/2.0))) ) + (1-(solwin(w0, R1[i]+h)/(rkvlin[i,0]+(h*k2)) ) )*abs((rkvlin[i,0]+(h*k1))$
				- solwin(w0, (R1[i]+h)) )

       endfor

       aa=t1
       bb=t2
       ;out = INTERPOLATE( rkvlin, r)
       LINTERP, r1, rkvlin, r, newv

       return, newv

end

function solwin, sws, R
       return, sws*sqrt( 1.0 - exp(-1.0d*( (R-2.8d)/8.1d)) )
end