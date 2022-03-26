function makeRealTimeAKmap(top_dir, lims)

% function makeRealTimeAKmap
%
% Using the Alaskan Bathymetry from AOOS, make an updated map of Alaska.
%
% KIM 07.13

if nargin < 2
    % load the default limits
    lims = defaultloadRealTimeLims;
end

% load the bathymetry data
[lat, lon, z] = loadAcrobatBathymetry(top_dir);

% create the figure
figure(3); clf
set( gcf, 'color', 'w','position', [16    52   390   288])

% plot the default bathymetry
plotRealTimeAKBathy(lat, lon, z, lims)
