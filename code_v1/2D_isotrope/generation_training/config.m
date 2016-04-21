clear all; close all;

nz=141;
nx=141;
ny=1;  %2D
h=5; %pas de discrétisation

%%%% milieu : generation du fichier vp_true %%%%%%

vp1=2000; %m/s
vp2=2500;

vp_true_generation(vp1,vp2, nz, nx, ny); %bicouche, pour test

%%%% milieu pour le probleme direct : generation du fichier vp_init %%%%%%

vp_init_generation(vp1,vp2, nz, nx, ny); %generation du fichier vp_init 


%%%% sources/recepts : generation du fichier acqui %%%%
%position en m !!
z_sources = 90*ones(1,16);	%position des sources en profondeur
x_sources = linspace(100,600,16);	%position des sources suivant x
y_sources = zeros(1,16);		%position des sources suivant y

z_recepts = 500*ones(1,40);
x_recepts = linspace(100,600,40);
y_recepts = zeros(1,40);

acqui_generation(z_sources,x_sources,y_sources,z_recepts,x_recepts,y_recepts, nz, nx, ny,h); %generation du fichier donnant la configuration des sources et des recepteurs

