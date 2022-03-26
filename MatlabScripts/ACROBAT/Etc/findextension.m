function [a] = findextension( targetdir, ext )

% function [a] = findextension( targetdir )
%
%  Find the all the files with extension 'ext' in  directory specified by
%  'targetdir'.  For example ext = '.txt' or '.ASC'.  The search is case
%  sensitive.
%
% KIM 08.12

% READ THE DIRECTORY CONTENTS
a=dir(targetdir);
% find the number of files in that folder
numfiles=length(a);
% FIND THE  FILES WITH EXTENSION 
ascindex = [];
for i=1:numfiles
    if ~isempty(strfind(a(i).name, ext))
        ascindex = [ascindex; i]; 
    end
end
% IGNORE ALL FILES WITHOUT EXTENSION
a = a(ascindex); 
