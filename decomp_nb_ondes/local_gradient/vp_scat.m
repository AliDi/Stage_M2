clear all; close all;

nx=400;
nz=200;

%pour les carrés
n=100;

%position des diffractants
pos_x=n/2:n:nx-n/2;
pos_x= [pos_x pos_x-1];

pos_z=n/2:n:nz-n/2;
pos_z= [pos_z pos_z-1];

%milieu uniforme
vp=6000;
vp_diff=3000;

vp_init=vp*ones(200,400);

fid=fopen('vp_init','w+');
fwrite(fid, vp_init(:,:),'single');
fclose(fid);

%milieu avec défauts

for ix=1:nx
	for iz=1:nz
		if (ix==149 || ix==150) && (iz==49 || iz==50)%( sum(ix==pos_x) && sum(iz==pos_z) )
			vp_init(iz,ix)=vp_diff;
		end		
	end
end

imagesc([0 nx], [0 nz],vp_init)
colorbar

fid=fopen('vp_scat','w+');
fwrite(fid, vp_init(:,:),'single');
fclose(fid);