function readAcrobatRawECO(top_dir, cruise_name)

% function readAcrobatRawECO(top_dir, cruise_name)
%
% Load and read the raw ECOpuck data during the Acrobat deployment logged to
% a text file using DASYLABS. The ECOpuck should be sampling at 10 hz.
% Raw Data is also saved out as a .mat file to ./Data/ACROBAT/PROCESSED
%
% ECO structure output [unit]
% _____________________
% ECO.ctime: computer time at fix [datenum.m format]
% ECO.chlsig:  [counts]
% CTD.backsig:  [counts]
% CTD.CDOMsig:  [counts]
%
% KIM 08.13

% DEFINE THE TARGET
targetdir = fullfile( top_dir, cruise_name, 'Data', 'ACROBAT','RAW','ecopuck'); 
% FIND THE ASCII FILES THEREIN
[a] = findextension( targetdir, '.ASC' );

% LOAD THE DATA
% make the blank structure
ECO.ctime = []; ECO.chlsig = []; ECO.backsig = []; ECO.CDOMsig = []; 

for d = 1:length(a)
    % open the ASCII
    fname = fullfile( top_dir, cruise_name, 'Data', 'ACROBAT','RAW','ecopuck', a(d).name);
    fid=fopen(fname); 
    
    % scan the text data, ignoring header
    datin = textscan( fid , ['%s %s ', repmat( ' %n ', [1, 3])], 'HeaderLines', 1); 
    
    % pull the variables
    datestr =  datin{1}; 
    timestr = datin{2}; 
    chlsig = datin{3}; 
    backsig = datin{4}; 
    CDOMsig = datin{5}; 
    
    % parse the computer time
    [ctime] = parseComputerTime(datestr, timestr);
    ECO.ctime = [ECO.ctime; ctime];
    
    % concat the data
    ECO.chlsig = [ECO.chlsig; chlsig];
    ECO.backsig = [ECO.backsig; backsig];
    ECO.CDOMsig = [ECO.CDOMsig; CDOMsig];
    
    % close file
    fclose( fid ); 
end

% display status
displayStatusLine( 'ECOpuck data loaded...', 2)

%  save out the ECOpuck data
savedir = fullfile(top_dir, cruise_name, 'Data', 'ACROBAT', 'PROCESSED'); 
name = 'ECO';
savefile = fullfile( savedir, name ); 
eval( ['save ', savefile , ' ECO '])
disp( 'ECO data processed and saved')


