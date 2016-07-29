%Pour du 3D, en ultrason, avec sonde multi-éléments IMMOBILE.

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
ny=floor(0.01/h)

dt=1.5e-8%1.4e-8;
dt=dt/R;


%%%%%%%%%% Milieu pour le probleme direct %%%%%%%%%%

%paramètre de vitesse des ondes de compression
[vp_true]=background(vp , nz , nx , h , 'vp_init' , 1 , 211);
vp_init=vp_true;

%paramètre de vitesse des ondes de cisaillement
vs_init = 3200; %en inversion monoparamètre, s'assurer que vs< vp/sqrt(2)
[vs_true]=background(vs_init , nz , nx , h , 'vs_init' , 3 , 211);
vs_init=vs_true;

%paramètre de masse volumique
rho=8000;
[rho_true]=background(rho , nz , nx , h , 'rho_init' , 2 , 211);
rho_init=rho_true;

%%%%%%%%%% Milieu : ajout d'une soudure %%%%%%%%%%

angl = 65;			%angle du bord droit de la soudure en degre
rg = l;			%root gap en m

%paramètre de vitesse des ondes de compression
vp_weld= 5500;

[vp_true]=weld(vp_true , vp_weld , angl, rg, nz, nx , h , 'vp_true' , 1 , 212);

%paramètre de masse volumique
rho_weld=8000;

[rho_true]=weld(rho_true , rho_weld , angl, rg, nz, nx , h , 'rho_true' , 2 , 212);

%%%%%%%%%% Milieu : ajout d'une fissure %%%%%%%%%%

xpos_center=nx/2*h-0.0108;   %position du centre du défaut en m
zpos_center=10*l;

long=6*l; 			%longueur du crack en m
Larg=h;				%largeur du crack en m
angl= 65;

%paramètre de vitesse des ondes de compression
vp_crack=5000;

[vp_true ]=crack(vp_true , vp_crack , Larg , long , angl, xpos_center,zpos_center , nz ,  nx , h , 'vp_true' , 1 , 212) ;

%paramètre de vitesse des ondes de cisaillement
vs_crack=100;

[vs_true ]=crack(vs_true , vs_crack , Larg , long , angl, xpos_center,zpos_center , nz ,  nx , h , 'vs_true' , 3 , 212) ;

%paramètre de masse volumique
rho_crack=3000;

[rho_true ]=crack(rho_true , rho_crack , Larg , long , angl, xpos_center,zpos_center , nz ,  nx , h , 'rho_true' , 2 , 212) ;


%%%%%%%%%% Milieu : ajout d'une inclusion %%%%%%%%%%

xpos_center=ceil(nx/2)*h;   %position du centre du défaut en m
zpos_center=10*l;
r=l/4;						%rayon de l'inclusion en m

% paramètre de vitesse des ondes de compression
vp_inclusion=5000;

[vp_true ]= inclusion(vp_true , vp_inclusion , r , xpos_center , zpos_center , nz , nx , h , 'vp_true' , 1 , 212);

%paramètre de vitesse des ondes de cisaillement
vs_inclusion = 100;

[vs_true ]= inclusion(vs_true , vs_inclusion , r , xpos_center , zpos_center , nz , nx , h , 'vs_true' , 3 , 212);

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

%paramètre de vitesse des ondes de compression
vp_inclusion=5000;
%[vp_true]=Ninclusions(vp_true , vp_inclusion , r, pitch , xpos_center , zpos_center , nz , nx , h , nb_inclusion ,  'vp_true' , 1 , 212);

%paramètre de masse volumiques
rho_inclusion=5000;
%[rho_true]=Ninclusions(rho_true , rho_inclusion , r, pitch , xpos_center , zpos_center , nz , nx , h , nb_inclusion ,  'rho_true' , 2 , 212);

%%%%%%%%%% Duplication du milieu 2D pour passage en "3D" %%%%%%%%%%

vp_init=vp_init.*ones(1,1,ny);
vs_init=vs_init.*ones(1,1,ny);
rho_init=rho_init.*ones(1,1,ny);
vp_true=vp_true.*ones(1,1,ny);
vs_true=vs_true.*ones(1,1,ny);
rho_true= rho_true.*ones(1,1,ny);


	fid=fopen('vs_init','w+');
	fwrite(fid, vs_init(:,:,:),'single');
	fclose(fid);
	
	fid=fopen('vs_true','w+');
	fwrite(fid, vs_true(:,:,:),'single');
	fclose(fid);
	
	fid=fopen('vp_init','w+');
	fwrite(fid, vp_init(:,:,:),'single');
	fclose(fid);

	fid=fopen('vp_true','w+');
	fwrite(fid, vp_true(:,:,:),'single');
	fclose(fid);
	
	fid=fopen('rho_true','w+');
	fwrite(fid, rho_true(:,:,:),'single');
	fclose(fid);

	fid=fopen('rho_init','w+');
	fwrite(fid, rho_init(:,:,:),'single');
	fclose(fid);


%%%%%%%%%% Sources/recepteurs : generation du fichier acqui %%%%%%%%%%
%sonde immobile et chaque element est considere ponctuel
nb_elements=64;		%number of active elements	
pitch=0.001;
			%center-to-center distance between 2 successive elements
zpos_sources1 =h; 			%z position of the probe (in m)
xpos_sources1 =floor(nx/2)*h; 	%position of array center (in m)

zpos_recep1 =(nz-1)*h;
xpos_recep1 =  xpos_sources1;

xpos_sources2 = xpos_sources1;
zpos_sources2= (nz-1)*h-2*h;

zpos_recep2 = zpos_sources2;
xpos_recep2 = xpos_sources2;

ypos=ny/2*h;



%[x_sources, z_sources, x_recep, z_recep]=acqui_generation_multielement_ELAS(nb_elements , pitch , zpos_sources1 , xpos_sources1 , zpos_recep1 , xpos_recep1 , ypos , nz , nx , ny, h , 'on');

%[x_sources z_sources x_recep z_recep]= acqui_generation_multielement_2trans_ELAS(nb_elements , pitch ,  zpos_sources1 , xpos_sources1 , zpos_sources2 , xpos_sources2 , zpos_recep1 , xpos_recep1 , zpos_recep2 , xpos_recep2 , ypos , nz , nx , ny, h , 'on');

%[x_sources z_sources x_recep z_recep]= acqui_generation_multielement_reflex_trans(nb_elements , pitch , zpos_sources1 , xpos_sources1 , zpos_recep1 , xpos_recep1 , zpos_recep2 , xpos_recep2 , nz , nx , h , 'on' );
nb_src=32;
nb_recep=64;

z_sources = h*ones(1,nb_src);
x_sources = 0.018500:2e-3:0.081500;
y_sources = ypos*ones(1,nb_src);

z_recepts = [(nz-1)*h*ones(1,nb_recep) ];
x_recepts = [0.018500:1e-3:0.081500];
y_recepts = ypos*ones(1,nb_recep);

[x_recep z_recep y_recep] = acqui_generation(z_sources,x_sources,y_sources,z_recepts,x_recepts,y_recepts, nz, nx,h , 'on');


%%%%%%%%%% Schema donnant la disposition des transducteurs %%%%%%%%%%
	figure(1)
	hold on
	scatter(x_sources, z_sources,'green','o','filled');
	hold on
	scatter(x_recep, z_recep,'black','o','filled');
	hold off
	colorbar("EastOutside")
	print -dpng config.png

%%%%%%%%%% Generation du signal d'excitation fricker %%%%%%%%%%

fricker_generation(f,2000,dt,1)



