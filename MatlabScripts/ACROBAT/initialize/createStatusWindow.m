function [fig, ax] = createStatusWindow

%function [fig, ax] = createStatusWindow
%
% create a status window in the center of the screen
%
% KIM 07.13

% get the size of the screen
set(0, 'units', 'pixels')
scnsize = get( 0, 'screensize'); 
% figure out the window position in relation to the screen size
winwidth = 600; 
winheight = 300; 
pos = [scnsize(3)/2 - winwidth./2, scnsize(4)/2- winheight./2, winwidth, winheight];
% make a figure
fig = figure(11);
set(fig, 'position', pos,...
    'dockcontrols', 'off',...
    'menubar', 'none',...
    'name', 'ACROBAT startup status',...
    'numbertitle', 'off')
ax  = axes; 
set( axes, 'position', [0, 0, 1, 1], 'color','w', 'xcolor', 'w', 'ycolor', 'w');