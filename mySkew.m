function [sk] = mySkew(in);
%H1 Line -- computation of skewness
%Help Text -- in must be one vector
%Laurence Chaput-Desrochers
%september 6th 2013

%MAIN PROGRAM
%**************************************************************************
long        = length(in);
samplemean  = mean(in);                 %sample mean
cubic_diff  = (in - samplemean).^3;     %cubic difference to mean
square_diff = (in - samplemean).^2;     %square difference to mean
variance    = sum(square_diff) / (long - 1);
standardev  = sqrt(variance);
sk          = (long * sum(cubic_diff)) / ((long - 1) * (long - 2) * (standardev^3));
%**************************************************************************
end%end of mySkew function