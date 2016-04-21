%%%%%%% milieu : 2 couches lissées %%%%%%%
function [epsilon]=epsilon_init_generation(epsilon_init, nz, nx,h)

	epsilon=epsilon_init*ones(nz,nx);
	
%%%%%%%%%% Illustration %%%%%%%%%%
	
	figure(103)
	subplot(2,1,1)
	imagesc([0 nx*h-h],[0 nz*h-h],epsilon);
	c=colorbar;
	set(c,'title','%');
	title('epsilon\_init');

%%%%%%%%%% Sauvegarde dans le fichier vp_init %%%%%%%%%%

	fid=fopen('epsilon_init','w+');
	fwrite(fid, epsilon(:,:,:),'single');
	fclose(fid);
	
end

%fid=fopen
%fwrite(fid, matrice(:, :,:),'single')

%save("-binary","vp_binaire","vp") 
