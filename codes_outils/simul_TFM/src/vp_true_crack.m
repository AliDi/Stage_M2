%vp1 : vitesse du milieu
%vp2 : vitesse dans la fissure
%l : longueur du crack en m
%L : largeur du crack en m
%xpos_center, ypos_center : coordonnees du centre du crack en m
%nx,nz : taille du milieu
%h pas de discrétisation
%angl : angle du crack en degré

function []=vp_true_crack(vp1,vp2, l , L , angl, xpos_center,zpos_center,nz, nx,h)
	close all
	
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
						
			if ( ((z(i)-a*x(j))<= (b+(l/2/cos(angl)))) && ((z(i)-a*x(j)) >=(b-(l/2/cos(angl)))) && ((z(i)-a2*x(j))<= (b2+abs(L/2/cos(angl2)))) && ((z(i)-a2*x(j)) >= (b2-abs(L/2/cos(angl2)))) ) 
				m(i,j)=vp2;
			else
				m(i,j)=vp1;
			end
		end
	end 
	
	
x=0:h:nx*h;

figure
plot(x,a*x+b);
hold on
plot(x,a*x+b+l/2/cos(angl))
plot(x,a*x+b-l/2/cos(angl))
plot(x,a2*x+b2+L/2/cos(angl2))
plot(x,a2*x+b2-L/2/cos(angl2))
plot(xpos_center,zpos_center,'or')
ylim([0 nz*h])
	
%%%%%%%%%% Illustration %%%%%%%%%%
	
	figure
	imagesc([0 nx*h-h],[0 nz*h-h],m)
	colorbar
	title('vp\_true')
	
%%%%%%%%%% Sauvegarde dans le fichier vp_true_inclusion %%%%%%%%%%

	fid=fopen('vp_true_crack','w+');
	fwrite(fid, m(:,:),'single');
	fclose(fid);
	
end

%save("-binary","vp_binaire","vp") 

