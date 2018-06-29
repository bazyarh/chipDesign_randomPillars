
%% program to generate a random pillar configuration using Monte Carlo
%% procedure
tic
clearvars;
clc;

global r radius Lx Ly N

% create directory if not present
[status, msg, msgID] = mkdir('data');

%% Parameter initialization
% control-parameters
Lx         = 20.0;                                  % Width
Ly         = 20.0;                                  % Height
epsilon    = 0.85;                                   % Porosity
deltaMin   = 0.2;                                   % deltamin / (2*r) = 0.2
fwriteFreq = 5e2;                                   % Frequency of file-writing
stepMax    = 1e7;                                   % Maximum steps

% Varibles
N          = 800;                                   % Number of pillars
At         = Lx * Ly;                               % Total Area
r0         = sqrt( At*( 1 - epsilon )/ (N * pi) );  % Actual Radius of single pillar
d          = (2 * r0 ) * ( 1 + deltaMin );          % Virtual diameter
radius     = d / 2.0;                               % Virtual Radius
deltay     = 0.5;                                   % vertical spacing between pillars
deltax     = 0.5;                                   % horizontal spacing between pillars
maxDisp    = Lx/10.0;
flag       = 1;
restart    = 1;
startFrom  = 1;

%% Geometry initialization
if ( restart == 0 )
    % Flexible initialization based on non-overlapping effects
    % first particle
    r(1,1) = rand(1) * Lx;
    r(1,2) = rand(1) * Ly;
    
    for i = 2:N
        while ( flag == 1 )
            r(i,1) = rand(1) * Lx;
            r(i,2) = rand(1) * Ly;
            
            for j = 1:i-1
                rij = r(i,:) - r(j, :);
                
                rij(1) = rij(1) - Lx * round( rij(1) / Lx );                    % minimum image convention
                rij(2) = rij(2) - Ly * round( rij(2) / Ly );
                
                r2 = ( sum( rij.^2 ) >= ( 2.0 * radius )^2 );                   % overlap-check between i and j
                
                if ( r2  == 0 )
                    flag = 1;
                    break;
                else
                    flag = 0;
                end
            end
        end
        flag = 1;	% reset flag to 1
    end
elseif ( restart == 1 )
     % restart option
    startFrom = 771;
    r = importdata(['./data/pos_vs_time_',num2str(startFrom),'.dat']);
else
    
    % array type-1
    [xpos, ypos] = meshgrid( 0.5:1:Lx-0.5, 0.5:1:Ly-0.5 );
    
    r = zeros(N,2);
    r(1:N/2,1) = reshape(xpos, N/2,1);
    r(1:N/2,2) = reshape(ypos, N/2,1);
    
    % array type-2
    [xpos2, ypos2] = meshgrid( 1:1:Lx, 1:1:Ly );
    
    r(N/2+1:N,1) = reshape(xpos2, N/2,1);
    r(N/2+1:N,2) = reshape(ypos2, N/2,1);
end

counter = startFrom;                                                                % counter for file-writing
visualize;

%% Monte Carlo steps
for steps = 1:stepMax
    
    for i=1:N
        dr = -( maxDisp / 2.0 ) + maxDisp*rand( 1, 2 );
        
        rNew(1) = mod( r(i,1) + dr(1) , Lx );           % account for pbc
        rNew(2) = mod( r(i,2) + dr(2) , Ly );
        
        flag = intersectCheck(i, rNew);
        
        if ( flag == 1 )
            r(i,:) = rNew;
        end
    end
    
    % File Writing
    if ( mod( steps, fwriteFreq ) == 0 )
        steps
        counter = counter + 1;
        csvwrite(['./data/pos_vs_time_',num2str(counter),'.dat'],r);
    end
end

% calculate g(r)
% grCalc
toc
