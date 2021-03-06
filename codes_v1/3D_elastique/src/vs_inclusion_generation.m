%vs : vitesse des ondes  transversale du milieu
%vs_inclusion : vitesse des ondes transversales dans l'inclusion
%r : rayon de l'inclusion en m
%xpos, ypos : coordonnees du centre de l'inclusion 
%nx,nz : taille du milieu
%
%usage : [vs]=vs_inclusion_generation( vs , vs_inclusion, r ,xpos_center,zpos_center, nz, nx,h)

function [vs]=vs_inclusion_generation( vs , vs_inclusion, r ,xpos_center,zpos_center, nz, nx,h)

	n_r=round(r/h);						%nombre de points du rayon
	n_xpos_center=round(xpos_center/h); %position du centre en nb de points
	n_zpos_center=round(zpos_center/h);
	
	%formation de l'inclusion en disque
	for (x=1:nx)
		for (z=1:nz)
			if (((x-n_xpos_center)^2 +(z-n_zpos_center)^2) <= (n_r^2)) %i.e. dans l'inclusion
				vs(z,x)= vs_inclusion ;
			end
		end
	
	end
	
	
%%%%%%%%%% Illustration %%%%%%%%%%
	
	figure(103)
	subplot(212)
	imagesc([0 nx*h-h],[0 nz*h-h],vs);
	c=colorbar;
	title('vs\_true');
		
	
%%%%%%%%%% Sauvegarde dans le fichier vs_true %%%%%%%%%%


	fid=fopen('vs_true','w+');
	fwrite(fid, vs(:,:),'single');
	fclose(fid);
	

end

%save("-binary","vp_binaire","vp") 

