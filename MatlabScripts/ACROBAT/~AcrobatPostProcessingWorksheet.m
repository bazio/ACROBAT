%%  ACROBAT POSTPROCESSING WORKSHEET
% -------------------------------------------------------------------------
% use this worksheet to run the process the data from a cruise
clear all; close all; pack

%% STEP 1: DEFINE THE DATA DIRECTORY
% -------------------------------------------------------------------------
% the top directory where all cruise data is saved
top_dir = 'C:\Users\Jeremy\Documents\Projects';
% input the cruise name
cruise_name = 'ChukchiGliderCruise2013';

%%  STEP 2: READ AND LOAD THE RAW DATA
% [GPS, CTD, ECO, acrobat] = ReadAcrobatRAW( top_dir, cruise_name );
ReadAcrobatRAW( top_dir, cruise_name );

%% STEP 3: 