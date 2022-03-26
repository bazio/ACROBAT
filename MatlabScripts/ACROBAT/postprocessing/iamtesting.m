function ProcessAndGridAcrobatData( top_dir, cruise_name )
%
%ISAAC 02.22 fixed an issue where turningpoints get out of sync if there
%are nans at nans at the beginning of the CTD.gpstime. This is because the
%unique function is not removing nans, it's moving them to the end of the
%new vector. This causes a shift in the data that was no accounted for in
%later indexing for turning points in CTD data.
% KIM 08.13
clear all

% IDENTIFY THE TARGET DIRECTORY
targetdir = fullfile( top_dir, cruise_name, 'DATA', 'ACROBAT','PROCESSED');

%LOAD THE DATA
load( fullfile( targetdir, 'GPS.mat'));
load( fullfile( targetdir, 'CTD.mat'));
load( fullfile( targetdir, 'ECO.mat'));

% interpolate the GPS data time onto the CTD and ECOpuck data
flagger = find( GPS.flag == 0 );
tmp1 = GPS.ctime(flagger);
[tmp1u , m, n] = unique(tmp1);
tmp2 = GPS.gpstime(flagger);
% tmp2u = unique(tmp2);
tmp2u = tmp2(m);
% tmp3 = CTD.ctime;
tmp3 = GPS.lat(flagger);
tmp3u = tmp3(m);
tmp4 = GPS.lon(flagger);
tmp4u = tmp4(m);

[B, I, J ] = unique( CTD.ctime );
CTD.ctime = CTD.ctime(I);
CTD.p = CTD.p(I);
CTD.t = CTD.t(I);
CTD.c = CTD.c(I);

CTD.gpstime = interp1(tmp1u, tmp2u, CTD.ctime);
ECO.gpstime = interp1(tmp1u, tmp2u, ECO.ctime);
CTD.lat = interp1(tmp1u, tmp3u, CTD.ctime);
CTD.lon = interp1(tmp1u, tmp4u, CTD.ctime);

% CTD.gpstime = interp1(GPS.ctime(flagger), GPS.gpstime(flagger), CTD.ctime);
% ECO.gpstime = interp1(GPS.ctime(flagger), GPS.gpstime(flagger), ECO.ctime);
% CTD.lat = interp1(GPS.ctime(flagger), GPS.lat(flagger), CTD.ctime);
% CTD.lon = interp1(GPS.ctime(flagger), GPS.lon(flagger), CTD.ctime);
% interpolate the pressure onto the ECOpuck data
ECO.p = interp1( CTD.ctime, CTD.p, ECO.ctime);

% PROCESS THE ECOPUCK DATA
% ECOpuck serial number
sn = 'FLBBCD2K-3883';
% get the calibrations for the ECOpuck
[ ECO.par ] = ECOpuckCals( sn );
% Now process ECOpuck
[ECO] = processECOpuck( ECO, ECO.par );

% PROCESS THE CTD DATA
CTpar.freq =  1/16; % sample rate (Hz) for SeaBird FastCat
%CTpar.alpha =  0.14;
CTpar.alpha =  0.03; %suggested value in SBE49 manual
%CTpar.alpha =  0.14; %K. Martini calculated value
CTpar.tauCTM = 7; % suggested value in SBE49 manual
CTpar.tauT = 0; % not defined yet
CTpar.tP = 0; % not defined yet
CTpar.t_advance = 1.*(0.0625)./86400; %advance Temperature by 0.0625 seconds, suggested value in SBE49 manual, Convert to decimal day
[CTD] = processAcrobatCTD( CTD, CTpar );

% GRID THE DATA

% pull the time and the pressure
[t, ucc] = unique( CTD.gpstime); %this creates two vectors one that is the unique times from the gps time, and one that is those corresponding indicies.
p = CTD.p(ucc);%we do this because if the CTD.gpstime is repeating, the lat long is also repeating and thus the measuremnt is wrong, so this weeds out both,
templist=1:length(CTD.gpstime);
what=ucc';
logi_ucc=templist==what;
% and grabs the good values that remain, sorting them from least to
% greatest which is ok since time is linear.Also, it puts all the nans at
% the end of the vector, but doesn't remove them.

% remove any nans
t = interp1( find( ~isnan(t )), t(~isnan(t )), 1:length(t), 'linear', 'extrap')';%since all the nans are at the end
%this doesn't actually change the consecutively ordered gps time, but it
%does replace all those nan values at the end with linearly
%extrapolated values. 
%on the x axis is the indicies of real nans, on the Y the real times
%and then the 1:length(t) is the indicies of all of length t
%and we get out times for all those indices. So it essentially extrapolates
%across all of the nans.


