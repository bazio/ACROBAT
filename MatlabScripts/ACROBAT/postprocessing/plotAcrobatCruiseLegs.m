function plotAcrobatCruiseLegs(top_dir, cruise_name)

% function plotAcrobatCruiseLegs(top_dir, cruise_name)
%
%  Make contour plots of each leg.
%
% KIM 08.13


% IDENTIFY THE TARGET
targetdir = fullfile( top_dir, cruise_name, 'DATA', 'ACROBAT','PROCESSED'); 
if ~isdir( fullfile(targetdir, 'PLOTS'))
    mkdir( fullfile( top_dir, cruise_name, 'DATA', 'ACROBAT','PROCESSED'), 'PLOTS')
end


%LOAD THE DATA
load( fullfile( targetdir, 'gridded.mat')); 
load( fullfile( targetdir, [cruise_name,'Legs.mat'])); 
targetdir = fullfile( top_dir, cruise_name, 'DATA', 'ACROBAT','PROCESSED', 'PLOTS'); 

% set up the plot
scrsz = get(0,'ScreenSize');
figure(1); % 'position', scrsz); clf
set( 1, 'Position', scrsz);   
orient landscape;
% create six axes
a(6,1) = axes('position', [0.0600    0.0310    0.5500 0.1226]);
a(5,1) = axes('position', [0.0600    0.1935    0.5500 0.1226]);
a(4,1) = axes('position', [0.0600    0.3560    0.5500 0.1226]);
a(3,1) = axes('position', [0.0600    0.5184    0.5500 0.1226]);
a(2,1) = axes('position', [0.0600    0.6809    0.5500 0.1226]);
a(1,1) = axes('position', [0.0600    0.8434    0.5500 0.1226]);
a(7,1) = axes('position', [0.68      0.2988    0.2800 0.4804]);

% define the variables
vars = {'t', 's', 'dens', 'chl', 'particle', 'CDOM'};
lims = {[-2, 8], [25, 33], [21, 27]+1000, [0, 4], [0, 4]*10^5, [0, 5]};
titles = {'temperature', 'salinity', 'density', 'chlorophyll', 'particle concentration', 'CDOM'};
units = {'[\circ C]', '', '[kg m^{-3}]', '[\mug/l]', '[(m sr)^{-1}]', '[ppb]'};
cticks = {[0:4:8], [25:4:33], [21:2:27], [0:2:4], [0:2:4]*10^5, [0:2:5]};

prange = [0, 60]; 
pint = 0:0.5:60; 

% Now to cycle through the legs and make a contour plot
for ll = 17:length(leg)
% for ll = 1:length( leg )
% for ll = 1:1

    %     clf;
    filestr = [cruise_name, 'Leg',  leg(ll).name];

%     % make the subplots
%     for ss = fliplr(1:6)
%         sb(ss) = subplot( 6, 1, ss );
%         scoot_axes( [-0.07, (6-ss)*0.02-0.08, -0.2, 0.02], sb(ss))
%     end
    
    % start plotting
    for ss = 1:6
%         axes(sb(ss))
        axes(a(ss,1))
        cla;
        set(gca,'Ylim',[0 100],'ytick',[0 50 100]);
        % find the profiles in that leg
        ii = find( gridded.mtime >= leg(ll).tlim(1) & gridded.mtime <=leg(ll).tlim(2)); 
        % pcolor the data
        pcolor( (gridded.dist(ii) - gridded.dist(ii(1)))./1000, gridded.p, real(gridded.(vars{ss})(:,ii)))
        shading flat; hold on
         
%         % make the density contours
%         [c, d] = contour( interpnans(gridded.dist(dd))./1000, gridded.p, sgthin , 20:33, '-', 'linewidth', 2, 'color', [1, 1, 1]*0);
%         clabel( c, d, 'fontsize', 16, 'fontweight', 'bold')
%         % plot bottom
%         k1 = karea( gridded.dist./1000,gridded.bottom, 'basevalue', 100, 'facecolor', [1, 1, 1]*0.5, 'edgecolor', [1, 1, 1]*0.1);
         
        % adjust the axes limits
        axis tight;  axis ij; caxis( lims{ss})
%         xlim( [0, gridded.dist(find( ~isnan(nanmean(gridded.t)), 1, 'last'))./1000])
        ylim( [0, 100]);
%         % label the axes
%         titleout( titles{ss}, sb(ss), 'fontsize', 18, 'fontweight', 'bold')
        titleout( titles{ss}, a(ss,1), 'fontsize', 17, 'fontweight', 'bold')

