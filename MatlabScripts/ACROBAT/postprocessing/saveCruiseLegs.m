function saveCruiseLegs( top_dir, cruise_name, leg, llims)

% function saveCruiseLegs( top_dir, cruise_name, leg)
%
% Save out the temporal boundaries of the cruise legs as determined from
% the GPS data in the post-processing worksheet.
%
% KIM 08.13
% HS 02.16

% IDENTIFY THE TARGET
targetdir = fullfile( top_dir, cruise_name, 'DATA', 'ACROBAT','PROCESSED');
filename = [cruise_name, 'Legs'];

%LOAD THE GPS DATA
load( fullfile( targetdir, 'GPS.mat'));

sgn = mean(GPS.lon);
if (sgn > 0),
    GPS.lon = -GPS.lon ;
end
sgn2 = mean(GPS.lat);
% if (sgn2 > 0),
%     GPS.lat = -GPS.lat ;
% end

bad = find(GPS.lon < llims(1) | GPS.lon > llims(2));
GPS.lon(bad) = NaN;
bad = find(GPS.lat < llims(3) | GPS.lat > llims(4));
GPS.lat(bad) = NaN;

% FIND THE TIME LIMITS FOR EACH LEG
for nn = 1:length( leg )
    leg(nn).name = leg(nn).name;
    leg(nn).tlim = [GPS.gpstime( leg(nn).ind(1)), GPS.gpstime( leg(nn).ind(end))];
end

% MAKE A PLOT AND SAVE IT OUT
figure
hold on
clrs = jet( length(leg ));
for nn = 1:length(leg )
    plot( GPS.lon(leg(nn).ind), GPS.lat(leg(nn).ind), '-', 'color', clrs(nn,:), 'linewidth', 2); hold on
    text( GPS.lon(leg(nn).ind(1)), GPS.lat(leg(nn).ind(1)), leg(nn).name)
end

filename = [cruise_name, '_all_legs' ];
print('-dpng','-r300',[targetdir '\' filename]);

%%
if 0,
    Site1 = [-(163+(3.186/60)) 69+45.481/60]; %pt lay
    Site2 = [-(160+(2+7.81/60)/60) 70+(38+20.48/60)/60]; %wainwright
    Site3 = [-(156+(39+59.38/60)/60) 71+(19+50.60/60)/60]; %barrow
    proj = 'lambert';
    if (strcmp(cruise_name, 'ChukchiGliderCruise2012')),
        lonrng = [-165 -153.5];
        latrng = [70 72.5];
    elseif (strcmp(cruise_name, 'ChukchiGliderCruise2013')),
        lonrng = [-169 -156];
        latrng = [70 73];
    else,
        lonrng = [-169 -156];
        latrng = [70 73];
    end
    load chuk_bath.mat
    orient portrait;
    
    figure
    clf
    
    m_proj(proj,'lat',latrng,'lon',lonrng);
    % m_gshhs_f('save','Chukchi_coast_2013_N2.mat')
    if (strcmp(cruise_name, 'ChukchiGliderCruise2012')),
        m_usercoast('Chukchi_coast_2012_N2.mat','patch',[0.7 0.7 0.7]);
    elseif (strcmp(cruise_name, 'ChukchiGliderCruise2013')),
        m_usercoast('Chukchi_coast_2013_N2.mat','patch',[0.7 0.7 0.7]);
    else,
        m_usercoast('Chukchi_coast_2013_N2.mat','patch',[0.7 0.7 0.7]);
    end
    m_usercoast('Chukchi_coast_2012_N2.mat','patch',[0.7 0.7 0.7]);
    m_grid('xtick', 3,'ytick', 3, 'fontsize', 16)
    hold on
    [cs,h] = m_contour(blon,blat,zz,[20 30 40  50 60  100  150 200 300 500 1000 2000 3000],'color',[.6 .6 .6]);
    clabel(cs,h,'fontsize',6,'label',350,'color',[.6 .6 .6]);
    set(h,'linewidth',.7)
    
    h3 = m_plot(Site2(1),Site2(2),'marker','square','markersize',7,'color','k','markerfacecolor','g','linestyle','none');
    h4 = m_text(Site2(1)-0.1,Site2(2),'WAINWRIGHT','fontsize',6,'fontweight','bold','fontname','verdana', 'horizontalalignment', 'right');
    h5 = m_plot(Site3(1),Site3(2),'marker','square','markersize',7,'color','k','markerfacecolor','g','linestyle','none');
    h6 = m_text(Site3(1)-0.1,Site3(2),'BARROW','fontsize',6,'fontweight','bold','fontname','verdana', 'horizontalalignment', 'right');
    clrs = jet( length(leg ));
    for nn = 1:length(leg )
        m_plot( GPS.lon(leg(nn).ind), GPS.lat(leg(nn).ind), '-', 'color', clrs(nn,:), 'linewidth', 2); hold on
        m_text( GPS.lon(leg(nn).ind(1))+0.05, GPS.lat(leg(nn).ind(1))+0.02, leg(nn).name)
    end
    
    m_ruler([0.2 0.8], .9);
    
    h8 = title( [cruise_name], 'fontsize', 18, 'fontweight', 'bold');
    %set(h8,'position',[ -0.00001    0.059    5.5197]);
    
    flags = '-r300 -painters';
    filename = [cruise_name, '_all_legs' ];
    print('-dpng','-r300',[targetdir '\' filename]);
end
% SAVE OUT THE LEGS AS A MATLAB FILE
filename = [cruise_name, 'Legs' ];
savefile = fullfile( targetdir, filename );
eval( ['save ', savefile , ' leg '])
disp( 'Leg data processed and saved')
leg = rmfield( leg, 'ind');

