function readAcrobatRawCTD( top_dir, cruise_name)

% function readAcrobatRawCTD( top_dir, cruise_name)
%
% Load and read the raw CTD data during the Acrobat deployment logged to
% a text file using DASYLABS. The CTD should be sampling at 16hz.
% Raw Data is saved out as a .mat file to ./Data/ACROBAT/PROCESSED
%
% CTD structure output [unit]
% _____________________
% CTD.ctime: computer time at fix [datenum.m format]
% CTD.p: raw pressure [db]
% CTD.t: raw temperature [degC, ITS-90]
% CTD.c: raw conductivity [S/m]
%
% KIM 08.13

% DEFINE THE TARGET
targetdir = fullfile( top_dir, cruise_name, 'Data', 'ACROBAT', 'RAW', 'CTD'); 
% FIND THE ASCII FILES THEREIN
[a] = findextension( targetdir, '.ASC' );

% LOAD THE DATA
% make the blank structure
CTD.ctime = []; CTD.p = []; CTD.t = []; CTD.c = []; 

for d = 1:length(a)
    % open the ASCII
    fname = fullfile( top_dir, cruise_name, 'Data', 'ACROBAT','RAW','CTD', a(d).name);
    fid=fopen(fname); 
    
    % scan the text data, ignoring header
    datin = textscan( fid , ['%s %s ', repmat( ' %n ', [1, 3])], 'HeaderLines', 1); 
    
    % pull the variables
    datestr =  datin{1}; 
    timestr = datin{2}; 
    
    % parse the computer time
    [ctime] = parseComputerTime(datestr, timestr);
    CTD.ctime = [CTD.ctime; ctime]; 
    t = datin{3};
    c= datin{4};
    p = datin{5};
    
    % add onto the matrices
    CTD.p = [CTD.p; p]; 
    CTD.t = [CTD.t; t];
    CTD.c = [CTD.c; c];
    
    % close file
    fclose( fid ); 
end

% display status
displayStatusLine( 'CTD data loaded...', 2)


%  save out the CTD
savedir = fullfile(top_dir,cruise_name,'Data', 'ACROBAT', 'PROCESSED'); 
name = 'CTD';
savefile = fullfile( savedir, name ); 
eval( ['save ', savefile , ' CTD '])
disp( 'CTD data processed and saved')
