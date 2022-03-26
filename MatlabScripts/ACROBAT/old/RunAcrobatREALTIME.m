%%  ACROBAT REALTIME DATA FEED
% use this worksheet to run the realtime data feed
clear all; close all; pack

%%


% DEFINE FTP TARGETS
% -------------------------------------------------------------------------
% local location of the files
localdir = 'C:\Users\pwinsor\Seward13\DATA\ACROBAT\REALTIME';
% remote location of the files
targetdir = 'C:\Users\pwinsor\Seward13\DATA\ACROBAT\REALTIME';

% DEFINE DATA REFRESH RATE AND WINDOW SIZE
% -------------------------------------------------------------------------
% plot update rate
updaterate = 30; % updates every 60 seconds/1 minute
% plot time span
%minutes = 30;
%twin = minutes./60./24; %convert to yeardays (change this at some point)

%% DEFINE THE DATA LIMITS
% -------------------------------------------------------------------------
lims.p = [0, 35];
lims.t = [7, 13];
lims.c = [2.8, 3.5];
lims.s = [23, 32];
lims.sgth = [17, 25];
lims.chl = [0, 4];
lims.particle = [0,3]*1e5;
lims.cdom = [0, 5];
lims.time = [0, 10]./60./24; %minutes to yearday

%% LOAD THE TIMESERIES PLOTS
% -------------------------------------------------------------------------
makeRealTimeFig1;
makeRealTimeFig2;
chukchimapREALTIME;

%%  START THE REALTIME DISPLAY
% -------------------------------------------------------------------------
a = startAcrobatREALTIME(updaterate,lims);

%%  STOP THE REALTIME DISPLAY
% -------------------------------------------------------------------------
stopAcrobatREALTIME(a)









%% TEST SOME STUFF DOWN HERE

%%  PULL THE DATA FROM THE REMOTE COMPUTER USING FTP
% -------------------------------------------------------------------------
tic
FTPAcrobatREALTIME(targetIP, user, psswrd, targetdir);
toc

%% PROCESS DATA ON LOCAL MACHINE FOR THE REALTIME DISPLAY
% -------------------------------------------------------------------------
tic
[acrobat, CTD, ECO] = ProcessAcrobatREALTIME(localdir, lims.time(end));
toc

%% PLOT THE LOCAL DATA
PlotAcrobatREALTIME( acrobat, CTD, ECO, lims);

