function [D2,IndicesRemoved] = hand_cleanup(D)
% function hand_cleanup
% Clean up time series data matrix by walking through each column
% and inspecting for spikes, stuck sensors or other problems.
% Data matrix D should have a Julian Date vector in column 1.
% Data seleted for removal is replaces with NaN.
%
% Example:
% ym

P = D;  % working matrix will be called P 
zf = 5; % zoom factor for selections 1 and 2
bad =[];
badkeep = [];
badkeptfor_each_variable={};

[m,n] = size(P);

getinput = 1;
for in = 2:n  % remove remaining bad data points by hand editing. julian date must be in column 1
  xmin = min(P(:,1));
  xmax = max(P(:,1));
  p1 = 1;
  p2 = length(P);
  clf; set(gcf,'position',[5 500 1270 450]) % position of figure on screen. Adjust for your screen as needed.
  plot(P(p1:p2,1),P(p1:p2,in),'b-')
  set(gca,'xlim',[xmin xmax]);
  gregaxy(P(1:100:end,1),5);
  done = 0;
  while ~done,
      disp(['(1) Zoom In']);
      disp(['(2) Zoom Out']);
      disp(['(3) Move Left']);
      disp(['(4) Move Right']);
      disp(['(5) Kill Point']);
      disp(['(6) Kill Range of Points']);
      disp(['(7) Make High Kill Threshold']);
      disp(['(8) Make Low Kill Threshold']);
      disp(['(9) Next Column']);
      disp(['(0) Set Zoom Factor']);
      disp(['(11) Kill points in polygon']);
    s1 = input('Enter choice: ');
    xrange = xmax-xmin;
    if s1 == 1,     % zoom in
        disp(['Click on zoom endpoints '])
        ep = ginput(2);
        xmin = min([ep(1,1) ep(2,1)]);
        xmax = max([ep(1,1) ep(2,1)]);
     elseif s1 == 2, % zoom out
        xmid = (xmax+xmin)/2;
        xmin = xmid - xrange*zf;
        xmax = xmid + xrange*zf;
    elseif s1 == 3, % move left
        xmin = xmin - xrange*3/4;
        xmax = xmax - xrange*3/4;
    elseif s1 == 4, % move right
        xmin = xmin + xrange*3/4;
        xmax = xmax + xrange*3/4;
    elseif s1 == 5, % kill point
        s2 = ginput(1);
        p1 = min(find(abs(P(:,1)-s2(1,1)) == min(abs(P(:,1)-s2(1,1)))));
        bad = [bad; p1];
    elseif s1 == 6, % kill points
        s2 = ginput(2);
        s2 = sortrows(s2,1);
        p1 = min(find(abs(P(:,1)-s2(1,1)) == min(abs(P(:,1)-s2(1,1)))));
        p2 = max(find(abs(P(:,1)-s2(2,1)) == min(abs(P(:,1)-s2(2,1)))));
        bad = [bad; [p1:p2]'];
    elseif s1 == 7, % make high kill threshold
        s2 = ginput(1);
        p1 = min(find(abs(P(:,1)-xmin) == min(abs(P(:,1)-xmin))));
        p2 = max(find(abs(P(:,1)-xmax) == min(abs(P(:,1)-xmax))));
        wbad = find(P(p1:p2,in) > s2(2));  
        bad = [bad; [p1+wbad-1]];
    elseif s1 == 8, % make low kill threshold
        s2 = ginput(1);
        p1 = min(find(abs(P(:,1)-xmin) == min(abs(P(:,1)-xmin))));
        p2 = max(find(abs(P(:,1)-xmax) == min(abs(P(:,1)-xmax))));
        wbad = find(P(p1:p2,in) < s2(2));  
        bad = [bad; [p1+wbad-1]];
    elseif s1 == 11 %draw a polygon and kill everything in it.

          clf;
        p1 = min(find(abs(P(:,1)-xmin) == min(abs(P(:,1)-xmin))));
        p2 = max(find(abs(P(:,1)-xmax) == min(abs(P(:,1)-xmax))));
          plot(P(p1:p2,1),P(p1:p2,in),'b-')
          set(gca,'xlim',[xmin xmax]);
          gregaxy(P(1:100:end,1),5);

        p1 = min(find(abs(P(:,1)-xmin) == min(abs(P(:,1)-xmin))));
        p2 = max(find(abs(P(:,1)-xmax) == min(abs(P(:,1)-xmax))));
            if ~isempty(bad)

                
                tempgood=sort(goodones);
       
                good_in_current_frame=tempgood>=p1 & tempgood<=p2;

                clf; plot(P(tempgood(good_in_current_frame),1),P(tempgood(good_in_current_frame),in),'b-'); hold on
                set(gca,'xlim',[xmin xmax]);
                tempbad=sort(bad);     
            
                bad_in_current_frame=tempbad>=p1 & tempbad<=p2;

                plot(P(tempbad(bad_in_current_frame),1),P(tempbad(bad_in_current_frame),in),'r*');
            end


        s2 = drawpolygon('LineWidth',.5,'Color','cyan');
        
        myshape=s2.Position;
     
        myshapex=myshape(:,1);
        myshapey=myshape(:,2);

        h = findobj(gca,'Type','line');

        allx_in_view=get(h,'Xdata') ;
        ally_in_view=get(h,'Ydata') ;


if iscell(allx_in_view)==1

        allx_in_view=[allx_in_view{:}];
        tempfully=[ally_in_view{:}];
        ally_in_view=[NaN(1,length(ally_in_view{1})),ally_in_view{2}];
end

[allx_in_view,sortind]=sort(allx_in_view);
ally_in_view=ally_in_view(sortind);
if length(h)==2
    tempfully=tempfully(sortind);
end

%         p1 = min(find(P(:,1) == allx_in_view(1)));
%         p2 = max(find(P(:,1) == allx_in_view(end)));
        
        temp=p1:p2;
        tempindex=1:length(temp);

        somex=allx_in_view(1:length(temp));
        somey=ally_in_view(1:length(temp));
        if length(h)==2
        somey=tempfully(1:length(temp));
        end

        bad_xy=inpolygon(somex,somey,myshapex,myshapey);
        wasnotbad=~isnan(ally_in_view);
        bad_xy=bad_xy(wasnotbad);
        tempindex=tempindex(wasnotbad);


        wbad = tempindex(bad_xy); %this can contain repeated values, if our shape included previous bad.

        bad = [bad; [p1+wbad-1]'];
        bad=unique(bad); %this gets rid of those repeat indices for this variable.
        clearvars somex somey allx_in_view ally_in_view h
    elseif s1 == 9, % next column
        P(badkeep,in) = NaN;
        bad = [];
        badkeptfor_each_variable{in}=badkeep; %consecutive columns from 2 onward, so each variable is distinguished
        badkeptfor_each_variable{1}=[badkeptfor_each_variable{1};badkeep];

        badkeep = [];
        done = 1;
    elseif s1 == 0, % set zoom factor
        zf = input('Enter Zoom Factor = ? ');
    end
    xrange = xmax - xmin;
    p1 = find(abs(P(:,1)-xmin) == min(abs(P(:,1)-xmin)));
    p2 = find(abs(P(:,1)-xmax) == min(abs(P(:,1)-xmax)));
        
        goodones = setxor(p1:p2, bad);
        clf; plot(P(goodones,1),P(goodones,in),'b-'); hold on
        set(gca,'xlim',[xmin xmax]);
        
        if xrange < 2,        gregaxh(P([min([p1 p2]):max([p1 p2])],1),1);
        elseif xrange < 40,   gregaxd(P([min([p1 p2]):10:max([p1 p2])],1),1);
        elseif xrange < 400,  gregaxm(P([min([p1 p2]):100:max([p1 p2])],1),1);
        elseif xrange < 4000, gregaxy(P([min([p1 p2]):200:max([p1 p2])],1),1);
        else                  gregaxy(P([min([p1 p2]):1000:max([p1 p2])],1),5);
        end
        
        if ~isempty(bad),
            plot(P(bad,1),P(bad,in),'r*');
        end
        
        if length(bad) ~= length(badkeep),
          s3 = input('keep changes (1/0)? ');
          if s3,
            badkeep = bad;
          else
            bad = badkeep;
          end
        end
  end
end

s4 = input('Keep changes to matrix P?? ');
if s4,
    D2 = P;
    badkeptfor_each_variable{1}=unique(badkeptfor_each_variable{1});
    IndicesRemoved=badkeptfor_each_variable;
    disp('All changes kept');
else
    disp('No changes kept');
    D2 = D;
    IndicesRemoved={};
end
