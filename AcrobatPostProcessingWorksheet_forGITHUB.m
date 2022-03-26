%%  ACROBAT POSTPROCESSING WORKSHEET
% -------------------------------------------------------------------------

%Citation information:
%Authors: Dr. Kim Martini (1st author), Hank Statscewich, Isaac Reister.
%University of Alaska Fairbanks
%Original Creation: 08-2013 by Martini (v1, v2)
%Revisions: 03-2016 by Statscewich (v3)
         %: 02-2022 by Reister (v4)

% use this worksheet to run the process the data from a cruise.
% It works best if you run each section in turn, using CTRL + RETURN
%WORD OF Caution: NMEA time parsing is variable between data sets. To make
%sure you are doing it right, open up the file that contains the raw NMEA
%time, and look closely at the function nested here:
%ACROBATPostProcessingWorksheet>ReadAcrobateRAW>readAcrobatRawGPS
%
clear all; close all; pack; clc;
%% STEP 1: DEFINE THE DATA DIRECTORY
% -------------------------------------------------------------------------
% the top directory where all cruise data is saved
%example fore Window machine shown here.
addpath('C:\Users\ISAAC\Documents\MATLAB\Research\code\CopperRiver_Acrobat') %this is where this script lives, and where addAcrobatPaths.m (available in the Matlabscripts folder) should be copied to
top_dir='\Users\Isaac\Documents\MATLAB\Research\Data'; %this is where your raw data is stored and will be accessed from.
mat_dir = 'C:\Users\ISAAC\Documents\MATLAB\Research\code';%this is to whatever directory you placed the Matlabscripts folder, which contains all the functions that this worksheet uses. 
cruise_name = 'SKQ201810Stest';%
addAcrobatPaths(mat_dir);


%%  STEP 2: READ THE RAW DATA AND SAVE AS MATLAB FILES (THIS STEP MAY TAKE  A WHILE DEPENDING ON AMOUNT OF DATA)

ReadAcrobatRAW( top_dir, cruise_name );
%takes in ACROBAT raw data saved to your directory using DasyLab software.
%outputs that raw acrobat data into matlab structures and saves these
%structures in a directory called processed.



%% STEP 3: VIEW THE CRUISE TRACK WITH NUMBERED WAY POINTS %defing.
dt = 300; %5-minute spacing between plotting data points (60 secs/min * 5 minutes = 300) 
dlim = [datenum(2018,4,15) datenum(2020,5,30)];%date limits for your research cruise
llims = [-152 -143.5 56  63]; %min max of your lat and lons for your study area
survey = 1;
%
viewCruiseTrack( top_dir, cruise_name, dlim , dt, survey, llims)

%% STEP 4: DEFINE THE CRUISE TRACKS MANUALLY USING CRUISE TRACK AS A GUIDE

%zoom into your track shown in the image and designate different legs of
%the cruise. Follow the format of the example here. You should only have to
%change the numbers [XXX:XXX] and add additional letters, making sure to
%change leg(X).name and leg(X).ind as you copy paste.

leg(1).ind = [900:17400]; leg(1).name = 'A';
leg(2).ind = [20400:26400]; leg(2).name = 'B';
leg(3).ind = [28200:86400]; leg(3).name = 'C';
leg(4).ind = [90300:109500]; leg(4).name = 'D';
leg(5).ind = [109800:124800]; leg(5).name = 'E';
leg(6).ind = [125100:141600]; leg(6).name = 'F';
leg(7).ind = [142500:173400]; leg(7).name = 'G';

leg(8).ind =  [173700:184500]; leg(8).name = 'H';
leg(9).ind =  [184800:219900];leg(9).name = 'I';

leg(10).ind = [222300:278100]; leg(10).name = 'J';
% SAVE OUT TO A MATLAB FILE AND MAKE A PLOT

saveCruiseLegs( top_dir, cruise_name, leg, llims)

%% STEP 5: PROCESS AND GRID THE DATA

 %YOU MUST MAKE SURE THE ECO PUCK SERIAL NUMBER IS ENTERED INTO THIS
 %SCRIPT. OPEN UP SCRIPT AND DO THAT.
 ProcessAndGridAcrobatData_IRmod( top_dir, cruise_name )
 disp(['ProcessAndGridAcrobatData done! ' datestr(datetime('now'))])

%% SAVE MAP WITH LEGS
%viewMapCruiseTrack(top_dir, cruise_name )
% 
%% STEP 6: MAKE ROUGH SUMMARY PLOTS OF THE RAW DATA 
plotAcrobatCruiseLegsDistanceMap_TS(top_dir, cruise_name);

%% STEP 6: MAKE ROUGH SUMMARY PLOTS OF THE RAW DATA (distance vs. depth)
%plotAcrobatCruiseLegs4(top_dir, cruise_name)
%plotAcrobatCruiseLegs4_w_oMap(top_dir, cruise_name)

%% STEP 7: MAKE ROUGH SUMMARY PLOTS OF THE RAW DATA (time vs. depth)
%plotAcrobatCruiseLegs5(top_dir, cruise_name)
%plotAcrobatCruiseLegs5_w_oMap(top_dir, cruise_name)

%% STEP 8: MAKE ROUGH SUMMARY WATERFALL PLOTS
%plotAcrobatCruiseLegs_waterfall(top_dir, cruise_name)

%% STEP 8: MAKE ROUGH SUMMARY PLOTS OF THE RAW DATA (time vs. depth)
%plotAcrobatCruiseLegs_TS_distance(top_dir, cruise_name)
%% STEP 9: MAKE ROUGH SUMMARY PLOTS OF THE RAW DATA (time vs. depth)
%plotAcrobatCruiseLegs_TS_distance_map(top_dir, cruise_name)

