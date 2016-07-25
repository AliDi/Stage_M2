%vp : paramètre du milieu à modifier (matrice nz X nx)
%vp_crack : valeur du paramètre dans la fissure (scalaire)
%l : longueur du crack en m
%L : largeur du crack en m
%xpos_center, ypos_center : coordonnees du centre du crack en m
%nx,nz : taille du milieu
%h pas de discrétisation
%angl : angle du crack en degré
%
%nom_fichier : nom du fichier binaire pour l'exportation du milieu (string)
%
%num_figure : numéro de la figure pour un affichage du milieu généré. Si num_figure==0, pas d'affichage.
%num_plot : paramètre d'entrée de subplot
%
%usage : [vp]=crack(vp , vp_crack , l , L , angl, xpos_center,zpos_center , nz ,  nx , h , nom_fichier , num_figure , num_subplot) 
%


function [vp]=crack(vp , vp_crack , l , L , angl, xpos_center,zpos_center , nz ,  nx , h , nom_fichier , num_figure , num_subplot) 

	angl=angl*pi/180;		%passage en radian
	
	angl2=(-pi/2+angl);		%angle pour les arêtes perpendiculaires
	
	a=tan(angl);			%coefficient directeur de la fissure
	a2=tan(angl2);		%coefficient directeur pour les bords perpendiculaires à l'axe de la fissure
	
	b=zpos_center-a * xpos_center; 		%ordonnées à l'origine de l'axe de la fissure
	b2=zpos_center-a2 * xpos_center;	%ordonnées à l'origine de la perpendiculaire à l'axe de la fissure
	
	x=linspace(0,nx*h,nx);
	z=linspace(0,nz*h,nz);
	
	for (j=1:nx)
		for (i=1:nz)
						
			if ( ((z(i)-a*x(j))<= (b+(l/2/cos(angl)))) && ((z(i)-a*x(j)) >=(b-(l/2/cos(angl)))) && ((z(i)-a2*x(j))<= (b2+abs(L/2/cos(angl2)))) && ((z(i)-a2*x(j)) >= (b2-abs(L/2/cos(angl2)))) ) %i.e. dans la fissure
				vp(i,j)=vp_crack;
			end
		end
	end 
	
	
x=0:h:nx*h;

%figure
%plot(x,a*x+b);
%hold on
%plot(x,a*x+b+l/2/cos(angl))
%plot(x,a*x+b-l/2/cos(angl))
%plot(x,a2*x+b2+L/2/cos(angl2))
%plot(x,a2*x+b2-L/2/cos(angl2))
%plot(xpos_center,zpos_center,'or')
%ylim([0 nz*h])
	
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

%save("-binary","vp_binaire","vp") 

