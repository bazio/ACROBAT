function initializeAcrobatPostProcessing(top_dir, cruise_name, scripts_dir)

% function initializeAcrobatREALTIME(top_dir, cruise_name)
%
% Prepare the Acrobat data aquisition computer to store data and run the
% realtime display. Status of initialization procedure is displayed via a
% pop-up window.
%
% Step 1: add appropriate matlab search paths
% Step 2: check if file structure for data storage exists. If not create.
% Step 3: load the default plot limits to the base workspace.
% Step 4: make the plotting windows for the realtime display
% Step 5: display Acrobat deployment prompt
%
% KIM 08.13

% adjust the matlab path so all the files REALTIME display files can be
% found 
addAcrobatPaths(scripts_dir)

% Make pop-up status window 
[fig, ax] = createStatusWindow;

% Find or create appropriate file structure
displayStatusLine('Checking data file structure....', 2)
checkandmakeAcrobatFolders(top_dir, cruise_name)

% load and output the default limits to the workspace
lims = defaultloadRealTimeLims;
assignin( 'base', 'lims', lims)

% open the figure windows
makeRealTimeFig3;

global bathy
makeRealTimeMap(scripts_dir, lims)
pause(0.1)
figure(11)
textin = {'close this window when all tasks completed.'};
text( 0.5, 0.5,  textin, 'horizontalalignment', 'center', 'fontsize', 16, 'color', 'k');





