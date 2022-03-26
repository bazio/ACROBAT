function [ ECOpar ] = defaultECOpuckCals

% function [ ECOpar ] = ECOpuckCals
%
% Load default ECOpuck calibrations. We use manufacturers values from the
% first ECOpuck (s/n FLBBCD2K-2710) received from WetLabs in July 2012.  
%
% OUTPUT: scale factors and dark counts.
%
% KIM 08.12

%chlorophyll fluorescence to chlorophyll concentration in microg/l
ECOpar.chl.dark = 50; % [counts]
ECOpar.chl.sf = 0.0073; % microg/l/count

% backscattering to particle concentration in (m^-1 sr^-1)
 ECOpar.backscat.dark = 51; % [counts]
 ECOpar.backscat.sf = 1.888e-6; % (m^-1 sr^-1)/count

% change CDOM fluorescence to CDOM concentration ppb
ECOpar.CDOM.dark = 49; % [counts]
ECOpar.CDOM.sf = 0.0905; % ppb/count
        