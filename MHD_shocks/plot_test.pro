pro plot_test

cd,'/Users/eoincarley/Tex/plasma_essay/data'
restore,'vary_mach_thetaBn.sav'
array = chi_surface

;set_plot,'ps'
;device,filename = 'vary_thetaVn_thetaBn_mach2_5.ps',/color,/inches,/landscape,/encapsulate,$
;ysize=8,xsize=13,yoffset=13

loadct,1
!p.color=0
!p.background=255
window,xs=1200,ys=600
plot_image,smooth(sqrt(array[0:298,*]),20),xticks=3,yticks=3,xminor=4,yminor=5,xtitle='Alfven Mach Number',$
ytitle='Angle between B and shock normal (degrees)',charsize=1.5,$
position=[0.08,0.15,0.4,0.9],/normal,xticknam=['1','2','3','4'],ytickname=['45','60 ','75 ','90']

loadct,39
contour,sqrt(array[0:298,*]),levels=[1.1,1.2,1.3,1.4,1.5,1.6,1.7,1.8],/overplot,color=240,$
thick=1.5,c_linestyle=2,c_charsize=2,/follow

loadct,1
color_key, range = [ sqrt(min(array)), sqrt(max(array) )],$
charsize=1.5,title='Bandsplitting'

shade_surf,smooth(sqrt(array),10),xticks=3,yticks=3,/xs,/ys,xtitle='Alfven Mach Number',$
ytitle='Angle B,n (degrees)',ztitle='B a n d s p l i t t i n g',ytickname=['45','60','75','90'],$
/normal,/noerase,position=[0.57,0.15,0.99,0.99],charsize=3,ax=50,az=10,xticknam=['1','2','3','4']

;device,/close
;set_plot,'x'

END
 