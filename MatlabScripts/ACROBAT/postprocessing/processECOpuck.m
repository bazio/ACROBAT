function [ECO] = processECOpuck( ECO, ECOpar )

% function [ECO] = processECOpuck( ECO, ECOpar )
%
%  Turn raw ECOpuck flourescence and backscatter count data to real
%  chlorophyll, particle and dissolved organic matter concentrations.  Use
%  cal files for a particular instrument.
%
% INPUT: chlsig [counts], 700sig [counts], CDOMsig [counts]
% OUTPUT: chlorophyll concentration [microg/l], particle concentration
% [m^-1 sr^-1], dissolved organic matter [ppb]
%
% KIM 08.12

% pull default calibration data if none specified
if nargin <1
   [ ECOpar ] = defaultECOpuckCals;
end

% convert raw values into real concentrations

% chlorophyll fluorescence to chlorophyll concentration [microg/l]
ECO.chl = ECOpar.chl.sf.*( ECO.chlsig - ECOpar.chl.dark ); 

% backscattering to particle concentration [m^-1 sr^-1]
ECO.particle = ECOpar.backscat.sf.*( ECO.backsig - ECOpar.backscat.dark ); 

% CDOM fluorescence to dissolved organic matter [ppb]
ECO.CDOM = ECOpar.CDOM.sf.*( ECO.CDOMsig - ECOpar.CDOM.dark ); 

% output the calibration data
ECO.par = ECOpar; 
