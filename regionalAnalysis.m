function [parameter] = regionalAnalysis(dat,path)
%H1 Line --   compute regional fequency analysis
%Help Text -- compute regional frequency analysis for the data set dat.
%it creates a table that contain fitted parameter for each return period
%[2, 5, 10, 25, 50, 100, 200].
%data requirements: 
%                   dat: is the output of mainFrequency analysis.
%output details:
%                   parameter: is a 2X7 table. Row(1) is the exponent and
%                   row(2) is the constant
%                   xlsx file: a excel workbook is written with discharges,
%                   corresponding years, retunr period and computed
%                   discharges
%**************************************************************************

%getting the data together
nbFiles     = size(dat,1);
regional    = zeros(nbFiles,7);
area        = zeros(nbFiles,1);
xlsname     = [path,'\','frequencyAnalysis.xlsx'];
for n = 1:nbFiles;%loop throught all files (station)
    area(n,1)     = dat(n,1).drainageArea;          %logging area of each station
    regional(n,:) = dat(n,1).logPearsonIII(:,3)';   %logging data of each return period for each station
    %writting data to an excel file
    xlswrite(xlsname,[dat(n,1).date_vector_formated(:,1:2),dat(n,1).discharges],...
        dat(n,1).HYDAT_station_ID(1:22));
    xlswrite(xlsname,[dat(n,1).logPearsonIII(:,1),dat(n,1).logPearsonIII(:,3)],...
                dat(n,1).HYDAT_station_ID(1:22),'D2:E8');
end%end of loop n
clear n

%regression of logDischarge against logArea
nbPeriods = size(regional,2);
x         = log10(area);
parameter = zeros(2,nbPeriods);
for n = 1:nbPeriods
    y = log10(regional(:,n));
    p = polyfit(x,y,1);
    parameter(:,n) = p';    
end%end of second loop n
%write to excel file
parameter(2,:) = 10.^parameter(2,:);
xlswrite(xlsname,[2 5 10 25 50 100 200;parameter],'regionalAnalysis');

%**************************************************************************
end%end of regionalAnalysis function