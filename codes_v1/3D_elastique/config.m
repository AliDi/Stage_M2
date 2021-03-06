%Pour du 2.5D en ultrason, avec sonde multi-éléments IMMOBILE.

clear all; close all;

R=1;%e-5; 			%rapport d'echelle  : 10^5 pour passer de CND->Geophys
					%n'est a changer que sur la frequence, puisque les autres dimensions sont definies a partir de la longueur d'onde l

%%%%%%%%%% Constantes du probleme %%%%%%%%%%

f=1e6*R;			% frequence centrale du transducteur en Hz
vp=6000;			%vitesse des ondes p en m/s
vs=3200;			%vitesse des ondes T
l=vp/f;				%longueur d'onde en m

h=vp/(2*f)/6				%pas de discrétisation : en fdtd o(4), respecter 5 pts par longueur d'onde

nz=floor(0.05/h) %floor(10*l /h)				%nb de points en z
nx=floor(0.10/h) %floor(50*l/2 /h)	
ny=floor(0.01/h)			%nb de points en x

dt=8e-9/R;




%%%%%%%%%% Milieu pour le probleme direct : generation du fichier vp_init et epsilon_init%%%%%%%%%%
rho=8000;

[vp_true rho_true]=vp_init_generation(vp,rho, nz, nx,h); %generation du fichier vp_init 

vs_init = 200; %en inversion monoparamètre, s'assurer que vs< vp/sqrt(2)

[vs_true]=vs_init_generation(vs ,  nz , nx , h);

[vs_init]=vs_init_generation(vs ,  nz , nx , h);

vp_init=vp_true;
rho_init=rho_true;

%epsilon_init=0;		%pas d'anisotropie
%epsilon_init_generation(epsilon_init, nz, nx,h);



%%%%%%%%%% Milieu : ajout d'une soudure %%%%%%%%%%

vp_weld= 5500;
rho_weld=8000;
angl = 65;			%angle du bord droit de la soudure en degre
rg = l;			%root gap en m
[vp_true rho_true]=vp_weld_generation(vp_true , vp_weld , rho_true , rho_weld , angl , rg , nz , nx , h );




%%%%%%%%%% Milieu : ajout d'une fissure %%%%%%%%%%

xpos_center=nx/2*h-0.0125;   %position du centre du défaut en m
zpos_center=5*l;

Larg=6*3e-3; 			%longueur du crack en m
long=h;				%largeur du crack en m
angl= 65;
vp_crack=340;
vs_crack=100;
rho_crack=100;


[vp_true rho_true]=vp_true_crack(vp_true , vp_crack , rho_true , rho_crack , long , Larg , angl , xpos_center , zpos_center , nz , nx , h);

[vs_true]=vs_crack_generation( vs_true , vs_crack , long , Larg , angl , xpos_center , zpos_center , nz , nx , h);


%%%%%%%%%% Milieu : ajout d'une inclusion %%%%%%%%%%

xpos_center=ceil(nx/2)*h;   %position du centre du défaut en m
zpos_center=5*l;

vp_inclusion=340;
vs_inclusion = 100;
rho_inclusion=100;
r=0.75e-3;%l/4;						%rayon de l'inclusion en m

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
nb_recep=128;

z_sources = h*ones(1,nb_src);
x_sources = 0.018500:2e-3:0.081500;
y_sources = ypos*ones(1,nb_src);

z_recepts = [h*ones(1,nb_recep/2)  (nz-1)*h*ones(1,nb_recep/2) ];
x_recepts = [ 0.018500:1e-3:0.081500 0.018500:1e-3:0.081500];
y_recepts = ypos*ones(1,nb_recep);

acqui_generation(z_sources,x_sources,y_sources,z_recepts,x_recepts,y_recepts, nz, nx,h , 'on')



%%%%%%%%%%% Vérification du critère de courant (fdtd 2D) %%%%%%%%%%
%a1=1.125; 			%d'apres le code TOY2DAC.......
%a2 = -1/24;
%dt_max=h/(sqrt(2)*(abs(a1)+abs(a2))) / max(max(max([vp_true])));


%disp(["Avec h=" num2str(h) " m, il faut que dt <= " num2str(dt_max) "s.\n\n"])

%%%%%%%%%% Generation du signal d'excitation fricker %%%%%%%%%%

fricker_generation(f,3000,dt,10^10)
title('excitation')




figure(100)
colorbar("EastOutside")


