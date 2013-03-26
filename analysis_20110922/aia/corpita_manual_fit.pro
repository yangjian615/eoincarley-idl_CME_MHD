; Routine to allow manual confirmation of pulse location and
; fitting. This is useful for ensuring that the algorithm has
; identified and fitted the correct feature.

pro corpita_manual_fit, date = date, passband = passband, first_go = first_go, $
                        tog = tog, plot_all = plot_all

  savedir = './test_cor_pita' ;2011-Feb-16
  if n_elements(date) eq 0 then date = '2011/02/16'
  if n_elements(passband) eq 0 then passband = '193'
  tilt_deg = findgen(36)*10.

  cor_pita_trigger, x_A, y_A, t_start, date = date, a = a, b = b

  case passband of
     '193': t_range = [date+'T14:27:07', date+'T14:38:00']
     '211': t_range = [date+'T14:27:02', date+'T14:39:36']
     '304': t_range = [date+'T14:28:44', date+'T14:39:56']
     '335': t_range = [date+'T14:27:03', date+'T14:39:51']
  endcase
     
  data_loc = './*.fits'

; Get the time of each image using the headers
  fls = file_search(data_loc)
  mreadfits_header, fls, index_arr, only_tags='date-obs,exptime'
  good_imgs = where(index_arr.exptime gt 0.5)
  file_list = fls[good_imgs]
  test_time = strarr(n_elements(file_list))

  for i=0,n_elements(file_list)-1 do test_time[i] = StrMid(time2file(index_arr[good_imgs[i]].date_d$obs, /sec), 9, 6)

  file_time = anytim(index_arr[good_imgs].date_d$obs)
  loc_lwr = min(abs(file_time - anytim(t_range[0])), f_lwr)
  loc_upr = min(abs(file_time - anytim(t_range[1])), f_upr)

; Which arc we want to study
  i_ang = 35

; Identify base image for de-rotating map later.
  loc_base = min(abs(file_time - anytim(t_start)), f_base)
  aia_prep, file_list[f_base], -1, index, data, /uncomp_delete
  index2map, index, data/index.exptime, map0, outsize = [2048, 2048]
  data = 0.

  if keyword_set(first_go) then begin
     
     !p.multi = 0

     for j = f_lwr, f_upr do begin
        
; Restore the intensity profile.  
        restore, savedir+'/CorPITA_profile_'+time2file(date, /date_only)+'_'+passband+'_SDO_'+test_time[j]+'.sav'
        t_img = anytim(date+' '+anytim(image_time, /yohkoh, /time_only), /sec)
        
; Only looking at positive intensities
        p_pos = pbd_av_inten[i_ang, *]*(pbd_av_inten[i_ang, *] ge 0)
        
; Blind estimates for fit to profile; First time estimates are
; manually defined then take the previous iteration as a start point. 
        if j eq f_lwr then begin
           est_peak = 100.
           est_mean = grt_dist_all[i_ang, 10]
           est_width = grt_dist_all[i_ang, 2]
           mean_min = 0.
           mean_max = max(grt_dist_all[i_ang,*])
        endif else begin
           est_peak = peak_val
           est_mean = mean_val
           est_width = width_val
           mean_min = 0.
           mean_max = max(grt_dist_all[i_ang,*])
        endelse
        
        peak_min = 0.1
        peak_max = max(p_pos)*1.1
        width_min = 0.
        width_max = (max(grt_dist_all[i_ang,*]))/2.
        
; Recall point for repeat line fitting. 
        confirm_count = 0.
        rep_fit:
        
        est_pbd = [est_peak, est_mean, est_width]
        
; Set limits. Peak and width must be greater than 0.1, mean must be
; defined for each event to be greater than some value.
        pi = replicate({fixed:0, limited:[0,0], limits:[0.D,0.D]},3)
        pi(0).limited(0) = 1
        pi(0).limits(0) = peak_min
        pi(0).limited(1) = 1
        pi(0).limits(1) = peak_max
        
        pi(1).limited(0) = 1
        pi(1).limits(0) = mean_min
        pi(1).limited(1) = 1
        pi(1).limits(1) = mean_max
        
        pi(2).limited(0) = 1
        pi(2).limits(0) = width_min
        pi(2).limited(1) = 1
        pi(2).limits(1) = width_max
        
        fit = mpfitpeak(grt_dist_all[i_ang,*], p_pos, a, error =  pbd_av_int_err[i_ang, *], quiet = 0, nterms = 3, parinfo = pi, $
                        estimates = est_pbd, perror = perr, bestnorm = bestnrm)
        
        dof = n_elements(grt_dist_all[i_ang,*]) - n_elements(a)
        pcerr = perr*sqrt(bestnrm/dof)
        
