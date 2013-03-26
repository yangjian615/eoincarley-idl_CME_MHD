function get_suncen, hdr

       xx = ((hdr.naxis1 - 1.0d)/2.0d) +  (hdr.xcen/hdr.cdelt1)
       yy = ((hdr.naxis2 - 1.0d)/2.0d) +  (hdr.ycen/hdr.cdelt2)

       return, {xcen:xx, ycen:yy}
end