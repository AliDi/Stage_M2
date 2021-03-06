%vp : vitesse du milieu sans fissure (matrice nz X nx)
%rho : masse volumique sans fissure (idem)
%vp_crack : vitesse dans la fissure (scalaire)
%rho_crack : masse volumique dans la fissure (idem)
%l : longueur du crack en m
%L : largeur du crack en m
%xpos_center, ypos_center : coordonnees du centre du crack en m
%nx,nz : taille du milieu
%h pas de discrétisation
%angl : angle du crack en degré
%
%usage : [vp,rho]=vp_true_crack(vp,vp_crack, rho, rho_crack, l , L , angl, xpos_center,zpos_center,nz, nx,h)
%
%sortie en binaire dans les fichiers 'vp_true' et 'rho_true'

function [vp,rho]=vp_true_crack(vp,vp_crack, rho, rho_crack, l , L , angl, xpos_center,zpos_center,nz, nx,h)

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
				rho(i,j)=rho_crack;
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

%save("-binary","vp_binaire","vp") 

