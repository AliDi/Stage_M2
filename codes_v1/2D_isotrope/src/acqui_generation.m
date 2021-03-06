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
%permet de placer des sources et recepteurs en donnant leurs coordonnées en m
%
%usage : []= acqui_generation(z_sources,x_sources,y_sources,z_recepts,x_recepts,y_recepts, nz, nx,h , grille)

function [x_recepts z_recepts y_recepts]= acqui_generation(z_sources,x_sources,y_sources,z_recepts,x_recepts,y_recepts, nz, nx,h , grille)

	nb_sources = length(z_sources);
	nb_recepts = length(z_recepts);
 
	if ( max(z_sources)>nz*h || max(x_sources)>nx*h || max(z_recepts)>nz*h || max(x_recepts)>nx*h  )
		disp("Au moins une source ou un récepteur se trouve hors de la zone d'étude")
	end
	
%%%%%%%%%% Placement des sources/recep sur la grille d'échantillonnage %%%%%%%%%%

	if(grille=='on')
		x_sources = round(x_sources./h).*h;
		z_sources = round(z_sources./h).*h;
		y_sources = round(y_sources./h).*h;	
		x_recepts = round(x_recepts./h).*h;
		z_recepts = round(z_recepts./h).*h;
		y_recepts = round(y_recepts./h).*h;	
	end	





	for i=1:nb_sources
		acqui(i+(i-1)*nb_recepts,1:6) = [z_sources(i) x_sources(i) y_sources(i) 0 0 0];
		acqui(i+(i-1)*nb_recepts+1 : i+(i-1)*nb_recepts+nb_recepts, 1:6) = [z_recepts' x_recepts' y_recepts' zeros(nb_recepts,1) zeros(nb_recepts,1) ones(nb_recepts,1)];		
	end
	
	acqui=acqui';
	fid=fopen('acqui_file','w+');
	fprintf(fid,'%f %f %f %f %f %f\n', acqui(:, :,:));
	fclose(fid);
	

	%save("-ascii","acqui_file","acqui")
	
	

%%%% schema donnant la disposition %%%%
	figure(100)
	hold on
	scatter(x_sources, z_sources,'green','o','filled');
	hold on
	scatter(x_recepts, z_recepts,'black','o','filled');
	hold off
end

