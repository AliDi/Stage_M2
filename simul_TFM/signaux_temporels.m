
clear all; close all;

nt=2700;		%nombre de points en temps ->nb de ligne
dt=0.0015;		%echantillonage temporel
t=(0:1:nt-1).*dt;  %reconstitution de l'axe temporel

nb_recep=96; 	%nombre de recepteurs -> nb de colonnes
nb_src=96;

cL_steel = 5600;
cL_weld = 5400;
vp=(cL_weld+cL_steel)/2; 		%vitesse du milieu en m/s


pitch=85.714; 	%distance entre les éléments en m
h=28.571;		%pas de discrétisation spatiale
nx=294;			%nb de points du milieu
nz=300;

%%%%%%%%%% Récupération des données simulées par TOYxDAC %%%%%%%%%%
%la variable s contient les signaux tempoaorels tq : s(src, temps, recep)

for i=0:nb_src-1

	if (i <= 9)
		fid=fopen(['./data/fsismos_P000' num2str(i)],'r','l');;
	else 
		fid=fopen(['./data/fsismos_P00' num2str(i)]);
	end
	A = fread(fid,'single'); 		%A a nt lignes et nb_recep colonnes 
	s(i+1,:,:)=reshape(A,nt,nb_recep);
	fclose(fid);		
end	

%%%%%%%%%% Calcul des vecteurs position pour les éléments %%%%%%%%%%

%pour les sources
xpos_src = ceil(nx/2)*h; 
zpos_src =h;

x_src= xpos_src-(nb_src-1)*pitch/2 : pitch : xpos_src+(nb_src-1)*pitch/2; 	

z_src=zpos_src*ones(1,nb_src);

%r_src = [x_src' z_src'];

%pour les recepteurs
xpos_recep = ceil(nx/2)*h;
zpos_recep =  h;

x_recep = xpos_recep-(nb_recep-1)*pitch/2 : pitch : xpos_recep+(nb_recep-1)*pitch/2;
	
z_recep=zpos_recep*ones(1,nb_recep);

%r_recep = [x_recep' z_recep'];


%%%%%%%%%% Calcul de l'intensité par l'équation 1 de Moreau_2009 %%%%%%%%%%
%points d'observation
x_obs=linspace(0,nx*h,nx);
z_obs=linspace(0,nz*h,nz);

%r_obs=[x' z'];

%initialisation de l'intensité I à 0
I=zeros(nx, nz);

parfor x=1:nx
	x
	for src=1:nb_src	
	
		%distance source-observation
		d_src_obs = sqrt( (x_obs(x)-x_src(src))^2 + (z_obs-z_src(src)).^2 );
			
		for recep=1:nb_recep
			
			%distance recep-observation
			d_recep_obs = sqrt( (x_obs(x)-x_recep(recep))^2 + (z_obs-z_recep(recep)).^2 );
			
			t_interp = (d_src_obs + d_recep_obs)/vp;
			
			y(:,:)=s(src,:,recep);
			y=y';
			
			
			I(x,:)=I(x,:) + interp1(t , y , t_interp);
		end 
	end
end

figure
imagesc(I);








