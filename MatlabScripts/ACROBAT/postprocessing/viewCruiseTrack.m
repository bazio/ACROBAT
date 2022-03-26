function viewCruiseTrack( top_dir, cruise_name, dlim , dt, survey, llims)

% function viewCruiseTrack( top_dir, cruise_name )
%
%  View the current cruise track with every points marked every 10 minutes so the legs
%  can be defined.
%
% KIM 08.13
% HS 02.16

% IDENTIFY THE TARGET
targetdir = fullfile( top_dir, cruise_name, 'DATA', 'ACROBAT','PROCESSED');

%LOAD THE GPS DATA
load( fullfile( targetdir, 'GPS.mat'));

ens = find(GPS.gpstime > dlim(1) & GPS.gpstime < dlim(2));
% MAKE A NEW FIGURE
figure;
clf;
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

plot( GPS.lon(ens), GPS.lat(ens), 'k-');
hold on
scatter( GPS.lon(ens(1:10:end)), GPS.lat(ens(1:10:end)), 5, GPS.gpstime(ens(1:10:end)), 'filled');

% 20 minute spacing
plot( GPS.lon(ens(1:dt:end)), GPS.lat(ens(1:dt:end)), 'r.')

for ii = dt:dt:length( GPS.gpstime(ens) )
    text( GPS.lon(ens(ii)), GPS.lat(ens(ii)), num2str(ens(ii)))
end

legend('track', 'time', [num2str(round(dt./60)) '-min markers'])
cb = colorbar;
datetick(cb,'y');
ylabel(cb, 'GPS time')
titleout( [cruise_name, ' cruise track for survey ' num2str(survey)])
grid on

%%
if 0,
    figure;
    clf;
    
    proj = 'lambert';
    
    m_proj(proj,'lat',[56  61.2],'lon',[-152 -141]);
    
    m_grid
    hold on
    m_gshhs_f('save','GOA');
    m_usercoast('GOA.mat','patch',[.7 .7 .7]);
    % coast file and bathymetry doesn't meet up
    
    h1 = m_plot( GPS.lon, GPS.lat, '.', 'color', 'r', 'linewidth', 2);
    hold on
    
end