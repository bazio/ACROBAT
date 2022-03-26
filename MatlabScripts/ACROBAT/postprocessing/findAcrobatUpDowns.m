function [ tpCTD, updowns ] = findAcrobatUpDowns(CTD, plotit)

% function [ tpCTD ] = findAcrobatUpDowns(CTD, plotit)
%
% Using the CTD pressure data, separate the data trace into up and down
% profiles. This is done to make a gridded product and makes it easier to
% depth bin each profile. Roughly binned pressure data is used here to find
% the turning points.
%
% KIM 06.13

if nargin < 2
    plotit = 0;
end

% set the size of time bin to find the turning points
dt = 5./24./60./60; % 5-second bin size

% first find the good data
goodinds = find( CTD.flag ~=1);

p = CTD.p(goodinds); 
time = CTD.ctime(goodinds);

% interpolate over any nans at the ends of the time vector if they exist
time = interp1( find( ~isnan(time)), time(~isnan(time)), 1:length(time), 'linear', 'extrap')';

% bin the pressure
tbin = [nanmin(time):dt:nanmax(time)]'; 
pbin = binaverage( time, p, tbin ); 

% use the binned data to calculate first and second derivatives of pressure
dpdt = gradient( pbin, tbin ); % vertical velocity
d2pdt2 = gradient( dpdt, tbin ); % double derivative of pressure


% make an up-down vector from the binned pressure data
% (+1 acrobat rising, -1 acrobat sinking, 0 constant depth)
udvec = nan*pbin;
udvec( sign( dpdt ) <0 ) = +1; % find all the up data points
udvec( sign( dpdt ) >0 ) = -1; % find all the down points

% find all the turning points in the up-down vector
tpb = find( diff( udvec) ~=0 ); 
tpb = tpb+1; % shift one indice to the right
% now to only keep the turning points that define the start of a new
% profile. Empirically decided that profiles with less than 5 data points
% are small 'jogs' undergone by the acrobat rather than a total profile.
faketurns = find(diff( tpb) <5); % find fake turns dur to jogs
tpb(faketurns) = nan;  % throw fake turns out.
tpb = tpb(~isnan( tpb )); 

% Define whether each profile is up or down
updowns = udvec( tpb ); 
badinds = find( diff(updowns) ==0 ); 
badinds = badinds+1;

% now remove the bad indices
updowns(badinds) = nan; 
updowns = updowns( ~isnan( updowns )); 
tpb(badinds) = nan; 
tpb = tpb( ~isnan( tpb )); 

%  now use find the turning points in the original CTD data vector
tpCTD = interp1( time, 1:length( time ), tbin(tpb) ); 
tpCTD = floor( tpCTD ); 
tpCTD = [tpCTD; length( time )]; 

% by default don't plot the data
if plotit ~=0
    % plot it up
    figure(plotit); clf
    plot( tbin, pbin, 'k-', tbin(sign( dpdt ) <0), pbin(sign( dpdt ) <0 ), 'r.', tbin( sign( dpdt ) >0 ), pbin( sign( dpdt ) >0 ), 'b.'); hold on
    plot( time(tpCTD), p(tpCTD), 'kp', 'markerfacecolor', 'c', 'markersize', 12)
    axis ij; datetick
    
    legend( 'flight path', 'up cast', 'downcast', 'turning pts')
    titleout( 'up and down casts')

end