function plotAcrobat_pycnocline_map(top_dir, cruise_name)

% function plotAcrobatCruiseLegs2(top_dir, cruise_name)
%
%
%
% HS 02.16


% IDENTIFY THE TARGET
targetdir = fullfile( top_dir, cruise_name, 'DATA', 'ACROBAT','PROCESSED');
if ~isdir( fullfile(targetdir, 'TC_CORRECTED_PLOTS'))
    mkdir( fullfile( top_dir, cruise_name, 'DATA', 'ACROBAT','PROCESSED'), 'TC_CORRECTED_PLOTS')
end


%LOAD THE DATA
load( fullfile( targetdir, 'gridded.mat'));
load( fullfile( targetdir, [cruise_name,'Legs.mat']));
targetdir = fullfile( top_dir, cruise_name, 'DATA', 'ACROBAT','PROCESSED', 'TC_CORRECTED_PLOTS');

%%
vars = {'m', 't', 's', 'dens', 'chl', 'particle', 'CDOM'};
lims = {[0, 40], [-2, 10], [25, 34], [20, 27], [0, 5], [0, 5]*10^5, [0, 5]};
titles = {'temperature', 'salinity', 'density', 'chlorophyll', 'particle concentration', 'CDOM'};
units = {'m', '[\circ C]', '', '[kg m^{-3}]', '[\mug/l]', '[(m sr)^{-1}]', '[ppb]'};
cticks = {[0:5:40], [-2:2:10], [25:4:34], [20:2:27], [0:2:4], [0:2:4]*10^5, [0:2:4]};

prange = [0, 60];
load chuk_bath.mat
load AlaskaXYZ.mat
XE = XE - 360;

%determine if lon is positive or negative
sgn = mean(gridded.lon);
if (sgn > 0),
    gridded.lon = -gridded.lon ;
end

[M,N] = size(gridded.dens),
for in=1:N,
    dif_dens(:,in) = diff(gridded.dens(:,in));
    if length(find(~isnan(dif_dens(:,in))) > 10),
        py_d(in) = gridded.p(near(dif_dens(:,in), max(dif_dens(:,in)),1));
    else,
        py_d(in) = NaN;
    end
    up_bins = find(gridded.p < py_d(in));
    bot_bins = find(gridded.p >= py_d(in));
    tbar(:,in) = [nanmean(gridded.t(up_bins,in)) nanmean(gridded.t(bot_bins,in))];
    sbar(:,in) = [nanmean(gridded.s(up_bins,in)) nanmean(gridded.s(bot_bins,in))];
    dbar(:,in) = [nanmean(gridded.dens(up_bins,in)) nanmean(gridded.dens(bot_bins,in))];
    cbar(:,in) = [nanmean(gridded.chl(up_bins,in)) nanmean(gridded.chl(bot_bins,in))];
end
%%
% set up the plot
scrsz = get(0,'ScreenSize');
figure(1); % 'position', scrsz);
clf
set( 1, 'Position', scrsz);
orient landscape;

Site1 = [-(163+(3.186/60)) 69+45.481/60]; %pt lay
Site2 = [-(160+(2+7.81/60)/60) 70+(38+20.48/60)/60]; %wainwright
Site3 = [-(156+(39+59.38/60)/60) 71+(19+50.60/60)/60]; %barrow

% open the map and define the projection
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

