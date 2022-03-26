%%  ACROBAT POSTPROCESSING WORKSHEET
% -------------------------------------------------------------------------
% use this worksheet to run the process the data from a cruise
clear all; close all; pack

%% STEP 1: DEFINE THE DATA DIRECTORY
% -------------------------------------------------------------------------
% the top directory where all cruise data is saved
top_dir = 'C:\Users\stats\Documents\Chukchi\2013\CRUISE_DATA\Chukchi_2013_N2';
% top_dir = 'G:\Chukchi_2013_N2';
% top_dir = 'C:\Users\Jeremy\Documents\Projects';
% top_dir = '/Users/kmartini/RESEARCH/';
% input the cruise name
cruise_name = 'ChukchiGliderCruise2013';

%%  STEP 2: READ THE RAW DATA AND SAVE AS MATLAB FILES (THIS STEP MAY TAKE  A WHILE DEPENDING ON AMOUNT OF DATA)
% addpath('C:\
addAcrobatPaths(top_dir, cruise_name);
ReadAcrobatRAW( top_dir, cruise_name );

%% STEP 3: VIEW THE CRUISE TRACK WITH NUMBERED WAY POINTS
viewCruiseTrack( top_dir, cruise_name )

%% STEP 4: DEFINE THE CRUISE TRACKS MANUALLY USING CRUISE TRACK AS A GUIDE
% leg(1).ind = [1:13000]; leg(1).name = 'A'; 
% leg(2).ind = [13000:21000]; leg(2).name = 'B'; 
% leg(3).ind = [21000:34000]; leg(3).name = 'C'; 
% ETC.
leg(1).ind = [2700:13354]; leg(1).name = 'A'; 
leg(2).ind = [15000:25000]; leg(2).name = 'B'; 
leg(3).ind = [26000:36050]; leg(3).name = 'C'; 
leg(4).ind = [37000:71100]; leg(4).name = 'D'; 
leg(5).ind = [71200:76700]; leg(5).name = 'E'; 
leg(6).ind = [76800:82500]; leg(6).name = 'F'; 
leg(7).ind = [82600:91500]; leg(7).name = 'G'; 
leg(8).ind = [91600:133500]; leg(8).name = 'H'; 
leg(9).ind = [135500:145500]; leg(9).name = 'I'; 
leg(10).ind = [146000:158000]; leg(10).name = 'J'; 
leg(11).ind = [159500:170000]; leg(11).name = 'K'; 
leg(12).ind = [171000:178000]; leg(12).name = 'L'; 
leg(13).ind = [179000:196000]; leg(13).name = 'M'; 
leg(14).ind = [197000:210000]; leg(14).name = 'N'; 
leg(15).ind = [212000:219000]; leg(15).name = 'O'; 
leg(16).ind = [220000:228000]; leg(16).name = 'P'; 
leg(17).ind = [229999:260000]; leg(17).name = 'Q'; 
leg(18).ind = [262000:276000]; leg(18).name = 'R'; 
% leg(19).ind = [:]; leg(16).name = 'S'; 


%  SAVE OUT TO A MATLAB FILE AND MAKE A PLOT
saveCruiseLegs( top_dir, cruise_name, leg)

%% STEP 5: PROCESS AND GRID THE DATA
ProcessAndGridAcrobatData( top_dir, cruise_name )

%% STEP 6: MAKE ROUGH SUMMARY PLOTS OF THE RAW DATA (NOT DONE YET)
plotAcrobatCruiseLegs2(top_dir, cruise_name)




