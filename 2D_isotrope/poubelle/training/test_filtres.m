clear all; close all;

v1=4000;
v2=3000;
nz=150;

f=[v1*ones(1,50) v2*ones(1,50) v1*ones(1,50)];

fft_f = fft(f);


figure
plot(f)

figure
plot(abs(fft_f))

fft_filtre=zeros(1,nz);
fft_filtre(1:floor(nz/10))=fft_f(1:floor(nz/10));
fft_filtre(floor(9*nz/10):end)=fft_f(floor(9*nz/10):end);

figure 
plot(abs(fft_filtre));
title('ifft')

f_smooth=ifft(fft_filtre);

figure
plot(abs(f_smooth))

Nh2 = floor(nz/10); % number of points of the local averaging
h2=fir1(Nh2,4/nz);
figure
stem(h2)
y2 = filter(h2,1,f); 

hold off
figure
plot(y2)
title('filter')