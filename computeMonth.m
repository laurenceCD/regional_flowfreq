function [dat] = computeMonth(dat);
%H1 Line -- compute the percentage of flood occuring in each month
%Help Text --
%Laurence Chaput-Desrochers
%September 6th 2013

%MAIN PROGRAM
%**************************************************************************
nbDat = size(dat,1);
mm    = [1:12];
for n = 1:nbDat;%loop of all files
    monthPercent = zeros(12,1);                         %empty matrix to store percent
    monthVec    = dat(n,1).date_vector_formated(:,2);  %month where max occurs
    long         = length(monthVec);
    for k = 1:12%loop of all month
        g = find(monthVec == k);
        if isempty(g);
            monthPercent(k) = 0;
            continue
        end
        monthPercent(k) = length(g) / long;
    end%end of loop k
dat(n,1).percentMonth = [mm',monthPercent];
end%end of loop n
%**************************************************************************
end%end of function computeMonth