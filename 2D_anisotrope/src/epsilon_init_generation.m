%%%%%%% milieu : 2 couches lissées %%%%%%%
function []=epsilon_init_generation(epsilon_init, nz, nx,h)

	epsilon=epsilon_init*ones(nz,nx);
	
%%%%%%%%%% Simulation de surface libre %%%%%%%%%%

	%e_sl=10; 		%10 points d'épaisseur pour la simulation de surface libre
	%v_sl=1500;		%vitesse dans le second milieu
	%vp(end-10:end,:)=v_sl;
	
%%%%%%%%%% Illustration %%%%%%%%%%
	
	figure
	imagesc([0 nx*h-h],[0 nz*h-h],epsilon);
	colorbar;
	title('epsilon\_init');

%%%%%%%%%% Sauvegarde dans le fichier vp_init %%%%%%%%%%

	fid=fopen('epsilon_init','w+');
	fwrite(fid, epsilon(:,:,:),'single');
	fclose(fid);
	
end

%fid=fopen
%fwrite(fid, matrice(:, :,:),'single')

%save("-binary","vp_binaire","vp") 
