function plotAcrobatCruiseLegsDistanceMap_TS(top_dir, cruise_name)

% function plotAcrobatCruiseLegs2(top_dir, cruise_name)
%
%  Make contour plots of each leg.
%
% KIM 08.13
% v2: CBI 09.13
% v3: HS 03.16
% v4: IR 04.20
set(0,'defaulttextfontsize',12);
set(0,'DefaultAxesFontName', 'Times')
set(0,'DefaultAxesFontSize', 12)
% IDENTIFY THE TARGET
targetdir = fullfile( top_dir, cruise_name, 'DATA', 'ACROBAT','PROCESSED');
if ~isdir( fullfile(targetdir, 'TC_CORRECTED_PLOTS'))
    mkdir( fullfile( top_dir, cruise_name, 'DATA', 'ACROBAT','PROCESSED'), 'TC_CORRECTED_PLOTS')
end


%LOAD THE DATA
load( fullfile( targetdir, 'gridded.mat'));
load( fullfile( targetdir, [cruise_name,'Legs.mat']));
targetdir = fullfile( top_dir, cruise_name, 'DATA', 'ACROBAT','PROCESSED', 'TC_CORRECTED_PLOTS');

%     gridded.lat = -1*gridded.lat; % ecofjords has positive latitudes
cruise_name = 'NUQ201901S';


% load bathymetry data
load chuk_bath.mat
% load AlaskaXYZ.mat
% XE = XE - 360;
load /Users/hstats/Documents/LTER/mapping/AlaskaXYZ.mat
XE = XE - 360;
% ZE = -ZE;
% define the variables
% define the variables
vars = {'t', 's', 'dens', 'chl', 'particle', 'CDOM'};
lims = {[6, 18], [20, 33], [10, 26], [0, 5], [0, 5]*10^5, [0, 5]};
titles = {'temperature', 'salinity', 'density', 'chlorophyll', 'particle concentration', 'CDOM'};
units = {'[\circ C]', '', '[kg m^{-3}]', '[\mug/l]', '[(m sr)^{-1}]', '[ppb]'};
cticks = {[6:2:18], [20:4:32.5], [10:2:26], [0:2:4], [0:2:4]*10^5, [0:2:4]};

prange = [0, 50];
pint = 0:0.5:50;
% lonrng = [-148 -145];
% latrng = [59.4  61.5];
lonrng = [-148.7 -143.5];
latrng = [59.4  61.2];
short_thresh = 3;

[M,N] = size(gridded.dens);
for in=1:N
    dif_dens(:,in) = diff(gridded.dens(:,in));
    if length(find(~isnan(dif_dens(:,in))) > 10)
        py_d(in) = gridded.p(near(dif_dens(:,in), max(dif_dens(:,in)),1));
    else
        py_d(in) = NaN;
    end
end

%%
figure('Position',[1950 10 1800 980])
orient landscape;
colormap(jet);

a(6,1) = axes('position', [0.0550    0.0610    0.5500 0.1126]);
a(5,1) = axes('position', [0.0550    0.2135    0.5500 0.1126]);
a(4,1) = axes('position', [0.0550    0.3660    0.5500 0.1126]);
a(3,1) = axes('position', [0.0550    0.5284    0.5500 0.1126]);
a(2,1) = axes('position', [0.0550    0.6909    0.5500 0.1126]);
a(1,1) = axes('position', [0.0550    0.8534    0.5500 0.1126]);
a(7,1) = axes('position', [0.68      0.4850    0.2800 0.4504]);
a(8,1) = axes('position', [0.68      0.0610    0.2800 0.3504]);

