function checkandmakeAcrobatFolders(top_dir, cruise_name)

% function checkandmakeAcrobatFolders(top_dir, cruise_name)
%
% Check if cruise folder already exists and is complete. If not create new
% folders for this cruise.
%
% KIM 07.13

if isdir( fullfile( top_dir, cruise_name))
    % if cruise folder exists, check to see if it has all necessary subfolders
    displayStatusLine({[fullfile( top_dir, cruise_name), ' already exists.']; 'checking subfolders...'})
    % check for the DATA folder
    if isdir( fullfile( top_dir, cruise_name, 'DATA'))
        displayStatusLine( {fullfile( top_dir, cruise_name, 'DATA'); ' already exists.'})
    else
        displayStatusLine(['making ', fullfile( top_dir, cruise_name, 'DATA') ])
        mkdir( fullfile( top_dir, cruise_name), 'DATA')
    end
    % check for the ACROBAT folder
    if isdir( fullfile( top_dir, cruise_name, 'DATA', 'ACROBAT'))
        displayStatusLine({fullfile( top_dir, cruise_name, 'DATA', 'ACROBAT'); ' already exists.'})
    else
        displayStatusLine(['making ', fullfile( top_dir, cruise_name, 'DATA', 'ACROBAT')])
        mkAcrobatFolders(top_dir, cruise_name)
    end
else
    % otherwise create all new folders
    displayStatusLine({[fullfile( top_dir, cruise_name), 'does not exist.']; 'creating data folders now....'})
    displayStatusLine( ['making ', fullfile( top_dir, cruise_name) ])
    mkdir( top_dir, cruise_name );
    displayStatusLine(['making ', fullfile( top_dir, cruise_name, 'DATA') ])
    mkdir( fullfile( top_dir, cruise_name), 'DATA')
    displayStatusLine(['making ', fullfile( top_dir, cruise_name, 'DATA', 'ACROBAT')])
    mkAcrobatFolders(top_dir, cruise_name)
end

% add cruise folders to the path
cruise_folders = genpath( fullfile( top_dir, cruise_name )); 
addpath( cruise_folders, '-end')