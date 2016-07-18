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
	
%%%%%%%%%% Simulation de surface libre %%%%%%%%%%

	%e_sl=10; 		%10 points d'épaisseur pour la simulation de surface libre
	%v_sl=1500;		%vitesse dans le second milieu
	%vp(end-10:end,:)=v_sl;
	
%%%%%%%%%% Illustration %%%%%%%%%%
	
	figure
	imagesc([0 nx*h-h],[0 nz*h-h],vp)
	colorbar
	title('vp\_init')

%%%%%%%%%% Sauvegarde dans le fichier vp_init %%%%%%%%%%

	fid=fopen('vp_init','w+');
	fwrite(fid, vp(:,:,:),'single');
	fclose(fid);
	
end

%fid=fopen
%fwrite(fid, matrice(:, :,:),'single')

%save("-binary","vp_binaire","vp") 
