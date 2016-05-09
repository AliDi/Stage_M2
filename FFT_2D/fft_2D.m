clear all;
close all;

nx=425;%960;%
nz=212;%200;%
h=2.5000e-04;

z=(0:(nz-1))*h;
x=(0:(nx-1))*h;

axetf_z=(0:nz-1)*1/max(z);
axetf_x=(0:nx-1)*1/max(x);

fid=fopen('vp_init');
vp=fread(fid,'single');

vp=reshape(vp,nz,nx);

figure
imagesc(x,z,vp);


figure
fft2D=(abs(fftshift(fft2(vp,nz,nx))));
imagesc(axetf_x,axetf_z,20*log10(fft2D));
colorbar


%affichage en section
figure
subplot(211)
plot(x,vp(100,:),'-o');

subplot(212)
plot(axetf_x,(abs(fftshift(fft2(vp(100,:))))),'*-');

figure
plot(axetf_x,20*log(fft2D(100,:)),'-o');