% Now to cycle through the legs and make a contour plot
for ll = 1:length(leg)
    
    clf;
    % create six axes
    a(6,1) = axes('position', [0.0550    0.0610    0.5500 0.1126]);
    a(5,1) = axes('position', [0.0550    0.2135    0.5500 0.1126]);
    a(4,1) = axes('position', [0.0550    0.3660    0.5500 0.1126]);
    a(3,1) = axes('position', [0.0550    0.5284    0.5500 0.1126]);
    a(2,1) = axes('position', [0.0550    0.6909    0.5500 0.1126]);
    a(1,1) = axes('position', [0.0550    0.8534    0.5500 0.1126]);
    a(7,1) = axes('position', [0.68      0.4450    0.2800 0.4504]);
    a(8,1) = axes('position', [0.68      0.0610    0.2800 0.3504]);
    
    filestr = [cruise_name, 'Leg',  leg(ll).name];
    
    cols = find( gridded.mtime >= leg(ll).tlim(1) &  gridded.mtime <=leg(ll).tlim(2));
    
    % find the gridded distance
    distleg = nancumsum(gridded.dist(cols),2); % distance in km

    depthgrid = interp2(YE, XE, -ZE , gridded.lat(cols), gridded.lon(cols));
  
    % make the sgth grid for contours
    sgthin = gridded.dens(:, cols)-1000;
    % weed out short profiles
    dds = find( sum( ~isnan( sgthin )) > short_thresh);
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
    for ss = 1:6
        %         axes(sb(ss))
        axes(a(ss,1))
        cla;
        
        % fill in the gaps
        if ss ~=5
            datin = gridded.(vars{ss})(:, cols);
        else
            datin = gridded.(vars{ss})(:, cols);
        end
        % plot sigma theta for plotting purposes
        if ss == 3
            datin = datin - 1000;
        end
        %% Set sgthin to NaN below data
        for cc = 1:size(sgthin,2)
            i_finite = find(isfinite(datin(:,cc)));
            if isempty(i_finite)
                max_i(cc) = NaN;
            else
                max_i(cc) = i_finite(end)+1;
                % data is NaN beyond max_i
                sgthin(max_i(cc):end,cc) = NaN;
            end
        end
        % weed out short profiles
        dd =  find( sum( ~isnan( datin )) >short_thresh);
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
        %% Setting all vertically interpolated data to NaN because odd values
%         for cc = 1:size(datin,2)
%             if isfinite(max_i(cc))
%                 datin(max_i(cc):end,cc) = NaN;
%             end
%         end
        %%
        % contourf the data
        v = naninterp(distleg(dd));
        badpt = find(diff(v) <= 0); % find where is not strictly increasing or has repeated value
        %% CAUTION -- altering data!
        if ~ isempty(badpt)
            disp([ '*** ' char(titles(ss))  ' not strickly increasing or has n repeated values! n = ' num2str(numel(badpt))]);
            for i = 1:numel(badpt)
                bad = badpt(i) + 1; % next place up will be the same
                next_i = bad + 1;
                if bad == numel(v) % last indice
                    next_diff = diff(v(bad-2:bad-1));
                else
                    next_diff = diff(v(bad:next_i));
                end
                v(bad) = v(bad) + next_diff./2;
            end
        end
        %contourf( naninterp(distleg(dd)), gridded.p, datin, linspace( lims{ss}(1), lims{ss}(2), 31), 'linecolor', 'none');
        contourf( v, gridded.p, real(datin), linspace( lims{ss}(1), lims{ss}(2), 31), 'linecolor', 'none');
        hold on
        % make the density contours
        v = naninterp(distleg(dds));
        badpt = find(diff(v) <= 0); % find where is not increasing or has repeated value
        %% CAUTION -- altering data!
        if ~ isempty(badpt)
            %disp([ '*** Density not strickly increasing or has n repeated values! n = ' num2str(numel(badpt))]);
            disp(' ');
            for i = 1:numel(badpt)
                bad = badpt(i) + 1; % next place up will be the same
                next_i = bad + 1;
                if bad == numel(v) % last indice
                    next_diff = diff(v(bad-2:bad-1));
                else
                    next_diff = diff(v(bad:next_i));
                end
                v(bad) = v(bad) + next_diff./2;
            end
        end
        %[c, d] = contour( naninterp(distleg(dds)), gridded.p, sgthin , 20:2:30, '-', 'linewidth', 1, 'color', [1, 1, 1]*0);
        if strcmp(cruise_name,'EcoFjordAcrobat2016')
            [c, d] = contour( v, gridded.p, sgthin , 26:0.25:28, '-', 'linewidth', 1, 'color', [1, 1, 1]*0);
        else
            [c, d] = contour( v, gridded.p, real(sgthin) , 10:2:30, '-', 'linewidth', 1, 'color', [1, 1, 1]*0);
        end
        clabel( c, d, 'fontweight', 'bold','fontsize',10,'fontname','Times')
        % plot bottom
         k1 = karea( distleg, depthgrid, 'basevalue', 100, 'facecolor', [1, 1, 1]*0.5, 'edgecolor', [1, 1, 1]*0.1);
