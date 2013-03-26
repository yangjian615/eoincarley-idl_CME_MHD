; Quick routine to produce a single save file containing the relevant info for Eoin

pro eoin_event_info

; 211A passband data for three arcs; 130, 140 & 150 degrees.

  set_line_color

  restore, 'CorPITA_pulse_params_211_130.sav'
  
  utplot, t_sec[min_val[loc[13],13]:max_val[loc[13],13]], top_parameters[1, 13, min_val[loc[13],13]:max_val[loc[13],13]]/(!dtor*696.), $
          time[0], title = '211A', ytit = 'Position Angle (Degrees)', charsize = 1.5, psym = 2, /xs, $
          xrange = [-10., max(t_sec)+10.], yr = [0, 100.], /ys, color = 0, background = 1
  
  restore, 'CorPITA_pulse_params_211_140.sav'  
  outplot, t_sec[min_val[loc[14],14]:max_val[loc[14],14]], top_parameters[1, 14, min_val[loc[14],14]:max_val[loc[14],14]]/(!dtor*696.), time[0], psym = 2, color = 3

  restore,'CorPITA_pulse_params_211_150.sav' 
  outplot, t_sec[min_val[loc[15],15]:max_val[loc[15],15]], top_parameters[1, 15, min_val[loc[15],15]:max_val[loc[15],15]]/(!dtor*696.), time[0], psym = 2, color = 5

  al_legend, ['130', '140', '150'], textcolor = [0,3,5], /bottom, /right, charsize = 1.5, outline_color = 1

stop



end
