%%%%%%% milieu : soudure en V %%%%%%%
%angl est en degre : donne l'angle du bord droit de la soudure
%rg : root gap (m)
%vp et rho sont les matrices des milieux à modifier
%vp_weld et rho_weld sont les valeurs (scalaires) de la vitesse et de la masse volumique dans la soudure
%
% usage : [vp,rho]=vp_weld_generation(vp, vp_weld , rho, rho_weld, angl, rg, nz, nx,h)
%
%sortie en binaire dans les fichiers 'vp_true' et 'rho_true'
% 
 
function [vp,rho]=vp_weld_generation(vp, vp_weld , rho, rho_weld, angl, rg, nz, nx,h)
	
	a1=-tan(abs(angl*pi/180)); 	%coefficient directeur du bord droit de la sourdure
	a2 = -a1;
	
	b1=nz*h-a1 * 0.5*(nx*h+rg);
	b2=nz*h-a2 * 0.5*(nx*h-rg);
	
	x=linspace(0,nx*h,nx);
	z=linspace(0,nz*h,nz);
	
	for (j=1:nx)
		for (i=1:nz)
						
			if ( ((z(i)-a1*x(j))<= b1) && ((z(i)-a2*x(j))<= b2 ) ) %i.e. dans la soudure
				vp(i,j)=vp_weld;
				rho(i,j)=rho_weld;
			end
		end
	end
	
x=0:h:nx*h;

	
%%%%%%%%%% Illustration %%%%%%%%%%
	
	figure(100)
	subplot(212)
	imagesc([0 nx*h-h],[0 nz*h-h],vp)
	colorbar
	title('vp\_true')
	
	figure(101)
	subplot(212)
	imagesc([0 nx*h-h],[0 nz*h-h],rho)
	colorbar
	title('rho\_true')
	
%%%%%%%%%% Sauvegarde dans le fichier vp_true_inclusion %%%%%%%%%%

	fid=fopen('vp_true','w+');
	fwrite(fid, vp(:,:),'single');
	fclose(fid);
	
	fid=fopen('rho_true','w+');
	fwrite(fid, rho(:,:),'single');
	fclose(fid);
	
end
