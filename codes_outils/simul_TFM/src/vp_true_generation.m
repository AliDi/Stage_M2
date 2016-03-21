%%%%%%% milieu de vitesse uniforme %%%%%%%
function []=vp_true_generation(vp1,vp2, nz, nx)

	vp(1:floor(nz/2),:,1)= vp1*ones(floor(nz/2),nx,1);
	vp(floor(nz/2)+1:nz,:,1)= vp2*ones(floor(nz/2)+1,nx,1);

	fid=fopen('vp_true','w+');
	fwrite(fid, vp(:,:,:),'single');
	fclose(fid);
	
end

%save("-binary","vp_binaire","vp") 