%          plot(distleg, py_d(cols),'w--','linewidth',1); %plot pycnocline depth
        % adjust the axes limits
        axis tight;  axis ij; caxis( lims{ss})
%         ylim( [0, max(gridded.p)])
        ylim( [0, prange(2)])
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
        if ss~=6
            set( a(ss,1), 'xticklabel', [])
            set(gca,'ytick',[0:20:max(gridded.p)],'yticklabel',[0:20:max(gridded.p)]);
        else
            xlh = xlabel( 'distance [km]','fontweight','bold','fontname','Times','fontsize',12);
            tmpp = get(xlh,'position');
            %set(xlh,'position',[tmpp(1,1) tmpp(1,2)+1.5 tmpp(1,3)]);
            ylh = ylabel( '[db]','fontweight','bold','fontname','Times','fontsize',12);
            tmpp = get(ylh,'position');
            set(ylh,'position',[tmpp(1,1)-.5 tmpp(1,2) tmpp(1,3)]);
            set(gca,'ytick',[0:20:max(gridded.p)],'yticklabel',[0:20:max(gridded.p)]);
        end
    end
    
    %%  make a map with the legs
    % open the map and define the projection
    
    
    proj = 'lambert';
    orient landscape;
    axes(a(7,1));
    m_proj(proj,'lat',latrng,'lon',lonrng);
    
    v_coast = [50 45];
    v_bathy = [ 0 -20 -40 -60 -100 -200 -400 -600 -1000];
    
    m_grid
    hold on
%     m_gshhs_f('save','GOA');
    m_usercoast('GOA.mat','patch',[.7 .7 .7]);
    % coast file and bathymetry doesn't meet up
    m_contour(blon,blat,zz,v_coast,'color',[0 0 0],'LineWidth',1);
    
    [cs,h] = m_contour(XE,YE,ZE,[-20 -30 -40 -50 -60 -100 -150 -200 -300 -500 -1000 -2000 -3000],'color',[.6 .6 .6]);
