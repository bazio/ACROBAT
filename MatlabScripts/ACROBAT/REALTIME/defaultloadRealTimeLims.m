function lims = defaultloadRealTimeLims

% function lims = defaultloadRealTimeLims
%
% Load a set of prechosen limits for all the plots
%
% KIM 08.12

% from SEABIRD
lims.p = [0, 40];
lims.t = [-5, 35];
lims.c = [0, 9];
lims.s = [0, 40];
lims.sgth = [17, 30];

%FROM WETLABS
lims.chl = [0, 30];
lims.particle = [0,3]*1e5;
lims.cdom = [0, 5];

% WINDOW SIZES
lims.time = [0, 10]./60./24; %minutes to yearday
lims.lat =  [70.5, 72];
lims.lon =  [-162 -155.75]; % double check what the AOOS limits are