%         set( sb(ss), 'fontsize', 18)
          set( a(ss,1), 'fontsize', 17)
        % make the colorbar
        cb = colorbar; set( cb, 'fontsize', 18, 'fontweight', 'normal', 'ytick', cticks{ss})
%         scoot_axes( [0.01, +0.01, -0.005, -0.02], cb)
        ylabel( cb, units{ss}, 'fontsize', 18)
        % adjust the axes
%         scoot_axes( [0, 0, -0.025, 0])  
        % turn tick labels on or off
        if ss~=6
%             set( sb(ss), 'xticklabel', [], 'yticklabel', [])
            set( a(ss,1), 'xticklabel', [], 'yticklabel', [])
        else
            xlabel( 'distance [km]')
            ylh = ylabel( '[db]');
            tmpp = get(ylh,'position');
            set(ylh,'position',[tmpp(1,1)+1.5 tmpp(1,2) tmpp(1,3)]);    
            set(gca,'yticklabel',{'0';'';'100'});
        end
                
    end
    
    %  make a map with the legs
    Site1 = [-(163+(3.186/60)) 69+45.481/60]; %pt lay
    Site2 = [-(160+(2+7.81/60)/60) 70+(38+20.48/60)/60]; %wainwright
    Site3 = [-(156+(39+59.38/60)/60) 71+(19+50.60/60)/60]; %barrow
    
    % open the map and define the projection
%     load chuk_bath.mat
    load AlaskaXYZ.mat
    proj = 'lambert';
    lonrng = [-170 -156];
%     latrng = [70.4 72.25];
    latrng = [69 73];

%     % make the plot
%     s3 = subplot( 2, 3, 3);
%     scoot_axes( [0.01, 0, 0, 0], s3)
        
%     orient portrait;
    orient landscape;
    axes(a(7,1));
    m_proj(proj,'lat',latrng,'lon',lonrng);
%     m_usercoast('Chukchi_coast_moorf.mat','patch',[.7 .7 .7]);
%     m_usercoast('Chukchi_coastfb.mat','patch',[.7 .7 .7]);
    m_gshhs_f('patch',[0.7 0.7 0.7]);
    m_grid('xtick', 3,'ytick', 3, 'fontsize', 16)
    hold on
%     [cs,h] = m_contour(blon,blat,zz,[-20 -30 -40  -50 -60  -100  -150 -200 -300 -500 -1000 -2000 -3000],'color',[.6 .6 .6]);
    XE = XE - 360;
    [cs,h] = m_contour(XE,YE,ZE,[-20 -30 -40  -50 -60  -100  -150 -200 -300 -500 -1000 -2000 -3000],'color',[.6 .6 .6]);
    clabel(cs,h,'fontsize',6,'label',350,'color',[.6 .6 .6]);
    set(h,'linewidth',.7)
%     
%     h1 = m_plot( gridded.lon, gridded.lat, '-', 'color', 'r', 'linewidth', 3); hold on
%     h2 = m_plot( gridded.lon(1), gridded.lat(1), 'o', 'color', 'r', 'markersize', 10, 'linewidth', 2, 'markerfacecolor', 'r')
    
    h1 = m_plot( gridded.lon(ii), gridded.lat(ii), '-', 'color', 'r', 'linewidth', 3); hold on
%     h2 = m_plot( gridded.lon(1), gridded.lat(1), 'o', 'color', 'r', 'markersize', 10, 'linewidth', 2, 'markerfacecolor', 'r')


    h3 = m_plot(Site2(1),Site2(2),'marker','square','markersize',7,'color','k','markerfacecolor','g','linestyle','none');
    h4 = m_text(Site2(1)-0.1,Site2(2),'WAINWRIGHT','fontsize',14,'fontweight','bold','fontname','verdana', 'horizontalalignment', 'right');
    h5 = m_plot(Site3(1),Site3(2),'marker','square','markersize',7,'color','k','markerfacecolor','g','linestyle','none');
    h6 = m_text(Site3(1)-0.1,Site3(2),'BARROW','fontsize',14,'fontweight','bold','fontname','verdana', 'horizontalalignment', 'right');
    
    m_ruler([0.2 0.8], .9);
    
    h8 = title( [cruise_name, ' Leg ', leg(ll).name ], 'fontsize', 18, 'fontweight', 'bold');
%     tmph8 = get(h8,'position');
    set(h8,'position',[ -0.00001    0.059    5.5197]);

    
    flags = '-r300 -painters';
    filename = [cruise_name, 'Leg', leg(ll).name ];
    WriteEPS(filename, targetdir, flags)
    
%     WritePDF(filename,targetdir,flags);
    clear h1 h2 h3 h4 h5 h6 h7 h8;
    for ss=1:7
        axes(a(ss,1));
        cla;
    end
end % ll