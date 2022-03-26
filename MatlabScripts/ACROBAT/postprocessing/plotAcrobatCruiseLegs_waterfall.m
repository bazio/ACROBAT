function plotAcrobatCruiseLegs4(top_dir, cruise_name)

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

load AlaskaXYZ.mat
XE = XE - 360;

% set up the plot

figure; % 'position', scrsz); clf
%set( 1, 'Position', scrsz);
clf

% create three axes
% a(3,1) = axes('position', [0.0600    0.5184    0.5500 0.1226]);
% a(2,1) = axes('position', [0.0600    0.6809    0.5500 0.1226]);
% a(1,1) = axes('position', [0.0600    0.8434    0.5500 0.1226]);


% define the variables
vars = {'t', 's', 'dens', 'chl', 'particle', 'CDOM'};
lims = {[-2, 8], [25, 33], [21, 27]+1000, [0, 4], [0, 4]*10^5, [0, 5]};
titles = {'temperature', 'salinity', 'density', 'chlorophyll', 'particle concentration', 'CDOM'};
units = {'[\circ C]', '', '[kg m^{-3}]', '[\mug/l]', '[(m sr)^{-1}]', '[ppb]'};
cticks = {[0:4:8], [25:4:33], [21:2:27], [0:2:4], [0:2:4]*10^5, [0:2:5]};

prange = [0, 60]; 
pint = 0:0.5:60; 

% Now to cycle through the legs and make a contour plot
% for ll = 1:length(leg)
% % for ll = 1:length( leg )
for ll = 3,
    
    clf;

    filestr = [cruise_name, 'Leg',  leg(ll).name];
    cols = find( gridded.mtime >=leg(ll).tlim(1) &  gridded.mtime <=leg(ll).tlim(2));
    % find the gridded distance
    distleg = nancumsum(gridded.dist(cols),2); % distance in km
    depthgrid = interp2(YE,XE,-ZE,gridded.lat(cols),gridded.lon(cols));
    
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
        subplot(3,1,ss)
        cla;

        % fill in the gaps
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
            datin(cc,:) = naninterp( datin(cc,:));
        end
        % smooth horizontally and cutoff anything greater than the depth
        for cc = 1:length(dd)
            datin(:,cc) = boxcarsmooth( datin(:,cc), 5)';
            datin( gridded.p > depthgrid(dd(cc)),cc) = nan;
            
        end
        
        % contourf the data
        contourf( naninterp(distleg(dd)), gridded.p, datin, linspace( lims{ss}(1), lims{ss}(2), 31), 'linecolor', 'none');
        hold on
        % make the density contours
        [c, d] = contour( naninterp(distleg(dds)), gridded.p, sgthin , 20:2:30, '-', 'linewidth', 1, 'color', [1, 1, 1]*0);
        clabel( c, d, 'fontsize', 16, 'fontweight', 'bold')

        % plot bottom
        k1 = karea( distleg, depthgrid, 'basevalue', 100, 'facecolor', [1, 1, 1]*0.5, 'edgecolor', [1, 1, 1]*0.1);
        plot(distleg(190),1,'k^','marker','^','markerfacecolor','y','markersize',5) 
        % adjust the axes limits
        axis tight;  axis ij; caxis( lims{ss})
        ylim( [0, max(gridded.p)])
%         % label the axes
        h = gca;
        titleout( titles{ss}, h, 'fontsize', 14, 'fontweight', 'bold')
          set( h, 'fontsize', 17)
        % make the colorbar
        cb = colorbar; set( cb, 'fontsize', 18, 'fontweight', 'normal', 'ytick', cticks{ss})
%         scoot_axes( [0.01, +0.01, -0.005, -0.02], cb)
        ylabel( cb, units{ss}, 'fontsize', 18)
        % adjust the axes
        scoot_axes( [0, 0, -0.025, 0])
        if ss==1,
            h8 = title( {[cruise_name];...
        [ ' Leg ', leg(ll).name ]}, 'fontsize', 18, 'fontweight', 'bold');
        end
        % turn tick labels on or off
        if ss~=3
            set( h, 'xticklabel', [])
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
    
    
    flags = '-r300 -painters';
    filename = [cruise_name, 'Leg', leg(ll).name 'T_S_Sigth_ens101' ];
     print('-dpng','-r150',[targetdir filename]);
  
    clear h1 h2 h3 h4 h5 h6 h7 h8;
    clf
end % ll