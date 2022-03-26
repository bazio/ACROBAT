function [ctime] = parseComputerTime(datestrs, timestr)

% function [ctime] = parseComputerTime(datestr, timestr)
%
% Parse both the time and date string
%
% INPUT FORMAT:
% datestr: 8/26/2012	
% timestr: 15:47:14.375
%
% OUTPUT FORMAT:
% ctime in datenumber, A serial date number of 1 corresponds to Jan-1-0000. 
%
% KIM 08.12

ctime = datenum(strcat( datestrs, repmat( {' '}, [size( datestrs, 1 ), 1]), timestr ));
