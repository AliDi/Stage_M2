%17/03/16, Pour du 2D, en ultrason, avec sonde multi-éléments IMMOBILE.

clear all; close all;

R=1;%e-5; 			%rapport d'echelle  : 10^5 pour passer de CND->Geophys
					%n'est a changer que sur la frequence, puisque les autres dimensions sont definies a partir de la longueur d'onde l

%%%%%%%%%% Constantes du probleme %%%%%%%%%%


f=2e6*R;			% frequence centrale du transducteur en Hz
vp=5800;			%vitesse du milieu en m/s
l=vp/f;				%longueur d'onde en m

h=vp/(1.5*2e6)/5;				%pas de discrétisation : en fdtd o(4), respecter 5 pts par longueur d'onde

nz=floor(0.05/h) %floor(10*l /h)				%nb de points en z
nx=floor(0.1/h) %floor(50*l/2 /h)				%nb de points en x

dt=2.4e-8/R;

%%%%%%%%%% Milieu : generation du fichier vp_true et espilon%%%%%%%%%%

vp_weld_h=5500;
vp_weld_v=5500;


angl = 63.4;			%angle du bord droit de la soudure en degre
rg = 5*h;			%root gap en m
vp_epsilon_weld_generation(vp, vp_weld_h, vp_weld_v,angl, rg, nz, nx,h);


%%%%%%%%%% Milieu pour le probleme direct : generation du fichier vp_init et epsilon_init%%%%%%%%%%

vp_init_generation(vp,vp, nz, nx,h); %generation du fichier vp_init 

epsilon_init=0;		%pas d'anisotropie
epsilon_init_generation(epsilon_init, nz, nx,h);

%%%%%%%%%% Generation du fichier contenant les masses volumiques %%%%%%%%%%
rho=8000;
rho_generation(rho,nz,nx);

%%%%%%%%%% Sources/recepteurs : generation du fichier acqui %%%%%%%%%%
%sonde immobile et chaque element est considere ponctuel
nb_elements=64;		%number of active elements	
pitch=0.0013;
			%center-to-center distance between 2 successive elements
zpos_sources =h; 			%z position of the probe (in m)
xpos_sources =ceil(nx/2)*h; 	%position of array center (in m)

zpos_recep = h;
xpos_recep =  ceil(nx/2)*h;


[x_sources, z_sources, x_recep, z_recep]=acqui_generation_multielement(nb_elements,pitch,zpos_sources,xpos_sources, zpos_recep, xpos_recep, nz, nx, h,'on');

%acqui_generation_multielement(nb_elements,pitch,zpos_sources,xpos_sources, zpos_recep, xpos_recep, nz, nx, h,'on');


%%%%%%%%%%% Vérification du critère de courant %%%%%%%%%%
a1=1.125; 			%d'apres le code TOY2DAC.......
a2 = -1/24;
dt_max=0.606*h/(sqrt(2)*(abs(a1)+abs(a2))) / max([vp,vp_weld_v,vp_weld_h]);


disp(["Avec h=" num2str(h) " m, il faut que dt <= " num2str(dt_max) "s.\n\n"])

%%%%%%%%%% Generation du signal d'excitation fricker %%%%%%%%%%

fricker_generation(f,150,dt)
title('excitation')