%clabel(cs,h,'fontsize',6);
%clabel(cs,h,'LabelSpacing',72,'Color','b','FontWeight','bold')
 
    set(h,'linewidth',.7)
    set(gcf,'renderer','painters')
    set(gca,'drawmode','fast')
    %h1 = m_plot( gridded.lon(cols), gridded.lat(cols), '-', 'color', 'r', 'linewidth', 2); hold on
    m_ruler([0.2 0.8], .2);
    % get idea of distance along track
    [x,y] = m_ll2xy(gridded.lon(cols),gridded.lat(cols));
    scatter(x,y,15,distleg,'filled')
    cb = colorbar('south');
    caxis([0 ceil(max(distleg))]);
    % make colorbar shorter [left,bottom,width,height]
    ax = get(gca);
    axpos = get(gca,'Position');
    cpos = get(cb,'Position');
    cpos(4) = 0.5*cpos(4);
    cpos(2) = cpos(2) + 0.01;
    set(cb,'Position',cpos);
    %         cb.Position = cpos;
    %set(ax,'Position',axpos); %ax.Position = axpos;
    
    ylabel(cb,'distance [km]','fontweight','normal','fontsize',12)
    h2 = m_plot( gridded.lon(cols(1)), gridded.lat(cols(1)), 'o', 'color', 'k', 'markersize', 8, 'linewidth', 0.5, 'markerfacecolor', 'g');
    %tempstring = num2str(distleg(1:8:end),' %1.0f');
    %strngs = strsplit(tempstring,' ');
    %places = [1:8:size(cols,2)];
    
    %m_text(lons(places),lats(places),strngs,'vertical','top','fontsize',10,'fontweight','bold','fontname','times')
    %% Chukchi Sea
    if 0,
        %         Site1 = [-(163+(3.186/60)) 69+45.481/60]; %pt lay
        %         Site2 = [-(160+(2+7.81/60)/60) 70+(38+20.48/60)/60]; %wainwright
        %         Site3 = [-(156+(39+59.38/60)/60) 71+(19+50.60/60)/60]; %barrow
        %         proj = 'lambert';
        %         % only call this once to make the coastline file
        %         %     m_gshhs_f('save','Chukchi_coast_2012_N2.mat')
        %         if (strcmp(cruise_name, 'ChukchiAcrobatCruise2012')),
        %           m_usercoast('Chukchi_coast_2012_N2.mat','patch',[0.7 0.7 0.7]);
        %         else
        %           m_usercoast('Chukchi_coast_2013_N2.mat','patch',[0.7 0.7 0.7]);
        %         end
        %
        %         orient landscape;
        %         axes(a(7,1));
        %         m_proj(proj,'lat',latrng,'lon',lonrng);
        %
        %         m_grid('xtick', 3,'ytick', 3, 'fontsize', 12)
        %         hold on
        %         [cs,h] = m_contour(blon,blat,zz,[20 30 40 50 60 100 150 200 300 500 1000 2000 3000],'color',[.6 .6 .6]);
        %         clabel(cs,h,'fontsize',6,'color',[.6 .6 .6],'fontname','Times');
        %         set(h,'linewidth',.7)
        %         h1 = m_plot( gridded.lon(cols), gridded.lat(cols), '-', 'color', 'r', 'linewidth', 2); hold on
        %         h2 = m_plot( gridded.lon(cols(1)), gridded.lat(cols(1)), 'o', 'color', 'k', 'markersize', 4, 'linewidth', 2, 'markerfacecolor', 'g');
        %         h3 = m_plot(Site2(1),Site2(2),'marker','square','markersize',7,'color','k','markerfacecolor','b','linestyle','none');
        %         h4 = m_text(Site2(1)-0.1,Site2(2),'WAINWRIGHT','fontsize',6,'fontweight','bold','fontname','verdana', 'horizontalalignment', 'right');
        %         h5 = m_plot(Site3(1),Site3(2),'marker','square','markersize',7,'color','k','markerfacecolor','b','linestyle','none');
        %         h6 = m_text(Site3(1)-0.1,Site3(2),'BARROW','fontsize',6,'fontweight','bold','fontname','verdana', 'horizontalalignment', 'right');
        %         m_ruler([0.2 0.8], .9);
    end
    %%
    
    %%cruise_name_title = strrep(cruise_name,'_','\_');
    %%h8 = title( {[cruise_name_title];...
    h8 = title( {[cruise_name];...
        [ ' Leg ', leg(ll).name ];...
        ['Start Time: ' datestr(gridded.mtime(cols(1)))]}, 'fontsize', 12, 'fontweight', 'bold','fontname','Times');
    
    
    %     tmph8 = get(h8,'position');
    %set(h8,'position',[ -0.00001    0.059    4.5197]);
    %% Make the TS plot
    axes(a(8,1));
    [M,N] = size(temp);
    if ll == 12 & strcmp(cruise_name,'EcoFjordAcrobat2015')
        sal(:,size(temp,2)) = NaN;
    end
    ptmp = sw_ptmp(sal,temp,gridded.p,1);
    tt = reshape(ptmp, M.*N,1);
    ss = reshape(sal, M.*N,1);
    
    Sg = lims{2}(1)+[0:30]/30*(lims{2}(2)-lims{2}(1));
    Tg = lims{1}(1)+[0:30]/30*(lims{1}(2)-lims{1}(1));
    SG = sw_dens(Sg,Tg,30)-1000;
    [X,Y] = meshgrid(Sg,Tg);
    dens = sw_dens(X,Y,1)-1000;
    [CS,H]=contour(X,Y,dens,'color','k','linewidth',.5,'linestyle','-');
    clabel(CS,H,'fontname','Times'); %,sigma(1:2:end));
    axis('square');
    freezeT=sw_fp(Sg,1);
    line(Sg,freezeT,'LineStyle','--','linewidth',1.5);
    hold on;
    plot(ss, tt,'k.')
    xlabel('Salinity','fontsize',12,'fontname','Times','fontweight','bold');
    ylabel('Pot. Temperature ({\circ}C)','fontsize',12,'fontname','Times','fontweight','bold');
    grid on
    set(gca,'xlim',[lims{2}(1) lims{2}(2)],'ylim',[lims{1}(1) lims{1}(2)],'fontsize',12,'fontname','Times')
    if isempty(strfind(cruise_name,'Chukchi')) == 0
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
    end
    
    %flags = '-r300 -painters';
    filename = [cruise_name, 'Leg', leg(ll).name ];
    print('-dpng','-r300',[targetdir '\' filename]);
    %    WriteEPS(filename, targetdir, flags)
    %      WritePDF(filename,targetdir,flags);
    clear h1 h2 h3 h4 h5 h6 h7 h8;
    
    %     for ss=1:8
    %         axes(a(ss,1));
    %         cla;
    %     end
end % ll
