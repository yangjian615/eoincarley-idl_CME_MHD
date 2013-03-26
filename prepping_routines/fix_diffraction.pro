pro fix_diffraction

files = findfile('*.fts')

pre = sccreadfits(files[5],he_pre)
data = sccreadfits(files[11],he)

;----------- remove nans --------------
remove_nans, pre, junk, junk, nan_pos
pre[nan_pos[*]] = 0.0
remove_nans, data, junk, junk, nan_pos
data[nan_pos[*]] = 0.0


window,1
img = data - pre
fft_image, img, he, img_fft
img_norm = (img_fft)/stdev(img_fft)
plot_image,  sigrange(img_norm)

mask = fltarr(he.naxis1, he.naxis2)
		mask[*,*] = 1.0
		rsun = he.rsun
		pixrad=rsun/he.CDELT1
		sun = scc_SUN_CENTER(he)
		IF he.detector eq 'COR1' THEN r_outer = 3.1
		IF he.detector eq 'COR1' THEN r_inner = 5.0
		
		
		index_outer = circle_mask(mask, sun.XCEN, sun.YCEN, 'le', pixrad*r_outer)
		mask[index_outer] = 0.0
		index_outer = circle_mask(mask, sun.XCEN, sun.YCEN, 'ge', pixrad*r_inner)
		mask[index_outer] = 0.0

img_fft = img_fft*mask

index = where(img_fft eq 0.0)
img_fft[index] = mean(img)
loadct,0
img_new = img - img_fft
img_new = img_new/stdev(img_new)

mask[*,*] = 1.0
		rsun = he.rsun
		pixrad=rsun/he.CDELT1
		sun = scc_SUN_CENTER(he)
		IF he.detector eq 'COR1' THEN r_outer = 1.6
		IF he.detector eq 'COR1' THEN r_inner = 4.7
		
		
		index_outer = circle_mask(mask, sun.XCEN, sun.YCEN, 'le', pixrad*r_outer)
		mask[index_outer] = 0.0
		index_outer = circle_mask(mask, sun.XCEN, sun.YCEN, 'ge', pixrad*r_inner)
		mask[index_outer] = 0.0
plot_image, sigrange(img_new)*mask > (-1.0), xstyle=4, ystyle=4

tvcircle, (he.rsun/he.cdelt1), sun.XCEN, sun.YCEN, 254, /data,color=255,thick=1

;-------------Do a 1D FFT-------------


stop
END

;*******************FFT_IMAGE*******************

pro fft_image, image, he, inverseTransform

;------------ FFT -------------------
fft_pre = fft(image,/center)
powerSpectrum = ABS(fft_pre)^2.0
scaledPowerSpect = ALOG10(fft_pre)

;------------- Scale the noise out -----------
scaledPS0 = scaledPowerSpect - MAX(scaledPowerSpect)
scaledPS0 = scaledPS0*masks_for_fft(he) ;remove this to see normal FFT and inverse result
window,10,xs=700, ys=700
plot_image,scaledPS0

print,'Enter Scaling cut-off: '


mask = REAL_PART(scaledPS0) GT -2.8
maskedTransform = fft_pre*mask

;----------- Perform inverse --------------
inverseTransform = REAL_PART(FFT(maskedTransform, $
   /INVERSE, /CENTER))
   
END   

