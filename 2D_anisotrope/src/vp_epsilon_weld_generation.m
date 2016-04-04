%%%%%%% milieu : soudure en V %%%%%%%
%angl est en degre
%rg : root gap (m)
function []=vp_epsilon_weld_generation(vp1, vp2,C1,C2,angl, rg, nz, nx,h)

	a1=-tan(abs(angl*pi/180)); 	%coefficient directeur du bord droit de la sourdure
	a2 = -a1;
	
	b1=nz*h-a1 * 0.5*(nx*h+rg);
	b2=nz*h-a2 * 0.5*(nx*h-rg);
	
	x=linspace(0,nx*h,nx);
	z=linspace(0,nz*h,nz);
	
	for (j=1:nx)
		for (i=1:nz)
						
			if ( ((z(i)-a1*x(j))<= b1) && ((z(i)-a2*x(j))<= b2 ) ) %ie au niveau de la soudure
				m(i,j)=vp2;
				espilon(i,j)= ( C2(1,1) - C2(3,3) ) / ( 2*C2(3,3));
			else
				m(i,j)=vp1;
				espilon(i,j)= ( C1(1,1) - C1(3,3) ) / ( 2*C1(3,3));
			end
		end
	end
	
x=0:h:nx*h;

	
%%%%%%%%%% Illustration %%%%%%%%%%
	
	figure
	imagesc([0 nx*h-1],[0 nz*h-1],m)
	colorbar
	title('vp\_true')
	
	figure
	imagesc([0 nx*h-1],[0 nz*h-1],epsilon)
	colorbar
	title('epsilon')
	
%%%%%%%%%% Sauvegarde dans le fichier vp_true_inclusion %%%%%%%%%%

	fid=fopen('vp_true_weld','w+');
	fwrite(fid, m(:,:),'single');
	fclose(fid);
	
	fid= fopen('epsilon', 'w+');
	fwrite(fid,epsilon(:,:), 'single')
	fclose(fid);	
	
end
