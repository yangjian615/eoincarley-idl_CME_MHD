pro sdo_nature

cd,'~/Desktop/nature_pics'




;------------------------------------------;
;			  Define Gradient
;
n = 4096
grad2D = fltarr(n, n)
grad1D = dindgen(n)
grad1D = grad1D^(0.1)   ;0.3 is good here
;grad1D = grad1D + 1.4*exp(-dindgen(4096)/100.0)

grad1D = grad1D/max(grad1D)
FOR i=0, n_elements(grad2D[0,*]) -1 DO BEGIN
	grad2D[*, i] = grad1D
ENDFOR
rev_grad2D = reverse(grad2D)

;grad2D[0:256, 0:140] = 0
set_plot, 'ps'
device, filename='cover_shot_negative.eps', /color, /inches, /landscape, /encapsulate, $
yoffset=13, ysize=13, xsize=13
;-------------------------------------------;
;				FIRST IMAGE
; 
file = 'three_col_nrgf_20110922_104048.png'
queryStatus = QUERY_IMAGE(file, imageInfo)

imageSize = imageInfo.dimensions

image171 = READ_IMAGE(file)

image171_0 = transpose(transpose(image171[0,*,*]))*grad2D
image171_1 = transpose(transpose(image171[1,*,*]))*grad2D
image171_2 = transpose(transpose(image171[2,*,*]))*grad2D

image171[0,*,*] = temporary(image171_0)
image171[1,*,*] = temporary(image171_1)
image171[2,*,*] = temporary(image171_2)

imageDims = SIZE(image171, /DIMENSIONS)

interleaving = WHERE((imageDims NE imageSize[0]) AND $
   (imageDims NE imageSize[1])) + 1


DEVICE, DECOMPOSED = 1

;WINDOW, 0, XSIZE = imageSize[0], YSIZE = imageSize[1], $
 ;  TITLE = 'An RGB Image'
TV, image171, TRUE = interleaving[0]


;------------------------------------------;
;			  Define Gradient
;
grad2D = fltarr(n, n)
grad1D = dindgen(n)
grad1D = grad1D/max(grad1D)
FOR i=0, n_elements(grad2D[0,*]) -1 DO BEGIN
	grad2D[*, i] = grad1D
ENDFOR
rev_grad2D = reverse(grad2D)^15.0
rev_grad2D = rev_grad2D*0.7
;-------------------------------------------;
;				SECOND IMAGE
; 
file = 'three_col_diff_nrgf_20110922_104048.png'

queryStatus = QUERY_IMAGE(file, imageInfo)

imageSize = imageInfo.dimensions

image_tri = READ_IMAGE(file)

image_tri_0 = transpose(transpose(image_tri[0,*,*]))*rev_grad2D
image_tri_1 = transpose(transpose(image_tri[1,*,*]))*rev_grad2D
image_tri_2 = transpose(transpose(image_tri[2,*,*]))*rev_grad2D


image_tri[0,*,*] = temporary(smooth(image_tri_0,1))
image_tri[1,*,*] = temporary(smooth(image_tri_1,1))
image_tri[2,*,*] = temporary(smooth(image_tri_2,1))

dist_circle, im, n
mask = 1-im/max(im)
mask = mask^0.3

mask = fltarr(n, n)
index  = circle_mask(mask, 2048, 2048, 'lt', 2305)
mask[index]	= 1.0
;plot_image, mask
;mask[512:1023,*] = 1
;window,2
;plot_image, mask
;stop
image_tri[0,*,*] = image_tri_0*mask
image_tri[1,*,*] = image_tri_1*mask
image_tri[2,*,*] = image_tri_2*mask



imageDims = SIZE(image, /DIMENSIONS)

interleaving = WHERE((imageDims NE imageSize[0]) AND $
   (imageDims NE imageSize[1])) + 1


DEVICE, DECOMPOSED = 1;, retain=2

;WINDOW, 0, XSIZE = imageSize[0], YSIZE = imageSize[1], $
  ; TITLE = 'An RGB Image'
   
image_all = image_tri
image_all[0,*,*] =  image_tri[0,*,*] + image171[0,*,*]
image_all[1,*,*] =  image_tri[1,*,*] + image171[1,*,*]
image_all[2,*,*] =  image_tri[2,*,*] + image171[2,*,*]

;image_all[0,*,*] = 255 - image_all[0,*,*] <255
;image_all[1,*,*] = 255 - image_all[1,*,*] <255
;image_all[2,*,*] = 255 - image_all[2,*,*] <255

TV, image_all, TRUE = interleaving[0];, channel=1
;TV, image_all, TRUE = interleaving[0], channel=2
;TV, image_all, TRUE = interleaving[0], channel=3


;draw_grid, [512,512], [1, 1], /noerase
device,/close
set_plot, 'x'
;x2png,'sdo_tri_comp.png'
END
