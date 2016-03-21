%vp1 : vitesse du milieu
%vp2 : vitesse dans l'inclusion
%r : rayon de l'inclusion en m
%xpos, ypos : coordonnees du centre de l'inclusion 
%nx,nz : taille du milieu

function []=vp_true_inclusion(vp1,vp2,r,xpos_center,zpos_center, nz, nx,h)

	n_r=floor(r/h);						%nombre de points du rayon
	n_xpos_center=floor(xpos_center/h); %position du centre en nb de points
	n_zpos_center=floor(zpos_center/h);
	
	%formation de l'inclusion en disque
	for (x=1:nx)
		for (z=1:nz)
			if (((x-n_xpos_center)^2 +(z-n_zpos_center)^2) <= (n_r^2))
				m(z,x)=vp2;
			else
				m(z,x)=vp1;
			end
		end
	
	end
	
	imagesc(m)
	colorbar
	title('inclusion')

	fid=fopen('vp_true_inclusion','w+');
	fwrite(fid, m(:,:),'single');
	fclose(fid);
	
end

%save("-binary","vp_binaire","vp") 

