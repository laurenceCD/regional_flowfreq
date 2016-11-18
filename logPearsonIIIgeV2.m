function [out,ntable] = logPearsonIIIgeV2(dat,yr)
%H1 Line -- compute log-PearsonIII frequency analysis
%Help text --
%Computing details
%input requirements:
%   dat: must be a 1 colum matrix values to
%        be analyze 
%        Each rows refering to observations
%   yr: is a vector of year      
%output details:
%   out: table (7X3) containning return periods [2,5,10,25,50,100,200]
%                    K factor
%                    computed value for each return period
%Laurence Chaput-Desrochers
%august 9th 2013
%last modification: august 19th 2013

%MAIN PROGRAMM
%**************************************************************************
dat           = [yr,dat];
long          = size(dat,1);                    %number of observations
returnPeriod  = [2 5 10 25 50 100 200]';
out           = zeros(length(returnPeriod),3);  %empty output table
out(:,1)      = returnPeriod;
ntable        = zeros(long,8);                  %create an empty table to put computed values
ntable(:,1:2) = sortrows(dat,-2);               %sort table
ntable(:,3)   = [1:long]';                      %rank values
ntable(:,4)   = (long + 1)./ntable(:,3);        %return period
ntable(:,5)   = log10(ntable(:,2));             %log of values
logmean       = mean(ntable(:,5));              %mean of log values
ntable(:,6)   = (ntable(:,5) - logmean).^2;     %square difference to mean
ntable(:,7)   = (ntable(:,5) - logmean).^3;     %cubic difference to mean
ntable(:,8)   = 1./ntable(:,4);                 %exceedence probability

variance      = sum(ntable(:,6))/(long-1); 
standardev    = sqrt(variance);
skew          = (long * sum(ntable(:,7)))/((long-1)*(long-2)*(standardev^3));

%compute K factor values for all return periods
%equations for K computation comme from curve fitting of sample skewness
%with K factor of Table 7.7 of Haan 1977
out(1,2) = (-0.1464 * skew) + (-7*10^-18);
out(2,2) = (-0.0356 * skew^2) + (0.04 * skew) + 0.8393;
out(3,2) = (-0.0419 * skew^2) + (0.0977 * skew) + 1.2745;
out(4,2) = (-0.0326 * skew^2) + (0.2998 * skew) + 1.7361;
out(5,2) = (-0.0174 * skew^2) + (0.4607 * skew) + 2.0347;
out(6,2) = (0.003 * skew^2) + (0.6251 * skew) + 2.3044;
out(7,2) = (0.0272 * skew^2) + (0.7917 * skew) + 2.5533;

%compute value from K factor
out(:,3) = 10.^(logmean + (out(:,2) * standardev));
%**************************************************************************
end%end of logPearsonIIIgeV2 function