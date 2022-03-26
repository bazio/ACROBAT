function plotRealTimeFig2( acrobat, CTD, ECO, lims )

% function plotRealTimeFig2( acrobat, CTD, ECO, lims)
%
% Plot the latest data from the ACROBAT in Figure 1 as a pressure-time
% scatter plot.
%
% KIM 08.12


% make figure 2 window if it does no exist
if ~ishghandle(2)
    makeRealTimeFig2;
end

% make the plot handle a global variable
global sc sp2 pt

if isempty( lims.p )
    plim = [ nanmin(CTD.p), nanmax(CTD.p)];
else
    plim = lims.p;
end

figure(2)

vars = {'t', 's', 'sgth', 'chl', 'particle', 'CDOM'};
titles = {'temperature', 'salinity', 'potential density', 'chlorophyll', 'particle conc', 'ZDOM'};
units = {'[\circ C]', '[psu]', '[kg m^{-1}-1000]','[\mug l^{-1}]', '[(m sr)^{-1}]', '[ppb]'};

for nn = 1:3
    axes(sp2(nn))
    pt(nn) = plot( acrobat.mtime(end) - acrobat.mtime, CTD.p, '-', 'color', [1, 0, 1]*0.9, 'linewidth', 1); hold on
    xlim( lims.time );ylim( plim );
    set( sp2(nn), 'xticklabel', [], 'Xdir', 'reverse', 'ydir', 'reverse')
    datetick( 'x', 'MM:SS', 'keeplimits')
    sc(nn) = scatter( acrobat.mtime(end) - acrobat.mtime, CTD.p, 10, CTD.(vars{nn}), 'filled' ); axis tight;
    caxis(lims.(vars{nn}));
    ylabel( {'pressure [db]'}, 'color', 'w'); grid on; cb = colorbar;
    xlim( lims.time );datetick( 'x', 'MM:SS', 'keeplimits')
    ylabel( cb , units{nn});ylim( plim );
    titleout( titles{nn} );
    set( sp2(nn), 'xticklabel', [])
    hold off
end


for nn = 4:6
    axes(sp2(nn))
    pt(nn) = plot( acrobat.mtime(end) - acrobat.mtime, CTD.p, '-', 'color', [1, 0, 1]*0.9, 'linewidth', 1); hold on
    xlim( lims.time );ylim( plim );
    set( sp2(nn), 'xticklabel', [], 'Xdir', 'reverse', 'ydir', 'reverse')
    datetick( 'x', 'MM:SS', 'keeplimits')
    sc(nn) = scatter( acrobat.mtime(end) - acrobat.mtime, CTD.p, 10, ECO.(vars{nn}), 'filled' ); axis tight;
    caxis(lims.(lower(vars{nn})));
    ylabel( {'pressure [db]'}, 'color', 'w'); grid on; cb = colorbar;
    xlim( lims.time );datetick( 'x', 'MM:SS', 'keeplimits')
    ylabel( cb , units{nn});ylim( plim );
    titleout( titles{nn} );
    if nn~=6
    set( sp2(nn), 'xticklabel', [])
    end
    hold off
    
end

