function [bin] = roughbinRAWAcrobat( dt, GPS, CTD, ECO)

% [bin] = roughbinRAWAcrobat( dt, GPS, CTD, ECO)
%
% bin the raw Acrobat data in time
%
% KIM 

%  Let us bin average this puppy



% set the time vector
bin.time = [CTD.NMEAtime(find(~isnan( CTD.NMEAtime), 1, 'first')):dt:CTD.NMEAtime(find(~isnan( CTD.NMEAtime), 1, 'last'))]'; 

% find the good inds
goodinds = find( CTD.flag ~=1); 

% bin the location data
bin.lat = binaverage( CTD.NMEAtime(goodinds), CTD.lat(goodinds), bin.time ); 
bin.lon = binaverage( CTD.NMEAtime(goodinds) ,CTD.lon(goodinds),  bin.time ); 

% bin the CTD
bin.t = binaverage( CTD.NMEAtime(goodinds) , CTD.t(goodinds),  bin.time ); 
bin.p = binaverage( CTD.NMEAtime(goodinds) , CTD.p(goodinds),  bin.time ); 
bin.s = binaverage( CTD.NMEAtime(goodinds) , CTD.s(goodinds),  bin.time ); 
bin.th = binaverage( CTD.NMEAtime(goodinds) , CTD.th(goodinds),  bin.time ); 
bin.dens = binaverage( CTD.NMEAtime(goodinds) , CTD.dens(goodinds),  bin.time ); 
bin.sgth = binaverage( CTD.NMEAtime(goodinds) , CTD.sgth(goodinds),  bin.time ); 

% bin the ECOpuck
bin.chl = binaverage( ECO.NMEAtime, ECO.chl, bin.time ); 
bin.particle = binaverage( ECO.NMEAtime, ECO.particle, bin.time ); 
bin.CDOM = binaverage( ECO.NMEAtime, ECO.CDOM, bin.time ); 
