%vp : paramètre du milieu à modifier (matrice nz X nx)
%vp_inclusion : valeur du paramètre dans l'inclusion (scalaire)
%r : rayon de l'inclusion en m
%xpos, ypos : coordonnees du centre de l'inclusion 
%nx,nz : taille du milieu
%
%nom_fichier : nom du fichier binaire pour l'exportation du milieu (string)
%
%num_figure : numéro de la figure pour un affichage du milieu généré. Si num_figure==0, pas d'affichage.
%num_plot : paramètre d'entrée de subplot
%
%usage : [ vp ]=inclusion(vp,vp_inclusion, r, xpos_center , zpos_center , nz , nx , h , nom_fichier , num_figure , num_subplot)
%


function [ vp ]=inclusion(vp,vp_inclusion, r, xpos_center , zpos_center , nz , nx , h , nom_fichier , num_figure , num_subplot)

	n_r=round(r/h);						%nombre de points du rayon
	n_xpos_center=round(xpos_center/h); %position du centre en nb de points
	n_zpos_center=round(zpos_center/h);
	
	%formation de l'inclusion en disque
	for (x=1:nx)
		for (z=1:nz)
			if (((x-n_xpos_center)^2 +(z-n_zpos_center)^2) <= (n_r^2)) %i.e. dans l'inclusion
				vp(z,x)=vp_inclusion;
			end
		end
	
	end
		
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

%save("-binary","vp_binaire","vp") 

