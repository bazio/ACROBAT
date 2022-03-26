function ProcessAndGridAcrobatData_IRmod( top_dir, cruise_name )
%this function 

%
%ISAAC 02.22 fixed an issue where turningpoints get out of sync if there
%are nans at nans at the beginning of the CTD.gpstime. This is because the
%unique function is not removing nans, it's moving them to the end of the
%new vector. This causes a shift in the data that was no accounted for in
%later indexing for turning points in CTD data.

% KIM 08.13

% ECOpuck serial number
sn = 'FLBBCD2K-3883';

redo=0;%set this to 1 if you've already hand cleaned 
% the file and you are happy with it and you don't want to change it.
%this will load a previously saved version of the indicies you hand
%selected to remove, and remove them again. Set this to 0 if you have a new
%data set, or you want to start fresh.


alter=0;
%set this to 1 if you want to alter an existing hand cleaned file to remove
%additional data points. This will load the previous version, apply it, and
%then enter the hand clean function for you to add more kill points, and
%then once you are done combines the you new kill points with the old kill
%points.

% IDENTIFY THE TARGET DIRECTORY
targetdir = fullfile( top_dir, cruise_name, 'DATA', 'ACROBAT','PROCESSED');

%LOAD THE DATA
load( fullfile( targetdir, 'GPS.mat'));
load( fullfile( targetdir, 'CTD.mat'));
load( fullfile( targetdir, 'ECO.mat'));
load(fullfile( targetdir, [cruise_name,'Legs.mat']))

% interpolate the GPS data time onto the CTD and ECOpuck data
flagger = find( GPS.flag == 0 );%0 flag data is good data.
tmp1 = GPS.ctime(flagger);%extract those good data points
[tmp1u , m, n] = unique(tmp1);%get the unique version of thos flags.
tmp2 = GPS.gpstime(flagger);%now getting the gps times with no flags
%however,I have noticed that sometime gpstime will get spikes.
%the method to remove those spikes is to take the differential and find
%any negatives, which indicate negative, which is not possible and therefor
%is a problem to be removed.

dtmp2=(diff(tmp2));
index_badgpstime=find(dtmp2<0);
if length(index_badgpstime)>10;
    Display('There is a lot of bad gpstime data. Review GPS data. Comment out this check and rerun if you would like to continue as is');
    keyboard
end
tmp2(index_badgpstime)=nan;
tmp2=naninterp(tmp2);


% tmp2u = unique(tmp2);
tmp2u = tmp2(m); %and getting the unique version of those
% tmp3 = CTD.ctime;
tmp3 = GPS.lat(flagger);%getting lat
tmp3u = tmp3(m);
tmp4 = GPS.lon(flagger);%getting lon
tmp4u = tmp4(m);

[B, I, J ] = unique( CTD.ctime );
CTD.ctime = CTD.ctime(I);
CTD.p = CTD.p(I);
CTD.t = CTD.t(I);
CTD.c = CTD.c(I);%so the data all matches up with ctime.

CTD.gpstime = interp1(tmp1u, tmp2u, CTD.ctime);
ECO.gpstime = interp1(tmp1u, tmp2u, ECO.ctime);
CTD.lat = interp1(tmp1u, tmp3u, CTD.ctime);
CTD.lon = interp1(tmp1u, tmp4u, CTD.ctime);


% interpolate the pressure onto the ECOpuck data
ECO.p = interp1( CTD.ctime, CTD.p, ECO.ctime);%recall that eco is sampling at
%a slower rate.




