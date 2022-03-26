function plotAcrobatCruiseLegsDistanceMap_temp_sal_TS(top_dir, cruise_name)

% function plotAcrobatCruiseLegs2(top_dir, cruise_name)
%
%  Make contour plots of each leg.
%
% KIM 08.13
% v2: CBI 09.13


% IDENTIFY THE TARGET
targetdir = fullfile( top_dir, cruise_name, 'DATA', 'ACROBAT','PROCESSED');
if ~isdir( fullfile(targetdir, 'TC_CORRECTED_PLOTS'))
    mkdir( fullfile( top_dir, cruise_name, 'DATA', 'ACROBAT','PROCESSED'), 'TC_CORRECTED_PLOTS')
end


%LOAD THE DATA
load( fullfile( targetdir, 'gridded.mat'));
load( fullfile( targetdir, [cruise_name,'Legs.mat']));
targetdir = fullfile( top_dir, cruise_name, 'DATA', 'ACROBAT','PROCESSED', 'TC_CORRECTED_PLOTS');

load chuk_bath.mat
load AlaskaXYZ.mat
XE = XE - 360;

% set up the plot
scrsz = get(0,'ScreenSize');
figure(1); % 'position', scrsz);
clf
set( 1, 'Position', scrsz);
orient landscape;
% create six axes
a(3,1) = axes('position', [0.0600    0.0301    0.5500 0.2900]);
a(2,1) = axes('position', [0.0600    0.3509    0.5500 0.2900]);
a(1,1) = axes('position', [0.0600    0.6709    0.5500 0.2900]);
a(4,1) = axes('position', [0.68      0.5250    0.2800 0.4004]);
a(5,1) = axes('position', [0.68      0.0310    0.2800 0.4004]);

% define the variables
vars = {'t', 's', 'chl'};
lims = {[-2, 10], [25, 34], [0, 5]};
titles = {'temperature', 'salinity', 'chlorophyll'};
units = {'[\circ C]', '', '[\mug/l]'};
cticks = {[-2:2:10], [25:4:34], [0:2:4]};

prange = [0, 60];
pint = 0:0.5:60;

% Now to cycle through the legs and make a contour plot
% for ll = 1:length(leg)
    % for ll = 1:length( leg )
 for ll = 6:6
    
    clf;
    % create six axes
    a(3,1) = axes('position', [0.0600    0.0301    0.5500 0.2900]);
    a(2,1) = axes('position', [0.0600    0.3509    0.5500 0.2900]);
    a(1,1) = axes('position', [0.0600    0.6709    0.5500 0.2900]);
    a(4,1) = axes('position', [0.68      0.5250    0.2800 0.4004]);
    a(5,1) = axes('position', [0.68      0.0310    0.2800 0.4004]);
    
    filestr = [cruise_name, 'Leg',  leg(ll).name];
    
    cols = find( gridded.mtime >= leg(ll).tlim(1) &  gridded.mtime <=leg(ll).tlim(2));
    
        %determine if lon is positive or negative
    sgn = mean(gridded.lon(cols));
    if (sgn > 0),
        gridded.lon(cols) = -gridded.lon(cols) ;
    end
    % find the gridded distance
    %distleg = nancumsum(gridded.dist(cols),2); % distance in km
    inshore_ind = find(gridded.lon(cols) == max(gridded.lon(cols)));
    lat1 = gridded.lat(cols(inshore_ind));
    lon1 = gridded.lon(cols(inshore_ind));
    for in = 1:length(cols),
        distleg(in) = m_idist(lon1,lat1,gridded.lon(cols(in)),gridded.lat(cols(in)));
    end
    distleg = distleg./1000; %convert to meters
