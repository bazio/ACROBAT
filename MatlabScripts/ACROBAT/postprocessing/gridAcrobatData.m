function [gridded] = gridAcrobatData(CTD, ECO, tpCTD, updowns, dp, maxp)

% function [gridded] = gridAcrobatData(CTD, ECO, tpCTD, updowns,  dp, maxp)
%
% Put the acrobat data on a grid 
%
% KIM 06.13

% if the max depth isn't defined, just chose the deepest depth
if nargin < 6
     maxp = ceil(nanmax( CTD.p ));
end
if nargin <5
    dp = 0.5; %default 0.5 m bins
end

% find the longest data vec 
maxlength= nanmax( diff(tpCTD)); 
profiles = length( tpCTD )-1; 

% make the pressure grid
pgrid = 0:dp:maxp; 

% make pressure matrices
gridded.p = pgrid'; 
gridded.z = sw_dpth( gridded.p, nanmean( CTD.lat )); 

% NEED TO PULL GOOD INDS ONLY.

% make the lat, lon and time vectors, location at start of profile
for cc = 1:profiles
    % pull the indices
    inds = tpCTD(cc):tpCTD(cc+1);
    % lat
    datin = CTD.lat(inds);
    gridded.lat(cc) = datin(find( ~isnan( datin ), 1, 'first'));
    %long
    datin = CTD.lon(inds);
    gridded.lon(cc) = datin(find( ~isnan( datin ), 1, 'first'));
    %time
    datin = CTD.ctime(inds);
    gridded.mtime(cc) = datin(find( ~isnan( datin ), 1, 'first'));
end %cc

% add the yearday
gridded.yday = gridded.mtime - datenum( 2012, 01, 01); 
% add distance to CTD
dist = sw_dist( gridded.lat, gridded.lon, 'km'); 
dist( end+1) = dist( end); 
dist( dist >1) = nan; 
gridded.dist = nancumsum(dist, 2)*1000; 
gridded.totaldist = nansum( dist*1000 ); 

% total time
dtime = diff( gridded.mtime); 
dtime( dtime> 0.02 ) = nan; 
gridded.totaltime = nansum( dtime ); 


% define the updown
gridded.updown = gridded.lat*nan; 


% define the other variables
vars = {'t', 's', 'th', 'dens', 'sgth'};
% eventually add in the ECOpuck here too.
dum = nan( length( pgrid ), profiles ); 
for vv = 1:length( vars)
    gridded.(vars{vv}) = dum;
end %vv

% Now separate the data into profiles
for vv = 1:length( vars ) % cycle through the variables
    for cc = 1:profiles % go through all the profiles
            % define whether up or down profile
            gridded.updown(cc) = updowns(cc); 
            % pull the indices
            inds = tpCTD(cc):tpCTD(cc+1); 
            % extract the data vector
            datin = CTD.(vars{vv})(inds); 
            % extract the pressure
            pin = CTD.p(inds); 
            if updowns(cc) ==1
            % flip if up profile
                datin = flipud( datin ); 
                pin = flipud( pin ); 
            end
            % Now BIN
             binout = binaverage( pin, datin, pgrid' ); 
             gridded.(vars{vv})(:,cc) = binout; 
    end
end

%  now let's bin the ECOpuck data
tpECO = interp1( ECO.ctime, 1:length( ECO.ctime ), CTD.ctime(tpCTD) ); 
tpECO = floor( tpECO ); 
tpECO = [tpECO, length( ECO.ctime )]; 

% Grid the ECOpuck
% define the other variables
vars = {'chl', 'particle', 'CDOM'};
% eventually add in the ECOpuck here too.
dum = nan( length( pgrid ), profiles ); 
for vv = 1:length( vars)
    gridded.(vars{vv}) = dum;
end %vv

% Now separate the data into profiles
for vv = 1:length( vars ) % cycle through the variables
    for cc = 1:profiles % go through all the profiles
            % pull the indices
            inds = tpECO(cc):tpECO(cc+1); 
            if (~isempty(inds)) && (length( inds) >1)
                % extract the data vector
                datin = ECO.(vars{vv})(inds);
                % extract the pressure
                pin = ECO.p(inds);
                % flip if up profile
                if updowns(cc) ==1
                    datin = flipud( datin );
                    pin = flipud( pin );
                end
                % Now BIN
                binout = binaverage(pin, datin,  pgrid' );
                gridded.(vars{vv})(:,cc) = binout;
            end
    end
end