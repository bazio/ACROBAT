%%  ACROBAT REALTIME DATA FEED

% use this worksheet to run the data feed
clear all; close all; pack
%% DEFINE FTP TARGETS
% -------------------------------------------------------------------------
% local location of the files
localdir = 'C:\Users\NorsemanII\DATA\Chukchi2012\ACROBAT\REALTIME';
% remote location of the files
targetdir = 'C:\Users\NorsemanII\DATA\Chukchi2012\ACROBAT\REALTIME';
% IP address of target
targetIP = '192.168.10.21:21';
% username
user = 'chukchi';
% password
psswrd = 'sea';

%% DEFINE DATA REFRESH RATE AND WINDOW SIZE
% -------------------------------------------------------------------------
% plot update rate
updaterate = 30; % updates every 60 seconds/1 minute
% plot time span
minutes = 5; 
twin = minutes./60./24; %convert to yeardays (change this at some point)

%% DEFINE THE DATA LIMITS
% -------------------------------------------------------------------------
lims.p = [-1, 0];
lims.t = [7, 10];
lims.c = [0, 9];
lims.s = [25,30];
lims.chl = [0, 3];
lims.particle = [2,5]*1e4;
lims.cdom = [1, 5];

%% LOAD THE TIMESERIES PLOTS
% -------------------------------------------------------------------------
makeRealTimeFig12;
makeRealTimeFig22;

%%  START THE REALTIME DISPLAY
% -------------------------------------------------------------------------
a = startAcrobatREALTIME2(updaterate,lims);

%%  STOP THE REALTIME DISPLAY
% -------------------------------------------------------------------------
stopAcrobatREALTIME(a)






%% TEST SOME STUFF DOWN HERE

%%  PULL THE DATA FROM THE REMOTE COMPUTER USING FTP
% -------------------------------------------------------------------------
FTPAcrobatREALTIME(targetIP, user, psswrd, targetdir);


%% PROCESS DATA ON LOCAL MACHINE FOR THE REALTIME DISPLAY
% -------------------------------------------------------------------------
[acrobat, CTD] = ProcessAcrobatREALTIME2(localdir, twin);


%% PLOT THE LOCAL DATA
PlotAcrobatREALTIME2( acrobat, CTD, lims);

%% DEFINE THE DATA LIMITS
% -------------------------------------------------------------------------
drange.p = [0, 100];
drange.t = [-5, 35];
drange.c = [0, 9];
drange.sal = [0, 40];
% drange.