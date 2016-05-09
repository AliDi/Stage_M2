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


%the probe is fixed
%the probe is along the x axis, emitting along z axis
%one element for excitation, all the elements for reception

%zpos_ et xpos_ sont les positions en m du centre des transducteurs multi-elements

%cette fonction place les éléments de manière à tomber exactement sur les points de la grille définie par nz,nx et h si grille=='on'

function [x_sources z_sources x_recep z_recep]= acqui_generation_multielement_ELAS(nb_elements , pitch , zpos_sources , xpos_sources , zpos_recep , xpos_recep , ypos , nz , nx , h , grille )

	aperture = (nb_elements-1)*pitch; %total length of the probe

%%%%%%%%%% Positionnement des elements en m %%%%%%%%%%
	x_sources= xpos_sources-(nb_elements-1)*pitch/2 : pitch : xpos_sources+(nb_elements-1)*pitch/2; 			

	z_sources=zpos_sources*ones(1,nb_elements);
	
	x_recep= xpos_recep-(nb_elements-1)*pitch/2 : pitch : xpos_recep+(nb_elements-1)*pitch/2; 			

	z_recep=zpos_recep*ones(1,nb_elements);
	
	y_elements=ypos*ones(1,nb_elements); %2D
	
	
%%%%%%%%%% Placement des sources/recep sur la grille d'échantillonnage %%%%%%%%%%

	if(grille=='on')
		x_sources = floor(x_sources./h).*h;
		z_sources = round(z_sources./h).*h;	
		x_recep = floor(x_recep./h).*h;
		z_recep = round(z_recep./h).*h;	
		y_elements = round(y_elements./h).*h;
	end


%%%%%%%%%% Generation de la matrice %%%%%%%%%%
	for i=1:nb_elements
		acqui(i+(i-1)*nb_elements,1:6) = [z_sources(i) x_sources(i) y_elements(i) 0 0 0];
		acqui(i+(i-1)*nb_elements+1 : i+(i-1)*nb_elements+nb_elements, 1:6) = [z_recep' x_recep' y_elements' zeros(nb_elements,1) zeros(nb_elements,1) ones(nb_elements,1)];		
	end
	
	acqui=acqui';
	
	
%%%%%%%%%% Impression dans un fichier, en ascii, single precision %%%%%%%%%%
	fid=fopen('acqui_file','w+');
	fprintf(fid,'%f %f %f %f %f %f\n', acqui(:, :,:));
	fclose(fid);

	%save("-ascii","acqui_file","acqui")

%%%%%%%%%% Schema donnant la disposition des transducteurs %%%%%%%%%%
	figure
	scatter3(x_sources, y_elements,-z_sources,'black','s','filled');
	hold on
	scatter3(x_recep, y_elements,-z_recep,'blue','s','filled');
	%view([0 0])
	xlabel('x')
	ylabel('y')
	zlabel('z')
	axis([0 nx*h 0 10 -nz*h 0.3*nz*h])

end

