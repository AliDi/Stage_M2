%%%%%%% milieu : 2 couches lissées %%%%%%%
function []=vp_init_generation(vp1, vp2, nz, nx,h)
	
	vp=[vp1*ones(1,floor(nz/2)) vp2*ones(1,ceil(nz/2))];	
	
	N=floor(nz/10); 	% number of points of the local averaging
	vp=[vp1*ones(1,N) vp]; %rajout de N points en amont pour ce qui sera coupé au filtre
	F=4/nz; 			%frequence spatiale de coupure (normalisée)
	h2=fir1(N,F);
	vp = filter(h2,1,vp);
	vp=vp(1,(N+1):end); 

	vp=vp'*ones(1,nx);
	

%%%%%%%%%% Illustration %%%%%%%%%%
	
	figure
	imagesc([0 nx*h-1],[0 nz*h-1],vp)
	colorbar
	title('vp\_init')

%%%%%%%%%% Sauvegarde dans le fichier vp_init %%%%%%%%%%

	fid=fopen('vp_init','w+');
	fwrite(fid, vp(:,:,:),'single');
	fclose(fid);
	
end

