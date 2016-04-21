%%%%%%% milieu : soudure en V %%%%%%%
%angl est en degre
%rg : root gap (m)
function []=vp_epsilon_weld_generation(vp, vp_weld_h, vp_weld_v,angl, rg, nz, nx,h)

	a1=-tan(abs(angl*pi/180)); 	%coefficient directeur du bord droit de la sourdure
	a2 = -a1;
	
	b1=nz*h-a1 * 0.5*(nx*h+rg);
	b2=nz*h-a2 * 0.5*(nx*h-rg);
	
	x=linspace(0,nx*h,nx);
	z=linspace(0,nz*h,nz);
	
	for (j=1:nx)
		for (i=1:nz)
						
			if ( ((z(i)-a1*x(j))<= b1) && ((z(i)-a2*x(j))<= b2 ) ) %ie au niveau de la soudure
				m(i,j)=vp_weld_v;
				epsilon(i,j)= (vp_weld_h - vp_weld_v ) / vp_weld_v;
			else
				m(i,j)=vp;
				epsilon(i,j)= 0; %isotrope hors de la soudure
			end
		end
	end
	
x=0:h:nx*h;

	
%%%%%%%%%% Illustration %%%%%%%%%%
	
	figure
	subplot(2,1,1);
	imagesc([0 nx*h-h],[0 nz*h-h],m);
	colorbar;
	title('vpV\_true');
	
	subplot(2,1,2);
	imagesc([0 nx*h-h],[0 nz*h-h],epsilon*100);
	c=colorbar;
	set(c,'title','%');
	title('epsilon\_true');
	
%%%%%%%%%% Sauvegarde dans le fichier vp_true_inclusion %%%%%%%%%%

	fid=fopen('vp_true_weld','w+');
	fwrite(fid, m(:,:),'single');
	fclose(fid);
	
	fid= fopen('epsilon', 'w+');
	fwrite(fid,epsilon(:,:), 'single');
	fclose(fid);	
	
end
