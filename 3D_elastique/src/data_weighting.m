function []=data_weighting(d,D)
%
% []=data_weighting(d,D)
%d=1e-3; %distance entre les récepteurs en m
%
%D=10e-3; %zone d'un côté de la source à enlever

weighting=[zeros(1,ceil(D/d)) ones(1,10)];

fid=fopen('weight_data','w+');
fwrite(fid, weighting, 'single');
fclose(fid)

disp(['Le nombre de points du fichier est ' num2str(ceil(D/d)+10)])
