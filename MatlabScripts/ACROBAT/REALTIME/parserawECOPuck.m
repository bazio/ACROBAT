function [chl, backscat, CDOM] = parserawECOPuck( tline ) 

% function [chl, backscat, CDOM] = parserawECOPuck( tline ) 
%
%  Takes one line of data from the raw ECOpuck file (filename ending in
%  .raw) and parses it.  
%
% Date and time characters are merely software ghosts. The ECOpuck has no
% internal data logger.
%
% Output are the raw, uncorrected chlorophyll fluourescence (chl), 700 nm
% backscattering (backscat), and CDOM fluorescence (CDOM) counts.  For real values, these
% must be corrected with the appropriate scaling factor and calibrated
% against dark counts.
%
% KIM 08/12

% parse the line using text scan
C  = textscan( tline, '%s %s %*n %n %*n %n %*n %n %n');

% pull the counts
chl = C{3}; % chlorophyll fluorescence
backscat = C{4}; % 700 nm backscattering
CDOM = C{5}; % CDOM fluorescence
therm = C{6};