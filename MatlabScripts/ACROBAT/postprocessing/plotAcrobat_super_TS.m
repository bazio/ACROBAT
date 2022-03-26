function plotAcrobat_super_TS(top_dir, cruise_name)

% plotAcrobat_super_TS(top_dir, cruise_name)
%
%
%
% HS 03.15


% IDENTIFY THE TARGET
targetdir = fullfile( top_dir, cruise_name, 'DATA', 'ACROBAT','PROCESSED');
if ~isdir( fullfile(targetdir, 'TC_CORRECTED_PLOTS'))
    mkdir( fullfile( top_dir, cruise_name, 'DATA', 'ACROBAT','PROCESSED'), 'TC_CORRECTED_PLOTS')
end


%LOAD THE DATA
load( fullfile( targetdir, 'gridded.mat'));
load( fullfile( targetdir, [cruise_name,'Legs.mat']));
targetdir = 'C:\Users\stats\Documents\Acrobat\Figures';


legs = ['A'; 'E'; 'F'; 'P'; 'Q'; 'R'; 'S'; 'U'; 'V'; 'W'; 'Y'; 'Z'];
% Now to cycle through the legs and buile the super-matrix
for ll = 1:length(leg)
    if (~isempty(strmatch(leg(ll).name,legs))),
        cols = find( gridded.mtime >= leg(ll).tlim(1) &  gridded.mtime <=leg(ll).tlim(2));
        if (ll==1),
            temp = gridded.t(:,cols);
            sal = gridded.s(:,cols);
        else
            temp = [temp gridded.t(:,cols)];
            sal = [sal gridded.s(:,cols)];
        end
    end
end
% set up the plot
scrsz = get(0,'ScreenSize');
figure(1); % 'position', scrsz);
clf
set( 1, 'Position', scrsz);
orient portrait;
% define the variables
vars = {'t', 's', 'dens', 'chl', 'particle', 'CDOM'};
lims = {[-2, 10], [25, 34], [20, 27]+1000, [0, 5], [0, 5]*10^5, [0, 5]};
titles = {'temperature', 'salinity', 'density', 'chlorophyll', 'particle concentration', 'CDOM'};
units = {'[\circ C]', '', '[kg m^{-3}]', '[\mug/l]', '[(m sr)^{-1}]', '[ppb]'};
cticks = {[-2:2:10], [25:4:34], [20:2:27], [0:2:4], [0:2:4]*10^5, [0:2:4]};

prange = [0, 60];

[M,N] = size(temp);
ptmp = sw_ptmp(sal,temp,gridded.p,1);
tt = reshape(ptmp, M.*N,1);
ss = reshape(sal, M.*N,1);

Sg = lims{2}(1)+[0:30]/30*(lims{2}(2)-lims{2}(1));
Tg = lims{1}(1)+[0:30]/30*(lims{1}(2)-lims{1}(1));
SG = sw_dens(Sg,Tg,30)-1000;
[X,Y] = meshgrid(Sg,Tg);
dens = sw_dens(X,Y,1)-1000;
[CS,H]=contour(X,Y,dens,'color','k','linewidth',.5,'linestyle','-');
clabel(CS,H); %,sigma(1:2:end));
axis('square');
freezeT=swfreezetemp([lims{2}(1) lims{2}(2)],1);
line([lims{2}(1) lims{2}(2)],freezeT,'LineStyle','--','linewidth',1.5);
hold on;
plot(ss, tt,'k.')
xlabel('Salinity','fontsize',12,'fontname','Times');
ylabel('Pot. Temperature ({\circ}C)','fontsize',12,'fontname','Times');
grid on
set(gca,'xlim',[lims{2}(1) lims{2}(2)],'ylim',[lims{1}(1) lims{1}(2)],'fontsize',10,'fontname','Times')
% Gong and Pickart Defined Limits
%ACW
plot([30 lims{2}(2)],[3 3],'b','linewidth',1.5); %horiz. line
plot([30 30],[-1 lims{1}(2)],'b','linewidth',1.5); %vert. line
%CSW
plot([lims{2}(1) lims{2}(2)],[-1 -1],'b','linewidth',1.5); %horiz. line
%plot([33.6 33.6],[-1 3],'k','linewidth',1.5); %vert. line
plot([32.8 32.8],[-1 3],'b','linewidth',1.5); %vert. line
%MW
plot([31.5 31.5],[-2 -1],'b','linewidth',1.5); %horiz. line
%PWW
plot([31.5 lims{2}(2)],[-1.6 -1.6],'b','linewidth',1.5); %horiz. line

print('-dpng','-r300',[targetdir '/Chukchi_ACROBAT_TS_GP.png']);

clf
[CS,H]=contour(X,Y,dens,'color','k','linewidth',.5,'linestyle','-');
clabel(CS,H); %,sigma(1:2:end));
axis('square');
freezeT=swfreezetemp([lims{2}(1) lims{2}(2)],1);
line([lims{2}(1) lims{2}(2)],freezeT,'LineStyle','--','linewidth',1.5);
hold on;
plot(ss, tt,'k.')
xlabel('Salinity','fontsize',12,'fontname','Times');
ylabel('Pot. Temperature ({\circ}C)','fontsize',12,'fontname','Times');
grid on
set(gca,'xlim',[lims{2}(1) lims{2}(2)],'ylim',[lims{1}(1) lims{1}(2)],'fontsize',10,'fontname','Times')
%ACW
plot([27 32],[5 5],'b','linewidth',1.5); %horiz. line (maybe chamge to 27)
plot([32 32],[5 lims{1}(2)],'b','linewidth',1.5); %vert. line
%BSAW
plot([31 31],[0 5],'b','linewidth',1.5); %horiz. line
plot([33 33],[0 5],'b','linewidth',1.5); %vert. line
plot([31 33],[5 5],'b','linewidth',1.5); %vert. line
plot([31 33],[0 0],'b','linewidth',1.5); %vert. line
%MW
plot([27 30],[2.5 2.5],'b','linewidth',1.5); %horiz. line (maybe chamge to 27)
plot([30 30],[-2 2.5],'b','linewidth',1.5); %vert. line
%SCW
plot([20 27],[0 0],'b','linewidth',1.5); %horiz. line
plot([27 27],[0 5],'b','linewidth',1.5); %vert. line
%WW
plot([31 33],[0 0],'b','linewidth',1.5); %horiz. line
plot([33 33],[-2 0],'b','linewidth',1.5); %vert. line
plot([31 31],[-2 0],'b','linewidth',1.5); %vert. line
%MW/SCW
plot([26 29],[2.5 2.5],'b','linewidth',1.5); %horiz. line
plot([26 29],[6 6],'b','linewidth',1.5); %horiz. line
plot([29 29],[2.5 6],'b','linewidth',1.5); %vert. line
%ACW/BSAW
plot([29 32.5],[2.5 2.5],'b','linewidth',1.5); %horiz. line
plot([29 32.5],[10 10],'b','linewidth',1.5); %horiz. line
plot([29 29],[2.5 10],'b','linewidth',1.5); %vert. line
plot([32.5 32.5],[2.5 10],'b','linewidth',1.5); %vert. line
%    WriteEPS(filename, targetdir, flags)
%      WritePDF(filename,targetdir,flags);

%     for ss=1:7
%         axes(a(ss,1));
%         cla;
%     end
end % ll