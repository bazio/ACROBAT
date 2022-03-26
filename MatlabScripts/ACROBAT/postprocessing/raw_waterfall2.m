clear all; close all; clc;
top_dir = 'C:\Users\stats\Documents\Chukchi\2013\CRUISE_DATA\Chukchi_2013_N2';
mat_dir = 'C:\Users\stats\Documents\Acrobat\TEST';
cruise_name = 'ChukchiGliderCruise2013';
targetdir = fullfile( top_dir, cruise_name, 'DATA', 'ACROBAT','PROCESSED'); 
load( fullfile( targetdir, 'corrected.mat')); 
targetdir = fullfile( top_dir, cruise_name, 'DATA', 'ACROBAT','PROCESSED', 'TC_CORRECTED_PLOTS'); 

%%
figure;
% st = near(CTD.ctime,datenum(2013,9,9,16,55,43),1);
% nd = near(CTD.ctime,datenum(2013,9,9,16,58,24),1);
% st = near(CTD.ctime,datenum(2013,9,12,16,56,50),1);
% nd = near(CTD.ctime,datenum(2013,9,12,16,59,24),1);
st = near(CTD.ctime,datenum(2013,9,14,14,25,50),1);
nd = near(CTD.ctime,datenum(2013,9,14,14,28,20),1);

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

c3515 = sw_c3515; 
c3515 = c3515*100/1000; % convert to S/m
% calculate salinity using conductivity ratio
CTD.s_raw = sw_salt( CTD.c_raw./c3515, CTD.t_raw, CTD.p); 

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
d1 = 10;
d2 = 20;
figure
clf
subplot(131)
plot(CTD.t(st+dns),CTD.p(st+dns),'k.')
hold on
plot(CTD.t(st+ups),CTD.p(st+ups),'b.')
plot(CTD.t_raw(st+dns),CTD.p(st+dns),'g.')
plot(CTD.t_raw(st+ups),CTD.p(st+ups),'r.')
grid on
set(gca,'ydir','reverse')
xlabel('Temperature \circC')
set(gca,'ylim',[d1 d2],'xlim',[-2 6],'xtick',[-2:1:6],'xminortick','on')
ylabel('dB')
%legend('upcast','downcast')
% ylim([0 50])

subplot(132)
plot(CTD.s(st+dns),CTD.p(st+dns),'k.')
hold on
plot(CTD.s(st+ups),CTD.p(st+ups),'b.')
plot(CTD.s_raw(st+dns),CTD.p(st+dns),'g.')
plot(CTD.s_raw(st+ups),CTD.p(st+ups),'r.')
grid on
set(gca,'ydir','reverse')
xlabel('Salinity')
ylabel('dB')
legend('location','southwest','down','up','raw down','raw up')
set(gca,'ylim',[d1 d2],'xlim',[26 33],'xtick',[26:2:33],'xminortick','on')
% ylim([0 50])
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
set(gca,'ylim',[d1 d2],'xlim',[20 26],'xtick',[20:1:26],'xminortick','on')
% ylim([0 50])
dd = datevec(CTD.ctime(st));
filename = [cruise_name, '_waterfall_' num2str(dd(3)) '_' num2str(dd(4)) '_' num2str(dd(5))  ];
print('-dpng','-r150',[targetdir '\' filename]);

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
 
