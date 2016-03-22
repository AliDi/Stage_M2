clear all; close all;

nt=4096;		%nombre de points en temps ->nb de ligne
n_recep=48; 	%nombre de recepteurs -> nb de colonnes

dt=0.0005;

%%%%%%%%%% Récupération des données simulées par TOYxDAC %%%%%%%%%%

for i=1:n_recep
%......................
fid =fopen('fsismos_P0006');
A = fread(fid,[nt 1],'single');
fclose(fid);

plot(A)

