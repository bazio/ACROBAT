function plotTransectShipTrack(acrobat,lims)

% plotRealTimeShipTrack(acrobat)
%
% Make 
%
% KIM 07.13
% HS 01.16

ens = find(acrobat.mtime >= lims.plot(1) & acrobat.mtime < lims.plot(2));
m_plot( acrobat.lon(ens), acrobat.lat(ens), 'rs-', 'markerfacecolor', 'b', 'markersize', 2 )