; Plot the intensity profile image
        
        set_line_color  
        plot, grt_dist_all[i_ang,*], pbd_av_inten[i_ang,*], color = 0, background = 1, $
              xr = [0,max(grt_dist_all)], yr = [-50, 100], /xs, /ys, xtit = 'Grt. circle dist. (Mm)', $
              ytit = '% Intensity', charsize = 1.5, charthick = 1
        
; Plot the zero line.     
        plots, [0, max(grt_dist_all[i_ang,*])], [0,0], linestyle = 2, color = 0
        
; Plot the fits to the data     
        x = findgen(max(grt_dist_all[i_ang,*]))
        if confirm_count eq 0 then begin
           oplot, x, gauss1(x, shift(a, -1), /peak), color = 3
           ans = 0
           read, 'Press 1 to fix the fit manually, 0 to exit: ', ans
        endif else begin
           outplot, x, gauss1(x, shift(a, -1), /peak), color = 5
           al_legend, ['Blind fit', 'Human-aided fit'], textcolor = [3,5], /bottom, /left
           ans = 0
           read, 'All ok? Press 0', ans
        endelse
        
        if ans ne 0 then begin
           
           ++confirm_count
           
           box_message, 'Identify the mean of the pulse using the mouse'
           cursor, x0, y0, /data, /down
           print, 'Selected pulse mean = ', x0
           est_mean = x0
           
           box_message, 'Identify the peak of the pulse using the mouse'
           cursor, x0, y0, /data, /down
           print, 'Selected pulse peak = ', y0
           est_peak = y0
           
           box_message, 'Identify the width of the pulse using the mouse (both sides)'
           cursor, x0, y0, /data, /down
           est_width_0 = x0
           cursor, x0, y0, /data, /down
           est_width_1 = x0
           print, 'Selected pulse width positions = ', est_width_0, est_width_1
           
           width = [est_width_0, est_width_1]
           width = width[sort(width)]
           est_width = (width[1]-width[0])/2.
           
           mean_min = est_mean - (grt_dist_all[i_ang,2]-grt_dist_all[i_ang,0])
           mean_max = est_mean + (grt_dist_all[i_ang,2]-grt_dist_all[i_ang,0])
           peak_min = est_peak*0.7
           peak_max = est_peak*1.4
           width_min = 0.
           width_max = (width[1]-width[0])
           
           goto, rep_fit
           
        endif
        
        peak_val = a[0]
        mean_val = a[1]
        width_val = a[2]
        values = [a[0], pcerr[0], a[1], pcerr[1], a[2], pcerr[2]]
        if j eq f_lwr then val_arr = values else val_arr = [[val_arr], [values]]
        
     endfor

     save, filename = time2file(date, /date_only)+'_'+passband+'_manual_fit_peak_'+peak_no+'_'+num2str(i_ang)+'.sav', $
           val_arr, grt_dist_all
     
  endif

; Identify optimal pulse

  t_sec = file_time - file_time[0]
  n_elems = n_elements(file_time)

; Define function for mpfit
  funct_quad = 'p[0] + p[1]*x + (1./2.)*p[2]*x^2.'
  funct_lin = 'p[0] + p[1]*x'
  
; Restore peak fit parameters

  restore, time2file(date, /date_only)+'_'+passband+'_manual_fit_peak_1_'+num2str(i_ang)+'.sav'
  val_arr_1 = val_arr
  grt_dist_1 = grt_dist_all