%      orient portrait;
orient landscape;
for in = 1:4,
    subplot(2,2,in)
    m_proj(proj,'lat',latrng,'lon',lonrng);
    % only call this once to make the coastline file
    %     m_gshhs_f('save','Chukchi_coastfb.mat')
    if (strcmp(cruise_name, 'ChukchiGliderCruise2012')),
        m_usercoast('Chukchi_coast_2012_N2.mat','patch',[0.7 0.7 0.7]);
    elseif (strcmp(cruise_name, 'ChukchiGliderCruise2013')),
        m_usercoast('Chukchi_coast_2013_N2.mat','patch',[0.7 0.7 0.7]);
    else,
        m_usercoast('Chukchi_coast_2013_N2.mat','patch',[0.7 0.7 0.7]);
    end
    
    m_grid('xtick', 3,'ytick', 3, 'fontsize', 12)
    hold on
    [cs,h] = m_contour(blon,blat,zz,[20 30 40 50 60 100 150 200 300 500 1000 2000 3000],'color',[.6 .6 .6]);
    clabel(cs,h,'fontsize',6,'label',350,'color',[.6 .6 .6]);
    set(h,'linewidth',.7)
    
    if (in == 1),
        h1 = m_scatter( gridded.lon, gridded.lat, 15, py_d,'filled');
        h8 = title( {[cruise_name];...
            [ ' Pycnocline Depth' ]},'fontsize', 16, 'fontweight', 'bold');
    elseif (in == 2),
        h1 = m_scatter( gridded.lon, gridded.lat, 15, tbar(1,:),'filled');
         h8 = title( {[cruise_name];...
            [ ' Upper Layer Temperature' ]},'fontsize', 16, 'fontweight', 'bold');
    elseif (in == 3),
        h1 = m_scatter( gridded.lon, gridded.lat, 15, sbar(1,:),'filled');
        h8 = title( {[cruise_name];...
            [ ' Upper Layer Salinity' ]},'fontsize', 16, 'fontweight', 'bold');
    elseif (in == 4),
        h1 = m_scatter( gridded.lon, gridded.lat, 15, dbar(1,:)-1000,'filled');
        h8 = title( {[cruise_name];...
            [ ' Upper Layer Density' ]},'fontsize', 16, 'fontweight', 'bold');
    end
    caxis( lims{in})
    cb = colorbar;
    set( cb, 'fontsize', 12, 'fontweight', 'normal', 'ytick', cticks{in})
    ylabel( cb, units{in}, 'fontsize', 12,'fontname','Times')
    
    %h2 = m_plot( gridded.lon, gridded.lat, 'o', 'color', 'k', 'markersize', 4, 'linewidth', 2, 'markerfacecolor', 'g')
    
    h3 = m_plot(Site2(1),Site2(2),'marker','square','markersize',7,'color','k','markerfacecolor','b','linestyle','none');
    h4 = m_text(Site2(1)-0.1,Site2(2),'WAINWRIGHT','fontsize',6,'fontweight','bold','fontname','verdana', 'horizontalalignment', 'right');
    h5 = m_plot(Site3(1),Site3(2),'marker','square','markersize',7,'color','k','markerfacecolor','b','linestyle','none');
    h6 = m_text(Site3(1)-0.1,Site3(2),'BARROW','fontsize',6,'fontweight','bold','fontname','verdana', 'horizontalalignment', 'right');
    
    m_ruler([0.2 0.8], .9);
    
end

%%
% set up the plot
scrsz = get(0,'ScreenSize');
figure(1); % 'position', scrsz);
clf
set( 1, 'Position', scrsz);
orient landscape;

Site1 = [-(163+(3.186/60)) 69+45.481/60]; %pt lay
Site2 = [-(160+(2+7.81/60)/60) 70+(38+20.48/60)/60]; %wainwright
Site3 = [-(156+(39+59.38/60)/60) 71+(19+50.60/60)/60]; %barrow

% open the map and define the projection
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

