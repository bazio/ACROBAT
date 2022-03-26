function  [lat, lon, z] = loadAcrobatBathymetry(top_dir, bathy, lims)

% function [lat, lon, z] = loadAcrobatBathymetry(top_dir, bathy, lims)
% 
% Load a bathymetry file with a lat vector, a lon vector and a depth
% matrix. You can point it to any bathymetric product you like
%
% KIM 07.13

if nargin <3
    % load the default limits
    lims = defaultloadRealTimeLims;
end

switch bathy
    
    case 'ALASKA'
        displayStatusLine('loading coastal Alaska bathymetry...', 2)
        filename = 'AlaskaBathy.mat';
        load( fullfile( top_dir, 'MatlabScripts', 'ACROBAT', 'bathymetry', filename))
        lat = bathy.lat;
        lon = bathy.lon;
        z = bathy.z;
        
    case 'GEBCO'
        displayStatusLine('loading GEBCO bathymetry...', 2)
        [lat, lon, z] = loadGEBCOBathymetry(top_dir, lims);
        
    otherwise
        displayStatusLine({'unknown bathymetry.';'defaulting to GEBCO global bathymetric product'}, 2)
        [lat, lon, z] = loadGEBCOBathymetry(top_dir, lims);
        bathy = 'GEBCO';
end




