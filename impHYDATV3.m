function [table] = impHYDATV3(path);
%H1 Line -- import HYDAT data set
%Help Text -- import all *.t3 files in the full path folder 'path'
%             table is a structure array filled with date and values
%             the path folder must contain only *.t3 files that are
%             desired to be imported. 
%Author:Laurence Chaput-Desrochers
%date:august 16th 2013
%Modified by Mathilde Péloquin-Gay, 9 janvier 2015
%Modifications at line 50, 51 and 65 % Parameter MultipleDelAsOne 
%**************************************************************************
%create structure array to wich store values
table = struct('HYDAT_station_ID',[],...
                'dateString_yyyymmdd',[],...
                'date_vector_formated',[],...
                'date_number_formated',[],...
                'year',[],...
                'discharges',[],...
                'drainageArea',[],...
                'rawTextFile',[],...
                'freqData',[],...
                'logPearsonIII',[]);
%**************************************************************************          
%open the path directory
d       = dir(path);
nbfiles = size(d,1);
%loop to detect non-file in d (open folder)
g = zeros(nbfiles,1);
for n = 1:nbfiles;
    if d(n).isdir == 1;
        g(n) = 1;
    end
end
%delete rows in d that are not files
d(g==1) = [];
nbfiles = size(d,1);
clear n g
%**************************************************************************
%main block
%**************************************************************************
%loop to open data files
for n = 1:nbfiles;
    %first openning of file to find the # headers lines
    fid   = fopen([path,'\',d(n).name],'rt');
    lines = textscan(fid,'%[^\n]');%text file store in cell array, scanning each lines
    g     = strmatch(':EndHeader',char(lines{1,1}));%number of header lines
    %find line of drainage area
    gArea = strmatch(':DrainageArea',char(lines{1,1}));
    fid2  = fopen([path,'\',d(n).name],'rt');
    area  = textscan(fid2,'%13q %9f',1,'delimiter',' ','headerlines',gArea(1)-1, 'MultipleDelimsAsOne', 1); 
    fclose('all');
    %second openning the file    
    fid = fopen([path,'\',d(n).name]);
    G = textscan(fid,'%10q %5q %6f %c','delimiter','\t','headerlines',g + 1);         
    %fill table with open values
    table(n,1).HYDAT_station_ID      = d(n).name;
    table(n,1).dateString_yyyymmdd   = char(G{1,1});
    table(n,1).date_vector_formated  = datevec(char(G{1,1}),'yyyy/mm/dd');
    table(n,1).date_number_formated  = datenum(char(G{1,1}),'yyyy/mm/dd');
    table(n,1).year                  = table(n).date_vector_formated(:,1);
    table(n,1).discharges            = G{1,3};
    table(n,1).drainageArea          = area{1,2};
    table(n,1).rawTextFile           = char(lines{1,1});
    clear G lines g gArea area
    fclose(fid);
end%end for loop
%**************************************************************************
end%end of function impHYDATV2