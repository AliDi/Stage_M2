clear all; close all;

dt=2.4e-8;
n=1000;
f=1e6;

freq_filtre=200000;

t=(0:n-1)*dt;
freqs=(0:n-1)*1/max(t);
	
fricker=ricker(f,n,dt);
	
figure
subplot(2,1,1)
plot(t,fricker,'o');
subplot(2,1,2)
fft_ricker=abs(fft(fricker));
plot(freqs(1:n/2),20*log10(fft_ricker(1:n/2)))
	
%%%%%%%%%% filtrage du ricker %%%%%%%%%%
N=150;
h=fir1(N,2.5*freq_filtre/max(freqs),"low");
fricker=filter(h,1,fricker);

figure
subplot(2,1,1)
plot(t,fricker,'o');
subplot(2,1,2)
fft_ricker=abs(fft(fricker));
plot(freqs(1:n/2),20*log10(fft_ricker(1:n/2)))
	
fid=fopen('fricker','w+');
fwrite(fid, fricker(:,:,:),'single');
fclose(fid);

