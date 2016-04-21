%vp : vitesse du milieu
%vp_inclusion : vitesse dans l'inclusion
%r : rayon de l'inclusion en m
%xpos, ypos : coordonnees du centre de l'inclusion 
%nx,nz : taille du milieu

function [vp,rho]=vp_true_inclusion(vp,vp_inclusion,rho, rho_inclusion , r,xpos_center,zpos_center, nz, nx,h)

	n_r=round(r/h);						%nombre de points du rayon
	n_xpos_center=round(xpos_center/h); %position du centre en nb de points
	n_zpos_center=round(zpos_center/h);
	
	%formation de l'inclusion en disque
	for (x=1:nx)
		for (z=1:nz)
			if (((x-n_xpos_center)^2 +(z-n_zpos_center)^2) <= (n_r^2)) %i.e. dans l'inclusion
				vp(z,x)=vp_inclusion;
				rho(z,x)=rho_inclusion;
			end
		end
	
	end
	
	
%%%%%%%%%% Illustration %%%%%%%%%%
	
	figure(100)
	subplot(212)
	imagesc([0 nx*h-h],[0 nz*h-h],vp)
	colorbar
	title('vp\_true')
	
	figure(101)
	subplot(212)
	imagesc([0 nx*h-h],[0 nz*h-h],rho)
	colorbar
	title('rho\_true')
	
%%%%%%%%%% Sauvegarde dans le fichier vp_true_inclusion %%%%%%%%%%

	fid=fopen('vp_true','w+');
	fwrite(fid, vp(:,:),'single');
	fclose(fid);
	
	fid=fopen('rho_true','w+');
	fwrite(fid, rho(:,:),'single');
	fclose(fid);
	

end

%save("-binary","vp_binaire","vp") 

