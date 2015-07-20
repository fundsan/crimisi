function returnImage = crimisi(image, mask, patchK)
    [ y x z ] = size(image);
    logiMask = logical(mask);
    returnImage = image;
    for channel = 1:z
        returnImageChannel = returnImage(:,:,channel);
        returnImageChannel(logiMask) = 0;
        returnImage(:,:,channel) = returnImageChannel;
    end    
   
    i = (patchK-1)/2;
    %% initialize the confidence values
    C = double(~logical(mask));
    while sum(logiMask(:) ) > 0
        absC = abs(1-C);
        sum(logiMask(:)) 

       %% if sum(absC(:)) <  1.7717e+03
         %%  sum(absC(:)) 
        %%end
        
        %% new contour 
        contour = getContour(logiMask);
        notContourOmega = ~contour&logiMask;
        %% compute priorites
        %% compute only the contour priorties ( these computes all values
        %% for now but all other values should be zeros
        C = computeConfidence(C,patchK);
        C(notContourOmega) = 0;
        C(~logiMask)=1;
        D =computeData(contour,image);
        P = C.*D;
        P(~contour) = 0;
        P(contour) = P(contour)+.00001;
        [m ip ] = max(P(:));
        [ py,px] = ind2sub(size(P),ip);
        
        [patchp, patchpMask] = getPatch(returnImage,px,py,patchK,logiMask);
        ssd1 = getSSDForPatch(patchp,returnImage,patchpMask);
        ssd1(logiMask) = inf;
        [M, I ] = min(ssd1);
        [rr, rc, rchannel] = size(returnImage);
        [qy,qx] = ind2sub([rr rc],I);
        
        [patchq, patchqMask] = getPatch(image,qx,qy,patchK,logiMask);
        [ y x z ] = size(image);
        [r, c, channels] = size(image);
    
    right = px +i;
    left = px - i;
    up = py -i;
    down = py +i;

    if left < 1
       
        left = 1;
        
    end
    
     if right >  x
         right = x;
     end
     if up < 1 
         up =1;
     end
     if down > y
         down = y;
     end
    [pr pc pi] = size(returnImage(up:down,left:right,:));
    patchq(~patchpMask) = patchp(~patchpMask);
   %% returnImage(up:down,left:right,:) = patchq(1:pr,1:pc,1:pi);
    C(up:down,left:right) = 1;
    logiMask(up:down,left:right) =0;
    end
        