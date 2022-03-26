function writeAcrobatRawToASCII(top_dir, cruise_name)

% function writeAcrobatRawToASCII(top_dir, cruise_name)
%
% KIM 08.13

% IDENTIFY THE TARGET
targetdir = fullfile( top_dir, cruise_name, 'DATA', 'ACROBAT','PROCESSED'); 

% CREATE A FILENAME
filename = [cruise_name, 'RAW.dat'];

% CREATE THE TEXTFILE TO WRITE TO
fid = fopen( fullfile( targetdir, filename), 'w'); 

%LOAD THE PARSED DATA
load( fullfile( targetdir, 'GPS.mat')); 
load( fullfile( targetdir, 'ECO.mat')); 
load( fullfile( targetdir, 'CTD.mat')); 
load( fullfile( targetdir, 'ACRO.mat')); 

% define all the variables to be output
vars = { 'gpstime'
    'ctime'
    'lat'
    'lon'
    'p'
    't'
    'c'
    'chlsig'
    'backsig'
    'CDOMsig'
    'SOGn'
    'SOGe'
    'depth'
    'z'
    'layback'
    'wingangle'
    'altitude'
    'speedvert'
    'flymode'
    'shallowlim'
    'deeplim'
    'k1'
    'k2'
    'k3'
    'roll'
    'pitch'
    'heading'
    'temp'
    'altimeter'};

% define the format of all the variables to be output
% strvalsGPS = [repmat( ' %d,', [1, 18]),  ' %s,',repmat( ' %d,', [1, 10]), '\r\n'];
strvalsGPS = [repmat( ' %d,', [1, 4]),  repmat( ' %s,', [1, 25]), '\r\n'];

% interpolate the GPS time onto the CTD and ECOpuck data
flagger = find( GPS.flag == 0 ); 
CTD.gpstime = interp1(GPS.ctime(flagger), GPS.gpstime(flagger), CTD.ctime); 
ECO.gpstime = interp1(GPS.ctime(flagger), GPS.gpstime(flagger), ECO.ctime); 


% CONCAT THE DATES
time = [GPS.gpstime; CTD.gpstime; ECO.gpstime; ACRO.gpstime];
% assign a structure identifier
id = [...
    repmat('G', [length( GPS.gpstime),1]);...
    repmat('C', [length( CTD.gpstime),1]);...
    repmat('E', [length( ECO.gpstime),1]);...
    repmat('A', [length( ACRO.gpstime),1])];
% sort the dates
[sortedtime, inds] = sort(time);

% find the first scientific data to start at (in case you imported all the
% acrobat flight data from previous cruises as well)
startind = min( [strmatch('G', id(inds)); strmatch('C', id(inds)); strmatch('E', id(inds))]);

for ll = startind:startind+10%length(sortedtime)
    if strcmp( id(inds(ll)), 'G')
        indout = find( GPS.gpstime == sortedtime(ll)); 
        datout = [GPS.gpstime(indout), GPS.ctime(indout), GPS.lat(indout), GPS.lon(indout)], [repmat(' ', [1, 25]) ];
        fprintf( fid, strvalsGPS, datout)
        
    elseif strcmp( id(inds(ll)), 'C')
        
    elseif strcmp( id(inds(ll)), 'E')
        
    elseif strcmp( id(inds(ll)), 'A')
        
    else
        
    end
    
end %ll

fclose( fid )



