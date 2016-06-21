clear all; close all; 

nom_lecture=input("nom des donnees a interpoler : ","s");
nom_ecriture=input("nom du fichier de sortie : ","s")

% propriétés du maillage irrégulier
cel_norm=[0 0.17267315 0.5 0.82732685 ]; %element allant de 0 à 1
lcel=3e-3;									 %largeur réelle de l'élément
cel=cel_norm; 
ncelz=17;
ncelx=34;
ncely=4;

zirreg=cel_norm;
for z=1:ncelz-1
	zirreg=[zirreg cel_norm+z];
end
zirreg=[zirreg ncelz].*lcel;

xirreg=cel_norm;
for x=1:ncelx-1
	xirreg=[xirreg cel_norm+x];
end
xirreg=[xirreg ncelx].*lcel;

%propriétés du maillage régulier sur lequel on projette
nz=200;
nx=400;
ny=40;
h=0.00025;

zreg=0:h:(nz-1)*h;
xreg=0:h:(nx-1)*h;
yreg=0:h:(ny-1)*h;

%lecture du fichier sur maillage irregulier
% Xgll  -1.000000     -0.6546537      0.0000000E+00  0.6546537       1.000000  
% Wgll  0.1000000      0.5444444      0.7111111      0.5444444      0.1000000 
fid=fopen([num2str(nom_lecture)]);
A = fread(fid,'single');
fclose(fid);

	%extraction d'un plan en y=0
A=reshape(A , 4*ncelz+1 , 4*ncelx+1 , 4*ncely+1);
A2D=A(:,:,1);
figure
imagesc(A2D);

%imterpolation linéaire 2D
[xreg zreg]=meshgrid(xreg,zreg);
Areg=interp2( xirreg , zirreg  ,  A2D , xreg , zreg  , "linear");

figure
imagesc(Areg)

Areg=ones(1,1,ny).*Areg;


%ecriture des nouvelles données
fid=fopen(nom_ecriture,'w+')
fwrite(fid, Areg(:,:,:) ,'single')
fclose(fid)


