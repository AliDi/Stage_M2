%%%%%%% milieu : soudure en V %%%%%%%
%angl est en degre : donne l'angle du bord droit de la soudure
%rg : root gap (m)
%vp : paramètre du milieu à modifier (matrice nz X nx)
%vp_inclusion : valeur du paramètre dans la soudure (scalaire)
%
%nom_fichier : nom du fichier binaire pour l'exportation du milieu (string)
%
%num_figure : numéro de la figure pour un affichage du milieu généré. Si num_figure==0, pas d'affichage.
%num_plot : paramètre d'entrée de subplot
%
% usage : [vp]=weld(vp, vp_weld , angl, rg, nz, nx , h , nom_fichier , num_figure , num_subplot)
 
function [vp]=weld(vp, vp_weld , angl, rg, nz, nx , h , nom_fichier , num_figure , num_subplot)
	
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
			end
		end
	end
	
x=0:h:nx*h;

	
%%%%%%%%%% Illustration %%%%%%%%%%
	
	figure(num_figure)
	subplot(num_subplot)
	imagesc([0 nx*h-h],[0 nz*h-h],vp)
	colorbar
	title(nom_fichier)

	
%%%%%%%%%% Sauvegarde dans le fichier nom_fichier %%%%%%%%%%

	fid=fopen(nom_fichier,'w+');
	fwrite(fid, vp(:,:),'single');
	fclose(fid);
	
end
