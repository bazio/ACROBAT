function [acrobat, CTD, ECO] = parseAcrobatRealtime( dat )

% function [acrobat, CTD, ECO] = parseAcrobatRealtime( dat )
%
% Parse the cell array of data parsed from the Acrobat REALTIME ASCII
% files.
%
%  for reference, the order of fields in the realtime data stream
% COLUMNS 1-5:   Date	 Time	Lat [deg]	Lon [deg]	NMEAhh [UTC]	  
% COLUMNS 6-10:   NMEAmm [UTC]    NMEAss [UTC]   temp [degC, ITS-90]	con [S/m]	pres [decibars]		
% COLUMNS 11-13:   chl sig [counts]    700 sig []	 CDOM sig [counts]	
%
% KIM 08.12

% I HATE HOW I AM PULLING THE DATE HERE.  I NEED NMEA DATE OUTPUT AS WELL.
% NOT SURE WHY I DID NOT. MUST CHANGE THIS IN DASY LABS

datestr = vertcat(dat{:,1});
timestr = vertcat(dat{:,2});

% spacer = repmat( ' ', [size( datestr, 1 ), 1]);

acrobat.mtime = nan(size(datestr, 1 ), 1 ); 
for mi = 1:size( datestr, 1 )
acrobat.mtime(mi) = datenum( [datestr{mi}, ' ', timestr{mi}], 'mm/dd/yyyy HH:MM:SS');
end

% % pull the date and time strings
% datestr = cell2mat(vertcat(dat{:,1})); 
% timestr = cell2mat(vertcat(dat{:,2})); 
% % parse the strings
% mm = str2num(datestr(:,1)); 
% dd = str2num(datestr(:,3:4)); 
% yy = str2num( datestr(:, 6:9)); 
% HH = str2num( timestr(:,1:2)); 
% MM = str2num( timestr(:, 4:5)); 
% SS = str2num( timestr(:, 7:12)); 
% % now find the datenum
% acrobat.mtime = datenum( yy, mm, dd, HH, MM, SS); 
% clear HH MM SS yy mm dd

% pull lat and long
acrobat.lat = vertcat(dat{:,3}); 
acrobat.lon = vertcat( dat{:,4});

%  pull the CTD
CTD.t = vertcat( dat{:,8}); 
CTD.c = vertcat( dat{:,9});
CTD.p = vertcat( dat{:,10});

% now the ECOpuck
ECO.chlsig = vertcat( dat{:,11});
ECO.backsig = vertcat( dat{:,12});
ECO.CDOMsig = vertcat( dat{:,13});
