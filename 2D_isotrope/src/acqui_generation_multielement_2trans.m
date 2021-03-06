%rappel : l'origine est forcement en (0,0,0) 
% format du fichier à generer : (dernier chiffre : 0 pour source, 1 pour reception
% z_source1	x_source1	y_source1	0	0	0
% z_recep1	x_recep1	y_recep1	0	0	1
% ...
% z_recepN	x_recepN	y_recepN	0	0	1
% ...
% z_sourceN	x_sourceN	y_sourceN	0	0	0
% z_recep1	x_recep1	y_recep1	0	0	1
% ...
% z_recepN	x_recepN	y_recepN	0	0	1
%
%Les sondes sont fixes. La longueur est placées suivant x
%zpos_ et xpos_ sont les positions en m du centre des transducteurs multi-elements
%
%On considère 4 positions de barrettes : 2 en émission (en position z/xpos_sources1 et z/xpos_sources2) et 2 en réception (en position z/xpos_recep1 et z/xpos_recep2).
%
%cette fonction place les éléments de manière à tomber exactement sur les points de la grille définie par nz,nx et h si grille=='on'
%
% usage : [x_sources z_sources x_recep z_recep]= acqui_generation_multielement_2trans(nb_elements , pitch ,  zpos_sources1 , xpos_sources1 , zpos_sources2 , xpos_sources2 , zpos_recep1 , xpos_recep1 , zpos_recep2 , xpos_recep2 , nz , nx , h , grille)
%
function [x_sources z_sources x_recep z_recep]= acqui_generation_multielement_2trans(nb_elements , pitch ,  zpos_sources1 , xpos_sources1 , zpos_sources2 , xpos_sources2 , zpos_recep1 , xpos_recep1 , zpos_recep2 , xpos_recep2 , nz , nx , h , grille)

	aperture = (nb_elements-1)*pitch; %total length of the probe
	
	nb_source=2*nb_elements;
	nb_recep=2*nb_elements;

%%%%%%%%%% Positionnement des elements en m %%%%%%%%%%

%pour le premier transducteur
	x_sources= xpos_sources1-(nb_elements-1)*pitch/2 : pitch : xpos_sources1+(nb_elements-1)*pitch/2; 			

	z_sources=zpos_sources1*ones(1,nb_elements);
	
	x_recep= xpos_recep1-(nb_elements-1)*pitch/2 : pitch : xpos_recep1+(nb_elements-1)*pitch/2;
	
	z_recep=zpos_recep1*ones(1,nb_elements);
	

	
%pour le second transducteur
	x_sources = [x_sources xpos_sources2-(nb_elements-1)*pitch/2 : pitch : xpos_sources2+(nb_elements-1)*pitch/2];

	z_sources = [z_sources zpos_sources2*ones(1,nb_elements)];

	x_recep= [x_recep  xpos_recep2-(nb_elements-1)*pitch/2 : pitch : xpos_recep2+(nb_elements-1)*pitch/2]; 
	
	z_recep=[z_recep zpos_recep2*ones(1,nb_elements)];
	
	
%en y
	y_recep=zeros(1,2*nb_elements); %2D
	y_sources=zeros(1,2*nb_elements); %2D
	
	
%%%%%%%%%% Placement des sources/recep sur la grille d'échantillonnage %%%%%%%%%%

	if(grille=='on')
		x_sources = round(x_sources./h).*h;
		z_sources = round(z_sources./h).*h;	
		x_recep = round(x_recep./h).*h;
		z_recep = round(z_recep./h).*h;	
	end

%%%%%%%%%% Generation de la matrice %%%%%%%%%%
	for i=1:nb_source
		acqui(i+(i-1)*nb_recep,1:6) = [z_sources(i) x_sources(i) y_sources(i) 0 0 0];
		acqui(i+(i-1)*nb_recep+1 : i+(i-1)*nb_recep+nb_recep, 1:6) = [z_recep' x_recep' y_recep' zeros(nb_recep,1) zeros(nb_recep,1) ones(nb_recep,1)];		
	end
	
	acqui=acqui';
	
	
%%%%%%%%%% Impression dans un fichier, en ascii, single precision %%%%%%%%%%
	fid=fopen('acqui_file','w+');
	fprintf(fid,'%f %f %f %f %f %f\n', acqui(:, :,:));
	fclose(fid);

end

