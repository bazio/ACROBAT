function [acro] = processAcrobatNAVfiles( top_dir, cruise_name)

% function [acro] = processAcrobatNAVfiles( top_dir, cruise_name)
%
%
% KIM 06.13


targetdir = fullfile( top_dir, cruise_name, '/Data/ACROBAT/RAW/Acrobat');

 [a] = findDATfiles( targetdir )
 
 %  predefine the out matrix
 clear out datin dat
 vars = {...
     'ctime'
     'NMEAtime'
     'lat'
     'lon'
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
     'altimeter'
     'flag' };
 
 for vv = 1:length( vars )
     eval( ['acro.', vars{vv}, '= [];'])
 end
 
 % LOAD THE DATA
 parsestr = ['%n %n %s %n %n %s %n %n %s %*s ', repmat( '%n ' , [1, 8]), '%s ', repmat( '%n ' , [1, 10]), '%s'];

 for d = 1:length(a)
     dat = []; datin = [];
     % open the ASCII
     fname=a(d).name;
     fid=fopen(fullfile( targetdir, fname));
     % scan the text data, ignoring header + first data line which has no GPS
     [datin] = textscan( fid , parsestr, 'HeaderLines', 18, 'delimiter', ',');
     % close file
     fclose( fid );
     
     % let's crop off the last line if it is incomplete
     datlength = length( datin{29});
     
     for dd = 1:29
         datin{dd} = datin{dd}(1:datlength,:);
     end

     % end % d
     
     % IMPORT THE DATA
     % COMPUTER TIME
     % year
     yy = datin{1};
     % julian day but convert to yearday
     yday = datin{2}; % SeaSciences sets Jan 1=1;
     % time in hours, minutes and seconds
     cHHMMSS = datin{:, 3};
     % convert hours minutes and seconds to serial datenum format
     timein = datenum(strcat( repmat( {'01/00/0000 '}, [size( cHHMMSS, 1 ), 1]), cHHMMSS ), 'mm/dd/yyyy HH:MM:SS');
     % because of the format, do a somewhat wonky way. Add year, yearday and time in
     dat.ctime = datenum( yy, 0, 0 )+yday+timein;
     
     % GPS time
%      mHHMMSS = char(datin{:,29});
     % the computer was in PST while the GPS is in UTC. assume clock drift
     % <0.1 seconds over 1 day.
%      offsetE = 7./24; % estimate a 7 hour offset from UTC
%      % DO THIS THE CRAPPY SLOW, BUT WORKS WAY. UGH.
%      HH = str2num(mHHMMSS(:,1:2));
%      MM = str2num(mHHMMSS(:, 4:5));
%      SS = str2num(mHHMMSS(:, 7:end));
%      ctimeE = dat.ctime+offsetE;
%      [Y,MO,D,H,MI,S] = datevec(dat.ctime+offsetE);
%      
%      % find the relative difference THIS IS WRONG. SOMETHING IS UP.
%      mtimeE = datenum(Y, MO, D, HH, MM, SS); 
%      offsetR = nanmean( mtimeE - ctimeE );
     % now add the correction to the computer time to find the NMEA time
%      dat.NMEAtime = dat.ctime+offsetR+offsetE; 
offset = 0.2914;  % Calculated manually from data
dat.NMEAtime = dat.ctime+offset; 
     
     % GPS location
     lat = datin{4}+datin{5}./60;
     NS  = datin{6};
     latsign = lat*0+1; latsign( strmatch( 'S', NS )) = -1;
     dat.lat = lat.*latsign;
     
     lon = datin{7}+datin{8}./60;
     EW = cell2mat(datin{9});
     lonsign = lon*0+1; lonsign( strmatch( 'W', EW)) = -1;
     dat.lon = lon.*lonsign;
     % Boat speed over Ground
     dat.SOGn = datin{10}; % [m/s]
     dat.SOGe = datin{11}; % [m/s]
     % bottom depth (gotta filter out wind waves, everything less than 5
     % min)
     dat.depth = datin{12}; % [m]
     
     % HOW THE ACROBAT WAS FLYING
     % acrobat depth
     dat.z = datin{13}; % [m/s]
     % lay back from stern of boat
     dat.layback = datin{14}; % [m/s]
     % wing angle
     dat.wingangle = datin{15}; % [degrees, + up]
     % altitude
     dat.altitude = datin{16}; % [m]
     % vertical speed
     dat.speedvert = datin{17}; % [m/s]
     % flying mode
     dat.flymode = char(datin{18}); % MAN, DPT, ALT, D/A, PGEN
     % depth limits
     dat.shallowlim = datin{19}; % [m]
     dat.deeplim = datin{20};% [m]
     % control coefficents
     dat.k1 = datin{21};
     dat.k2 = datin{22};
     dat.k3 = datin{23};
     % roll, pitch and heading
     dat.roll = datin{24};
     dat.pitch = datin{25};
     dat.heading  = datin{26};
     
     % OTHER RANDOM
     % temperature
     dat.temp = datin{27};
     % altitude from altimeter
     dat.altimeter = datin{28};
     
     % if no data is not recording from the acrobat, the pitch ,roll and heading will all be zero
     % define these points as bad indices
     badinds = find( dat.roll+dat.pitch+dat.heading == 0);
     dat.flag = zeros(size(dat.ctime));
     dat.flag(badinds) = 1;
     
     clear EW NS GPSdateoffset ctimeref NMEAref cHHMMSS datestrout lat latsign lon lonsign mHHMMSS yday yy timein
     
     % NOW CONCAT INTO 1 LARGE STRUCTURE
     vars = fieldnames( dat );
     
     for vv = 1:length( vars )
         % concatenate vertically
         acro.(vars{vv})  = cat( 1, acro.(vars{vv}) , dat.(vars{vv}) );
     end
     
 end %d