function [CTD] = processRealtimeCTD( CTD, acrobat )

% function [CTD] = processRealtimeCTD( CTD, acrobat )
%
% Output a variety of seawater properties using the binned inputs from the
% CTD data. Conductivity and temperature are binned, then binned values are
% used to calculate salinity. The data is very coarsely processed, and due
% to the binning temperature and conductivity have not been aligned, which
% could potenitally lead to very severe salinity spiking.
%
% INPUT: temp [degC, ITS-90], con [S/m],	pres [decibars]
% OUTPUT: depth [m], salinity [psu (PSS-78)], potential temperature [degree C (ITS-90)],...
%   density [kg/m^3], potential density  [kg/m^3]
%
% KIM 08.12

% load default range for temperature [degrees C] and conductivity [S/m]
[t_range, con_range] = SBE49DefaultRange; 

% remove T and C outside of range
[CTD.t, tout,CTD.c, conout]= sb_calrange(CTD.t,CTD.c, t_range,con_range);

% add depth in meters
CTD.z = sw_dpth( CTD.p, acrobat.lat); 

% load reference conductivity c3515  [mmho/cm == mS/cm]
c3515 = sw_c3515; 
c3515 = c3515*100/1000; % convert to S/m
% calculate salinity using conductivity ratio
CTD.s = sw_salt( CTD.c./c3515, CTD.t, CTD.p); 

% add potential temperature, reference depth, p=0; 
CTD.th = sw_ptmp( CTD.s, CTD.t, CTD.p, 0 ); 

% add density
CTD.dens = sw_dens( CTD.s, CTD.t, CTD.p ); 

% add potential density, reference depth p=0; 
CTD.sgth = sw_pden( CTD.s, CTD.t, CTD.p, 0)-1000; 


