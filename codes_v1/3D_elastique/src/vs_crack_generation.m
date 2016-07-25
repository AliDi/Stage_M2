%vs : vitesse des ondes shear du milieu sans fissure (matrice nz X nx)
%vs_crack : vitesse dans la fissure (scalaire)
%l : longueur du crack en m
%L : largeur du crack en m
%xpos_center, ypos_center : coordonnees du centre du crack en m
%nx,nz : taille du milieu
%h pas de discrétisation
%angl : angle du crack en degré
%
%usage : [vs]=vs_true_crack(vs,vs_crack, l , L , angl, xpos_center,zpos_center,nz, nx,h)
%
%sortie en binaire dans les fichiers 'vs_true' et 'rho_true'

function [vs]=vs_crack_generation(vs,vs_crack,  l , L , angl, xpos_center,zpos_center,nz, nx,h)

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
				vs(i,j)=vs_crack;
			end
		end
	end 
	
	
x=0:h:nx*h;
	
%%%%%%%%%% Illustration %%%%%%%%%%
	
	figure(103)
	subplot(212)
	imagesc([0 nx*h-h],[0 nz*h-h],vs)
	colorbar
	title('vs\_true')

	
%%%%%%%%%% Sauvegarde dans le fichier vs_true_inclusion %%%%%%%%%%

	fid=fopen('vs_true','w+');
	fwrite(fid, vs(:,:),'single');
	fclose(fid);
	
end

%save("-binary","vs_binaire","vs") 

