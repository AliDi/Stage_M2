%17/03/16, Pour du 2D, en ultrason, avec sonde multi-éléments IMMOBILE.

clear all; close all;

R=1;%e-5; 			%rapport d'echelle  : 10^5 pour passer de CND->Geophys
					%n'est a changer que sur la frequence, puisque les autres dimensions sont definies a partir de la longueur d'onde l

%%%%%%%%%% Constantes du probleme %%%%%%%%%%

f=2e6*R;			% frequence centrale du transducteur en Hz
vp=6000;			%vitesse du milieu en m/s
l=vp/f;				%longueur d'onde en m

h=vp/(2*f)/6;				%pas de discrétisation : en fdtd o(4), respecter 5 pts par longueur d'onde
%h=h;

nz=floor(0.05/R/h) %floor(10*l /h)				%nb de points en z
nx=floor(0.12/R/h) %floor(50*l/2 /h)					%nb de points en x

dt=1.4e-8/R;

alpha=1e-4; 		%petit paramètre pour satisfaire epsilon !=delta et delta< epsilon



%%%%%%%%%% Milieu pour le probleme direct : uniforme par défaut et pas d'anisotropie %%%%%%%%%%
rho=8000;

[vp_true rho_true]=vp_init_generation(vp,rho, nz, nx,h); %generation du fichier vp_init 

delta_init = 0;		%pas d'anisotropie
delta = delta_init_generation(delta_init, nz, nx,h);

epsilon_init=delta_init + alpha;		%elliptique : epsilon = delta
epsilon = epsilon_init_generation(epsilon_init, nz, nx,h);


%%%%%%%%%% Milieu : ajout d'une soudure %%%%%%%%%%

vp_weld= 5500;
rho_weld=5000;
angl = 65;			%angle du bord droit de la soudure en degre
rg = l;			%root gap en m
[vp_true rho_true]=vp_weld_generation(vp_true , vp_weld , rho_true , rho_weld , angl , rg , nz , nx , h );

%anisotropie elliptique : vitesse horizontale différente de la verticale
epsilon_weld=20/100;
epsilon=epsilon_weld_generation(epsilon_weld , epsilon , angl , rg , nz , nx , h);




%%%%%%%%%% Milieu : ajout d'une fissure %%%%%%%%%%

xpos_center=ceil(nx/2)*h;   %position du centre du défaut en m
zpos_center=10*l;

Larg=6*l; 			%longueur du crack en m
long=l;				%largeur du crack en m
angl= 45;
vp_crack=5000;
rho_crack=5000;


%[vp_true rho_true]=vp_true_crack(vp_true , vp_crack , rho_true , rho_crack , long , Larg , angl , xpos_center , zpos_center , nz , nx , h);




%%%%%%%%%% Milieu : ajout d'une inclusion %%%%%%%%%%

%où ?
xpos_center=ceil(nx/2)*h;   %position du centre du défaut en m
zpos_center=ceil(nz/2)*h;
r=1e-3;						%rayon de l'inclusion en m

%propriétés ?
vp_inclusion = 5000;
rho_inclusion = 5000;
delta_inclusion = 20 /100;
epsilon_inclusion = delta_inclusion + alpha;


%[vp_true rho_true]=vp_true_inclusion(vp_true , vp_inclusion , rho_true , rho_inclusion , r , xpos_center , zpos_center , nz , nx , h);

%[epsilon] = epsilon_inclusion_generation(epsilon_inclusion, epsilon , r,xpos_center,zpos_center, nz, nx,h);

%[delta] = delta_inclusion_generation(delta_inclusion, delta , r,xpos_center,zpos_center, nz, nx,h);


%%%%%%%%% Milieu : ajout d'un alignement d'inclusions %%%%%%%%%%

xpos_center=ceil(nx/2)*h;   %position du centre du défaut en m
zpos_center=7*l;

vp_inclusion=5000;
rho_inclusion=5000;
r=l/4;

pitch_inclusion=2*l;
nb_inclusion=5;

%[vp_true rho_true]=vp_true_Ninclusions(vp_true , vp_inclusion , rho_true , rho_inclusion , r , pitch_inclusion , xpos_center , zpos_center , nz , nx , h , nb_inclusion);



%%%%%%%%%% Sources/recepteurs : generation du fichier acqui %%%%%%%%%%
%sonde immobile et chaque element est considere ponctuel
nb_elements=32;		%number of active elements	
pitch=0.001;
					%center-to-center distance between 2 successive elements
zpos_sources1 =h; 			%z position of the probe (in m)
xpos_sources1 =nx*h/2 -5e-2;% -5e-2; 	%position of array center (in m)

zpos_recep1 =  zpos_sources1;
xpos_recep1 =  xpos_sources1;

zpos_sources2 = h;
xpos_sources2 = nx*h/2 +5e-2;% +5e-2;

zpos_recep2 = zpos_sources2;
xpos_recep2 =  xpos_sources2;

[x_sources z_sources x_recep z_recep]= acqui_generation_multielement_2trans(nb_elements , pitch ,  zpos_sources1 , xpos_sources1 , zpos_sources2 , xpos_sources2 , zpos_recep1 , xpos_recep1 , zpos_recep2 , xpos_recep2 , nz , nx , h , 'on');

