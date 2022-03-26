function [CTD] = processAcrobatCTD( CTD, CTpar )

% function [CTD] = processAcrobatCTD( CTD, CTpar )
%
% Output a variety of seawater properties using the binned inputs from the
% CTD data.  This may be changed in the future, as I might do the salinity
% calculation in DASY labs to minimize spiking.  Currently binning conductivity and
% temperature, then calculating salinity.
%
% INPUT: temp [degC, ITS-90], con [S/m],	pres [decibars]
% OUTPUT: depth [m], salinity [psu (PSS-78)], potential temperature [degree C (ITS-90)],...
%   density [kg/m^3], potential density  [kg/m^3]
%
% KIM 08.12
% HS 04.15

% load default range for temperature [degrees C] and conductivity [S/m]
[t_range, con_range] = SBE49DefaultRange; 
% remove T and C outside of range
[CTD.t, tout,CTD.c, conout]=sb_calrange(CTD.t,CTD.c, t_range,con_range);
% flag the bad data
flag = unique( [tout; conout]); 

% identify any crazy jumps in temperature
t_thresh = 1; 
flag = [flag; find( abs(diff( CTD.t) ) > t_thresh)]; 

% identify any crazy jumps in pressure
p_thresh = 1; 
flag = [flag; find( abs(diff( CTD.p)) > p_thresh)]; 

% identify any crazy jumps in conductivity
c_thresh = 0.5; 
flag = [flag; find( abs(diff( CTD.c)) > c_thresh)]; 

% add depth in meters
CTD.z = sw_dpth( CTD.p, CTD.lat); 
% [B,I,J] = unique(CTD.ctime);

% do corrections on CTD if the parameters exist
if exist( 'CTpar', 'var')
    % align temperature data in time relative to C and P
    To = interp1(CTD.ctime, CTD.t, CTD.ctime + CTpar.t_advance,'linear','extrap');
    % apply the thermal lag to temperature
%     To= apply_tauT( CTD.t, CTpar.tauT, CTpar.freq );
    % scan lag due to the physical separation of the T and C sensors
%     lag = round(CTpar.tP.*CTpar.freq);
%     Co = shift( CTD.c, lag )';
    % Now apply the thermal lag correction to the conductivity sensor
    [Ti,Co] = correctThermalLag(CTD.ctime,CTD.c,To,[CTpar.alpha CTpar.tauCTM]);
%     csbe = apply_tauCTM(CTD.p, To, Co, CTpar);  
    CTD.t_raw = CTD.t;
    CTD.c_raw = CTD.c;
    CTD.t = To; 
    CTD.c = Co; 
end
CTD.c(CTD.c<0) = 0;
% load reference conductivity c3515  [mmho/cm == mS/cm]
c3515 = sw_c3515; 
c3515 = c3515*100/1000; % convert to S/m
% calculate salinity using conductivity ratio
CTD.s = sw_salt( CTD.c./c3515, CTD.t, CTD.p); 

% add potential temperature, reference depth, p=0; 
% CTD.th = sw_ptmp( CTD.s, CTD.t, CTD.p, 0 ); 

% add density
CTD.dens = sw_dens( CTD.s, CTD.t, CTD.p ); 

% add potential density, reference depth p=0; 
% CTD.sgth = sw_pden( CTD.s, CTD.t, CTD.p, 0)-1000; 

CTD.flag = zeros(size( CTD.p ));
CTD.flag(flag) = 1; 

