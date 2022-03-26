function [boxed] = boxcarsmooth( vec, win)

% function [boxed] = boxcarsmooth( vec, win)
%
%  Smooth vector vec with a running boxcar of size win
%  Can use both even and odd sized windows
%
% KIM 10/10

boxed = vec*nan; 

% check if the window is even or odd
evenodd = mod( win, 2 ); 

if evenodd == 1 % odd
    lobe = floor( win./2 ); 
    % define the start and end indices
    start_i = lobe+1;
    end_i = length( vec ) - (lobe+1);
    % now cycle through
    for n = start_i:end_i
        chunk = vec( n-lobe:n+lobe);         
        boxed( n ) = nanmean( chunk ); 
    end

elseif evenodd == 0 % even
    lobe = win - 1; 
    % define the start and end indices
    start_i = 1;
    end_i = length( vec ) - (win);
    % cycle through
    for n =start_i:end_i
          chunk = vec( n:n+lobe );     
          % offset grid
          odd(n) = nanmean(chunk); 
          ind(n) = nanmean( n:n+lobe); 
    end
    %interpolate back onto the original grid
    boxed = interp1( ind, odd, 1:length( vec ));
   
end