%      orient portrait;
orient landscape;
for in = 1:4,
    subplot(2,2,in)
    m_proj(proj,'lat',latrng,'lon',lonrng);
    % only call this once to make the coastline file
    %     m_gshhs_f('save','Chukchi_coastfb.mat')
    if (strcmp(cruise_name, 'ChukchiGliderCruise2012')),
        m_usercoast('Chukchi_coast_2012_N2.mat','patch',[0.7 0.7 0.7]);
    elseif (strcmp(cruise_name, 'ChukchiGliderCruise2013')),
        m_usercoast('Chukchi_coast_2013_N2.mat','patch',[0.7 0.7 0.7]);
    else,
        m_usercoast('Chukchi_coast_2013_N2.mat','patch',[0.7 0.7 0.7]);
    end
    
    m_grid('xtick', 3,'ytick', 3, 'fontsize', 12)
    hold on
    [cs,h] = m_contour(blon,blat,zz,[20 30 40 50 60 100 150 200 300 500 1000 2000 3000],'color',[.6 .6 .6]);
    clabel(cs,h,'fontsize',6,'label',350,'color',[.6 .6 .6]);
    set(h,'linewidth',.7)
    
    if (in == 1),
        h1 = m_scatter( gridded.lon, gridded.lat, 15, py_d,'filled');
        h8 = title( {[cruise_name];...
            [ ' Pycnocline Depth' ]},'fontsize', 16, 'fontweight', 'bold');
    elseif (in == 2),
        h1 = m_scatter( gridded.lon, gridded.lat, 15, tbar(2,:),'filled');
         h8 = title( {[cruise_name];...
            [ ' Bottom Layer Temperature' ]},'fontsize', 16, 'fontweight', 'bold');
    elseif (in == 3),
        h1 = m_scatter( gridded.lon, gridded.lat, 15, sbar(2,:),'filled');
        h8 = title( {[cruise_name];...
            [ ' Bottom Layer Salinity' ]},'fontsize', 16, 'fontweight', 'bold');
    elseif (in == 4),
        h1 = m_scatter( gridded.lon, gridded.lat, 15, dbar(2,:)-1000,'filled');
        h8 = title( {[cruise_name];...
            [ ' Bottom Layer Density' ]},'fontsize', 16, 'fontweight', 'bold');
    end
    caxis( lims{in})
    cb = colorbar;
    set( cb, 'fontsize', 12, 'fontweight', 'normal', 'ytick', cticks{in})
    ylabel( cb, units{in}, 'fontsize', 12,'fontname','Times')
    
    %h2 = m_plot( gridded.lon, gridded.lat, 'o', 'color', 'k', 'markersize', 4, 'linewidth', 2, 'markerfacecolor', 'g')
    
    h3 = m_plot(Site2(1),Site2(2),'marker','square','markersize',7,'color','k','markerfacecolor','b','linestyle','none');
    h4 = m_text(Site2(1)-0.1,Site2(2),'WAINWRIGHT','fontsize',6,'fontweight','bold','fontname','verdana', 'horizontalalignment', 'right');
    h5 = m_plot(Site3(1),Site3(2),'marker','square','markersize',7,'color','k','markerfacecolor','b','linestyle','none');
    h6 = m_text(Site3(1)-0.1,Site3(2),'BARROW','fontsize',6,'fontweight','bold','fontname','verdana', 'horizontalalignment', 'right');
    
    m_ruler([0.2 0.8], .9);
    