% bin the pressure data
dt = 5./24./60./60; % bin size. 5 seconds.
tbin = [nanmin(t):dt:nanmax(t)]; %t already doesn't have any nans, but now we've made a tbin that includes extrapolated values,
%so there are nonreal max t here that associate with real pressure valeus
%all of which assoicates with nan values of t.



pbin = binaverage( t, p, tbin' );%the p that is the same length as t then gets binned accordingly.
%this output of pbin has real values of pressure binned within real time
%bin values and has fake time values that contain what amounts to bad
%pressure data.


% so the turning points are cacluated from pbin and the time is paired with it always so that we can find the value in the original
% calculate first and secind derivatitives to find turning points
dpdt = gradient( pbin, tbin ); % vertical velocity.
d2pdt2 = gradient( dpdt, tbin ); % double derivative of pressure. not used right now.
% find up and down profiles
upi= find( sign( dpdt ) <0); % find all the up data points. Find negative velocities relative to pressure
dwni = find( sign( dpdt ) >0 ); % find all the down points. Finding positive velocites relative to pressure.

%Don't forget those bogus times and pressures are still in there.

% make one giant vector
udvec = nan*pbin;%makes a blank vector
udvec(upi) = +1;%and inserts all of the ups
udvec(dwni) = -1;%and all of the downs, now its relative to height, noting that dwni was the postive values as pressure increases downward.
% find turning points
tpb = find( diff( udvec) ~=0 ); %if velcityis changing sign, then we must be turning. We find the indicies for that condition.
tpb = tpb+1; % shift one indice to the right. If we shift everything to the right.
faketurns = find(diff( tpb) <5); %after a real turn, there should be no other turn for at least 20 seconds (guessing 
% as to how long a turn takes here). So if that next turn index (the one to the right of our real one) is only 4
% or less indicies away from our turn (in the udvec space),we 
%say that that turn is fake.
tpb(faketurns) = nan;
tpb = tpb(~isnan( tpb ));%we remove all the fake turns.
% now define whether the following profile is up or down
updowns = udvec( tpb ); %now we exract our real turns indicatedd by the remaining +1 and -1's in udvec and make an vector from that.
badinds = find( diff(updowns) ==0 );%we find where for example -1 and -1 are next to each other.
badinds = badinds+1; %we shift
% now remove the bad indices
updowns(badinds) = nan; %and we remove. Note that if we remove small wiggles that occur in the middle of a cast, this will put -1s beside -1 and 
%+1 beside +1s. Isaac has written up code that combines casts in this case
%back to being a full -1 or a full +1. Howver, with or without Isaac's additional code, this results are correct.
updowns = updowns( ~isnan( updowns ));
tpb(badinds) = nan;
tpb = tpb( ~isnan( tpb )); 

%  now use find the turning points in the original CTD data vector
[tt,in] = unique(t); %so if t no has no nans and has been extrolated and was the result of being unique
%I don't expect this command to ever do anything.
tpCTD = interp1( tt, 1:length( tt ), tbin(tpb) );%this line is taking our time vector that represents 
%times consective from the first real instance of a value all the way to
%the end and then plus some nonreal ogus times that are connected to real bogus
%pressures.We call that x. we also designate a Y vector that is essentially
%the indices of tt. And then we say, Ok we have the times for our turning
%points, what are the incdies for those turning points in terms of tt. 

tpCTD = floor( tpCTD ); %since our turning points are might not line up perfectly with tt, since they are binned values, we need to
%floor all values in tpCTD to get a interger value for our turning point.

% plot it up
figure
plot(tbin, pbin, 'ko-', tbin(upi), pbin(upi ), 'r.', tbin( dwni ), pbin( dwni ), 'b.'); hold on
plot( t(tpCTD), p(tpCTD), 'kp', 'markerfacecolor', 'c', 'markersize', 12)
axis ij
%to find a particular leg, look at the tlim for your leg of interest and do
%something like this:
 %zindi=find(tbin<lim2 & lim1<tbin);
 %plot(tbin(zindi), pbin(zindi), 'o');
ax=gca;
ax.XTickMode='manual';
ax.XTick=ax.XLim(1):.5:ax.XLim(2);
datetick( 'x',0,'keeplimits','keepticks')
legend( 'track', 'up', 'down', 'turning points')
titleout( 'up and down profiles')


tpCTD = [tpCTD, length( t )];%this creates a turning point at the end of our list of real turning points that corresponds
%to the last time in t which, if there are any nans, is not actually a
%turning point..I think it has to do with finding the last lat long for the
%end of the cruise possibly.



%the plot looks good because it's all relative to bins that have the fake
%extraploated values piled up at the end. The real values still contained
%in CTD structure still have the nans in the front, and possibly
%interspered within.
%one solution is change tpCTD to always align correctly. Another solution
%is to change all the data vectors coming out of CTD to be similarly
%modified. It seems like teh best solution is to change tpCTD to be
%correct.but after trying that and failing, we've opted for chaning tpCTD
%  Now that figured out the turning points, let's break up the data and grid it
% find the longest data vec
%maxlength= nanmax( diff(tpCTD));
profiles = length( tpCTD ) - 2;

%  define the grid
dp = 0.5; % grid spacing 0.5 meters
maxp = 65; %ceil( nanmax( p ));
pgrid = 0:dp:maxp;

% make pressure matrices
gridded.p = pgrid';
gridded.z = sw_dpth( gridded.p, nanmean( CTD.lat(ucc) ));

% make the lat, lon and time vectors, location at start of profile
    unilatdatin=CTD.lat(ucc);
    unilondatin=CTD.lon(ucc);
    unitimdatin=CTD.ctime(ucc);
for cc = 1:profiles
    % pull the indices
    inds = tpCTD(cc):tpCTD(cc+1);%tpCTD is all of our turningpoint, by so this is just all of the points between two turning points.
    % lat

    datin = unilatdatin(inds);%all our lats.
    test = datin(find( ~isnan( datin ), 1, 'first'));%find the first values in our list of lats
    if ~isempty(test)%if its not empty
        gridded.lat(cc) = datin(find( ~isnan( datin ), 1, 'first'));%the first lat passes muster and goes into the grid.
    end
    %long. Same proceedure.

    datin = unilondatin(inds);
    test1 = datin(find( ~isnan( datin ), 1, 'first'));
    if ~isempty(test1)
        gridded.lon(cc) = datin(find( ~isnan( datin ), 1, 'first'));
    end
    %time
    
    datin = unitimdatin(inds);
    test2 = datin(find( ~isnan( datin ), 1, 'first'));
    if ~isempty(test2)
        gridded.mtime(cc) = datin(find( ~isnan( datin ), 1, 'first'));
    end
end %cc


% add distance to CTD (from start point)
dist = sw_dist( gridded.lat, gridded.lon, 'km');
dist( end+1) = dist( end);
% dist( dist >1) = nan;
gridded.dist = dist; %distance in km
gridded.totaldist = nansum( dist*1000 );

% add distance to CTD (from nearshore point)
% dist = sw_dist( gridded.lat, gridded.lon, 'km');
% inshore_ind = find(max(gridded.lon));
% lat1 = gridded.lat(inshore_ind);
% lon1 = gridded.lon(inshore_ind);
% for in = 1:length(gridded.lon)-1,
%     dist(in) = m_idist(lon1,lat1,gridded.lon(in),gridded.lat(in));
% 
% end
% dist = dist./1000; %convert to meters
% dist( end+1) = dist( end);
% dist( dist >1) = nan;

% total time
dtime = diff( gridded.mtime);
dtime( dtime> 0.02 ) = nan;
gridded.totaltime = nansum( dtime );


% define the updown
gridded.updown = gridded.lat*nan;

% Grid the other variables
% define the other variables
vars = {'t', 's', 'dens'};
% eventually add in the ECOpuck here too.
dum = nan( length( pgrid ), profiles );
for vv = 1:length( vars)
    gridded.(vars{vv}) = dum;
end %vv

% Now separate the data into profiles
unipress=CTD.p(ucc);
for vv = 1:length( vars ) % cycle through the variables
        univardatin=CTD.(vars{vv})(ucc);
    for cc = 1:profiles % go through all the profiles
        % define whether up or down profile
        gridded.updown(cc) = updowns(cc);
        % pull the indices
        inds = tpCTD(cc):tpCTD(cc+1);
        % extract the data vector

        datin = univardatin(inds);
        % extract the pressure

        pin = unipress(inds);
        if updowns(cc) ==1
            % flip if up profile
            datin = flipud( datin );
            pin = flipud( pin );
        end
   %     Now BIN


        binout = binaverage( pin, datin, pgrid' );
        gridded.(vars{vv})(:,cc) = binout;
    end
end

%  now let's bin the ECOpuck data

% find the turning points in the ECO puck data
naner = find( ~isnan(ECO.gpstime));
tpECO = interp1( unique(ECO.gpstime(naner)), 1:length( unique(ECO.gpstime(naner)) ), tbin(tpb) );
tpECO = floor( tpECO );
tpECO = [tpECO, length( unique(ECO.gpstime(naner)) )];

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
            binout = binaverage( pin, datin, pgrid' );
            gridded.(vars{vv})(:,cc) = binout;
        end
    end
end
