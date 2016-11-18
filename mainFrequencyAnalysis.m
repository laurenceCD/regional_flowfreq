function [dat] = mainFrequencyAnalysis(dat);
%H1 Line -- loop to calculate on frequency analysis on a structure array
%Help Text --
%input requirements: dat is a structure array (output of impHYDAT)
%
%output details: dat, is the same arry entered in output with a filed that
%               contain the frequency analysis. The analysis is run for
%               each flow station.
%Author: Laurence Chaput-Desrochers
%date:august 19th 2013
%**************************************************************************
nbFiles = size(dat,1);

%compute log-PearsonIII frequency analysis
%**************************************************************************
for n = 1:nbFiles;
    [out,tableN] = logPearsonIIIgeV2(dat(n,1).discharges,dat(n,1).year);
    dat(n,1).freqDataPearson = tableN;
    dat(n,1).logPearsonIII = out;
    clear out tableN
end%end loop n
clear n
%**************************************************************************
end%end of function mainFrequancyAnalysis