%[x_sources, z_sources, x_recep, z_recep]=acqui_generation_multielement(nb_elements , pitch , zpos_sources , xpos_sources , zpos_recep , xpos_recep , nz , nx , h , 'on');

%[x_sources z_sources x_recep z_recep]= acqui_generation_multielement_reflex_trans(nb_elements , pitch , zpos_sources , xpos_sources , zpos_recep1 , xpos_recep1 , zpos_recep2 ,  xpos_recep2 , nz , nx , h , 'on');

%acqui_generation_multielement(nb_elements,pitch,zpos_sources,xpos_sources, zpos_recep, xpos_recep, nz, nx, h,'on');


%full acquisition
#Nsrc=13; %nb src par ligne
#z_sources=[ones(1,Nsrc)*0.4e-2 ((0:Nsrc-1)+4).*1e-3 ones(1,Nsrc).*(nz-1)*h-0.4e-2 ((0:Nsrc-1)+4).*1e-3 ];
#z_recepts=z_sources;
#x_sources=[((0:Nsrc-1)+4).*1e-3 ones(1,Nsrc).*(nx-1)*h-4e-3  ((0:Nsrc-1)+4).*1e-3 ones(1,Nsrc)*4e-3];
#x_recepts=x_sources;
#y_sources=zeros(1,length(z_sources));
#y_recepts=y_sources;
# 
#acqui_generation(z_sources,x_sources,y_sources,z_recepts,x_recepts,y_recepts, nz, nx,h , 'on')

%4 recep, 2 barrettes sources
%sources
%[x_sources1, z_sources1, x_recep1, z_recep1]=acqui_generation_multielement( 16 , pitch , 2.5000e-04 , nx*h/2 -5e-2 , 0 , 0 , nz , nx , h , 'on');
%[x_sources2, z_sources2, x_recep1, z_recep1]=acqui_generation_multielement( 16 , pitch , 2.5000e-04 , nx*h/2 +5e-2 , 0 , 0 , nz , nx , h , 'on');

%[x_sources3, z_sources3, x_recep1, z_recep1]=acqui_generation_multielement( 16 , pitch , (nz-1)*2.5000e-04-2.5000e-04 , nx*h/2 -5e-2 , 0 , 0 , nz , nx , h , 'on');
%[x_sources4, z_sources4, x_recep1, z_recep1]=acqui_generation_multielement( 16 , pitch , (nz-1)*2.5000e-04-2.5000e-04 , nx*h/2 +5e-2 , 0 , 0 , nz , nx , h , 'on');

%recep
%[x_sources, z_sources, x_recep1, z_recep1]=acqui_generation_multielement(nb_elements , pitch , 0 , 0 , 2.5000e-04 , nx*h/2 -5e-2 , nz , nx , h , 'on');
%[x_sources, z_sources, x_recep2, z_recep2]=acqui_generation_multielement(nb_elements , pitch , 0 , 0 , 2.5000e-04 , nx*h/2 +5e-2 , nz , nx , h , 'on');
%[x_sources, z_sources, x_recep3, z_recep3]=acqui_generation_multielement(nb_elements , pitch , 0 , 0 , (nz-1)*2.5000e-04-2.5000e-04 , nx*h/2 +5e-2 , nz , nx , h , 'on');
%[x_sources, z_sources, x_recep4, z_recep4]=acqui_generation_multielement(nb_elements , pitch , 0 , 0 , (nz-1)*2.5000e-04-2.5000e-04 , nx*h/2 -5e-2 , nz , nx , h , 'on');

%tous
%acqui_generation([z_sources1 z_sources2 z_sources3 z_sources4] , [x_sources1 x_sources2 x_sources3 x_sources4] , zeros(1,64) , [z_recep1 z_recep2 z_recep3 z_recep4] , [x_recep1 x_recep2 x_recep3 x_recep4] , zeros(1,64) , nz ,  nx , 2.5000e-04 , 'on' )
#acqui_generation([z_sources1 z_sources2] , [x_sources1 x_sources2] , zeros(1,32) , [z_recep1 z_recep2] , [x_recep1 x_recep2] , zeros(1,64) , nz ,  nx , h , 'on')
%acqui_generation([z_sources1 z_sources2] , [x_sources1 x_sources2] , zeros(1,32) , [z_recep1 z_recep2 z_recep3 z_recep4] , [x_recep1 x_recep2 x_recep3 x_recep4] , zeros(1,64) , nz ,  nx , h , 'on')

%%%%%%%%%%% Vérification du critère de courant %%%%%%%%%%
a1=1.125; 			%d'apres le code TOY2DAC.......
a2 = -1/24;
dt_max=0.606*h/(sqrt(2)*(abs(a1)+abs(a2))) / max([vp]);


disp(["Avec h=" num2str(h) " m, il faut que dt <= " num2str(dt_max) "s.\n\n"])

%%%%%%%%%% Generation du signal d'excitation fricker %%%%%%%%%%

fricker_generation(f,2500,dt,1)
title('excitation')



figure(100)
colorbar("EastOutside")
print -dpng config.png

delta_zero_generation(nz,nx,h);







