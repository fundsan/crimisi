function ssdImage = getSSDForPatch(patch,image,patchMask)
   %% we want the part inside the mask to be computed as that will
   %% make the minimum patch look more like the part that we want to get rid of 
    patch(logical(patchMask)) = 0;
    [pRow pColumn pChannel] = size(patch);
    [iRow iColumn iChannel] = size(image);
     ipr = (pRow-1)/2;
     ipc = (pColumn-1)/2;
     paddedImage = zeros(iRow+pRow-1,iColumn+pColumn-1, iChannel);
     paddedImage(ipr+1:ipr+iRow, ipc+1:iColumn+ipc,:) = image;
     paddedImage(1:ipr,ipc+1:iColumn+ipc,:) =image(abs(-(ipr):-1),:,:);
     paddedImage(ipr+iRow+1:iRow+pRow-1 ,ipc+1:iColumn+ipc, :) = image(abs(-(iRow):-(iRow-ipr+1)),:,:);     
     paddedImage(ipr+1:iRow+ipr,1:ipc,:) =image(:,abs(-(ipc):-1),:);
     paddedImage(ipr+1:iRow+ipr,ipc+iColumn+1:iColumn+pColumn-1,:) =image(:,abs(-(iColumn):-(iColumn-ipc+1)),:); 
     bigColumnList = zeros(pRow* pColumn*iChannel, iRow* iColumn, 'double');
     
     for channel = 1:iChannel
         columns = im2col(paddedImage(:,:,channel), [pRow pColumn]);
         %% 0 out the places where the patch is 0 as well
         columns(logical(patchMask(:)),:) = 0;
         bigColumnList((channel-1)*(pRow* pColumn)+1:(channel)*(pRow* pColumn),:) = columns;
        
         
     end
     patchColumn = patch(:);
     ssdImage = sum(bsxfun( @minus, double(patchColumn),bigColumnList ),1).^2;
     
     