function makeRealTimeMap(top_dir, lims)

% function makeRealTimeMap(top_dir, lims)
%
% Render a bathymetric map in figure 3, using the appropriate bathymetry
%
% KIM 07.13

if nargin < 2
    % load the default limits
    lims = defaultloadRealTimeLims;
end

% load the bathymetry
global bathy
[lat, lon, z] = loadAcrobatBathymetry(top_dir, bathy, lims);

% create the figure
figure(3); clf
set( gcf, 'color', 'w','position', [16    52   390   288])

% plot the default bathymetry
plotRealTimeBathy(lat, lon, z, lims)

