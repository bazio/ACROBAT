function [CTD] = processAcrobatRawCTD( top_dir, cruise_name)

% function [CTD] = processAcrobatRawCTD( top_dir, cruise_name)


% USED SPLICED DATA HERE TO FIND LAT AND LON!
loadstr = fullfile( top_dir, cruise_name, '/Data/ACROBAT/PROCESSED/GPS');
load(loadstr)

% NOW THE CTD
% define the target
targetdir = fullfile( top_dir, cruise_name ,'/Data/ACROBAT/RAW/CTD'); 

%GO TO THE TARGET DIRECTORY
cd( targetdir )
% FIND THE ASCII FILES
[a] = findASCIIfiles( targetdir ); 

% LOAD THE DATA
% make the blank structure
CTD.ctime = []; 
CTD.NMEAtime = []; CTD.lat = []; CTD.lon = []; 
CTD.p = []; CTD.t = []; CTD.c = []; 


for d = 1:length(a)
    % open the ASCII
    fname=a(d).name;
    fid=fopen(fname); 
    % scan the text data, ignoring header
    datin = textscan( fid , ['%s %s ', repmat( ' %n ', [1, 3])], 'HeaderLines', 1); 
    % pull the variables
    datestr =  datin{1}; 
    timestr = datin{2}; 
    % parse the computer time
    [ctime] = parseComputerTime(datestr, timestr);
    CTD.ctime = [CTD.ctime; ctime]; 
    t = datin{3};
    c= datin{4};
    p = datin{5};
    % add onto the matrices
    CTD.p = [CTD.p; p]; 
    CTD.t = [CTD.t; t];
    CTD.c = [CTD.c; c];
    % close file
    fclose( fid ); 
end


% For now, interpolate over any redundant points
diffzero = find( diff( CTD.ctime) == 0);
if ~isempty( diffzero )
    CTD.ctime(diffzero+1) = nan;
   CTD.ctime = interpnans( CTD.ctime )';
end

% Interpolate to find NMEA time, latitude and longitude
CTD.NMEAtime = interp1( GPS.ctime, GPS.NMEAtime, CTD.ctime );
CTD.lat  = interp1( GPS.ctime, GPS.lat, CTD.ctime );
CTD.lon = interp1( GPS.ctime, GPS.lon,  CTD.ctime );

% process the CTD data
[CTD] = processAcrobatCTD( CTD );

%   save out the CTD
savedir = fullfile(top_dir,cruise_name,'/Data/ACROBAT/PROCESSED/'); 
name = 'CTD';
savefile = fullfile( savedir, name ); 
eval( ['save ', savefile , ' CTD '])
disp( 'CTD data processed and saved')
