function makeRealTimeFig2

% function makeRealTimeFig2
%
%  Set up the window to make the scrolling depth-time scatter plots
%
% KIM 08.12

% make the subplot handle a global variable
global sp2

% FIRST MAKE THE FIGURE
figure(2); clf
set( gcf, 'toolbar', 'none', 'menubar', 'none',...
    'numbertitle', 'off', 'name', 'Pressure-Time scrolling plot',...
    'position', [ 1050    50   850   1000])

set(0,'DefaultFigureColor',[1, 1, 1]*0.2,'DefaultFigureInvertHardCopy','off');
set(0,'defaultaxescolor', [1, 1, 1]*0.1, 'DefaultAxesXColor','w','DefaultAxesYColor','w','DefaultAxesZColor','w')
set(0,'DefaultTextColor',[1 1 1]*1);

% make the subplots
for n = 1:5
    sp2(n)  = subplot( 6, 1, n );
    scoot_axes( [-0.05, (7-n)*0.01-0.05, 0.05, 0.02]); 
    set( gca, 'xticklabel', [])
end
n = 6;
sp2(n) = subplot( 6, 1, n );
scoot_axes( [-0.05, (7-n)*0.01-0.05, 0.05, 0.02]);
