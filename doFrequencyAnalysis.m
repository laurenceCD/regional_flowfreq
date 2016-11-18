%% SCRIPT TO RUN A COMPLETE FREQUENCY ANALYSIS
%enter the full path directory of the file to import and the location to
%save figures excel file
pathInput = 'enter full input path';
pathOutput = 'enter full output path';

%% Importing data from specified path input
[table] = impHYDATV2(pathInput);

%% Perform a frequency analysis on each gaging station located in the input path
[dat] = mainFrequencyAnalysis(table);

%% Perform a regional analysis on the data set imported and write an excel file and creates figures
[parameter] = regionalAnalysis(dat,pathOutput);
[dat] = computeMonth(dat);
reportingFrequencyAnalysis(dat,pathOutput);
