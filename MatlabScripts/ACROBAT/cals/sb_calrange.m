function [t, tout,con, conout]=sb_calrange(t,con,t_range,con_range);

% [t, tout,con, conout]=sb_calrange(t,con);
% 
% Removes Temperature and Conductivity ranges that are outside the
% calibration ranges for each instrument. 
%
% SEABIRD RANGES taken from SBE 9plus manual
% t_range=[-1.4 , 32.5];
% con_range=[2.6, 6];
%
% INPUT:
% t:  Temperature vector [degrees C]
% con:  Conductivity vector [S/m]
%
% OUTPUT:
% t and con vectors with outliers removed and replaced with NaNs
% tout and tcon are the outlier indices.
%
% Created KIM 05/06

% DEFINE ACCEPTABLE T AND CON VALUE RANGES
if nargin<3
 t_range=[-1.4 , 32.5];
 con_range=[2.6, 6];
end

 % FIND THE OUTLIERS
 tout=find(t<t_range(1) | t>t_range(2));
 conout=find(con<con_range(1) | con>con_range(2));
 
 % REPLACE WITH NAN's
 t(tout)=NaN;
 con(conout)=NaN;
 
 % DISPLAY THE PERCENT OUT OF CALIBRATION RANGE
 disp('Percent of points out of calibration range:')
 disp(['temp = ',num2str(length(tout)./length(t)*100), '% ;  con = ', num2str(length(conout)./length(con)*100), '%'])