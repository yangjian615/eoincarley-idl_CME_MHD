pro fft_aperture, npoints

N = npoints
grid = fltarr(N, N)
index = circle_mask(grid, N/2.0, N/2.0, 'le', 50.0)
grid[index]=1
ap = 1.0 - grid
window,0
plot_image, ap


beam = fft(ap, /center)
window,1
plot_image, beam^0.1, charsize=1.0


END