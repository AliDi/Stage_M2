clear all; close all;
addpath('/home/dinsenma/simul_TFM/src');

R=1;%10^-5; 			%rapport d'echelle  : 10^5 pour passer de CND->Geophys
					%n'est a changer que sur la frequence, puisque les autres dimensions sont definies a partir de la longueur d'onde l

%%%%%%%%%% Constantes du probleme %%%%%%%%%%


f=2e6*R;			% frequence centrale du transducteur en Hz
vp=5500;			%vitesse du milieu en m/s
l=vp/f;				%longueur d'onde en m

h=0.25e-3;				%pas de discrétisation : en fdtd o(4), respecter 5 pts par longueur d'onde

nz=200				%nb de points en z
nx=400				%nb de points en x

dt=1.5e-8/R;			%echantillonage de la fonction de ricker (signal d'excitation)

%%%%%%%%%% Milieu : generation du fichier vp_true %%%%%%%%%%

vp_inclusion=5500;	%vitesse dans l'inclusion en m





%%%%%%%%%% Sources/recepteurs : generation du fichier acqui %%%%%%%%%%
%sonde immobile et chaque element est considere ponctuel
nb_elements=64;		%number of active elements	
pitch=0.001;
			%center-to-center distance between 2 successive elements
zpos_sources1 =h; 			%z position of the probe (in m)
xpos_sources1 =nx/2*h;%7.7e-2; 	%position of array center (in m)

zpos_recep1 = zpos_sources1;
xpos_recep1 =  xpos_sources1;

zpos_sources2 = (nz-1)*h;
xpos_sources2 = nx/2*h;

zpos_recep2 = zpos_sources2;
xpos_recep2 =  xpos_sources2;

%[x_sources, z_sources, x_recep, z_recep]=acqui_generation_multielement(nb_elements , pitch , zpos_sources1 , xpos_sources1 , zpos_recep1 , xpos_recep1 , nz , nx , h , 'on');

[x_sources z_sources x_recep z_recep]= acqui_generation_multielement_2trans(nb_elements , pitch ,  zpos_sources1 , xpos_sources1 , zpos_sources2 , xpos_sources2 , zpos_recep1 , xpos_recep1 , zpos_recep2 , xpos_recep2 , nz , nx , h , 'on');

	figure(100)
	hold on
	scatter(x_sources, z_sources,'green','o','filled');
	hold on
	scatter(x_recep, z_recep,'black','o','filled');
	hold off
	print -dpng acqui.png


%%%%%%%%%% calcul TFM %%%%%%%%%%
nt=1024;
tfm(nt,dt, 2*nb_elements,pitch, vp, vp_inclusion , x_sources, z_sources, x_recep, z_recep, nz, nx, h);

%%%%%%%%%% Affichage TFM %%%%%%%%%%

data=load('img_tfm2');

%data=data(66:132,30:60);

figure
imagesc([0 nz*h]*R,[0 nx*h]*R,(data));
colorbar


xpos_center=0.048000;
zpos_center=0.030000;
r=7.5000e-04;
theta=0:0.0001:2*pi;
hold on
plot( (r*sin(theta)+(zpos_center))*R,(r*cos(theta)+(xpos_center))*R,'r');

title('TFM')
xlabel('m')
ylabel('m')

print -dpng image_tfm2.png


