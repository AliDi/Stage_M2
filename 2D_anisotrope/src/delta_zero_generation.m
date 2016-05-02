%%%%%%% milieu : 2 couches lissées %%%%%%%
function []=delta_zero_generation(nz, nx,h)

	delta=-00/100*ones(nz,nx);
	
%%%%%%%%%% Sauvegarde dans le fichier delta_zero %%%%%%%%%%

	fid=fopen('delta_zero','w+');
	fwrite(fid, delta(:,:,:),'single');
	fclose(fid);
	
end

%fid=fopen
%fwrite(fid, matrice(:, :,:),'single')

%save("-binary","vp_binaire","vp") 
