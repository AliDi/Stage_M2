clear all;
close all;


freq=input(sprintf('freq \n')); 		%lecture de la frequence centrale du filtre
nb_src=input(sprintf('nb src \n'));
N=input(sprintf('nb de coeff du filtre \n'));

nb_recep=128;
dt=1.4e-8;

%%%%%%%%%% Calcul du nb de point sur le signal temporel
fid=fopen(['fsismos_P0000'],'r','l');
A = fread(fid,'single');
nt=length(A)/nb_recep;


for i=0:nb_src-1

		if (i <= 9)
			fid=fopen(['fsismos_P000' num2str(i)],'r','l');
		elseif (i <=99 && i>9) 
			fid=fopen(['fsismos_P00' num2str(i)]);
		else 
			fid=fopen(['fsismos_P0' num2str(i)]);
		end
		A = fread(fid,'single'); 
		s(i+1,:,:)=reshape(A,nt,nb_recep);
		fclose(fid);		
end	

%%%%%%%%%% tracer du signal temporel pour le couple src/recep 0-0 %%%%%%%%%%
t=(0:nt-1)*dt;
freqs=(0:nt-1)*1/max(t);

#figure
#subplot(2,1,1)
#plot(t,s(1,:,1));
#title('Signal temporel pour le couple 0-0')

fft_s=abs(fft(s(1,:,1)));
#subplot(2,1,2)
#plot(freqs(1:nt/2),20*log10(fft_s(1:nt/2)))

%%%%%%%%%% filtrage des données %%%%%%%%%%
h=fir1(N,[2.5*freq/max(freqs)],"low");
[filtre ff]=freqz(h,1,nt/2,1/max(t));
#figure
#plot(freqs(1:nt/2),20*log10(abs(filtre)))

for i=1:nb_src
	for j=1:nb_recep
		y=[s(i,:,j)];%'.*tukeywin(nt,0.001);
		s_filtre(i,:,j) = filter(h,1,y);
	end
end



%%%%%%%%%% Filtrage du signal d'excitation %%%%%%%%%%

fid=fopen('fricker');
excitation=fread(fid,'single');
fclose(fid);

fricker=filter(h,1,excitation);

#figure
#subplot(2,1,1)
#plot(t,excitation,'o');
#subplot(2,1,2)
fft_exci=abs(fft(excitation));
#plot(freqs(1:nt/2),20*log10(fft_exci(1:nt/2)))
#title('Excitation d origine')

#figure
#subplot(2,1,1)
#plot(t,fricker,'o');
#subplot(2,1,2)
fft_ricker=abs(fft(fricker));
#plot(freqs(1:nt/2),20*log10(fft_ricker(1:nt/2)))
#title('Excitation filtrée')

fid=fopen('filtre_fricker','w+');
fwrite(fid, fricker(:,:,:),'single');
fclose(fid);





%%%%%%%%%% tracer du signal 0-0 filtre %%%%%%%%%%%
#figure
#subplot(2,1,1)
#plot(t,s_filtre(1,:,1));
#title('Signal temporel pour le couple 0-0 FILTRÉ')

fft_s_filtre=abs(fft(s_filtre(1,:,1)));
#subplot(2,1,2)
#plot(freqs(1:nt/2),20*log10(fft_s_filtre(1:nt/2)))

%%%%%%%%% Ecriture des donnees filtrees %%%%%%%%%%

for i=0:nb_src-1
		if (i <= 9)
			fid=fopen(['filtre_fsismos_P000' num2str(i)],'w+');
		elseif (i<=99)
			fid=fopen(['filtre_fsismos_P00' num2str(i)],'w+');
		else
			fid=fopen(['filtre_fsismos_P0' num2str(i)],'w+');
		end
		B=reshape(s_filtre(i+1,:,:),nt*nb_recep,1);
		fwrite(fid, B,'single');
		fclose(fid);
end





