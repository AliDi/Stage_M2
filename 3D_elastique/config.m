%Pour du 2.5D en ultrason, avec sonde multi-éléments IMMOBILE.

clear all; close all;

R=1;%e-5; 			%rapport d'echelle  : 10^5 pour passer de CND->Geophys
					%n'est a changer que sur la frequence, puisque les autres dimensions sont definies a partir de la longueur d'onde l

%%%%%%%%%% Constantes du probleme %%%%%%%%%%

f=2e6*R;			% frequence centrale du transducteur en Hz
vp=6000;			%vitesse des ondes p en m/s
vs=3200;			%vitesse des ondes T
l=vp/f;				%longueur d'onde en m

h=vp/(2*2e6)/6				%pas de discrétisation : en fdtd o(4), respecter 5 pts par longueur d'onde

nz=floor(0.10/h) %floor(10*l /h)				%nb de points en z
nx=floor(0.05/h) %floor(50*l/2 /h)	
ny=floor(0.01/h)			%nb de points en x

dt=8e-9/R;




%%%%%%%%%% Milieu pour le probleme direct : generation du fichier vp_init et epsilon_init%%%%%%%%%%
rho=8000;

[vp_true rho_true]=vp_init_generation(vp,rho, nz, nx,h); %generation du fichier vp_init 

[vs_true]=vs_init_generation(vs ,  nz , nx , h);

vs_init=vs_true;
vp_init=vp_true;
rho_init=rho_true;

%epsilon_init=0;		%pas d'anisotropie
%epsilon_init_generation(epsilon_init, nz, nx,h);



%%%%%%%%%% Milieu : ajout d'une soudure %%%%%%%%%%

vp_weld= 5500;
rho_weld=8000;
angl = 65;			%angle du bord droit de la soudure en degre
rg = l;			%root gap en m
%[vp_true rho_true]=vp_weld_generation(vp_true , vp_weld , rho_true , rho_weld , angl , rg , nz , nx , h );




%%%%%%%%%% Milieu : ajout d'une fissure %%%%%%%%%%

xpos_center=nx/2*h-0.0108;   %position du centre du défaut en m
zpos_center=10*l;

Larg=6*l; 			%longueur du crack en m
long=h;				%largeur du crack en m
angl= 65;
vp_crack=5000;
rho_crack=5000;


%[vp_true rho_true]=vp_true_crack(vp_true , vp_crack , rho_true , rho_crack , long , Larg , angl , xpos_center , zpos_center , nz , nx , h);




%%%%%%%%%% Milieu : ajout d'une inclusion %%%%%%%%%%

xpos_center=ceil(nx/2)*h;   %position du centre du défaut en m
zpos_center=10*l;

vp_inclusion=5000;
vs_inclusion = 2000;
rho_inclusion=5000;
r=l/4;						%rayon de l'inclusion en m

[vp_true rho_true]=vp_true_inclusion(vp_true , vp_inclusion , rho_true , rho_inclusion , r , xpos_center , zpos_center , nz , nx , h);

[vs_true] = vs_inclusion_generation( vs_true , vs_inclusion, r , xpos_center ,zpos_center, nz, nx , h);

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
nb_elements=32;		%number of active elements	
pitch=0.001;
			%center-to-center distance between 2 successive elements
zpos_sources =h; 			%z position of the probe (in m)
xpos_sources =floor(nx/2)*h; 	%position of array center (in m)

zpos_recep = h;
xpos_recep =  xpos_sources;

ypos=ny/2*h;


[x_sources, z_sources, x_recep, z_recep]=acqui_generation_multielement_ELAS(nb_elements , pitch , zpos_sources , xpos_sources , zpos_recep , xpos_recep , ypos , nz , nx , h , 'on');

%[x_sources z_sources x_recep z_recep]= acqui_generation_multielement_2trans(nb_elements , pitch ,  zpos_sources1 , xpos_sources1 , zpos_sources2 , xpos_sources2 , zpos_recep1 , xpos_recep1 , zpos_recep2 , xpos_recep2 , nz , nx , h , 'on');

%[x_sources z_sources x_recep z_recep]= acqui_generation_multielement_reflex_trans(nb_elements , pitch , zpos_sources1 , xpos_sources1 , zpos_recep1 , xpos_recep1 , zpos_recep2 , xpos_recep2 , nz , nx , h , 'on' );



%%%%%%%%%%% Vérification du critère de courant (fdtd 2D) %%%%%%%%%%
%a1=1.125; 			%d'apres le code TOY2DAC.......
%a2 = -1/24;
%dt_max=h/(sqrt(2)*(abs(a1)+abs(a2))) / max(max(max([vp_true])));


%disp(["Avec h=" num2str(h) " m, il faut que dt <= " num2str(dt_max) "s.\n\n"])

%%%%%%%%%% Generation du signal d'excitation fricker %%%%%%%%%%

fricker_generation(f,1024,dt)
title('excitation')




figure(100)
colorbar("EastOutside")

