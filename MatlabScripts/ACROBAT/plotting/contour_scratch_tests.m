targetdir = fullfile( top_dir, cruise_name, 'DATA', 'ACROBAT','PROCESSED');
load( fullfile( targetdir, 'gridded.mat'));
load( fullfile( targetdir, [cruise_name,'Legs.mat']));
load /Users/hstats/Documents/LTER/mapping/AlaskaXYZ.mat
XE = XE - 360;
%%
 for ll = 2 %:length(leg),
%     ll= 1;
    cols = find( gridded.mtime >= leg(ll).tlim(1) &  gridded.mtime <=leg(ll).tlim(2));
    
    % find the gridded distance
%     dist = sw_dist( gridded.lat, gridded.lon, 'km');
%     dist( end+1) = dist( end);
% %     dist( dist >1) = nan;
%     distleg = nancumsum(dist(cols),2,2); % distance in km
     
    distleg = nancumsum(gridded.dist(cols),2,2); % distance in km
    sgthin = gridded.dens(:, cols)-1000;
    p = gridded.p;
    [M,N] = size(sgthin);
    short_thresh = 3;
    
    
    depthgrid = interp2(YE, XE, -ZE , gridded.lat(cols), gridded.lon(cols));
    %% Run through the density field contour processing
    % weed out short profiles
    dds = find( sum( ~isnan( sgthin )) > short_thresh);
    sgthin2 = sgthin(:,dds );
    % fill in surface gaps less than 10 m
    for cc = 1:size( sgthin2, 2 )
        ii = find( ~isnan( sgthin2(:,cc)), 1, 'first');
        if ii < 10
            sgthin2(1:ii,cc) = sgthin2(ii,cc);
        end
    end
    % fill to the bottom on full profiles
    for cc = 2:size( sgthin2, 2 )-1
        ii = find( ~isnan( sgthin2(:,cc)), 1, 'last');
        i1 = find( ~isnan( sgthin2(:,cc-1)), 1, 'last');
        i2 = find( ~isnan( sgthin2(:,cc+1)), 1, 'last');
        if mean(abs( [ii-i1, ii-i2])) < 8
            sgthin2(ii:end,cc) = sgthin2(ii,cc);
        end
    end
    % interpolate the rest horizontally
    for cc = 1:size( sgthin2, 1 )
        if (length(find(~isnan(sgthin2(cc,:)))) >= 2)
            sgthin2(cc,:) = naninterp( sgthin2(cc,:));
        end
    end
    % smooth horizontally and cutoff anything greater than the depth
    for cc = 1:size( sgthin2, 2 )
        sgthin2(:,cc) = boxcarsmooth( sgthin2(:,cc), 5)';
        sgthin2( gridded.p > depthgrid(dds(cc)), cc) = nan;
    end
    
    v = naninterp(distleg(dds));
    badpt = find(diff(v) <= 0); % find where is not increasing or has repeated value
    % CAUTION -- altering data!
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

    %%
    figure(ll)
    clf
    subplot(221)
    for in = 1:N,
        if (in==1),
            plot(sgthin(:,in),p,'k');
            hold on
        else
            plot(sgthin(:,in)+in.*.25,p,'k')
        end
    end
    grid on
    axis ij
    ylabel('Pressure (db)')
    ylim( [0, 50])
    title(['Leg = ' num2str(ll) ' Density Waterfall'])
    
    
    subplot(222)
    [c, d] = contour(distleg,gridded.p,sgthin,20:.1:30, '-', 'linewidth', 1, 'color', [1, 1, 1]*0);
    hold on
    grid on
    xlabel('Distance (km)')
    clabel( c, d, 'fontweight', 'bold','fontsize',10,'fontname','Times')
    k1 = karea( distleg, depthgrid, 'basevalue', 100, 'facecolor', [1, 1, 1]*0.5, 'edgecolor', [1, 1, 1]*0.1);
    ylim( [0, 50])
    axis ij
    
    subplot(223)
    for in = 1:length(v),
        if (in==1),
            plot(sgthin2(:,in),p,'k');
            hold on
        else
            plot(sgthin2(:,in)+in.*.25,p,'k')
        end
    end
    grid on
    axis ij
    ylim( [0, 50])
    ylabel('Pressure (db)')
    title('Interpolated Density Waterfall')
    
    
    subplot(224)
    [c, d] = contour(v,gridded.p,sgthin2,20:.1:30, '-', 'linewidth', 1, 'color', [1, 1, 1]*0);
    hold on
    grid on
    xlabel('Distance (km)')
    title('Interpolated Density Contour')
    clabel( c, d, 'fontweight', 'bold','fontsize',10,'fontname','Times')
    k1 = karea( distleg, depthgrid, 'basevalue', 100, 'facecolor', [1, 1, 1]*0.5, 'edgecolor', [1, 1, 1]*0.1);
    ylim( [0, 50])
    axis ij
end