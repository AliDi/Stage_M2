%Même fonction que 2D_isotrope/src/acqui_generation_multielement.m, avec en plus la nécessité de renseigner la taille de la troisième dimension ny
%La coordonnée en y de la position de la sonde est donnée par ypos.
%
%usage : [x_sources z_sources x_recep z_recep]= acqui_generation_multielement_2trans_ELAS(nb_elements , pitch ,  zpos_sources1 , xpos_sources1 , zpos_sources2 , xpos_sources2 , zpos_recep1 , xpos_recep1 , zpos_recep2 , xpos_recep2 , ypos , nz , nx , ny , h , grille)

function [x_sources z_sources x_recep z_recep]= acqui_generation_multielement_2trans_ELAS(nb_elements , pitch ,  zpos_sources1 , xpos_sources1 , zpos_sources2 , xpos_sources2 , zpos_recep1 , xpos_recep1 , zpos_recep2 , xpos_recep2 , ypos , nz , nx , ny , h , grille)

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
	y_recep=ypos*ones(1,2*nb_elements); %3D
	y_sources=ypos*ones(1,2*nb_elements); %3D
	
	
%%%%%%%%%% Placement des sources/recep sur la grille d'échantillonnage %%%%%%%%%%

	if(grille=='on')
		x_sources = round(x_sources./h).*h;
		z_sources = round(z_sources./h).*h;	
		y_sources = round(y_sources./h).*h;
		x_recep = round(x_recep./h).*h;
		z_recep = round(z_recep./h).*h;
		y_recep	= round(y_recep./h).*h;
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

	%save("-ascii","acqui_file","acqui")

%%%%%%%%%% Schema donnant la disposition des transducteurs %%%%%%%%%%
	figure
	scatter3(x_sources, y_sources,-z_sources,'black','s','filled');
	hold on
	scatter3(x_recep, y_recep,-z_recep,'blue','s','filled');
	%view([0 0])
	xlabel('x')
	ylabel('y')
	zlabel('z')
	axis([0 nx*h 0 ny*h -nz*h 0.3*nz*h])

end

