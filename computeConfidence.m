function C = computeConfidence(C,K)
   C =  imfilter(C, ones(K,K)/(K*K),'symmetric');
   