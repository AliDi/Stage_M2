%vp : vitesse du milieu à modifier (matrice nz X nx)
%rho : masse volumique à modifier (idem)
%vp_inclusion : vitesse dans l'inclusion (scalaire)
%rho_inclusion : masse volumique dans l'inclusion (scalaire)
%r : rayon de l'inclusion en m
%xpos, ypos : coordonnees du centre de l'inclusion 
%nx,nz : nombre de points du milieu
%N : nombre d'inclusions
%
%usage : [vp,rho]=vp_true_Ninclusions(vp,vp_inclusion , rho , rho_inclusion , r,pitch,xpos_center,zpos_center, nz, nx,h,N)
%
%sortie en binaire dans les fichiers 'vp_true' et 'rho_true'

function [vp,rho]=vp_true_Ninclusions(vp,vp_inclusion , rho , rho_inclusion , r,pitch,xpos_center,zpos_center, nz, nx,h,N)

	n_r=floor(r/h);						%nombre de points du rayon

	x_centers = xpos_center- (N-1) *pitch/2 : pitch : xpos_center + (N-1)*pitch/2;
	
	n_xpos_center=floor(x_centers/h); %position du centre en nb de points
	n_zpos_center=floor(zpos_center/h);

	for (n=1:N)	
		%formation de l'inclusion en disque
		for (x=1:nx)
			for (z=1:nz)
				if (((x-n_xpos_center(n))^2 +(z-n_zpos_center)^2) <= (n_r^2))
					vp(z,x)=vp_inclusion;
					rho(z,x) = rho_inclusion;
				end
			end
	
		end
	end
	
%%%%%%%%%% Simulation de surface libre %%%%%%%%%%

	%e_sl=10; 		%10 points d'épaisseur pour la simulation de surface libre
	%v_sl=1500;		%vitesse dans le second milieu
	%m(end-10:end,:)=v_sl;
	
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

