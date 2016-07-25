%17/03/16, Pour du 2D, en ultrason, avec sonde multi-éléments IMMOBILE.

clear all; close all;

R=1;%e-5; 			%rapport d'echelle  : 10^5 pour passer de CND->Geophys
					%n'est a changer que sur la frequence, puisque les autres dimensions sont definies a partir de la longueur d'onde l

%%%%%%%%%% Constantes du probleme %%%%%%%%%%

f=2e6*R;			% frequence centrale du transducteur en Hz
vp=6000;			%vitesse du milieu en m/s
l=vp/f;				%longueur d'onde en m

h=2*0.00025;%vp/(2*2e6)/6;				%pas de discrétisation : en fdtd o(4), respecter 5 pts par longueur d'onde

nz=floor(0.05/h) %floor(10*l /h)				%nb de points en z
nx=floor(0.10/h) %floor(50*l/2 /h)				%nb de points en x

dt=1.5e-8%1.4e-8;
dt=dt/R;

alpha=1e-4; 		%petit paramètre pour satisfaire epsilon !=delta et delta< epsilon

%%%%%%%%%% Milieu pour le probleme direct %%%%%%%%%%

%paramètre de vitesse
[vp_true]=background(vp , nz , nx , h , 'vp_init' , 1 , 211);

%paramètre de masse volumique
rho=8000;
[rho_true]=background(rho , nz , nx , h , 'rho_init' , 2 , 211);

%paramètre d'anisotropie delta
delta_init = 0;
[delta_true]=background(delta_init , nz , nx , h , 'delta_init' , 3 , 211);

%paramètre d'anisotropie epsilon
epsilon_init=delta_init + alpha;
[epsilon_true]=background(rho , nz , nx , h , 'epsilon_init' , 4 , 211);


%%%%%%%%%% Milieu : ajout d'une soudure %%%%%%%%%%

angl = 65;			%angle du bord droit de la soudure en degre
rg = l;			%root gap en m

%paramètre de vitesse 
vp_weld= 5500;
[vp_true]=weld(vp_true , vp_weld , angl, rg, nz, nx , h , 'vp_true' , 1 , 212);

%paramètre de masse volumique
rho_weld=8000;
[rho_true]=weld(rho_true , rho_weld , angl, rg, nz, nx , h , 'rho_true' , 2 , 212);

%paramètre d'anisotropie epsilon
epsilon_weld=20/100;
[epsilon_true]=weld(epsilon_true , epsilon_weld , angl, rg, nz, nx , h , 'epsilon_true' , 4 , 212);

%%%%%%%%%% Milieu : ajout d'une fissure %%%%%%%%%%

xpos_center=nx/2*h-0.0108;   %position du centre du défaut en m
zpos_center=10*l;

long=6*l; 			%longueur du crack en m
Larg=h;				%largeur du crack en m
angl= 65;

%paramètre de vitesse
vp_crack=5000;

[vp_true ]=crack(vp_true , vp_crack , Larg , long , angl, xpos_center,zpos_center , nz ,  nx , h , 'vp_true' , 1 , 212) ;

%paramètre de masse volumique
rho_crack=3000;

[rho_true ]=crack(rho_true , rho_crack , Larg , long , angl, xpos_center,zpos_center , nz ,  nx , h , 'rho_true' , 2 , 212) ;


%%%%%%%%%% Milieu : ajout d'une inclusion %%%%%%%%%%

xpos_center=ceil(nx/2)*h;   %position du centre du défaut en m
zpos_center=10*l;
r=l/4;						%rayon de l'inclusion en m

% paramètre de vitesse
vp_inclusion=5000;

[vp_true ]= inclusion(vp_true , vp_inclusion , r , xpos_center , zpos_center , nz , nx , h , 'vp_true' , 1 , 212);

%paramètre de masse volumique
rho_inclusion=3000;

[rho_true] = inclusion( rho_true , rho_inclusion , r , xpos_center , zpos_center , nz , nx , h , 'rho_true' , 2 , 212);


%%%%%%%%% Milieu : ajout d'un alignement d'inclusions %%%%%%%%%%

xpos_center=ceil(nx/2)*h;   %position du centre du défaut en m
zpos_center=7*l;
r=l/4;
pitch_inclusion=2*l;
nb_inclusion=5;
pitch=2e-3;

%paramètre de vitesse
vp_inclusion=5000;
[vp_true]=Ninclusions(vp_true , vp_inclusion , r, pitch , xpos_center , zpos_center , nz , nx , h , nb_inclusion ,  'vp_true' , 1 , 212);

%paramètre de masse volumiques
rho_inclusion=5000;
[rho_true]=Ninclusions(rho_true , rho_inclusion , r, pitch , xpos_center , zpos_center , nz , nx , h , nb_inclusion ,  'rho_true' , 2 , 212);


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


%%%%%%%%%% Schema donnant la disposition des transducteurs %%%%%%%%%%
	figure(1)
	hold on
	scatter(x_sources, z_sources,'green','o','filled');
	hold on
	scatter(x_recep, z_recep,'black','o','filled');
	hold off
	colorbar("EastOutside")
	print -dpng config.png

%%%%%%%%%%% Vérification du critère de courant %%%%%%%%%%
a1=1.125; 			
a2 = -1/24;
dt_max=h/(sqrt(2)*(abs(a1)+abs(a2))) / max(max([vp_true]));


disp(["Avec h=" num2str(h) " m, il faut que dt <= " num2str(dt_max) "s.\n\n"])

%%%%%%%%%% Generation du signal d'excitation fricker %%%%%%%%%%

fricker_generation(f,2000,dt,1)



