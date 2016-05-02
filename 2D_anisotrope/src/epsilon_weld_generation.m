%%%%%%% milieu : soudure en V %%%%%%%
%angl est en degre
%rg : root gap (m)
function [epsilon]=epsilon_weld_generation(vp_weld_h , vp_weld_v , angl , rg , nz , nx , h)

	a1=-tan(abs(angl*pi/180)); 	%coefficient directeur du bord droit de la sourdure
	a2 = -a1;
	
	b1=nz*h-a1 * 0.5*(nx*h+rg);
	b2=nz*h-a2 * 0.5*(nx*h-rg);
	
	x=linspace(0,nx*h,nx);
	z=linspace(0,nz*h,nz);
	
	for (j=1:nx)
		for (i=1:nz)
						
			if ( ((z(i)-a1*x(j))<= b1) && ((z(i)-a2*x(j))<= b2 ) ) %ie au niveau de la soudure
				epsilon(i,j)= (vp_weld_h - vp_weld_v ) / vp_weld_v;
			else
				epsilon(i,j)= 0; %isotrope hors de la soudure
			end
		end
	end
	
	
%%%%%%%%%% Illustration %%%%%%%%%%
	
	figure(103)
	subplot(212)
	imagesc([0 nx*h-h],[0 nz*h-h],epsilon*100);
	c=colorbar;
	set(c,'title','%');
	title('epsilon\_true');
	
%%%%%%%%%% Sauvegarde dans le fichier vp_true_inclusion %%%%%%%%%%

	fid= fopen('epsilon_true', 'w+');
	fwrite(fid,epsilon(:,:), 'single');
	fclose(fid);	
	
end