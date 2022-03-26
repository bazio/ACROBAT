function leg = GetAcrobatLegs( cruise_name )
% 
% Keep acrobat legs in one place so that can process consistently
%
%
switch cruise_name
  case 'Chukchi_2013_N2'
    % leg(1).ind = [1:13000]; leg(1).name = 'A'; 
    % leg(2).ind = [13000:21000]; leg(2).name = 'B'; 
    % leg(3).ind = [21000:34000]; leg(3).name = 'C'; 
    % ETC.
    leg(1).ind = [2700:13354]; leg(1).name = 'A'; 
    leg(2).ind = [15000:25000]; leg(2).name = 'B'; 
    leg(3).ind = [26000:36050]; leg(3).name = 'C'; 
    leg(4).ind = [37000:71100]; leg(4).name = 'D'; 
    leg(5).ind = [71200:76700]; leg(5).name = 'E'; 
    leg(6).ind = [76800:82500]; leg(6).name = 'F'; 
    leg(7).ind = [82600:91500]; leg(7).name = 'G'; 
    leg(8).ind = [91600:133500]; leg(8).name = 'H'; 
    leg(9).ind = [135500:145500]; leg(9).name = 'I'; 
    leg(10).ind = [146000:158000]; leg(10).name = 'J'; 
    leg(11).ind = [159500:170000]; leg(11).name = 'K'; 
    leg(12).ind = [171000:178000]; leg(12).name = 'L'; 
    leg(13).ind = [179000:196000]; leg(13).name = 'M'; 
    leg(14).ind = [197000:210000]; leg(14).name = 'N'; 
    leg(15).ind = [212000:219000]; leg(15).name = 'O'; 
    leg(16).ind = [220000:228000]; leg(16).name = 'P'; 
    leg(17).ind = [229999:260000]; leg(17).name = 'Q'; 
    leg(18).ind = [262000:276000]; leg(18).name = 'R'; 
    % leg(19).ind = [:]; leg(16).name = 'S'; 
    
  case 'Chukchi_2012_N2'
      disp('Legs not yet defined')
    
  case 'Chukchi_2014_N2'
      disp('Legs not yet defined')
end

return 