% % plot temperature
% axes(sp2(1))
% pt(1) = plot( acrobat.mtime(end) - acrobat.mtime, CTD.p, '-', 'color', [1, 0, 1]*0.9, 'linewidth', 1); hold on
% caxis(lims.t); 
% set( sp2(1), 'xticklabel', [], 'Xdir', 'reverse', 'ydir', 'reverse')
% sc(1) = scatter( acrobat.mtime(end) - acrobat.mtime, CTD.p, 10, CTD.t, 'filled' ); axis tight;  
% ylabel( {'pressure [db]'}, 'color', 'w'); grid on; cb = colorbar; 
% titleout( 'temperature');
% xlim( lims.time );datetick( 'x', 'MM:SS', 'keeplimits')
% ylabel( cb , '[^\circ C]');ylim( lims.p ); 
% hold off
% 
% % salinity
% axes(sp2(2))
% pt(2) = plot( acrobat.mtime(end) - acrobat.mtime, CTD.p, '-', 'color', [1, 0, 1]*0.9, 'linewidth', 1); hold on
% caxis(lims.s);
% set( sp2(2), 'xticklabel', [], 'Xdir', 'reverse', 'ydir', 'reverse')
% sc(2) = scatter( acrobat.mtime(end) - acrobat.mtime, CTD.p, 10, CTD.s, 'filled' ); axis tight;  
% ylabel( {'pressure [db]'}, 'color', 'w'); grid on;  cb = colorbar; 
% titleout( 'salinity');
% xlim( lims.time );datetick( 'x', 'MM:SS', 'keeplimits');ylim( lims.p );
% ylabel( cb , '[psu]');
% hold off
% 
% % potential density
% axes(sp2(3))
% pt(3) = plot( acrobat.mtime(end) - acrobat.mtime, CTD.p, '-', 'color', [1, 0, 1]*0.9, 'linewidth', 1); hold on
% caxis(lims.sgth);
% set( sp2(3), 'xticklabel', [], 'Xdir', 'reverse', 'ydir', 'reverse')
% sc(3) = scatter( acrobat.mtime(end) - acrobat.mtime, CTD.p, 10, CTD.sgth, 'filled' ); axis tight;  
% ylabel( {'pressure [db]'}, 'color', 'w'); grid on;  cb = colorbar; 
% titleout( 'potential density');
% xlim( lims.time );datetick( 'x', 'MM:SS', 'keeplimits'); ylim( lims.p );
% ylabel( cb , '[kg m^{-3}-1000]')
% hold off
% 
% % chlorophyll
% axes(sp2(4))
% pt(4) = plot( acrobat.mtime(end) - acrobat.mtime, CTD.p, '-', 'color', [1, 0, 1]*0.9, 'linewidth', 1); hold on
% caxis(lims.chl);
% sc(4) = scatter( acrobat.mtime(end) - acrobat.mtime, CTD.p, 10, ECO.chl, 'filled' ); axis tight;  
% ylabel( {'pressure [db]'}, 'color', 'w'); grid on;  cb = colorbar; 
% set( sp2(4), 'xticklabel', [], 'Xdir', 'reverse', 'ydir', 'reverse')
% titleout( 'chlorophyll');
% xlim( lims.time );datetick( 'x', 'MM:SS', 'keeplimits');ylim( lims.p );
% ylabel( cb , '[\mug/l]')
% hold off
% 
% % particle concentration
% axes(sp2(5))
% pt(5) = plot( acrobat.mtime(end) - acrobat.mtime, CTD.p, '-', 'color', [1, 0, 1]*0.9, 'linewidth', 1); hold on
%  caxis(lims.particle); 
% sc(5) = scatter( acrobat.mtime(end) - acrobat.mtime, CTD.p, 10, ECO.particle, 'filled' ); axis tight; 
% ylabel( {'pressure [db]'}, 'color', 'w'); grid on;  cb = colorbar; 
% set( sp2(5), 'xticklabel', [], 'Xdir', 'reverse', 'ydir', 'reverse')
% titleout( 'particle conc');
% xlim( lims.time );datetick( 'x', 'MM:SS', 'keeplimits');ylim( lims.p );
% ylabel( cb , '[(m sr)^{-1}]')
% hold off
% 
% % particle concentration
% axes(sp2(6))
% pt(6) = plot( acrobat.mtime(end) - acrobat.mtime, CTD.p, '-', 'color', [1, 0, 1]*0.9, 'linewidth', 1); hold on
% caxis( lims.cdom )
% sc(6) = scatter( acrobat.mtime(end) - acrobat.mtime, CTD.p, 10, ECO.CDOM, 'filled' ); axis tight;
% ylabel( {'pressure [db]'}, 'color', 'w'); grid on;  cb = colorbar;
% set( sp2(6),  'Xdir', 'reverse', 'ydir', 'reverse');
% titleout( 'ZDOM')
% ylabel( cb , '[ppb]')
% xlim( lims.time );datetick( 'x', 'MM:SS', 'keeplimits');ylim( lims.p );
% xlabel( 'Time elapsed [min]')
% hold off
% 