;; Plot map and kinematics using Z-buffer; date-specific

  aia_prep, file_list[f_lwr+25], -1, ind, dat, /uncomp_delete
  index2map, ind, dat/ind.exptime, map, outsize = [2048, 2048]
  rmap = drot_map(map, time = index_arr[f_base].date_d$obs, rsun = map0.rsun, l0 = map0.l0, b0 = map0.b0)

  mask = map
  mask.data[where(rmap.data eq 0.)] = 1.
  mask.data[where(rmap.data gt 0.)] = 0.
  rmap.data = rmap.data + map.data*mask.data

  bd_map = diff_map(rmap, map0)
  pbd_map = bd_map
  pbd_map.data = (bd_map.data/map0.data)*100.0d
  add_prop,pbd_map,ratio=get_map_time(bd_map)+'/'+get_map_time(map0)
  pbd_map = rebin_map(pbd_map,1024,1024)

  if keyword_set(tog) then begin
     toggle, filename = 'AIA_EIS_pulse_'+time2file(date, /date_only)+'_'+passband+'.eps', xs = 6, ys = 3, /inches, /landscape, /color
     chrs = 1.2
     bckgrnd = 1
     txtclr = 0
     symsz = 0.7
  endif else begin
     window, xs = 1000, ys = 500
     chrs = 2
     bckgrnd = 0
     txtclr = 1
     symsz = 1
  endelse
  !p.multi = [0, 1, 3]

  loadct, 0, /silent
  plot_map, pbd_map, /isotropic, pos = [0.1, 0.1, 0.5, 0.95], charsize = chrs, dmin = -50, dmax = 50, $
            title = '!6Passband = '+passband, /limb
 
  restore, 'eis_params_20110216.sav'
 
  set_line_color
  
  restore, savedir+'/cor_pita_mask_'+time2file(date, /date_only)+'_SDO_'+num2str(fix(tilt_deg(i_ang)))+'.sav'
  ptr_free, mask
  
  set_line_color
  oplot, arc_x[0,0:ind_lon[0]], arc_y[0,0:ind_lon[0]], color = 5, thick = 2
  oplot, arc_x[10,0:ind_lon[10]], arc_y[10,0:ind_lon[10]], color = 5, thick = 2
  
  plots, [x_arc[0], x_arc[0]], [y_arc[0], y_arc[511]], color = 3, thick = 2
  plots, [x_arc[39], x_arc[39]], [y_arc[0], y_arc[511]], color = 3, thick = 2

; Pulse kinematics

; The limits of the identified indices. In a lot of cases we'll
; need to manually define when the pulse starts and stops. This should
; be automatic, but I haven't gotten around to writing that yet.
  if passband eq '193' then pr_1 = [0,n_elements(val_arr_1[2,*])-1]
  if passband eq '211' then pr_1 = [0,61]
  if passband eq '304' then pr_1 = [5,45]

  dist_1 = reform(val_arr_1[2,pr_1[0]:pr_1[1]])
  dist_err_1 = reform(val_arr_1[3,pr_1[0]:pr_1[1]])
  width_1 = reform(val_arr_1[4,pr_1[0]:pr_1[1]])
  width_err_1 = reform(val_arr_1[5,pr_1[0]:pr_1[1]])

  chk_err_1 = where(dist_err_1, c_1)
  if c_1 ne n_elements(dist_err_1) then dist_err_1[where(dist_err_1 eq 0)] = 1.
  if max(dist_err_1) gt 1000. then dist_err_1[where(dist_err_1 gt 1000)] = 1.
  chk_err_1 = where(width_err_1, c_1)
  if c_1 ne n_elements(width_err_1) then width_err_1[where(width_err_1 eq 0)] = 1.
  if max(width_err_1) gt 500. then width_err_1[where(width_err_1 gt 500)] = 1.

  time = t_sec[f_lwr:f_upr]

  utplot, time[pr_1[0]:pr_1[1]], dist_1, file_time[0], title = '', ytit = 'Dist. [Mm]', charsize = chrs, symsize = symsz, $
          color = txtclr, background = bckgrnd, psym = 1, /xs, xtitle = ' ', xtickname = [replicate(' ', 10)], $
          xrange = [time[pr_1[0]], max([time[pr_1[1]], time[pr_2[1]]])], yr = [0, 1.3*max(dist_1)], /ys, pos = [0.57, 0.505, 0.99, 0.9]
  uterrplot, time[pr_1[0]:pr_1[1]], dist_1 + dist_err_1, dist_1 - dist_err_1, color = txtclr

  plots, [time[pr_1[0]], max([time[pr_1[1]]])],[grt_dist_all[35,13], grt_dist_all[35,13]], linestyle=2,color=txtclr
  plots, [time[pr_1[0]], max([time[pr_1[1]]])],[grt_dist_all[35,31], grt_dist_all[35,31]], linestyle=2,color=txtclr

  fit_quad_1 = mpfitexpr(funct_quad, time[pr_1[0]:pr_1[1]]-time[0], dist_1, dist_err_1, start_params = [dist_1[0], 10., 10.], $
                       bestnorm = bstnrm_q1, perror = perr_q1, /nan, quiet = 1)
  dof_1 = n_elements(time[pr_1[0]:pr_1[1]]) - n_elements(fit_quad)
  pcerr_q1 = perr_q1 * sqrt(bstnrm_q1 / dof_1)
  bestnorm_quad_1 = bstnrm_q1
  x1 = dindgen(t_sec[f_lwr+pr_1[1]]-t_sec[f_lwr])
  outplot, x1+t_sec[f_lwr], (fit_quad_1[0]+fit_quad_1[1]*x1+(1./2.)*fit_quad_1[2]*x1^2.), linestyle = 0, color = txtclr
  
  al_legend, [' V!D0!N = '+num2str(round(fit_quad_1[1]*1e3))+' !9+!6 '+num2str(round(pcerr_q1[1]*1e3))+' kms!u-1!n', $
              ' A!D0!N = '+num2str(round(fit_quad_1[2]*1e6))+' !9+!6 '+num2str(round(pcerr_q1[2]*1e6))+' ms!u-2!n'], $
             /top, /left, charsize = chrs/2.5, textcolor = txtclr, box = 1, background_color = bckgrnd, linestyle = [0,0]
  
