function fricker_generation(f,n,dt)
	
	t=(0:n-1)*dt;
	freqs=(0:n-1)*1/max(t);
	
	fricker=ricker(f,n,dt);
	

%%%%%%%%%% Fonction de Romain %%%%%%%%%%
f0=f;
t0=1.5*sqrt(6)/(pi*f0);
da=pi*f0;
d1=dt;
n1=n;

 for i1=1:n1
 t=(i1-1)*d1;
 a=pi*f0*(t-t0);
 a2=(pi*f0*(t-t0))^2;
 ppx(i1)=-(0.5/(da*da))*exp(-a2);					  %double primitive ricker
 px(i1)=(a/da)*exp(-a2);							  %primitive du ricker
 x(i1)=(1.-2.*a2)*exp(-a2);							  %ricker
 dx(i1)=-4*a*da*exp(-a2)-2.*a*da*(1.-2.*a2)*exp(-a2); %derivee du ricker
 end
 
%%%%%%%%%%
	
	%fricker=dx;

	figure
	subplot(2,1,1)
	plot(fricker,'o');
	subplot(2,1,2)
	fft_ricker=abs(fft(fricker));
	plot(freqs(1:n/2)/1e6,20*log10(fft_ricker(1:n/2)))
	
	
	
	fid=fopen('fricker','w+');
	fwrite(fid, fricker(:,:,:),'single');
	fclose(fid);

end