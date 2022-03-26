function plotRealTimeFig1( acrobat, CTD, ECO, lims)

% function plotRealTimeFig1( acrobat, CTD, ECO, lims)
%
% Plot the latest data from the ACROBAT in Figure 1
%
% KIM 08.12

% make figure 1 window if it does no exist
if ~ishghandle(1)
    makeRealTimeFig1;
end

% delete the plots first
if ishandle( 'p' )
    delete( p )
end

% make the plot handle a global variable
global p sp
figure(1)

% automatically set limits if not predefined
if isempty( lims.p )
    plim = [ nanmin(CTD.p), nanmax(CTD.p)];
else
    plim = lims.p;
end

% plot pressure
axes(sp(1))
p(1) = plot( acrobat.mtime(end) - acrobat.mtime, CTD.p, 'r-', 'linewidth', 2 ); axis tight;  
ylabel( {'pressure [db]'}, 'color', 'r'); grid on; ylim( plim ); xlim(lims.time); datetick( 'x', 'MM', 'keeplimits')
set( sp(1), 'xticklabel', [], 'Xdir', 'reverse', 'Ydir', 'reverse')

% temperature
axes(sp(2))
p(2) = plot( acrobat.mtime(end) - acrobat.mtime, CTD.t, 'c-', 'linewidth', 2 ); axis tight;  
grid on; ylim( lims.t );  xlim(lims.time); datetick( 'x', 'MM', 'keeplimits')
ylabel( {'temp [\circ C]'}, 'color', 'c')
set( sp(2), 'xticklabel', [], 'Xdir', 'reverse'); 

% conductivity
axes(sp(3))
p(3) = plot( acrobat.mtime(end) - acrobat.mtime, CTD.c, 'w-', 'linewidth', 2 ); axis tight;  
grid on; ylim( lims.c ); xlim(lims.time); datetick( 'x', 'MM', 'keeplimits')
ylabel( {'conductivity', '[S/m]'}, 'color', 'w')
set( sp(3), 'xticklabel', [], 'Xdir', 'reverse');

% salinity
axes(sp(4))
p(4) = plot( acrobat.mtime(end) - acrobat.mtime, CTD.s, 'y-', 'linewidth', 2 ); axis tight;  
grid on; ylim( lims.s ); xlim(lims.time); datetick( 'x', 'MM', 'keeplimits')
ylabel( {'salinity [psu]'}, 'color', 'y')
set( sp(4), 'xticklabel', [], 'Xdir', 'reverse');

% potential density
axes(sp(5))
p(5) = plot( acrobat.mtime(end) - acrobat.mtime, CTD.sgth, 'm-', 'linewidth', 2 ); axis tight;  
grid on; ylim( lims.sgth ); xlim(lims.time); datetick( 'x', 'MM', 'keeplimits')
ylabel( {'\sigma_{\theta} [kg m^{-3}-1000]'}, 'color', 'm')
set( sp(5), 'xticklabel', [], 'Xdir', 'reverse');


% chlorophyll
axes(sp(6))
p(6) = plot( acrobat.mtime(end) - acrobat.mtime, ECO.chl, 'g-', 'linewidth', 2 ); axis tight; 
grid on; ylim( lims.chl ); xlim(lims.time); datetick( 'x', 'MM', 'keeplimits')
ylabel( {'Chl [\mug/l]'}, 'color', 'g')
set( sp(6), 'xticklabel', [],'Xdir', 'reverse');

% particle concentration
axes(sp(7))
p(7) = plot( acrobat.mtime(end) - acrobat.mtime, ECO.particle, 'b-', 'linewidth', 2 ); axis tight;  
grid on; %ylim( lims.particle);
ylabel( {'particle [1/m*sr]'}, 'color', 'b'); xlim(lims.time); datetick( 'x', 'MM', 'keeplimits')
set( sp(7), 'xticklabel', [], 'Xdir', 'reverse'); 

% CDOM
axes(sp(8))
p(8) = plot( acrobat.mtime(end) - acrobat.mtime, ECO.CDOM, 'r-', 'linewidth', 2 ); axis tight;  
grid on; ylim( lims.cdom );  xlim(lims.time); datetick( 'x', 'MM', 'keeplimits')
ylabel( {'CDOM [ppb]'}, 'color', 'r')
xlabel( 'Time elapsed [min]')
set( sp(8), 'Xdir', 'reverse');