end
%%
if 0,
    % define the variables
    vars = {'t', 's', 'dens', 'chl', 'particle', 'CDOM'};
    lims = {[-2, 10], [25, 34], [20, 27], [0, 5], [0, 5]*10^5, [0, 5]};
    titles = {'temperature', 'salinity', 'density', 'chlorophyll', 'particle concentration', 'CDOM'};
    units = {'[\circ C]', '', '[kg m^{-3}]', '[\mug/l]', '[(m sr)^{-1}]', '[ppb]'};
    cticks = {[-2:2:10], [25:4:34], [20:2:27], [0:2:4], [0:2:4]*10^5, [0:2:4]};
    
    prange = [0, 60];
    load chuk_bath.mat
    load AlaskaXYZ.mat
    XE = XE - 360;
    scrsz = get(0,'ScreenSize');
    
    
    ll = 1;
    
    filestr = [cruise_name, 'Leg',  leg(ll).name];
    
    cols = find( gridded.mtime >= leg(ll).tlim(1) &  gridded.mtime <=leg(ll).tlim(2));
    
    % find the gridded distance
    distleg = nancumsum(gridded.dist(cols),2); % distance in km
    %determine if lon is positive or negative
    sgn = mean(gridded.lon(cols));
    if (sgn > 0),
        gridded.lon(cols) = -gridded.lon(cols) ;
    end
    % find the gridded depth
    depthgrid = interp2(YE, XE, -ZE , gridded.lat(cols), gridded.lon(cols));
    
    
    % fill in the gaps
    ss=3;
    datin = gridded.(vars{ss})(:, cols);
    
    
    % weed out short profiles
    dd =  find( sum( ~isnan( datin )) >10);
    datin = datin(:,dd );
    % fill in surface gaps less than 15 m
    for cc = 1:size( datin, 2 )
        ii = find( ~isnan( datin(:,cc)), 1, 'first');
        if ii < 15
            datin(1:ii,cc) = datin(ii,cc);
        end
    end
    % fill to the bottom on full profiles
    for cc = 2:size( datin, 2 )-1
        ii = find( ~isnan( datin(:,cc)), 1, 'last');
        i1 = find( ~isnan( datin(:,cc-1)), 1, 'last');
        i2 = find( ~isnan( datin(:,cc+1)), 1, 'last');
        if mean(abs( [ii-i1, ii-i2])) < 8
            datin(ii:end,cc) = datin(ii,cc);
        end
    end
    % interpolate the rest horizontally
    for cc = 1:size( datin, 1 )
        if (length(find(isnan(datin(cc,:)))) > (length(datin(cc,:))-2)),
            datin(cc,:) = ones(length(datin(cc,:)),1).*NaN;
        else
            datin(cc,:) = naninterp( datin(cc,:));
        end
    end
    % smooth horizontally and cutoff anything greater than the depth
    for cc = 1:length(dd)
        datin(:,cc) = boxcarsmooth( datin(:,cc), 5)';
        datin( gridded.p > depthgrid(dd(cc)),cc) = nan;
    end
    
    for in=1:length(distleg),
        dif_dens(:,in) = diff(datin(:,in));
        if length(find(~isnan(dif_dens(:,in))) > 10),
            py_d(in) = gridded.p(near(dif_dens(:,in), max(dif_dens(:,in)),1));
        else,
            py_d(in) = NaN;
        end
    end
    py_df = boxcarsmooth(py_d,5);
    
    figure(1); % 'position', scrsz);
    clf
    set( 1, 'Position', scrsz);
    orient landscape;
    % contourf the data
    contourf( naninterp(distleg(dd)), gridded.p, datin-1000, linspace( lims{ss}(1), lims{ss}(2), 31), 'linecolor', 'none');
    hold on
    % make the density contours
    [c, d] = contour( naninterp(distleg(dd)), gridded.p, datin-1000 , 20:2:30, '-', 'linewidth', 1, 'color', [1, 1, 1]*0);
    clabel( c, d, 'fontweight', 'bold','fontsize',10,'fontname','Times')
    % plot bottom
    k1 = karea( distleg, depthgrid, 'basevalue', 100, 'facecolor', [1, 1, 1]*0.5, 'edgecolor', [1, 1, 1]*0.1);
    plot(distleg, py_df,'w--','linewidth',3)
    % adjust the axes limits
    axis tight;  axis ij; caxis( lims{ss})
    ylim( [0, max(gridded.p)])
    % label the axes
    titleout( titles{ss}, gca, 'fontsize', 14, 'fontweight', 'bold','fontname','Times')
    set( gca, 'fontsize', 12,'fontname','Times')
    % make the colorbar
    cb = colorbar;
    set( cb, 'fontsize', 12, 'fontweight', 'normal', 'ytick', cticks{ss})
    ylabel( cb, units{ss}, 'fontsize', 12,'fontname','Times')
    % adjust the axes
    scoot_axes( [0, 0, -0.025, 0])
    % turn tick labels on or off
    
    xlh = xlabel( 'distance [km]');
    tmpp = get(xlh,'position');
    set(xlh,'position',[tmpp(1,1) tmpp(1,2)+1.5 tmpp(1,3)]);
    ylh = ylabel( '[db]');
    tmpp = get(ylh,'position');
    set(ylh,'position',[tmpp(1,1)-.5 tmpp(1,2) tmpp(1,3)]);
    set(gca,'ytick',[0:20:max(gridded.p)],'yticklabel',[0:20:max(gridded.p)]);
    
    
    
    figure
    clf
    subplot(121)
    plot(datin(:,2),gridded.p,'k')
    hold on
    for in = 3:10:length(distleg),
        plot(datin(:,in),gridded.p,'k')
    end
    axis ij;
    
    subplot(122)
    plot(diff(datin(:,2)),gridded.p(1:end-1),'b')
    hold on
    for in = 3:10:length(distleg),
        plot(diff(datin(:,in)),gridded.p(1:end-1),'b')
    end
    axis ij;
end
