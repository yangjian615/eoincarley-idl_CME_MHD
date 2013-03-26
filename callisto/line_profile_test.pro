pro line_profile_test

dat = dblarr(500,500)
dat[200:300,200:300]=1
plot_image,dat

point,x,y


x1=x[0]
x2=x[1]

y1=y[0]
y2=y[1]
nPoints = ABS(x2-x1+1) > ABS(y2-y1+1)

xloc = x1 + (x2 - x1) * Findgen(nPoints) / (nPoints - 1)
yloc = y1 + (y2 - y1) * Findgen(nPoints) / (nPoints - 1)

profile = Interpolate(dat, xloc, yloc)



stop
END