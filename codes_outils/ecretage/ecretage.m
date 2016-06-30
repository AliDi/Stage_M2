clear all;
%close all;

nx=400;
nz=200;


fid=fopen('vp_ecrete_filtre')
data=fread(fid, 'single');
fclose(fid);
vp=reshape(data,nz,nx);

seuil=5750;

#for i=1:nx
#	for j=1:nz
#		if (vp(j,i)>= seuil)
#			vp(j,i)=6000;
#		elseif (vp(j,i)< seuil)
#			vp(j,i)=5500;
#		end
#	end	
#end

fid=fopen('vp_ecrete','w+');
fwrite(fid, vp  ,'single');
fclose(fid);


%%%%%%%%%% filtrage
figure
I=vp;
F=fftshift(fft2(I));
%calcul de la taille de l'image;
M=size(F,1);
N=size(F,2);
P=size(F,3);
H0=zeros(M,N);
D0=5;
M2=round(M/2);
N2=round(N/2);
H0(M2-D0:M2+D0,N2-D0:N2+D0)=1;
for i=1:M
for j=1:N
G(i,j)=F(i,j)*H0(i,j);
end
end
g=ifft2(G);
subplot(1,2,1);imagesc(I);title('image originale');
subplot(1,2,2);imagesc(abs(g));title('image filtrée'); 

fid=fopen('vp_ecrete_filtre','w+')
fwrite(fid, abs(g),'single');
fclose(fid);


