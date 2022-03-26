%%  ACROBAT Waterfall Plot Worksheet
% -------------------------------------------------------------------------
% use this worksheet to run the process the data from a cruise
clear all; close all; clc;

%% STEP 1: DEFINE THE DATA DIRECTORY
% -------------------------------------------------------------------------
% the top directory where all cruise data is saved
top_dir = 'C:\Users\stats\Documents\Chukchi\2013\CRUISE_DATA\Chukchi_2013_N2';
mat_dir = 'C:\Users\stats\Documents\Acrobat\TEST';
cruise_name = 'ChukchiGliderCruise2013';
addAcrobatPaths(mat_dir);

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

%LOAD THE DATA
targetdir = fullfile( top_dir, cruise_name, 'DATA', 'ACROBAT','PROCESSED'); 
load( fullfile( targetdir, 'gridded.mat')); 
load( fullfile( targetdir, [cruise_name,'Legs.mat'])); 
targetdir = fullfile( top_dir, cruise_name, 'DATA', 'ACROBAT','PROCESSED', 'TC_CORRECTED_PLOTS'); 


ll = 3;
offset = 1.5;
cols = find( gridded.mtime >=leg(ll).tlim(1) &  gridded.mtime <=leg(ll).tlim(2));
ens = 190;
figure;
%%
clf
subplot(131)
plot(gridded.t(:,cols(ens)),gridded.p,'k.','linestyle','-')
hold on
plot(gridded.t(:,cols(ens+1)),gridded.p,'b.','linestyle','-')
for in = 2:15
    if (~iseven(in)),
        plot(gridded.t(:,cols(ens+in))+(in-1).*offset,gridded.p,'k.','linestyle','-')
    else
        plot(gridded.t(:,cols(ens+in))+in.*offset,gridded.p,'b.','linestyle','-')
    end
end
grid on
set(gca,'ydir','reverse')
xlabel('Temperature \circC')
ylabel('dB')
%legend('upcast','downcast')
ylim([0 40])


subplot(132)
plot(gridded.s(:,cols(ens)),gridded.p,'k.','linestyle','-')
hold on
plot(gridded.s(:,cols(ens+1)),gridded.p,'b.','linestyle','-')
for in = 2:15
    if (~iseven(in)),
        plot(gridded.s(:,cols(ens+in))+(in-1).*offset,gridded.p,'k.','linestyle','-')
    else
        plot(gridded.s(:,cols(ens+in))+in.*offset,gridded.p,'b.','linestyle','-')
    end
end
grid on
set(gca,'ydir','reverse')
xlabel('Salinity')
ylabel('dB')
%legend('upcast','downcast')
ylim([0 40])
title( {[cruise_name];...
        [ ' Leg ', leg(ll).name ' Ensembles: ' num2str(ens) '-' num2str(ens+15)]}, 'fontsize', 18, 'fontweight', 'bold');
subplot(133)
plot(gridded.dens(:,cols(ens)),gridded.p,'k.','linestyle','-')
hold on
plot(gridded.dens(:,cols(ens+1)),gridded.p,'b.','linestyle','-')
for in = 2:15
    if (~iseven(in)),
        plot(gridded.dens(:,cols(ens+in))+(in-1).*offset,gridded.p,'k.','linestyle','-')
    else
        plot(gridded.dens(:,cols(ens+in))+in.*offset,gridded.p,'b.','linestyle','-')
    end
end
grid on
set(gca,'ydir','reverse')
xlabel('Density')
ylabel('dB')
%legend('upcast','downcast')
ylim([0 40])
filename = [cruise_name, 'Leg', leg(ll).name 'waterfall_' num2str(ens) ];
print('-dpng','-r150',[targetdir '\' filename]);
