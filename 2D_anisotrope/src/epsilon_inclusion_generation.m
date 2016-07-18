%epsilon : milieu à modifier (matrice nz X nx)
%epsilon_inclusion : epsilon dans l'inclusion (scalaire)
%r : rayon de l'inclusion en m
%xpos, ypos : coordonnees du centre de l'inclusion 
%nx,nz : taille du milieu
%
%usage : [epsilon]=epsilon_inclusion_generation(epsilon_inclusion , epsilon ,  r,xpos_center,zpos_center, nz, nx,h)

function [epsilon]=epsilon_inclusion_generation(epsilon_inclusion , epsilon ,  r,xpos_center,zpos_center, nz, nx,h)

	n_r=round(r/h);						%nombre de points du rayon
	n_xpos_center=round(xpos_center/h); %position du centre en nb de points
	n_zpos_center=round(zpos_center/h);
	
	%formation de l'inclusion en disque
	for (x=1:nx)
		for (z=1:nz)
			if (((x-n_xpos_center)^2 +(z-n_zpos_center)^2) <= (n_r^2)) %i.e. dans l'inclusion
				epsilon(z,x)= epsilon_inclusion;
			end
		end
	
	end
	
	
%%%%%%%%%% Illustration %%%%%%%%%%
	
	figure(103)
	subplot(212)
	imagesc([0 nx*h-h],[0 nz*h-h],epsilon*100);
	c=colorbar;
	set(c,'title','%');
	title('epsilon\_true');
		
	
%%%%%%%%%% Sauvegarde dans le fichier epsilon_true %%%%%%%%%%

	fid=fopen('epsilon_true','w+');
	fwrite(fid, epsilon(:,:),'single');
	fclose(fid);
	

end

%save("-binary","vp_binaire","vp") 

