clearvars;
clc;

% variables
Lx         = 20.0;                                  % Width
Ly         = 20.0;                                  % Height
epsilon    = 0.8;                                   % Porosity
deltaMin   = 0.2;                                   % deltamin / (2*r) = 0.2
N          = 800;
fileNum    = 430;

At         = Lx * Ly;                               % Total Area
r0         = sqrt( At*( 1 - epsilon )/ (N * pi) );  % Actual Radius of single pillar

unit_cell  = 0.5;
scale      = (unit_cell / Lx) * 1e6;                % final units in nm

% read data
fname      = ['./data/pos_vs_time_',num2str(fileNum),'.dat'];
X          = importdata(fname);
data       = round(X  * scale);
r0         = round(r0 * scale);

fname      = ['./clewin_eta_0_8_DeltaMin_0_2_',num2str(fileNum),'.txt'];
fileID     = fopen(fname, 'w');
for i=0:4
    for j=0:9
        for k=1:length(data)
            fprintf(fileID, 'R %d %d %d;\n', r0*2, data(k,1)+j*5e5, data(k,2)+i*5e5);
        end
    end
end
