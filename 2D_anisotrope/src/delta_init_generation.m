%milieu décrit par delta uniforme, de valeur delta_init (scalaire)
%
%usage : [delta]=delta_init_generation(delta_init, nz, nx,h)

function [delta]=delta_init_generation(delta_init, nz, nx,h)

	delta=delta_init*ones(nz,nx);
	
%%%%%%%%%% Illustration %%%%%%%%%%
	
	figure(104)
	subplot(2,1,1)
	imagesc([0 nx*h-h],[0 nz*h-h],delta);
	c=colorbar;
	set(c,'title','%');
	title('delta\_init');

%%%%%%%%%% Sauvegarde dans le fichier vp_init %%%%%%%%%%

	fid=fopen('delta_init','w+');
	fwrite(fid, delta(:,:,:),'single');
	fclose(fid);
	
end

%fid=fopen
%fwrite(fid, matrice(:, :,:),'single')

%save("-binary","vp_binaire","vp") 
