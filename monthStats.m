function [out] = monthStats(dat,mt);
% H1 Line -- compute stats for a speficic month
% Help Text -- work with structure data table (dat) created with the code
% impHYDATV2.m. Sort the data according to the selected month (mt) and
% compute max, average, min and std od imput data tables.
% mt is the numeric month value to look for
%Author: Laurence Chaput-Desrochers
%Date: February 24th 2014
%++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
%main programm
%create structure array to wich store values
nbDat = size(dat,1);
out = cell(nbDat,6);
%Details of column:
%nom du fichier
%catchment area
%Max
%Average
%Min
%std
%**************************************************************************
%loop through input data
for n = 1:nbDat;
    currentDate      = dat(n).date_vector_formated;
    currentDischarge = dat(n).discharges;
    gMT = find(currentDate(:,2) == mt);%find lines of specified month
    out{n,1} = dat(n).HYDAT_station_ID;
    out{n,2} = dat(n).drainageArea;
    out{n,3} = max(currentDischarge(gMT));
    out{n,4} = mean(currentDischarge(gMT));
    out{n,5} = min(currentDischarge(gMT));
    out{n,6} = std(currentDischarge(gMT));
    clear currentDate currentDischarge gMT
end%end of loop n
%**************************************************************************
end%end of function

