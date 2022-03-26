%%  ACROBAT POSTPROCESSING WORKSHEET
% -------------------------------------------------------------------------
% use this worksheet to run the process the data from a cruise
clear all; close all; pack

%% STEP 1: DEFINE THE DATA DIRECTORY
% -------------------------------------------------------------------------
% the top directory where all cruise data is saved
top_dir = 'C:\Users\pwinsor';
top_dir = '/Users/kmartini/RESEARCH/';
% input the cruise name
cruise_name = 'OfficeCruise2013';

%%  STEP 2: READ THE RAW DATA AND SAVE AS MATLAB FILES (THIS STEP MAY TAKE  A WHILE DEPENDING ON AMOUNT OF DATA)
ReadAcrobatRAW( top_dir, cruise_name );

%% STEP 3: VIEW THE CRUISE TRACK WITH NUMBERED WAY POINTS
viewCruiseTrack( top_dir, cruise_name )

%% STEP 4: DEFINE THE CRUISE TRACKS MANUALLY USING CRUISE TRACK AS A GUIDE
leg(1).ind = [1:13000]; leg(1).name = 'A'; 
leg(2).ind = [13000:21000]; leg(2).name = 'B'; 
leg(3).ind = [21000:34000]; leg(3).name = 'C'; 
% ETC.

%  SAVE OUT TO A MATLAB FILE AND MAKE A PLOT
saveCruiseLegs( top_dir, cruise_name, leg)

%% STEP 5: PROCESS AND GRID THE DATA
ProcessAndGridAcrobatData( top_dir, cruise_name )

%% STEP 6: MAKE ROUGH SUMMARY PLOTS OF THE RAW DATA (NOT DONE YET)
plotAcrobatCruiseLegs(top_dir, cruise_name)