%     distleg( end+1) = distleg( end);
    
    % find the gridded depth
    depthgrid = interp2(YE, XE, -ZE , gridded.lat(cols), gridded.lon(cols));
    
    % make the sgth grid for contours
    sgthin = gridded.dens(:, cols)-1000;
    % weed out short profiles
    dds = find( sum( ~isnan( sgthin )) >10);
    sgthin = sgthin(:,dds );
    % fill in surface gaps less than 10 m
    for cc = 1:size( sgthin, 2 )
        ii = find( ~isnan( sgthin(:,cc)), 1, 'first');
        if ii < 10
            sgthin(1:ii,cc) = sgthin(ii,cc);
        end
    end
    % fill to the bottom on full profiles
    for cc = 2:size( sgthin, 2 )-1
        ii = find( ~isnan( sgthin(:,cc)), 1, 'last');
        i1 = find( ~isnan( sgthin(:,cc-1)), 1, 'last');
        i2 = find( ~isnan( sgthin(:,cc+1)), 1, 'last');
        if mean(abs( [ii-i1, ii-i2])) < 8
            sgthin(ii:end,cc) = sgthin(ii,cc);
        end
    end
    % interpolate the rest horizontally
    for cc = 1:size( sgthin, 1 )
        sgthin(cc,:) = naninterp( sgthin(cc,:));
    end
    % smooth horizontally and cutoff anything greater than the depth
    for cc = 1:size( sgthin, 2 )
        sgthin(:,cc) = boxcarsmooth( sgthin(:,cc), 5)';
        sgthin( gridded.p > depthgrid(dds(cc)), cc) = nan;
    end
    
    % start plotting
    for ss = 1:3
        %         axes(sb(ss))
        axes(a(ss,1))
        cla;
        % fill in the gaps
        if ss ~=5
            datin = gridded.(vars{ss})(:, cols);
        else
            datin = gridded.(vars{ss})(:, cols);
        end
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
        if (ss == 1),
            temp = datin;
        elseif (ss == 2);
            sal = datin;
        end
        % contourf the data
        [dl,in] = unique(distleg(dd));
        [dls,in2] = unique(distleg(dds));
        contourf( naninterp(dl), gridded.p, datin(:,in), linspace( lims{ss}(1), lims{ss}(2), 31), 'linecolor', 'none');
        hold on
        % make the density contours
        [c, d] = contour( naninterp(dls), gridded.p, sgthin(:,in2) , 20:2:30, '-', 'linewidth', 1, 'color', [1, 1, 1]*0);
        clabel( c, d, 'fontweight', 'bold','fontsize',10,'fontname','Times')
        % plot bottom
        k1 = karea( distleg, depthgrid, 'basevalue', 100, 'facecolor', [1, 1, 1]*0.5, 'edgecolor', [1, 1, 1]*0.1);
        
        % adjust the axes limits
        axis tight;  axis ij; caxis( lims{ss})
        ylim( [0, max(gridded.p)])
        % label the axes
        titleout( titles{ss}, a(ss,1), 'fontsize', 14, 'fontweight', 'bold','fontname','Times')
        set( a(ss,1), 'fontsize', 12,'fontname','Times')
        % make the colorbar
        cb = colorbar;
        set( cb, 'fontsize', 12, 'fontweight', 'normal', 'ytick', cticks{ss})
        ylabel( cb, units{ss}, 'fontsize', 12,'fontname','Times')
        % adjust the axes
        scoot_axes( [0, 0, -0.025, 0])
        % turn tick labels on or off
        if ss~=3
            set( a(ss,1), 'xticklabel', [])
            set(gca,'ytick',[0:20:max(gridded.p)],'yticklabel',[0:20:max(gridded.p)]);
        else
            xlh = xlabel( 'distance [km]');
            tmpp = get(xlh,'position');
            set(xlh,'position',[tmpp(1,1) tmpp(1,2)+1.5 tmpp(1,3)]);
            ylh = ylabel( '[db]');
            tmpp = get(ylh,'position');
            set(ylh,'position',[tmpp(1,1)-.5 tmpp(1,2) tmpp(1,3)]);
            set(gca,'ytick',[0:20:max(gridded.p)],'yticklabel',[0:20:max(gridded.p)]);
        end
    end
    
    %  make a map with the legs
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
    axes(a(4,1));
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
    clabel(cs,h,'fontsize',6,'color',[.6 .6 .6]);
    set(h,'linewidth',.7)
    
    h1 = m_plot( gridded.lon(cols), gridded.lat(cols), '-', 'color', 'r', 'linewidth', 2); hold on
    h2 = m_plot( lon1, lat1, 'o', 'color', 'k', 'markersize', 4, 'linewidth', 2, 'markerfacecolor', 'g')
    
    h3 = m_plot(Site2(1),Site2(2),'marker','square','markersize',7,'color','k','markerfacecolor','b','linestyle','none');
    h4 = m_text(Site2(1)-0.1,Site2(2),'WAINWRIGHT','fontsize',6,'fontweight','bold','fontname','verdana', 'horizontalalignment', 'right');
    h5 = m_plot(Site3(1),Site3(2),'marker','square','markersize',7,'color','k','markerfacecolor','b','linestyle','none');
    h6 = m_text(Site3(1)-0.1,Site3(2),'BARROW','fontsize',6,'fontweight','bold','fontname','verdana', 'horizontalalignment', 'right');
    
    m_ruler([0.2 0.8], .9);
    
    h8 = title( {[cruise_name];...
        [ ' Leg ', leg(ll).name ];...
        ['Start Time: ' datestr(gridded.mtime(cols(1)))]}, 'fontsize', 16, 'fontweight', 'bold');
    %     tmph8 = get(h8,'position');
    %set(h8,'position',[ -0.00001    0.059    4.5197]);
    % Make the TS plot
    axes(a(5,1));
    [M,N] = size(temp);
    ptmp = sw_ptmp(sal,temp,gridded.p,1);
    tt = reshape(ptmp, M.*N,1);
    ss = reshape(sal, M.*N,1);
    
    Sg = lims{2}(1)+[0:30]/30*(lims{2}(2)-lims{2}(1));
    Tg = lims{1}(1)+[0:30]/30*(lims{1}(2)-lims{1}(1));
    SG = sw_dens(Sg,Tg,30)-1000;
    [X,Y] = meshgrid(Sg,Tg);
    dens = sw_dens(X,Y,1)-1000;
    [CS,H]=contour(X,Y,dens,'color','k','linewidth',.5,'linestyle','-');
    clabel(CS,H); %,sigma(1:2:end));
    axis('square');
    freezeT=swfreezetemp([lims{2}(1) lims{2}(2)],1);
    line([lims{2}(1) lims{2}(2)],freezeT,'LineStyle','--','linewidth',1.5);
    hold on;
    plot(ss, tt,'k.')
    xlabel('Salinity','fontsize',12,'fontname','Times');
    ylabel('Pot. Temperature ({\circ}C)','fontsize',12,'fontname','Times');
    grid on
    set(gca,'xlim',[lims{2}(1) lims{2}(2)],'ylim',[lims{1}(1) lims{1}(2)],'fontsize',10,'fontname','Times')
    % Gong and Pickart Defined Limits
    %ACW
    plot([30 lims{2}(2)],[3 3],'k','linewidth',1.5); %horiz. line
    plot([30 30],[-1 lims{1}(2)],'k','linewidth',1.5); %vert. line
    %CSW
    plot([lims{2}(1) lims{2}(2)],[-1 -1],'k','linewidth',1.5); %horiz. line
    %plot([33.6 33.6],[-1 3],'k','linewidth',1.5); %vert. line
    plot([32.8 32.8],[-1 3],'k','linewidth',1.5); %vert. line
    %MW
    plot([31.5 31.5],[-2 -1],'k','linewidth',1.5); %horiz. line
    %PWW
    plot([31.5 lims{2}(2)],[-1.6 -1.6],'k','linewidth',1.5); %horiz. line
    
    flags = '-r300 -painters';
    filename = [cruise_name, 'Leg_T_S_Chl', leg(ll).name ];
    print('-dpng','-r300',[targetdir '\' filename]);
    %    WriteEPS(filename, targetdir, flags)
    %      WritePDF(filename,targetdir,flags);
    clear h1 h2 h3 h4 h5 h6 h7 h8 distleg depthgrid;
    for ss=1:5
        axes(a(ss,1));
        cla;
    end
end % ll