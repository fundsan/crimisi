function contour = getContour(imask)
    negMask = double(~imask);
    conv = imfilter(negMask,[1,1,1;1,-8,1;1,1,1],'replicate');
    contour = conv >0 ;
    