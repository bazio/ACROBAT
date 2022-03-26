function  FTPAcrobatREALTIME(targetIP, user, psswrd, targetdir)

% function  FTPAcrobatREALTIME(targetIP, user, psswrd, targetdir)
%
%  PULL THE DATA FROM THE REMOTE COMPUTER USING FTP
%
% KIM 08.12

% make the FTP object
f = ftp( targetIP, user, psswrd);

% check out what is in the folder
dorig = dir(f);
ddest = dir(targetdir);

% find the last file in the folder on this computer
lastfile = ddest(end).name;

% Pull the file names from the original folders
sorig = struct2cell(dorig);
names = sorig(1,:);

%now find match to the file with the same name on the remote computer
startind = find(strcmp(names, lastfile));

% if none found, set default to 1
if isempty(startind)
    startind = 1; 
end

% copy new contents to current folder
for n = startind:length(dorig)-1
    mget(f, dorig(n).name,targetdir);
end
%  Close connection
close(f)
% clear ftp the variables
clear f dorig ddest lastfile sorig names startind

disp( ['ACROBAT DATA COPIED TO LOCAL COMPUTER', datestr(now)])