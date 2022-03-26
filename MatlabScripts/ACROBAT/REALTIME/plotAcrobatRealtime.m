function plotAcrobatRealtime( top_dir, cruise_name, acrobat, CTD, ECO, lims )

% function plotAcrobatRealtime( top_dir, cruise_name, acrobat, CTD, ECO, lims)
%
% Plot the processed Acrobat Realtime Data
%
% KIM 08.12

%load default limits if not defined
if nargin <4
     lims = loadDefaultLimsREALTIME;
end

% PLOT THE LOCAL DATA
plotRealTimeFig1(acrobat, CTD, ECO, lims);
plotRealTimeFig2(acrobat, CTD, ECO, lims);
plotRealTimeMap(top_dir, cruise_name, acrobat, lims)
