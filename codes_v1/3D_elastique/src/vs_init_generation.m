%génration d'un milieu de vitesse transversale uniforme de valeur vs_init_generation
%
%usage :  [vs]=vs_init_generation(vs_init, nz, nx,h)

function [vs]=vs_init_generation(vs_init, nz, nx,h)

	vs=vs_init*ones(nz,nx);
	
%%%%%%%%%% Illustration %%%%%%%%%%
	
	figure(103)
	subplot(2,1,1)
	imagesc([0 nx*h-h],[0 nz*h-h],vs);
	c=colorbar;
	title('vs\_init');

%%%%%%%%%% Sauvegarde dans le fichier vp_init %%%%%%%%%%
	
	fid=fopen('vs_init','w+');
	fwrite(fid, vs(:,:,:),'single');
	fclose(fid);
	
end

%fid=fopen
%fwrite(fid, matrice(:, :,:),'single')

%save("-binary","vp_binaire","vp") 
