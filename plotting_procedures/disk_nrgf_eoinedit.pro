function disk_nrgf_eoinedit, imgs, hdrs, bgm, bgstd, htrange

	ress=double(imgs)
	
	for i =0, n_elements(hdrs) -1 do begin
	
		;imgs[*,*,i] = filter_image(imgs[*,*,i], fwhm=4.0)
		imgs[*,*,i] = median(imgs[*,*,i], 4)
		
		s=size(imgs[*,*,i])
		crpix1=hdrs[i].crpix1
		crpix2=hdrs[i].crpix2
		pix_size=1.0d ;keyword_set(pix_size)?pix_size:1.
		
		x=(findgen(s[1])-crpix1)*pix_size
		y=(findgen(s[1])-crpix2)*pix_size
		xx=rebin(x,s[1],s[2])
		yy=rebin(reform(y,1,s[2]),s[1],s[2])
		ht0=sqrt(xx^2+yy^2)
		

		if tag_exist(hdrs[0], 'rsun_obs')  then begin
			rsub = where(ht0 le hdrs[i].rsun_obs/hdrs[i].cdelt1)
		
			res = nrgf(imgs[*,*,i], htr=[hdrs[i].rsun_obs/hdrs[i].cdelt1, hdrs[i].naxis1/2.0d], $
				crpix1=hdrs[i].crpix1, crpix2=hdrs[i].crpix2)
			res[where(finite(res, /nan))] =0.0d
			
			tmp = (imgs[*,*,i]-mean(imgs[*,*,i]))/stdev(imgs[*,*,i])
		endif else begin
			rsub = where(ht0 le hdrs[i].rsun/hdrs[i].cdelt1)  ; I think this is for the purposes
			;of EUV images, where on disk the image is just given by temp.
			;Whereas off-disk it's a radial gradient filter. It has no use for
			;coronagraph images.
			
			res = nrgf(imgs[*,*,i], htr=htrange/hdrs[i].cdelt1, $     ;    [(hdrs[i].rsun*2.2)/hdrs[i].cdelt1, hdrs[i].naxis1/2.0d], $
				crpix1=hdrs[i].crpix1, crpix2=hdrs[i].crpix2)
				
				
			res[where(finite(res, /nan))] =0.0d
			
			tmp = (imgs[*,*,i]-mean(imgs[*,*,i]))/stdev(imgs[*,*,i])
		endelse
		

		res[rsub]=tmp[rsub]
		
		ress[*,*,i]=res
		
	endfor
	return , ress

end