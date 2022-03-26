function [lat, lon, z] = loadGEBCOBathymetry(top_dir, lims)

% function [lat, lon, z] = loadGEBCOBathymetry(top_dir, lims)
% 
% Load the GEBCO bathymetry file, converting it to a lat vector, a lon vector and a depth
% matrix. You can point it to any matrix you like!
%
% KIM 07.13

% define the lat and lon vectors
lonrange = [-180, 180];
latrange =    [-80 90];
dh = 1./120; 
lon = (lonrange(1):dh:lonrange(2)-dh).';
lat = fliplr(latrange(1):dh:latrange(2)-dh).';

% find the indices to subset the global data
loni = find( lon>=lims.lon(1) & lon<=lims.lon(2)); 
lati = find( lat >= lims.lat(1) & lat<=lims.lat(2)); 

% define the bathymetry target
filename = 'gebco_Global.grd';
target = fullfile( top_dir, 'MatlabScripts', 'ACROBAT', 'bathymetry',filename); 

% open the file
ncid = netcdf.open(target, 'NC_NOWRITE'); 
% pull the subset data
lon = netcdf.getVar(ncid, 0, loni(1)-1, length(loni)); 
lat = netcdf.getVar(ncid, 1, lati(1)-1, length(lati));
z = netcdf.getVar(ncid, 2, [loni(1), lati(1)]-1, [length(loni), length(lati)]);
% close the file
netcdf.close(ncid)

% adjust data a bit
% change the depth format from int16 to double and flip longitude
z = flipud(double(z)).'; 
lon = flipud(lon);