; Variation in pulse width
  utplot, time[pr_1[0]:pr_1[1]], width_1, file_time[0], title = '', ytit = 'Width [Mm]', charsize = chrs, color = txtclr, $
          background = bckgrnd, psym = 1, /xs, pos = [0.57, 0.1, 0.99, 0.495], symsize = symsz, $
          xrange = [time[pr_1[0]], max([time[pr_1[1]], time[pr_2[1]]])], yr = [0, 1.3*max(width_1)], /ys
  uterrplot, time[pr_1[0]:pr_1[1]], width_1 + width_err_1, width_1 - width_err_1, color = txtclr

  fit_line_1 = mpfitexpr(funct_lin, time[pr_1[0]:pr_1[1]]-time[0], width_1, width_err_1, start_params = [width_1[0], 10.], $
                       bestnorm = bstnrm_l1, perror = perr_l1, /nan, quiet = 1)
  dof_1 = n_elements(time[pr_1[0]:pr_1[1]]) - n_elements(fit_line_1)
  pcerr_l1 = perr_l1 * sqrt(bstnrm_l1 / dof_1)     
  bestnorm_lin_1 = bstnrm_l1
  outplot, x1+t_sec[f_lwr], (fit_line_1[0]+fit_line_1[1]*x1), linestyle = 0, color = txtclr

  al_legend, ['d!4r!6/dt = '+num2str(round(fit_line_1[1]*1e3))+' !9+!6 '+num2str(round(pcerr_l1[1]*1e3))+' kms!u-1!n'], $
             /top, /left, charsize = chrs/2.5, textcolor = txtclr, box = 1, background_color = bckgrnd, linestyle = [0]
  
  if keyword_set(tog) then toggle
  
  save, filename = 'AIA_EIS_kins_'+time2file(date, /date_only)+'_'+passband+'.sav', dist_1, dist_2, dist_err_1, dist_err_2, $
        file_time, fit_line_1, fit_line_2, fit_quad_1, fit_quad_2, f_base, f_lwr, f_upr, grt_dist_1, grt_dist_2, pcerr_l1, $
        pcerr_l2, pcerr_q1, pcerr_q2, time, pr_1, pr_2, val_arr_1, val_arr_2, width_1, width_2, width_err_1, width_err_2, x1, x2


  if keyword_set(plot_all) then begin

     !p.multi = 0
     set_line_color
     restore, 'AIA_EIS_kins_'+time2file(date, /date_only)+'_193.sav'
     time_193 = file_time
          
     utplot, time_193[pr_1[0]:pr_1[1]]-time_193[0], dist_1, time_193[0], title = '', ytit = 'Dist. [Mm]', charsize = chrs, symsize = symsz, $
             color = txtclr, background = bckgrnd, psym = 1, /xs, $;xtitle = ' ', xtickname = [replicate(' ', 10)], $
             xrange = [time_193[pr_1[0]]-time_193[0], max([time_193[pr_1[1]]-time_193[0]])], $
             yr = [0, 1.3*max(dist_1)], /ys ;, pos = [0.57, 0.505, 0.99, 0.9]
     uterrplot, time_193[pr_1[0]:pr_1[1]]-time_193[0], dist_1 + dist_err_1, dist_1 - dist_err_1, color = txtclr
   
     restore, 'AIA_EIS_kins_'+time2file(date, /date_only)+'_211.sav'
     time_211 = file_time
     outplot, time_211[pr_1[0]:pr_1[1]]-time_193[0], dist_1, psym = 4, symsize = symsz, color = txtclr
     uterrplot, time_211[pr_1[0]:pr_1[1]]-time_193[0], dist_1 + dist_err_1, dist_1 - dist_err_1, color = txtclr

     restore, 'AIA_EIS_kins_'+time2file(date, /date_only)+'_304.sav'
     time_304 = file_time
     outplot, time_304[pr_1[0]:pr_1[1]]-time_193[0], dist_1, psym = 6, symsize = symsz, color = txtclr
     uterrplot, time_304[pr_1[0]:pr_1[1]]-time_193[0], dist_1 + dist_err_1, dist_1 - dist_err_1, color = txtclr

  endif
     
stop

end
