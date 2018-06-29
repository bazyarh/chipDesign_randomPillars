function [flag] = intersectCheck(i, rNew)

global r N Lx Ly radius

flag = 1;
for j= 1:N
    if ( j~= i )
        rij = rNew - r(j, :);
        
        rij(1) = rij(1) - Lx * round( rij(1) / Lx );                                             % minimum image convention
        rij(2) = rij(2) - Ly * round( rij(2) / Ly );                                             % minimum image convention
        
        r2 = ( sum( rij.^2 ) >= (2.0*radius)^2 );                                  % check if they intersect
        
        if ( r2  == 0)
            flag = 0;
        end
    end
end

end

% flag = 1;
% rij = rNew - r;
% rij = rij - a*round(rij,a);
%
% rij( i, :) = 1000;                                                          % put it to an arbitrarily high value
% r2 = ( sum( rij.^2 ) >= (2.0*radius)^2 );
%
% if ( r2  == 0)
%     flag = 0;
% end
