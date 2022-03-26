function [GPS] = processAcrobatGPS( top_dir, cruise_name )

% function [GPS] = processAcrobatGPS( top_dir, cruise_name )
%
%

%  FIRST THE GPS

% define the target
targetdir = fullfile( top_dir, cruise_name, '/Data/ACROBAT/RAW/GPS'); 

%GO TO THE TARGET DIRECTORY
cd( targetdir )
% FIND THE ASCII FILES THEREIN
[a] = findASCIIfiles( targetdir ); 

% LOAD THE DATA

% make the blank structure
GPS.ctime = []; 
GPS.NMEAtime = []; GPS.lat = []; GPS.lon = []; 

for d = 1:length(a)
    % open the ASCII
    fname=a(d).name;
    fid=fopen(fname); 
    % scan the text data, ignoring header
    datin = textscan( fid , ['%s %s ', repmat( ' %n ', [1, 5])], 'HeaderLines', 1); 
%     disp( [num2str( size( datin{1}, 1)), ' rows of data'])
    
    % pull the computer time
    datestrs =  datin{1}; 
    timestr = datin{2}; 
    % parse the computer time
    [ctime] = parseComputerTime(datestrs, timestr);
    GPS.ctime = [GPS.ctime; ctime]; 
    
    % pull the NMEA time
    HH = datin{:,5}; 
    MM = datin{:,6}; 
    SS = datin{:,7}; 
    % write the time string
    timestr = [num2str(HH),repmat( ':', [size( datestrs, 1 ), 1]), num2str(MM), repmat( ':', [size( datestrs, 1 ), 1]), num2str(SS)];
    % adjust the datestring manually
    timeoffset = 12.5./60./60./24; % time offset of 12.5 seconds
    datestrs = datestr(floor(ctime-timeoffset), 'mm/dd/yyyy'); 
    
    % parse the NMEA time from the GPSdatestr
    [NMEAtime] = parseComputerTime(datestrs, timestr);
    GPS.NMEAtime = [GPS.NMEAtime; NMEAtime]; 
    
    %  pull the lat and long
    GPS.lat = [GPS.lat; datin{3}];
    GPS.lon = [GPS.lon; -1*datin{4}];
    
    % close file
    fclose( fid ); 
end

% For now, interpolate over any redundant points
diffzero = find( diff( GPS.NMEAtime) == 0);
if ~isempty( diffzero )
    GPS.NMEAtime(diffzero+1) = nan;
   GPS.NMEAtime = interpnans( GPS.NMEAtime )';
end

% For now, interpolate over any redundant points
diffzero = find( diff( GPS.ctime) == 0);
if ~isempty( diffzero )
    GPS.ctime(diffzero+1) = nan;
   GPS.ctime = interpnans( GPS.ctime )';
end

% flag the bad data
GPS.flag = GPS.lat*0; 
GPS.flag(GPS.lat+GPS.lon == 0 ) = 1; 

%   save out the GPS
savedir = fullfile( top_dir, cruise_name,'/Data/ACROBAT/PROCESSED/'); 
name = 'GPS';
savefile = fullfile( savedir, name ); 
eval( ['save ', savefile , ' GPS '])

disp( 'GPS data processed and saved')
