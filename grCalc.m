% calculating g(r)
clearvars;
clc;

string = [];
% create directory if not present
[status, msg, msgID] = mkdir('gR');

%% Parameters for calculating g(r)
% control-parameters
startFile     = 101;                                                          % first file for averaging: ./data/pos_vs_time_startFile.dat
endFile       = 771;                                                         % last file for averaging: ./data/pos_vs_time_endFile.dat
deltaFile     = endFile - startFile + 1;
numIntervals  = ( endFile - startFile + 1 ) / deltaFile;
% variables
Lx            = 20;
Ly            = 20;
At            = Lx * Ly;
N             = 800;
rho           = N / At;
gR_radMin     = 0;                                                          % Min. inter-particle distance for g(r)
gR_radDelta   = 0.05;                                                       % Incr. inter-particle distance for g(r)
gR_radMax     = (20 / 2.0) - gR_radDelta;                                          % Max. inter-particle distance for g(r)

for int=1:numIntervals
    
    gR_Hist_Edges = gR_radMin:gR_radDelta:gR_radMax;                            % Edges for histogram
    gR_len        = length(gR_Hist_Edges);
    grCount       = zeros( gR_len , 1);                                         % Count for the bins in g(r)
    
    % radius for g(r)
    rad = zeros( gR_len, 1 );
    for k=1:gR_len-1
        rad(k) = 0.5 * ( gR_Hist_Edges(k) + gR_Hist_Edges(k+1) );
    end
    rad(k+1) = 0.5 * ( gR_Hist_Edges(k+1) + ( gR_radMax + 0.01 ) );
    
    %% g(r) calculation
    indStart = startFile + (int - 1)* deltaFile;
    indEnd   = indStart + deltaFile - 1;
    
    for fNum = indStart:indEnd
        
        fname = ['./data/pos_vs_time_',num2str(fNum),'.dat'];
        r = importdata(fname);                                                  % Importing particle positions
        
        % initialize positions
        [i,j] = meshgrid(1:N, 1:N);
        rij(:, :, 1) = reshape(r(i, 1) - r(j, 1), N, N);
        rij(:, :, 2) = reshape(r(i, 2) - r(j, 2), N, N);
        
        % Periodic boundary condition -- shortest x and y distance between particles
        rij(:, :, 1) = rij(:, :, 1) - Lx * round( rij(:, :, 1) / Lx);
        rij(:, :, 2) = rij(:, :, 2) - Ly * round( rij(:, :, 2) / Ly);
        
        dist = sqrt( rij(:,:,1).^2 + rij(:,:,2).^2 );
        dist( ( dist(:) > ( Lx / 2.0) )) = 0;             % Ignore distances greater than half-box-length and 0 distances
        
        grCount = grCount + ( hist( dist(:), gR_Hist_Edges) )';                 % Specify histogram with edges
        
    end
    
    % final calculation for g(r)
    count = indEnd - indStart + 1;
    dr    = rad(2) - rad(1);
    gr    = ( grCount ./ ( N * count) ) ./ ( 2 * pi * rad * dr * rho );         % y/N because i loop over all particles
    
    % write data to gR
    fname = ['./gR/gr_interval_', num2str(indStart),'_', num2str(indEnd),'.dat'];
    fileID = fopen(fname, 'w');
    fprintf(fileID, '%8.5f %8.5f',[ rad(2:end-1), gr(2:end-1) ]);
    
    %% plotting
    hold on;
    plot( rad(2:end-1), gr(2:end-1))
    % substr = strcat( num2str(indStart), '-', num2str(indEnd) );
    substr = strcat( 'Interval' , num2str(int) );
    string = [string ; substr];
    
end

% show legend
legend (string);