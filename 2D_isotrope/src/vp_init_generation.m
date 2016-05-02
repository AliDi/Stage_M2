%%%%%%% milieu : 2 couches lissées %%%%%%%
function [vp,rho]=vp_init_generation(vp,rho, nz, nx,h)
	
	vp=vp*ones(nz,nx);
	rho=rho*ones(nz,nx);
	

%%%%%%%%%% Illustration %%%%%%%%%%
	
	figure(101)
	subplot(211)
	imagesc([0 nx*h-h],[0 nz*h-h],rho)
	colorbar
	title('rho\_init')
	
	figure(100)
	subplot(211)
	imagesc([0 nx*h-h],[0 nz*h-h],vp)
	colorbar
	title('vp\_init')

%%%%%%%%%% Sauvegarde dans le fichier vp_init %%%%%%%%%%

	fid=fopen('vp_init','w+');
	fwrite(fid, vp(:,:,:),'single');
	fclose(fid);

%%%%%%%%%% Sauvegarde dans le fichier rho_init %%%%%%%%%%

	fid=fopen('rho_init','w+');
	fwrite(fid, rho(:,:,:),'single');
	fclose(fid);
	
end

%fid=fopen
%fwrite(fid, matrice(:, :,:),'single')

%save("-binary","vp_binaire","vp") 