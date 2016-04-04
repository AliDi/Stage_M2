%%%%%%% milieu : 2 couches lissées %%%%%%%
function []=vp_init_generation(vp1, vp2, nz, nx, ny)
	
	x=[1:nz/2-nz/10-1 nz/2-nz/10 nz/2 nz/2+nz/10 nz/2+nz/10+1:nz];
	l1=length(1:nz/2-nz/10-1);
	l2=length(nz/2+nz/10+1:nz);
	y=[vp1*ones(1,l1) vp1 (vp1+vp2)/2 vp2 vp2*ones(1,l2)];
	p=polyfit(x,y,17);
	vp=polyval(p,1:nz);
	figure;
	plot(vp);
	
	vp=vp'*ones(1,nx);
	
	
	fid=fopen('vp_init','w+');
	fwrite(fid, vp(:,:,:),'single');
	fclose(fid);
	
end

%fid=fopen
%fwrite(fid, matrice(:, :,:),'single')

%save("-binary","vp_binaire","vp") 
