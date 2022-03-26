function  ReadAcrobatRAW(top_dir, cruise_name)

% function ReadAcrobatRAW(top_dir, cruise_name)
%
% Read and process the Raw Acrobat data from the files.
%
% KIM 08.12

% Make pop-up status window
[fig, ax] = createStatusWindow;
% check if the acrobat folder has data in it
[status] = checkforAcrobatFlightData(top_dir, cruise_name);

% READ IN ALL THE DATA AND SAVE IT OUT AS MATLAB FILES
% read in the GPS data
displayStatusLine( 'Reading Raw GPS Data...', 2)
readAcrobatRawGPS( top_dir, cruise_name ); 
% read in the CTD data
displayStatusLine( 'Reading Raw CTD Data...', 2)
readAcrobatRawCTD( top_dir, cruise_name ); 
% read in the ECOpuck data
displayStatusLine( 'Reading Raw ECOPuck Data...', 2)
readAcrobatRawECO(top_dir, cruise_name);
% read in the ACROBAT flying data
displayStatusLine( 'Reading Raw Acrobat Flight Data...', 2)
readAcrobatRawFlightData( top_dir, cruise_name );


