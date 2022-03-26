function  [acrobat, CTD, ECO] = ProcessAcrobatREALTIME( top_dir, cruise_name, twin)

% function  [acrobat, CTD, ECO] = ProcessAcrobatREALTIME( top_dir, cruise_name, twin)
%
% Pull in an parse the REALTIME ACrobat data once it is on the local
% machine
%
% KIM 08.12

% load the local data
[dat, a] = loadAcrobatRealtime( top_dir, cruise_name , twin);

%  now parse the individual components for processing
[acrobat, CTD, ECO] = parseAcrobatRealtime( dat );

% ECOpuck serial number
sn = 'FLBBCD2K-2710'; 
% get the calibrations for the ECOpuck
[ ECO.par ] = ECOpuckCals( sn );
% Now process ECOpuck
[ECO] = processECOpuck( ECO, ECO.par ); 

% process CTD data (because binned data is used, corrections are not
% applied.
[CTD] = processRealtimeCTD( CTD, acrobat ); 

disp( 'Acrobat realtime processed')