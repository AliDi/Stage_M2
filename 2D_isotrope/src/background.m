%génération des milieux uniformes
%vp  : valeur (scalaire) du milieu
%sortie : vp et rho sont les matrices des milieux uniformes, de dimension nz X nx
%nx,nz : taille du milieu
%
%nom_fichier : nom du fichier binaire pour l'exportation du milieu (string)
%
%num_figure : numéro de la figure pour un affichage du milieu généré. Si num_figure==0, pas d'affichage.
%num_plot : paramètre d'entrée de subplot
%

%usage : [vp]=background(vp , nz , nx , h , nom_fichier , num_figure , num_subplot)

function [vp]=background(vp , nz , nx , h , nom_fichier , num_figure , num_subplot)
	
	vp=vp*ones(nz,nx);

%%%%%%%%%% Illustration %%%%%%%%%%
	
	figure(num_figure)
	subplot(num_subplot)
	imagesc([0 nx*h-h],[0 nz*h-h],vp)
	colorbar
	title(nom_fichier)

	
%%%%%%%%%% Sauvegarde dans le fichier nom_fichier %%%%%%%%%%

	fid=fopen(nom_fichier,'w+');
	fwrite(fid, vp(:,:),'single');
	fclose(fid);
	
end

%fid=fopen
%fwrite(fid, matrice(:, :,:),'single')

%save("-binary","vp_binaire","vp") 
