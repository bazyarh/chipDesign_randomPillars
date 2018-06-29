clearvars;
clc;

% variables
Lx         = 20.0;                                  % Width
Ly         = 20.0;                                  % Height
epsilon    = 0.85;                                   % Porosity
deltaMin   = 0.2;                                   % deltamin / (2*r) = 0.2
N          = 800;
fileNum    = 771;

At         = Lx * Ly;                               % Total Area
r0         = sqrt( At*( 1 - epsilon )/ (N * pi) );  % Actual Radius of single pillar

unit_cell  = 0.5;
scale      = (unit_cell / Lx) * 1e6;                % final units in nm

% read data
fname      = ['./data/pos_vs_time_',num2str(fileNum),'.dat'];
X          = importdata(fname);
data       = round(X  * scale);
r0         = round(r0 * scale);

fname      = ['./clewin_eta_0_85_DeltaMin_0_2_',num2str(fileNum),'_singleUnit.txt'];
fileID     = fopen(fname, 'w');

for k=1:length(data)
    fprintf(fileID, 'R %d %d %d;\n', r0*2, data(k,1), data(k,2));
end


