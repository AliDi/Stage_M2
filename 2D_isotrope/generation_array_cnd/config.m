%17/03/16, Pour du 2D, en ultrason, avec sonde multi-éléments IMMOBILE.

clear all; close all;

R=10^-5; 			%rapport d'echelle  : 10^5 pour passer de CND->Geophys
					%n'est a changer que sur la frequence, puisque les autres dimensions sont definies a partir de la longueur d'onde l

%%%%%%%%%% Constantes du probleme %%%%%%%%%%

f=3.5e6*R;			% frequence centrale du transducteur en Hz
vp=6000;			%vitesse du milieu en m/s
l=vp/f;				%longueur d'onde en m

nz=141;				%nb de points en z
nx=141;				%nb de points en x

h=l/6;				%pas de discrétisation : en fdtd o(4), respecter 5 pts par longueur d'onde

%%%%%%%%%% Milieu : generation du fichier vp_true %%%%%%%%%%

vp_inclusion=4000;	%vitesse dans l'onclusion en m

if (min(vp,vp_inclusion)/f/h < 5) 
	disp("!!! ATTENTION !!! \n Il n'y aura pas 5 pts par longueur d'onde. \n\n")
end

r=l;				%rayon de l'inclusion en m
xpos_center=10*l;   %position de l'inclusion en m
zpos_center=10*l;

vp_true_inclusion(vp1,vp2,r,xpos_center,zpos_center, nz, nx,h); %generation du fichier 'vp_true_inclusion'

%%%%%%%%%% Milieu pour le probleme direct : generation du fichier vp_init %%%%%%%%%%

vp_init_generation(vp1,vp1, nz, nx); %generation du fichier vp_init 

%%%%%%%%%% Sources/recepteurs : generation du fichier acqui %%%%%%%%%%
%sonde immobile et chaque element est considere ponctuel
nb_elements=10;		%number of active elements	
pitch=l/2;			%center-to-center distance between 2 successive elements
xpos_sensor =ceil(nx/2)*h; 	%position of array center (in m)
zpos_sensor =20*l; 			%z position of the probe (in m)

acqui_generation_multielement(nb_elements,pitch,zpos_sensor,xpos_sensor, nz, nx, h);

disp(["Avec h=" num2str(h) " m, il faut que dt <= " num2str(0.66*h/max(vp1,vp2)) "s.\n\n"])





