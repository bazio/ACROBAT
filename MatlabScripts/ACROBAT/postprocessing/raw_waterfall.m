clear all; close all; clc;
top_dir = 'C:\Users\stats\Documents\Chukchi\2013\CRUISE_DATA\Chukchi_2013_N2';
mat_dir = 'C:\Users\stats\Documents\Acrobat\TEST';
cruise_name = 'ChukchiGliderCruise2013';
targetdir = fullfile( top_dir, cruise_name, 'DATA', 'ACROBAT','PROCESSED'); 
load( fullfile( targetdir, 'corrected.mat')); 
targetdir = fullfile( top_dir, cruise_name, 'DATA', 'ACROBAT','PROCESSED', 'TC_CORRECTED_PLOTS'); 

%%
figure;
st = near(CTD.ctime,datenum(2013,9,9,16,55,40),1);
nd = near(CTD.ctime,datenum(2013,9,9,16,58,10),1);

dpdt = gradient( CTD.p, CTD.ctime ); % vertical velocity

% find up and down profiles
upi = find( sign( dpdt ) <0); % find all the up data points
dwni = find( sign( dpdt ) >0 ); % find all the down points
CTD.up = CTD.lat.*NaN;
CTD.up(upi) = 1;
CTD.up(dwni) = -1;
% find turning points
tpb = find( diff( CTD.up) ~=0 );
tpb = tpb+1; % shift one indice to the right
faketurns = find(diff( tpb) <5);
tpb(faketurns) = nan;
tpb = tpb(~isnan( tpb ));
CTD.up(tpb) = NaN;

clf
plot(CTD.ctime(st:nd),CTD.p(st:nd),'k','linestyle','-');
hold on
ups = find(CTD.up(st:nd) == 1);
dns = find(CTD.up(st:nd) == -1);
plot(CTD.ctime(st+ups),CTD.p(st+ups),'b.');
plot(CTD.ctime(st+dns),CTD.p(st+dns),'r.');
datetick
grid on
set(gca,'ydir','reverse')
ylabel('dB')
ylim([0 50])
%%
figure
clf
subplot(131)
plot(CTD.t(st+dns),CTD.p(st+dns),'k.')
hold on
plot(CTD.t(st+ups),CTD.p(st+ups),'b.')
grid on
set(gca,'ydir','reverse')
xlabel('Temperature \circC')
ylabel('dB')
%legend('upcast','downcast')
ylim([0 50])


subplot(132)
plot(CTD.s(st+dns),CTD.p(st+dns),'k.')
hold on
plot(CTD.s(st+ups),CTD.p(st+ups),'b.')
grid on
set(gca,'ydir','reverse')
xlabel('Salinity')
ylabel('dB')
%legend('upcast','downcast')
ylim([0 50])
title( {[cruise_name];...
        [ ' Start Time ' datestr(CTD.ctime(st))]}, 'fontsize', 18, 'fontweight', 'bold');
    
subplot(133)
plot(CTD.dens(st+dns)-1000,CTD.p(st+dns),'k.')
hold on
plot(CTD.dens(st+ups)-1000,CTD.p(st+ups),'b.')
grid on
set(gca,'ydir','reverse')
xlabel('Density')
ylabel('dB')
%legend('upcast','downcast')
ylim([0 50])

% filename = [cruise_name, 'Leg', leg(ll).name 'waterfall_' num2str(ens) ];
% print('-dpng','-r150',[targetdir '\' filename]);

%%
figure
clf
subplot(121)
plot(CTD.t(st+dns),CTD.p(st+dns),'k')
hold on
plot(CTD.t(st+ups),CTD.p(st+ups),'b')
plot(CTD.t_raw(st+dns),CTD.p(st+dns),'g')
plot(CTD.t_raw(st+ups),CTD.p(st+ups),'r')
grid on
set(gca,'ydir','reverse')
xlabel('Temperature \circC')
ylabel('dB')
%legend('upcast','downcast')
ylim([0 50])


subplot(122)
plot(CTD.c(st+dns),CTD.p(st+dns),'k')
hold on
plot(CTD.c(st+ups),CTD.p(st+ups),'b')
plot(CTD.c_raw(st+dns),CTD.p(st+dns),'g')
plot(CTD.c_raw(st+ups),CTD.p(st+ups),'r')
grid on
set(gca,'ydir','reverse')
xlabel('Conductivity')
ylabel('dB')
%legend('upcast','downcast')
ylim([0 50])
title( {[cruise_name];...
        [ ' Start Time ' datestr(CTD.ctime(st))]}, 'fontsize', 18, 'fontweight', 'bold');
 