if cruise_name(1:10)=='SKQ202010S';
        % PROCESS THE ECOPUCK DATA
    %the SKQ202010S cruise had the ecopuck swapped out in the middle. The
    %time that it was swapped out is 2020 7 13 12 35.To account for this
    %the extisting ECO data, which combined together the entire cruise, is
    %split at that time, and then each is processed by it's appropriate
    %cals and then recombined.
    naner = find( ~isnan(ECO.gpstime));
    nonanECO=ECO.gpstime(naner);
    ECO1timesi=find(nonanECO<datenum(2020,7,13,12,35,00));%indices in terms of nonnan
    ECO2timesi=find(nonanECO>datenum(2020,7,13,12,35,00));

    ECO1timesi_with_nan=naner(ECO1timesi);
    ECO2timesi_with_nan=naner(ECO2timesi);
    %ECO1timesi was in terms of naner. and naner is in terms of our
    %original dataset what has the nans included.So this will let us pull
    %out from our orinal data set, the nans + the real values before teh
    %date of interests and after the date of interest. 



    ECO1=ECO;
    ECO1.ctime(ECO2timesi_with_nan(1):end)=[];
    ECO1.chlsig(ECO2timesi_with_nan(1):end)=[];
    ECO1.backsig(ECO2timesi_with_nan(1):end)=[];
    ECO1.CDOMsig(ECO2timesi_with_nan(1):end)=[];
    ECO1.gpstime(ECO2timesi_with_nan(1):end)=[];
    ECO1.p(ECO2timesi_with_nan(1):end)=[];

    ECO2=ECO;
    ECO2.ctime(1:ECO1timesi_with_nan(end))=[];
    ECO2.chlsig(1:ECO1timesi_with_nan(end))=[];
    ECO2.backsig(1:ECO1timesi_with_nan(end))=[];
    ECO2.CDOMsig(1:ECO1timesi_with_nan(end))=[];
    ECO2.gpstime(1:ECO1timesi_with_nan(end))=[];
    ECO2.p(1:ECO1timesi_with_nan(end))=[];
  % ECOpuck serial number
    sn = 'FLBBCD2K-2710';
    % get the calibrations for the ECOpuck
    [ ECO.par ] = ECOpuckCals( sn );
    % Now process ECOpuck
   
    [ECO1] = processECOpuck( ECO1, ECO.par );
    sn = 'FLBBCD2K-3883';
    % get the calibrations for the ECOpuck
    [ ECO.par ] = ECOpuckCals( sn );
    % Now process ECOpuck
   
    [ECO2] = processECOpuck( ECO2, ECO.par );


    ECO.chl =  [ECO1.chl;ECO2.chl]; 

    % backscattering to particle concentration [m^-1 sr^-1]
    ECO.particle = [ECO1.particle;ECO2.particle]; 
    
    % CDOM fluorescence to dissolved organic matter [ppb]
    ECO.CDOM = [ECO1.CDOM;ECO2.CDOM];
    
    % output the calibration data
    ECO.par = [ECO1.par;ECO2.par];
else
        % PROCESS THE ECOPUCK DATA

    %serial number entered at the top of this file

    % get the calibrations for the ECOpuck
    [ ECO.par ] = ECOpuckCals( sn );
    % Now process ECOpuck
    [ECO] = processECOpuck( ECO, ECO.par );
end

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


%CLEAN UP DATA WITH MANUAL EDITING



[t, ucc] = unique( CTD.gpstime);%this creates two vectors one that is the unique times from the gps time, and one that is those corresponding indicies.


figure(1);
if redo==1
load( fullfile( targetdir, 'corrected.mat'),'-mat','removedIndices');
    if alter==1
    badsal=removedIndices{2};
    S=CTD.s(ucc);
    S(badsal)=nan;
    J=juliandate(datetime(t,'ConvertFrom','datenum'));
    D=horzcat(J,S);
    [~,removedIndices_2ndround]=hand_cleanup_IR(D);
    time2ndround=removedIndices_2ndround{1};
    sal2ndround=removedIndices_2ndround{2};
    removedIndices{1}=vertcat(removedIndices{1},time2ndround);
    removedIndices{2}=vertcat(removedIndices{2},sal2ndround);
    end

else
J=juliandate(datetime(t,'ConvertFrom','datenum'));
D=horzcat(J,CTD.s(ucc));
[~,removedIndices]=hand_cleanup_IR(D);
end
%indentify the good indices in terms of the CTD.gpstime indicies.
badindi_in_terms_of_J=removedIndices{1}; %this is bad indicies that we just removed from J.
ucc(badindi_in_terms_of_J)=nan;
goodi=ucc(~isnan(ucc));

% savedir = fullfile(top_dir, cruise_name, 'Data', 'ACROBAT', 'PROCESSED');
% name = 'corrected';
% savefile = fullfile( savedir, name );
% eval( ['save ', savefile ,' CTD ', ' ECO ','removedIndices'])





% IDENTIFY TURNING POINTS

t=CTD.gpstime(goodi);
p = CTD.p(goodi);%we do this because if the CTD.gpstime is repeating, the lat long is also repeating and thus the measuremnt is wrong, so this weeds out both,
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


tpCTD = [tpCTD, length( t )];%this creates a "turning point" but its not a turning point,
%its our last value and it's important to include because without it, our
%last real turningpoing doesn't have and end. Remember how all the lat
%longs specify the start of either an upcast or a downcast? by including
%the last good point, we have a final lat long, which for one thing, is
%neccessary to calculate the distance of the last profile. Also all our
%other turning points are real turning points, which mean the last real
%turning points needs a last point. This is why we do this.



%the plot looks good because it's all relative to bins that have the fake
%extraploated values piled up at the end. The real values still contained
%in CTD structure still have the nans in the front, and possibly
%interspered within.
%one solution is change tpCTD to always align correctly. Another solution
%is to change all the data vectors coming out of CTD to be similarly
%modified. It seems like teh best solution is to change tpCTD to be
%correct.but after trying that and failing, we've opted for simply mimicing
%the indeicies that were pulled out for pressure, and applying those
%incides to all data that we pull from the CTD structure.




%GRID THE DATA

%  Now that figured out the turning points, let's break up the data and grid it
% find the longest data vec
%maxlength= nanmax( diff(tpCTD));
profiles = length( tpCTD ) - 2;

