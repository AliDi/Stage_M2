%17/03/16, Pour du 2D, en ultrason, avec sonde multi-éléments IMMOBILE.

clear all; close all;

R=1;%10^-5; 			%rapport d'echelle  : 10^5 pour passer de CND->Geophys
					%n'est a changer que sur la frequence, puisque les autres dimensions sont definies a partir de la longueur d'onde l

%%%%%%%%%% Constantes du probleme %%%%%%%%%%


f=2e6*R;			% frequence centrale du transducteur en Hz
vp=6000;			%vitesse du milieu en m/s
l=vp/f;				%longueur d'onde en m

h=l/6;				%pas de discrétisation : en fdtd o(4), respecter 5 pts par longueur d'onde

nz=floor(32*l /h)				%nb de points en z
nx=floor(68*l/2 /h)				%nb de points en x

dt=1e-8/R;			%echantillonage de la fonction de ricker (signal d'excitation)

%%%%%%%%%% Milieu : generation du fichier vp_true %%%%%%%%%%

vp_inclusion=5800;	%vitesse dans l'inclusion en m

if (min(vp,vp_inclusion)/f/h < 5) 
	disp("!!! ATTENTION !!! \n Il n'y aura pas 5 pts par longueur d'onde. \n\n")
end

xpos_center=ceil(nx/2)*h;   %position du centre du défaut en m
zpos_center=16*l;

Larg=6*l; 			%longueur du crack en m
long=l;				%largeur du crack en m
angl= 45;			%angle du crack en degres
vp_true_crack(vp,vp_inclusion,  long ,Larg , angl, xpos_center,zpos_center,nz, nx,h);

%%%%%%%%%% Milieu pour le probleme direct : generation du fichier vp_init %%%%%%%%%%

vp_init_generation(vp,vp, nz, nx,h); %generation du fichier vp_init 


%%%%%%%%%% Generation du fichier contenant les masses volumiques %%%%%%%%%%
rho=1000;
rho_generation(rho,nz,nx)

%%%%%%%%%% Sources/recepteurs : generation du fichier acqui %%%%%%%%%%
%sonde immobile et chaque element est considere ponctuel
nb_elements=64;		%number of active elements	
pitch=l/2;			%center-to-center distance between 2 successive elements
zpos_sources =h/2; 			%z position of the probe (in m)
xpos_sources =ceil(nx/2)*h; 	%position of array center (in m)


zpos_recep = h/2;
xpos_recep =  ceil(nx/2)*h;


[x_sources, z_sources, x_recep, z_recep]=acqui_generation_multielement_reflex_trans(nb_elements,pitch,zpos_sources,xpos_sources, zpos_recep, xpos_recep, nz*h-h, xpos_recep, nz, nx, h,'on');

%[x_sources, z_sources, x_recep, z_recep]=acqui_generation_multielement(nb_elements,pitch,zpos_sources,xpos_sources, zpos_recep, xpos_recep, nz, nx, h,'on');


%%%%%%%%%%% Vérification du critère de courant %%%%%%%%%%
a1=1.125; 			%d'apres le code TOY2DAC.......
a2 = -1/24;
dt_max=0.606*h/(sqrt(2)*(abs(a1)+abs(a2))) / max(vp,vp_inclusion);


disp(["Avec h=" num2str(h) " m, il faut que dt <= " num2str(dt_max) "s.\n\n"])

%%%%%%%%%% Generation du signal d'excitation fricker %%%%%%%%%%

fricker_generation(f,2048,dt)
title('excitation')


