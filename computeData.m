function D = computeData(contour,image)
   [Gxn, Gyn] = imgradientxy(double(contour));
   %% first we need to get the the orothogonal normal vector of the contour
   %% We need it to be orthogonal, that is why we switch gy and gx and make gx negative. 
   n = getNormVec(Gyn, -Gxn);
   
   
   
   [r c channels] = size(image);
   [nr nc nGrad ] = size(n);
   nsSize = [nr nc channels nGrad];
   ns = zeros(nsSize);
   Gy = zeros(r,c,channels,'double' );  
   Gx = zeros(r,c,channels,'double' );  

   for channel = 1:channels
   Gx = zeros(r,c,channels,'double' );  
   %% get the orthogonal gradient of the image
    [Gx(:,:,channel), Gy(:,:,channel)] = imgradientxy(double(image(:,:,channel)));
    ns(:,:,channel,:) = n; 
   end
    %%  make orthogonal
   temp = Gx;
   Gx = Gy;
   Gy = -temp;
   D=  sum(abs(Gx.*ns(:,:,:,1)+Gy.*ns(:,:,:,2)),3) ;
   D = D / (255*3);
   D(~contour) = 0;
   
   