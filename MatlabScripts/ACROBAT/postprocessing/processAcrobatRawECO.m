function [ECO] = processAcrobatRawECO(top_dir, cruise_name)


% Load the GPS data
loadstr = fullfile( top_dir, cruise_name, '/Data/ACROBAT/PROCESSED/GPS');
load(loadstr)

% load the CTD data
loadstr = fullfile( top_dir, cruise_name, '/Data/ACROBAT/PROCESSED/CTD');
load(loadstr)

% define the target
targetdir = fullfile( top_dir, cruise_name, '/Data/ACROBAT/RAW/ecopuck'); 

%GO TO THE TARGET DIRECTORY
cd( targetdir )
% FIND THE ASCII FILES THEREIN
[a] = findASCIIfiles( targetdir ); 

% LOAD THE DATA
% make the blank structure
ECO.ctime = []; 
ECO.NMEAtime = []; ECO.lat = []; ECO.lon = []; 
ECO.chlsig = []; ECO.backsig = []; ECO.CDOMsig = []; 
for d = 1:length(a)
    % open the ASCII
    fname=a(d).name;
    fid=fopen(fname); 
    % scan the text data, ignoring header
    datin = textscan( fid , ['%s %s ', repmat( ' %n ', [1, 3])], 'HeaderLines', 1); 
    
    % pull the variables
    datestr =  datin{1}; 
    timestr = datin{2}; 
    chlsig = datin{3}; 
    backsig = datin{4}; 
    CDOMsig = datin{5}; 
    % parse the computer time
    [ctime] = parseComputerTime(datestr, timestr);
    ECO.ctime = [ECO.ctime; ctime];
    % concat the data
    ECO.chlsig = [ECO.chlsig; chlsig];
    ECO.backsig = [ECO.backsig; backsig];
    ECO.CDOMsig = [ECO.CDOMsig; CDOMsig];
    
    % close file
    fclose( fid ); 
end

% For now, interpolate over any redundant points
diffzero = find( diff( ECO.ctime) == 0);
if ~isempty( diffzero )
    ECO.ctime(diffzero+1) = nan;
    ECO.ctime = interpnans( ECO.ctime )';
end

% Apply calibrations to data
[ECO] = processECOpuck( ECO );

% Interpolate the onto the NMEA time
ECO.NMEAtime = interp1( GPS.ctime, GPS.NMEAtime, ECO.ctime ); 
ECO.lat = interp1( GPS.ctime, GPS.lat, ECO.ctime ); 
ECO.lon = interp1( GPS.ctime, GPS.lon, ECO.ctime ); 

% take out the nans in the CTD ctime data
si = find( ~isnan( CTD.ctime), 1, 'last'); 
ll = length( CTD.ctime); 
inds = [si:ll]; 
dt = nanmean( diff( CTD.ctime)); 
CTD.ctime(inds) = dt*(inds-inds(1)+1)+CTD.ctime( si-1); 

% interpolate pressure data
ECO.p = interp1( CTD.ctime, CTD.p, ECO.ctime ); 

%   save out the ECOpuck data
savedir = fullfile(top_dir, cruise_name, '/Data/ACROBAT/PROCESSED/'); 
name = 'ECO';
savefile = fullfile( savedir, name ); 
eval( ['save ', savefile , ' ECO '])
disp( 'ECO data processed and saved')


