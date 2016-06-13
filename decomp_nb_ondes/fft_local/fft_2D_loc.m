clear all; close all;

nz=200;
nx=400;

%pour les carrés
n=floor(200/3);


%recup du gradient
fid=fopen('gradient_18inclus_2freesurf_nt4200_2MHz');
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

gmin=min(min(g));
gmax=max(max(g));


cpt=1;

for j=1:nz/n
	for i=1:nx/n
		
		figure(35)
		subplot('position',[(n*(i-1))/nx 1-(n*(j))/nz  n/(nx+1) n/(nz+1)])
		imagesc(g(n*(j-1)+1:n*j,n*(i-1)+1:n*i),[gmin gmax]);
		axis('off')
		%colorbar

				
		figure(36)
		subplot('position',[(n*(i-1))/nx 1-(n*(j))/nz  n/(nx+1) n/(nz+1)])
		fft2D=(abs(fftshift(fft2(g(n*(j-1)+1:n*j,n*(i-1)+1:n*i),n,n))));
		imagesc(axetf_x,axetf_z,20*log10(fft2D),[-20 80]);
		%colorbar
		axis('off')

		cpt=cpt+1
	end
end

figure(35)
colorbar
print -dsvg 'gradient_18inclus_2freesurf_nt4200_2MHz.svg'

figure(36)
print -dsvg 'fft2d_18inclus_2freesurf_nt4200_2MHz.svg'







