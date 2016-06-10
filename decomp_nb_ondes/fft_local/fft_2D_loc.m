clear all; close all;

nz=200;
nx=400;

%pour les carrés
n=100;


%recup du gradient
fid=fopen('gradient_8inclu_sansfs');
g=fread(fid,'single');
fclose(fid);

g=reshape(g,nz,nx);

imagesc(g);

%calcul des fft2D
h=2.5000e-04;

z=(0:(n-1))*h;
x=(0:(n-1))*h;

axetf_z=(-n/2:n/2-1)*1/max(z);
axetf_x=(-n/2:n/2-1)*1/max(x);

cpt=1;

for j=1:nz/n
	for i=1:nx/n
		
		figure(35)
		subplot('position',[(n*(i-1))/nx (n*(j-1))/nz  0.25 0.5])
		imagesc(g(n*(j-1)+1:n*j,n*(i-1)+1:n*i),[-77 83])
		axis('off')
				
		figure(36)
		subplot('position',[(n*(i-1))/nx (n*(j-1))/nz  0.25 0.5])
		fft2D=(abs(fftshift(fft2(g(n*(j-1)+1:n*j,n*(i-1)+1:n*i),n,n))));
		imagesc(axetf_x,axetf_z,20*log10(fft2D),[-30 90]);
		%colorbar
		axis('off')
		cpt=cpt+1
	end
end

figure(35)
print -dpng 'gradient_8inclu_sansfs.png'

figure(36)
print -dpng 'fft2d_8inclu_sansfs.png'







