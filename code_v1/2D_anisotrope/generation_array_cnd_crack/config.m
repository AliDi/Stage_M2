%17/03/16, Pour du 2D, en ultrason, avec sonde multi-éléments IMMOBILE.

clear all; close all;

R=10^-5; 			%rapport d'echelle  : 10^5 pour passer de CND->Geophys
					%n'est a changer que sur la frequence, puisque les autres dimensions sont definies a partir de la longueur d'onde l

%%%%%%%%%% Constantes du probleme %%%%%%%%%%


f=3.5e6*R;			% frequence centrale du transducteur en Hz
vp=6000;			%vitesse du milieu en m/s
l=vp/f;				%longueur d'onde en m

h=l/6;				%pas de discrétisation : en fdtd o(4), respecter 5 pts par longueur d'onde

nz=floor(30*l /h)				%nb de points en z
nx=floor(34*l/2 /h)				%nb de points en x

%%%%%%%%%% Milieu : generation du fichier vp_true %%%%%%%%%%

vp_inclusion=5800;	%vitesse dans l'inclusion en m

if (min(vp,vp_inclusion)/f/h < 5) 
	disp("!!! ATTENTION !!! \n Il n'y aura pas 5 pts par longueur d'onde. \n\n")
end

xpos_center=ceil(nx/2)*h;   %position du centre du défaut en m
zpos_center=25*l;


%r=l/4;						%rayon de l'inclusion en m
%vp_true_inclusion(vp,vp_inclusion,r,xpos_center,zpos_center, nz, nx,h); %generation du fichier 'vp_true_inclusion'

Larg=6*l; 			%longueur du crack en m
long=l;				%largeur du crack en m
angl= 45;			%angle du crack en degres
vp_true_crack(vp,vp_inclusion,  long ,Larg , angl, xpos_center,zpos_center,nz, nx,h);

%nb_inclusion=5;
%pitch_inclusion=2*l;
%vp_true_Ninclusions(vp,vp_inclusion,r,pitch_inclusion,xpos_center,zpos_center, nz, nx,h,nb_inclusion); %generation du fichier 'vp_true_Ninclusions'

%%%%%%%%%% Milieu pour le probleme direct : generation du fichier vp_init %%%%%%%%%%

vp_init_generation(vp,vp, nz, nx,h); %generation du fichier vp_init 


%%%%%%%%%% Generation du fichier contenant les masses volumiques %%%%%%%%%%
rho=1000;
rho_generation(rho,nz,nx)

%%%%%%%%%% Sources/recepteurs : generation du fichier acqui %%%%%%%%%%
%sonde immobile et chaque element est considere ponctuel
nb_elements=32;		%number of active elements	
pitch=l/2;			%center-to-center distance between 2 successive elements
zpos_sources =h; 			%z position of the probe (in m)
xpos_sources =ceil(nx/2)*h; 	%position of array center (in m)


zpos_recep = h;
xpos_recep =  ceil(nx/2)*h;


acqui_generation_multielement(nb_elements,pitch,zpos_sources,xpos_sources, zpos_recep, xpos_recep, nz, nx, h, 'on');


%%%%%%%%%%% Vérification du critère de courant %%%%%%%%%%
a1=1.125; 			%d'apres le code TOY2DAC.......
a2 = -1/24;
dt_max=0.606*h/(sqrt(2)*(abs(a1)+abs(a2))) / max(vp,vp_inclusion);


disp(["Avec h=" num2str(h) " m, il faut que dt <= " num2str(dt_max) "s.\n\n"])

%%%%%%%%%% Generation du signal d'excitation fricker %%%%%%%%%%

fricker_generation(f,1024)



