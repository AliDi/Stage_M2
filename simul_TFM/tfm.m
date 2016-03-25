clear all; close all;

nt=4096;		%nombre de points en temps ->nb de ligne
dt=0.0005;		%echantillonage temporel
t=(0:1:nt-1).*dt;  %reconstitution de l'axe temporel

nb_recep=96; 	%nombre de recepteurs -> nb de colonnes
nb_src=96;

cL_steel = 5600;
cL_weld = 5400;
vp=(cL_weld+cL_steel)/2; 		%vitesse du milieu en m/s


pitch=42.857; 	%distance entre les éléments en m
h=5.7143;		%pas de discrétisation spatiale
nx=300;			%nb de points du milieu
nz=500;

%%%%%%%%%% Récupération des données simulées par TOYxDAC %%%%%%%%%%
%la variable s contient les signaux temporels tq : s(src, recep, temps)

for i=0:nb_src-1

	if (i <= 9)
		fid=fopen(['./data/fsismos_P000' num2str(i)]);
	else 
		fid=fopen(['./data/fsismos_P00' num2str(i)]);
	end
	A = fread(fid,[nt nb_recep],'single'); 		%A a nt lignes et nb_recep colonnes 
	s(i+1,:,:)=A';		
end	

%%%%%%%%%% Calcul des vecteurs position pour les éléments %%%%%%%%%%

%pour les sources
xpos_src = nx/2*h; 
zpos_src =85.714;

x_src= xpos_src-(nb_src-1)*pitch/2 : pitch : xpos_src+(nb_src-1)*pitch/2; 	

z_src=zpos_src*ones(1,nb_src);

%r_src = [x_src' z_src'];

%pour les recepteurs
xpos_recep = nx/2*h;
zpos_recep =  nz*h-85.714;

x_recep = xpos_recep-(nb_recep-1)*pitch/2 : pitch : xpos_recep+(nb_recep-1)*pitch/2;
	
z_recep=zpos_recep*ones(1,nb_recep);

%r_recep = [x_recep' z_recep'];


%%%%%%%%%% Calcul de l'intensité par l'équation 1 de Moreau_2009 %%%%%%%%%%
%hh = waitbar(0,'');
%points d'observation
x_obs=(1:nx)*h;
z_obs=(1:nz)*h;

%r_obs=[x' z'];

%initialisation de l'intensité I à 0
I=zeros(nx, nz);

parfor x=1:nx
	for src=1:nb_src
			
		%distance source-observation
		d_src_obs = sqrt( (x_obs(x)-x_src(src))^2 + (z_obs-z_src(src)).^2 );
			
		for recep=1:nb_recep
			
			%distance recep-observation
			d_recep_obs = sqrt( (x_obs(x)-x_recep(recep))^2 + (z_obs-z_recep(recep)).^2 );
			
			t_interp = (d_src_obs + d_recep_obs)/vp;
			
			y(:,:)=s(src,recep,:);
			y=y';
				
			I(x,:)=I(x,:) + interp1(t , y , t_interp); 
		end 
	end
	%waitbar(x/nx,hh);
end

figure
imagesc(I);







