function n = getNormVec(Gx, Gy)
    nMag = sqrt(Gx.^2+Gy.^2);
    sizeN = size(Gx);
    sizeN(1,3) = 2;
    n = zeros(sizeN );
    n(:,:,1) = Gx./nMag;
    n(:,:,2) = Gy./nMag;
    n(isnan(n)) = 0;
    