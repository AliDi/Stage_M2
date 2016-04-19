function []=tfm(nt,dt, nb_recep,pitch, vp, vp_inclusion , x_sources, z_sources, x_recep, z_recep, nz, nx, h)
	nt=2048;		%nombre de points en temps ->nb de ligne
	dt=0.003;		%echantillonage temporel
	t=(0:1:nt-1).*dt;  %reconstitution de l'axe temporel

	nb_src=nb_recep;

	vp = 6000;
	vp_inclusion = 5800;
	vp=(vp+vp_inclusion)/2; 		%vitesse du milieu en m/s


%%%%%%%%%% Récupération des données simulées par TOYxDAC %%%%%%%%%%
%la variable s contient les signaux tempoorels tq : s(src, temps, recep)

	for i=0:nb_src-1

		if (i <= 9)
			fid=fopen(['./data/fsismos_P000' num2str(i)],'r','l');
		else 
			fid=fopen(['./data/fsismos_P00' num2str(i)]);
		end
		A = fread(fid,'single'); 
		s(i+1,:,:)=reshape(A,nt,nb_recep);
		fclose(fid);		
	end	

%%%%%%%%%% Calcul de l'intensité par l'équation 1 de Moreau_2009 %%%%%%%%%%
%points d'observation
	nx_obs=200;			%nb de points pour la tfm
	nz_obs=100;

	x_obs=linspace(0,(nx)*h,nx_obs);
	z_obs=linspace(nz*h/3,(nz)*h,nz_obs);


	%initialisation de l'intensité I à 0
	IMG=zeros(nx_obs, nz_obs);

	parfor x=1:nx_obs
		x
		for src=1:nb_src	
	
			%distance source-observation
			d_src_obs = sqrt( (x_obs(x)-x_sources(src))^2 + (z_obs-z_sources(src)).^2 );
			
			for recep=1:nb_recep
			
				%distance recep-observation
				d_recep_obs = sqrt( (x_obs(x)-x_recep(recep))^2 + (z_obs-z_recep(recep)).^2 );
			
				t_interp = (d_src_obs + d_recep_obs)/vp;
						
				I = (interp1(t,(abs((squeeze(s(src,:,recep))))),t_interp));
            	I(isnan(I)) = 0;
            	IMG(x,:) = IMG(x,:) + I;
			end 
		end
	end

	save('img_tfm','IMG','-ascii');
	
end


