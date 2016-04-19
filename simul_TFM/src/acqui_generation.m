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

%permet de placer des sources et recepteurs en donnant leurs coordonnées en m

function []= acqui_generation(z_sources,x_sources,y_sources,z_recepts,x_recepts,y_recepts, nz, nx,h)

	nb_sources = length(z_sources);
	nb_recepts = length(z_recepts);
 
	if ( max(z_sources)>nz*h || max(x_sources)>nx*h || max(z_recepts)>nz*h || max(x_recepts)>nx*h  )
		disp("Au moins une source ou un récepteur se trouve hors de la zone d'étude")
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
	figure(1)
	scatter3(x_sources, y_sources,-z_sources, 10,'blue','*','filled');
	hold on 
	scatter3(x_recepts,y_recepts,-z_recepts,10,'black','v','filled');
	view([0 0])
	axis([0 nx*h 0 1 -nz*h 0])
end

