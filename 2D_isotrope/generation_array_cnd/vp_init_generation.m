%%%%%%% milieu : 2 couches lissées %%%%%%%
function []=vp_init_generation(vp1, vp2, nz, nx)
	
	vp=[vp1*ones(1,floor(nz/2)) vp2*ones(1,ceil(nz/2))];	
	
	N=floor(nz/10); 	% number of points of the local averaging
	vp=[vp1*ones(1,N) vp]; %rajout de N points en amont pour ce qui sera coupé au filtre
	F=4/nz; 			%frequence spatiale de coupure (normalisée)
	h2=fir1(N,F);
	vp = filter(h2,1,vp);
	vp=vp(1,(N+1):end); 

	figure
	plot(vp)
	title('Profil de vp\_init')

	vp=vp'*ones(1,nx);
	fid=fopen('vp_init','w+');
	fwrite(fid, vp(:,:,:),'single');
	fclose(fid);
	
end

%fid=fopen
%fwrite(fid, matrice(:, :,:),'single')

%save("-binary","vp_binaire","vp") 
