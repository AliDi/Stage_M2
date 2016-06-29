%17/03/16, Pour du 2D, en ultrason, avec sonde multi-éléments IMMOBILE.

clear all; close all;

R=1;%e-5; 			%rapport d'echelle  : 10^5 pour passer de CND->Geophys
					%n'est a changer que sur la frequence, puisque les autres dimensions sont definies a partir de la longueur d'onde l

%%%%%%%%%% Constantes du probleme %%%%%%%%%%

f=2e6*R;			% frequence centrale du transducteur en Hz
vp=6000;			%vitesse du milieu en m/s
l=vp/f;				%longueur d'onde en m

h=0.00016;%vp/(2*2e6)/6;				%pas de discrétisation : en fdtd o(4), respecter 5 pts par longueur d'onde

nz=300%floor(0.05/h) %floor(10*l /h)				%nb de points en z
nx=600%floor(0.10/h) %floor(50*l/2 /h)				%nb de points en x

dt=9.3e-9%1.4e-8/R;




%%%%%%%%%% Milieu pour le probleme direct : generation du fichier vp_init et epsilon_init%%%%%%%%%%
rho=8000;

[vp_true rho_true]=vp_init_generation(vp,rho, nz, nx,h); %generation du fichier vp_init 

%epsilon_init=0;		%pas d'anisotropie
%epsilon_init_generation(epsilon_init, nz, nx,h);




%%%%%%%%%% Milieu : ajout d'une soudure %%%%%%%%%%

vp_weld= 5500;
rho_weld=8000;
angl = 65;			%angle du bord droit de la soudure en degre
rg = l;			%root gap en m
[vp_true rho_true]=vp_weld_generation(vp_true , vp_weld , rho_true , rho_weld , angl , rg , nz , nx , h );




%%%%%%%%%% Milieu : ajout d'une fissure %%%%%%%%%%

xpos_center=nx/2*h-0.0108;   %position du centre du défaut en m
zpos_center=10*l;

Larg=6*l; 			%longueur du crack en m
long=h;				%largeur du crack en m
angl= 65;
vp_crack=5000;
rho_crack=3000;


[vp_true rho_true]=vp_true_crack(vp_true , vp_crack , rho_true , rho_crack , long , Larg , angl , xpos_center , zpos_center , nz , nx , h);




%%%%%%%%%% Milieu : ajout d'une inclusion %%%%%%%%%%

xpos_center=ceil(nx/2)*h;   %position du centre du défaut en m
zpos_center=10*l;

vp_inclusion=5000;
rho_inclusion=3000;
r=l/4;						%rayon de l'inclusion en m

[vp_true rho_true]=vp_true_inclusion(vp_true , vp_inclusion , rho_true , rho_inclusion , r , xpos_center , zpos_center , nz , nx , h);



%%%%%%%%% Milieu : ajout d'un alignement d'inclusions %%%%%%%%%%

#xpos_center=ceil(nx/2)*h;   %position du centre du défaut en m
#zpos_center=7*l;

#vp_inclusion=5000;
#rho_inclusion=5000;
#r=l/4;

#pitch_inclusion=2*l;
#nb_inclusion=5;

#[vp_true rho_true]=vp_true_Ninclusions(vp_true , vp_inclusion , rho_true , rho_inclusion , r , pitch_inclusion , xpos_center , zpos_center , nz , nx , h , nb_inclusion);



%%%%%%%%%% Generation du fichier contenant les masses volumiques %%%%%%%%%%
%rho=8000;
%rho_generation(rho,nz,nx);

%%%%%%%%%% Sources/recepteurs : generation du fichier acqui %%%%%%%%%%
%sonde immobile et chaque element est considere ponctuel
nb_elements=64;		%number of active elements	
pitch=0.001;
			%center-to-center distance between 2 successive elements
zpos_sources1 =h; 			%z position of the probe (in m)
xpos_sources1 =nx/2*h;%7.7e-2; 	%position of array center (in m)

zpos_recep1 = zpos_sources1;
xpos_recep1 =  xpos_sources1;

zpos_sources2 = (nz-1)*h-h;
xpos_sources2 = nx/2*h;

zpos_recep2 = zpos_sources2;
xpos_recep2 =  xpos_sources2;

%[x_sources, z_sources, x_recep, z_recep]=acqui_generation_multielement(nb_elements , pitch , zpos_sources1 , xpos_sources1 , zpos_recep1 , xpos_recep1 , nz , nx , h , 'on');

[x_sources z_sources x_recep z_recep]= acqui_generation_multielement_2trans(nb_elements , pitch ,  zpos_sources1 , xpos_sources1 , zpos_sources2 , xpos_sources2 , zpos_recep1 , xpos_recep1 , zpos_recep2 , xpos_recep2 , nz , nx , h , 'on');

%[x_sources z_sources x_recep z_recep]= acqui_generation_multielement_reflex_trans(nb_elements , pitch , zpos_sources1 , xpos_sources1 , zpos_recep1 , xpos_recep1 , zpos_recep2 , xpos_recep2 , nz , nx , h , 'on' );



%%%%%%%%%%% Vérification du critère de courant %%%%%%%%%%
a1=1.125; 			%d'apres le code TOY2DAC.......
a2 = -1/24;
dt_max=h/(sqrt(2)*(abs(a1)+abs(a2))) / max(max([vp_true]));


disp(["Avec h=" num2str(h) " m, il faut que dt <= " num2str(dt_max) "s.\n\n"])

%%%%%%%%%% Generation du signal d'excitation fricker %%%%%%%%%%

fricker_generation(f,2000,dt)
title('excitation')




figure(100)
colorbar("EastOutside")
print -dpng config.png


