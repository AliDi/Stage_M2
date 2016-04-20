clear all;
%close all;


freq=input('freq'); 		%lecture de la frequence centrale du filtre
nb_src=input('nb src');

nb_recep=32;
dt=0.0005;

%%%%%%%%%% Calcul du nb de point sur le signal temporel
fid=fopen(['./data/fsismos_P0000'],'r','l');
A = fread(fid,'single');
nt=length(A)/nb_recep;


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

%%%%%%%%%% tracer du signal temporel pour le couple src/recep 0-0 %%%%%%%%%%
t=(0:nt-1)*dt;
freqs=(0:nt-1)*1/max(t);

figure
subplot(2,1,1)
plot(t,s(1,:,1));
title('Signal temporel pour le couple 0-0')

fft_s=abs(fft(s(1,:,1)));
subplot(2,1,2)
plot(freqs(1:nt/2),20*log10(fft_s(1:nt/2)))

%%%%%%%%%% filtrage %%%%%%%%%%
h=fir1(150,2.5*freq/max(freqs),"low");
[filtre ff]=freqz(h,1,nt/2,1/max(t));
figure
plot(freqs(1:nt/2),20*log10(abs(filtre)))

for i=1:nb_src
	for j=1:nb_recep
		s_filtre(i,:,j) = filter(h,1,s(i,:,j));
	end
end

%%%%%%%%%% tracer du signal 0-0 filtre %%%%%%%%%%%
figure
subplot(2,1,1)
plot(t,s_filtre(1,:,1));
title('Signal temporel pour le couple 0-0 FILTRÉ')

fft_s_filtre=abs(fft(s_filtre(1,:,1)));
subplot(2,1,2)
plot(freqs(1:nt/2),20*log10(fft_s_filtre(1:nt/2)))

%%%%%%%%% Ecriture des donnees filtrees %%%%%%%%%%

for i=0:nb_src-1
		if (i <= 9)
			fid=fopen(['./data/fsismos_P000' num2str(i) '_filtre'],'w+');
		else 
			fid=fopen(['./data/fsismos_P00' num2str(i) '_filtre'],'w+');
		end
		B=reshape(s_filtre(i+1,:,:),nt*nb_recep,1);
		fwrite(fid, B,'single');
		fclose(fid);
end