%  define the grid
dp = 1; % grid spacing 0.5 meters
maxp = 65; %ceil( nanmax( p ));
pgrid = 0:dp:maxp;

% make pressure matrices
gridded.p = pgrid';
gridded.z = sw_dpth( gridded.p, nanmean( CTD.lat(goodi) ));

% make the lat, lon and time vectors, location at start of profile
    unilatdatin=CTD.lat(goodi);
    unilondatin=CTD.lon(goodi);
    unitimdatin=CTD.ctime(goodi);
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
unipress=CTD.p(goodi);
for vv = 1:length( vars ) % cycle through the variables
        univardatin=CTD.(vars{vv})(goodi);
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
naner = find( ~isnan(ECO.gpstime));%remove nan times first.
% lets also remove sections where the salinity data was bad.
goodCTDtime=CTD.gpstime(goodi);
CTDnaner=find(~isnan(goodCTDtime));

indiciesfor_good_ECO_times_via_handcleaning=interp1(unique(ECO.gpstime(naner)),1:length(unique(ECO.gpstime(naner))),goodCTDtime(CTDnaner));
indiciesfor_good_ECO_times_via_handcleaning = floor( indiciesfor_good_ECO_times_via_handcleaning );
 %interp actualy also procudes nans, if the function being interoplated is
 %gappy enough, such as the case with the ECO having a slower sampling
 %than the CTD. We don't want to concern ourselves with those nans, we want
 %a good index that we can use to access the original data, to extract
 %pressure at teh right time to then grid it. Gridding it will then leave
 %the gaps in the ECO data showing, as expected. SO we denan our cleaned,
 %unique and previously denaned data.
final_denan_of_ECO = find( ~isnan(indiciesfor_good_ECO_times_via_handcleaning));
finalindices=indiciesfor_good_ECO_times_via_handcleaning(final_denan_of_ECO);

%this is what we have to do to each variable. In order to make sure we
%extract from the original data set at teh right index.
%************************
[unique_and_denanedECOtime,ucc]=unique(ECO.gpstime(naner));
%but we also ahve to run these times through unique, on top of the
%cleaning, since interoplate produced yet more repeat values that we are
%not intersted in.
[finaledECOtimes,extraucc]=unique(unique_and_denanedECOtime(finalindices));
%****************

tpECO = interp1( finaledECOtimes, 1:length( finaledECOtimes ), tbin(tpb));
%It doesn't matter how the tpb are termed, the result is a series of times.
%What interp is doing for us here is OK what indicie are the finaled
%ECOtimes equal to tbin(tpb). So that works OK.

%using intropolcation this gives us where, the indicies +fraction that
%descibe where the previously defined turning points occur.
%but these turning point indices are in terms of a vector that is 1 to the
%length of the finaledECOtimes not length ECO.gpstime, and is
%the same issue as before. So we implement the same fix. 

tpECO = floor( tpECO );%this gives us the actual indici
tpECO = [tpECO, length( finaledECOtimes )];%this appends a final indici equal to our original length.

% Grid the ECOpuck
% define the other variables
vars = {'chl', 'particle', 'CDOM'};

dum = nan( length( pgrid ), profiles ); %makes a bunch of nans
for vv = 1:length( vars)
    gridded.(vars{vv}) = dum;
end %vv
%we have now preallocated. Ready for the seperation.
% Now separate the data into profiles


%Doing what we did to gpstime, but now to pressure.and we do it via
%prevoulsy defined indcies, we are not for example interested in the unique
%values of pressure. We are intrested in the pressure values that
%correspong to the unique times.And so on.
unipress=ECO.p(naner);
unipress=unipress(ucc);
unipress=unipress(finalindices);
unipress=unipress(extraucc);

for vv = 1:length( vars ) % cycle through the variables

    %Doing what we did to gpstime, but now to the other par variables
     univardatin=ECO.(vars{vv})(naner);
     univardatin=univardatin(ucc);
     univardatin=univardatin(finalindices);
     univardatin=univardatin(extraucc);

    
    for cc = 1:profiles % go through all the profiles
        % pull the indices
        inds = tpECO(cc):tpECO(cc+1);%our turning points in terms of the uniqued and naned data.
        if (~isempty(inds)) && (length( inds) >1)
            % extract the data vector
            datin = univardatin(inds); %now tpECO and this univardatin are referring to the same things.
            % extract the pressure
            pin = unipress(inds);

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


% SAVE OUT THE ACROBAT DATA!!!!
savedir = fullfile(top_dir, cruise_name, 'Data', 'ACROBAT', 'PROCESSED');
name = 'gridded';
savefile = fullfile( savedir, name );
eval( ['save ', savefile , ' gridded '])
name = 'corrected';
savefile = fullfile( savedir, name );
eval( ['save ', savefile ,' CTD ', ' ECO ','removedIndices'])
disp( 'Acrobat binned data processed and saved')


