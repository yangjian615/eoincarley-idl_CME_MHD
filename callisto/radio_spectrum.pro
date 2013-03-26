pro radio_spectrum,data,time,y,freqsum

sizeData = size(data)
freqsum = fltarr(sizeData[2])

yaxis = sizeData[2] - 1

for i=0,yaxis do begin
	freqsum(i)=mean(data(*,i))
endfor

plot,y,freqsum,/xs,/ys

end