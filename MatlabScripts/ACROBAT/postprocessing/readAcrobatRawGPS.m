function readAcrobatRawGPS( top_dir, cruise_name )

% function readAcrobatRawGPS( top_dir, cruise_name )
%
% Load and process the raw GPS data during the Acrobat deployment logged to
% a text file using DASYLABS. Typically, a GPS fix is taken every 1 second.
% Raw Data is also saved out as a .mat file to ./Data/ACROBAT/PROCESSED
%
% GPS structure output [unit]
% _____________________
% GPS.ctime: computer time at fix [datenum.m format]
% GPS.gpstime: GPS time at fix [datenum.m format]
% GPS.lat: Latitude [-90 to 90 N]
% GPS.lon: Longitude [-180 to 180 E]
% GPS.flag: redundant and empty GPS fixes are flagged [flag =1]
%
% KIM 08.13

% DEFINE THE TARGET
targetdir = fullfile( top_dir, cruise_name, 'Data', 'ACROBAT','RAW','GPS'); 
% FIND THE ASCII FILES THEREIN
[a] = findextension( targetdir, '.ASC' );

% LOAD THE DATA

% make the blank structure
GPS.ctime = []; GPS.gpstime = []; GPS.lat = []; GPS.lon = []; 

for d = 1:length(a)
    % open the ASCII
    fname = fullfile( top_dir, cruise_name, 'Data', 'ACROBAT','RAW','GPS', a(d).name);
    fid=fopen(fname); 
    
    % get header
    header = fgetl(fid);
    
    % scan the text data, ignoring header
    if length( header ) >80 % if GPS does have date information 
        datin = textscan( fid , ['%s %s ', repmat( ' %n ', [1, 8])], 'HeaderLines', 0);
    else % if GPS does not have date information
        datin = textscan( fid , ['%s %s ', repmat( ' %n ', [1, 5])], 'HeaderLines', 0);
    end
    
    %  pull the lat and long
    GPS.lat = [GPS.lat; datin{3}];
    GPS.lon = [GPS.lon; datin{4}];
        
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
    timestr = [num2str(HH),repmat( ':', [size( HH, 1 ), 1]), num2str(MM), repmat( ':', [size( HH, 1 ), 1]), num2str(SS, '%05.2f')];
    
    % find the NMEA date
    if length( header ) > 80  % if GPS does have date information
        datestrs = datestr( datenum( datin{10}, datin{9}, datin{8}), 'mm/dd/yyyy');   
    else % estimate offset and find date from computer time
        % parse the NMEA time from the GPSdatestr
        [gpstime] = parseComputerTime(datestrs, timestr);
        % find the computer datestring to use with the GPS time
        timediff = ctime - gpstime;
        % statistics on the difference
        timestd = nanstd( timediff); timemean = nanmean( timediff);
        goodinds =  timediff > timemean - timestd & timediff < timemean + timestd;
        % make sure there are enough points to parse
        if sum( goodinds ) < 1
            goodinds = 1:length( timediff );
        end
        % calculate the offset from computer time
        timeoffset = nanmean( timediff( goodinds ) );
        datestrs = datestr(floor(ctime-timeoffset), 'mm/dd/yyyy');
    end

    % parse the NMEA time from the GPSdatestr using the correct datestring
    [gpstime] = parseComputerTime(datestrs, timestr);
    GPS.gpstime = [GPS.gpstime; gpstime];
        
    
    % close file
    fclose( fid ); 
end

    dats = datevec(GPS.gpstime);
    if (mean(dats(1)) < 2015 || mean(dats(1)) > 2025),
       GPS.gpstime = GPS.ctime; 
    end
    
% flag any empty data
GPS.flag = GPS.lat*0; 
GPS.flag( GPS.lat+GPS.lon == 0 ) = 1; 
% flag redundant timestamps
[B, i, j] = unique( GPS.gpstime, 'first'); 
flagger = setxor(i, 1:length( GPS.flag)); 
GPS.flag( flagger ) = 1;
% flag time reversals
flagger = find( diff( GPS.gpstime ) < 0);
GPS.flag( flagger+1) = 1; 

% display status
displayStatusLine( 'GPS data loaded...', 2)

%  save out the GPS
savedir = fullfile( top_dir, cruise_name,'Data','ACROBAT','PROCESSED'); 
name = 'GPS';
savefile = fullfile( savedir, name ); 
eval( ['save ', savefile , ' GPS '])

