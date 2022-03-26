function mkAcrobatFolders(top_dir, cruise_name)

% function mkAcrobatFolders(topdir, cruise)
%
%  Make the data folder structure for the ACROBAT so all the files are in
%  the right place.
%
% KIM 06.13

% make ACROBAT folder
mkdir( fullfile( top_dir, cruise_name, 'DATA'), 'ACROBAT')
% populate the ACROBAT folder
mkdir( fullfile(top_dir, cruise_name, 'DATA', 'ACROBAT'), 'PROCESSED')
mkdir( fullfile(top_dir, cruise_name, 'DATA', 'ACROBAT'), 'RAW')
mkdir( fullfile(top_dir, cruise_name, 'DATA', 'ACROBAT'), 'REALTIME')
% populate the RAW folder
mkdir( fullfile(top_dir, cruise_name, 'DATA', 'ACROBAT', 'RAW'), 'ACROBAT')
mkdir( fullfile(top_dir, cruise_name, 'DATA', 'ACROBAT', 'RAW'), 'CTD')
mkdir( fullfile(top_dir, cruise_name, 'DATA', 'ACROBAT', 'RAW'), 'ecopuck')
mkdir( fullfile(top_dir, cruise_name, 'DATA', 'ACROBAT', 'RAW'), 'GPS')