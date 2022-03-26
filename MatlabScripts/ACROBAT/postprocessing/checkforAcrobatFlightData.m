function [status] = checkforAcrobatFlightData(top_dir, cruise_name)

% function [status] = checkforAcrobatFlightData(top_dir, cruise_name)
%
% Check the folder .../DATA/ACROBAT/RAW/ACROBAT to check if the flight files have been moved from the
% Toshiba Laptop to the local laptop.
%
% KIM 08.13

%DEFINE THE TARGET DIRECTORY
targetdir = fullfile( top_dir,cruise_name,'DATA','ACROBAT','RAW', 'ACROBAT');

% find all the ASCII files in the folder
[a] = findextension( targetdir, '.dat' );

if isempty( a )
    displayStatusLine({'Acrobat flight files not found.';  'Please copy all .dat files from  to local computer.'}, 2)
    status = 0; 
    return
else
    displayStatusLine({'Acrobat flight files found on local computer.'}, 2)
    status = 1; 
end
    