function [t_range, con_range] = SBE49DefaultRange

% function [t_range, con_range] = SBE49DefaultRange
%
% Load the default temperature and conductivity measurements for the
% SeaBird 49 FastCAT as indicated by the manufacturer.
%
% t_range = [-5, 35];  % [degrees C]
% con_range = [0, 9]; % [S/m]
%
% Obtained from http://www.seabird.com/products/spec_sheets/49data.htm
%
% KIM 08.12

t_range = [-5, 35];  % [degrees C]
con_range = [0, 9]; % [S/m]