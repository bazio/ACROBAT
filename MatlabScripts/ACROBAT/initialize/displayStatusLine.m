function displayStatusLine(textin, disptime)

%function displayStatusLine(textin, disptime)
%
% Displays a line of text in the middle of the current aces for 1 second
%
% KIM 07.13

% set default display time
if nargin <2
    disptime = 1; 
end
 t1 = text( 0.5, 0.5,  textin,  'horizontalalignment', 'center', 'fontsize', 16, 'color', 'k','interpreter', 'none');
    pause(disptime); delete(t1); % pause included so humans can read text

