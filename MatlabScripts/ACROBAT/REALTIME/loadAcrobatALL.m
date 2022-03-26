function [dat, a] = loadAcrobatRealtime(top_dir, cruise_name)

% function [dat, a] = loadAcrobatRealtime(top_dir, cruise_name, twin)
%
% Navigate to directory specified by targetdir and pull ASCII files with
% binned realtime acrobat data.  Only pull files within specified
% elapsed time-window. Also output directory info.
%
% KIM 08.12

%DEFINE THE TARGET DIRECTORY
targetdir = fullfile( top_dir,cruise_name,'DATA','ACROBAT','REALTIME');

%GO TO THE TARGET DIRECTORY
cd( targetdir )

% find all the ASCII files in the folder
[a] = findextension( targetdir, '.ASC' );

% %  FIND ALL FILES WITHIN TIME RANGE
% telapsed = a(end).datenum - vertcat( a.datenum ); 
% tt = find( telapsed <= twin, 1, 'first'); 

% % TARGET FILES ONLY WITHIN TIME WINDOW
% loadindex = tt:length( a ); 

% LOAD THE DATA
dat = []; 
count = 0; 
for d = 1:length(a),
    % open the ASCII
    fname=a(d).name;
    fid=fopen(fname); 
    % scan the text data, ignoring header
    datin = textscan( fid , ['%s %s ', repmat( '%n ', [1, 11])], 'HeaderLines', 1); 
    % build onto data matrix
    dat = vertcat( dat, datin ); 
    % close file
    fclose( fid ); 
    count = count+1; 
end

% % crop directory index to only the files that were used.
% a = a(tt:end);

