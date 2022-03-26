function plotRealTimeAKBathy(lat, lon, z, lims)

% function plotRealTimeAKBathy(lat, lon, z, lims)
% 
% Plot the Alaskan Bathymetry
%
%

figure(3);

%  subset the bathymetry data for faster plotting
lati = find( lat >= lims.lat(1) & lat <= lims.lat(2)); 
loni = find( lon >= lims.lon(1) & lon <= lims.lon(2)); 

% define the projection
proj = 'lambert';
m_proj(proj,'lat',lims.lat,'lon',lims.lon);
m_grid
hold on        
[cs,h] = m_contour(lon(loni),lat(lati),z(lati, loni),[-20 -30 -40  -50 -60  -100  -150 -200 -300 -500 -1000 -2000 -3000],'color',[.6 .6 .6]);
clabel(cs,h,'fontsize',6,'label',350,'color',[.6 .6 .6]);

m_contourf(lon(loni),lat(lati),z(lati, loni),[0, 0],'color',[1, 1, 1]*0, 'linewidth', 1);
colormap(gray)
caxis( [-5, 1])

% plot the HF Radar sites
Site1 = [-(163+(3.186/60)) 69+45.481/60]; %pt lay
Site2 = [-(160+(2+7.81/60)/60) 70+(38+20.48/60)/60]; %wainwright
Site3 = [-(156+(39+59.38/60)/60) 71+(19+50.60/60)/60]; %barrow

m_plot(Site1(1),Site1(2),'marker','square','markersize',5,'color','k','markerfacecolor','g','linestyle','none');
m_text(Site1(1)+0.05,Site1(2),'PT. LAY','fontsize',7,'fontweight','bold','fontname','verdana', 'color', 'k');
m_plot(Site2(1),Site2(2),'marker','square','markersize',5,'color','k','markerfacecolor','g','linestyle','none');
m_text(Site2(1)+0.05,Site2(2),'WAINWRIGHT','fontsize',7,'fontweight','bold','fontname','verdana', 'color', 'k');
m_plot(Site3(1),Site3(2),'marker','square','markersize',5,'color','k','markerfacecolor','g','linestyle','none');
m_text(Site3(1)+0.05,Site3(2),'BARROW','fontsize',7,'fontweight','bold','fontname','verdana', 'color', 'k');

% set the userdata to the limits 
set(3, 'UserData', [lims.lat; lims.lon]); 