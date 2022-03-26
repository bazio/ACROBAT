function [sp] = makeRealTimeFig1; 

% function makeRealTimeFig1
%
%  Set up the window to make the scrolling time series plot
%
% KIM 08.12

% make the subplot handle a global variable
global sp

set(0,'DefaultFigureColor',[1, 1, 1]*0.2,'DefaultFigureInvertHardCopy','off');
set(0,'defaultaxescolor', [1, 1, 1]*0.1, 'DefaultAxesXColor','w','DefaultAxesYColor','w','DefaultAxesZColor','w')

% FIRST MAKE THE FIGURE
figure(1); clf
set( gcf, 'toolbar', 'none', 'menubar', 'none',...
    'numbertitle', 'off', 'name', 'Streamed Real Time Data',...
    'position', [425    50   600   1000])

% make the subplots
for n = 1:8
    sp(n)  = subplot( 8, 1, n );
end

for n = 1:8
    scoot_axes( [0.05, (6-n)*0.01-0.03, 0.0, 0.01], sp(n)); 
end
