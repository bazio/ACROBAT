close all
clear all
top_dir = 'C:\Users\stats\Documents\Chukchi\2013\CRUISE_DATA\Chukchi_2013_N2';
mat_dir = 'C:\Users\stats\Documents\Acrobat\TEST';
cruise_name = 'ChukchiGliderCruise2013';

c3515 = sw_c3515;
c3515 = c3515*100/1000; % convert to S/m

targetdir = fullfile( top_dir, cruise_name, 'DATA', 'ACROBAT','PROCESSED');
for in = 1:3,
%LOAD THE DATA
load( fullfile( targetdir, 'GPS.mat'));
load( fullfile( targetdir, 'CTD.mat'));

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

CTD.gpstime = interp1(tmp1u, tmp2u, CTD.ctime);
CTD.lat = interp1(tmp1u, tmp3u, CTD.ctime);
CTD.lon = interp1(tmp1u, tmp4u, CTD.ctime);
CTpar.freq =  1/16; % sample rate (Hz) for SeaBird FastCat
% CTpar.alpha =  0.03; %suggested value in SBE49 manual
%CTpar.alpha =  0.14; %K. Martini calculated value
CTpar.tauCTM = 7; % suggested value in SBE49 manual
CTpar.tauT = 0; % not defined yet
CTpar.tP = 0; % not defined yet
CTpar.t_advance = 0.0625./86400; %advance Temperature by 0.0625 seconds, suggested value in SBE49 manual, Convert to decimal day


    if (in==1),
        CTpar.alpha =  0.03; %suggested value in SBE49 manual
    elseif (in==2),
        CTpar.alpha =  0.1; 
    else
        CTpar.alpha =  0.14;
    end
    [CTD] = processAcrobatCTD( CTD, CTpar );
    st = near(CTD.ctime,datenum(2013,9,14,14,25,50),1);
    nd = near(CTD.ctime,datenum(2013,9,14,14,28,20),1);

    % calculate salinity using conductivity ratio
    CTD.s_raw = sw_salt( CTD.c_raw./c3515, CTD.t_raw, CTD.p);
    CTD.dens_raw = sw_dens( CTD.s_raw, CTD.t_raw, CTD.p ); 
    CTD.dens = sw_dens( CTD.s, CTD.t, CTD.p ); 
    dpdt = gradient( CTD.p, CTD.ctime ); % vertical velocity
    
    % find up and down profiles
    upi = find( sign( dpdt ) <0); % find all the up data points
    dwni = find( sign( dpdt ) >0 ); % find all the down points
    CTD.up = CTD.lat.*NaN;
    CTD.up(upi) = 1;
    CTD.up(dwni) = -1;
    ups = find(CTD.up(st:nd) == 1);
    dns = find(CTD.up(st:nd) == -1);
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
    title( {[cruise_name 'alpha = ' num2str(CTpar.alpha)];...
        [ ' Start Time ' datestr(CTD.ctime(st))]}, 'fontsize', 18, 'fontweight', 'bold');
    
    subplot(133)
    plot(CTD.dens(st+dns)-1000,CTD.p(st+dns),'k.')
    hold on
    plot(CTD.dens(st+ups)-1000,CTD.p(st+ups),'b.')
    plot(CTD.dens_raw(st+dns),CTD.p(st+dns),'g.')
    plot(CTD.dens_raw(st+ups),CTD.p(st+ups),'r.')
    grid on
    set(gca,'ydir','reverse')
    xlabel('Density')
    ylabel('dB')
    %legend('upcast','downcast')
    set(gca,'ylim',[d1 d2],'xlim',[20 26],'xtick',[20:1:26],'xminortick','on')
    % ylim([0 50])
    dd = datevec(CTD.ctime(st));
    filename = [cruise_name, '_waterfall_a' num2str(in) '_' num2str(dd(3)) '_' num2str(dd(4)) '_' num2str(dd(5))  ];
    print('-dpng','-r150',[targetdir '\' filename]);
    clear CTD
end

