clear all; clc; close all

%% Initial Definitions

dir.xfoil = strcat(pwd, '\XFOIL');
dir.exp   = strcat(pwd, '\EXP');


% Define parametres
basename = 'input';
aerofoil = 4412;
%alpha   = [-3:3:12 13:1:15];
alpha    = [3];
i        = length (alpha);
Re       = 300000;
M        = 32/300;

% Deleting previous files
delete ('polar.txt');
delete (['naca' num2str(aerofoil)])

%% Plotting Options

options.FontSizeLegend = 12;
options.LineWidth      = 1.5; %plot line width
options.axFontSize     = 14; %axis labels and the title size
options.MarkerSize     = 8; %marker size
options.axLineWidth    = 1.5; %Border line width
options.axGridAlpha    = 0.1; %Grid-line transparency
options.savePlot       = true; %save figures? 


% Delete previous file
delete (['naca' num2str(aerofoil)]);
delete(strcat(basename,'.run'));
    
% Open File
filename.geo = ['naca' num2str(aerofoil)];
fid = fopen(strcat(basename,'.run'), 'w');

% Extract aerofoil shape
fprintf (fid, ['naca ' num2str(aerofoil)]);
fprintf (fid, '\n');

% Smoothing the airfoil shape
fprintf (fid, 'pane\n');

% OPER
fprintf (fid,'OPER\n');
    
% Number of Iterations
fprintf (fid,'ITER 100 \n');

% Turning on viscid mode
fprintf (fid, 'visc\n');
fprintf (fid, num2str(Re));
fprintf (fid,'\n');
fprintf (fid,'Mach\n');
fprintf (fid,num2str(M));
fprintf (fid,'\n');
    
%Polar
fprintf (fid,'PACC \n');
fprintf (fid,'polar.txt \n');
fprintf (fid,'\n');

% Defining Angle of Attack
fprintf (fid,['a' num2str(alpha(i))]);
fprintf (fid,'\n');
    
% CP
fprintf (fid,'CPWR \n');
fprintf (fid,filename.geo);
fprintf (fid,'\n');
    
%Cerrando el fichero
fprintf (fid,'\n \n quit');
fclose(fid);
    
% Llamando al programa
[status, results] = dos(strcat('.\xfoil.exe < ',basename,'.run'));

if (alpha(i) <0)
  alpha_name{i} = ['alpha_' 'm' num2str(abs(alpha(i)))];
else
   alpha_name{i} = ['alpha_' num2str(abs(alpha(i)))];
end

%Cp.(alpha_name)= importdata([filename.geo],' ', 1);
Cp.(alpha_name{i}) = readtable (filename.geo);
    

%% Reading Polar 

%% Plotting Cp

figure()
hold on
for i =1: length(alpha_name)   
plot(Cp.(alpha_name{i}){:,1},Cp.(alpha_name{i}){:,3});
end
hold off

set(gcf,'units','normalized')
set(gcf,'position',[0 0 1 1])



