
clear all; close all; clc


set(0, 'defaultfigurevisible', 'off');

nb_src=128;
nb_recep=128;
dt=1.5e-8;
nt=2048;
t=(0:2048-1)*dt;

for i=0:nb_src-1

	if (i <= 9)
		fid=fopen(['./2048pt/fsismos_P000' num2str(i)],'r','l');
	elseif (i <=99 && i>9) 
			fid=fopen(['./2048pt/fsismos_P00' num2str(i)]);
	else 
			fid=fopen(['./2048pt/fsismos_P0' num2str(i)]);
	end
	A = fread(fid,'single'); 
	true_data(i+1,:,:)=reshape(A,nt,nb_recep);
	fclose(fid);		
end	

for i=0:nb_src-1

	if (i <= 9)
		fid=fopen(['./fsismos_P000' num2str(i)],'r','l');
	elseif (i <=99 && i>9) 
			fid=fopen(['./fsismos_P00' num2str(i)]);
	else 
			fid=fopen(['./fsismos_P0' num2str(i)]);
	end
	A = fread(fid,'single'); 
	reconstructed_data(i+1,:,:)=reshape(A,nt,nb_recep);
	fclose(fid);		
end	

cpt=0;
 for source=1:10:nb_src
 	for recep=1:10:nb_recep
 		cpt=cpt+1;
     	figure; clf
     	plot(t,true_data(source,:,recep)); hold on
     	%plot(t,reconstructed_data(source,:,recep),'r--'); hold off
     	xlabel('Temps (s)')
     	ylabel('signals (blue = true and red = reconstructed)')
     	title(['source : ',num2str(source) '; recep : ' num2str(recep)])
     	
     	coucou = sprintf('./img/sig%05d.png', cpt);
		print ('-dpng', coucou);
     	
     	%F(cpt) = getframe(gcf);
    end
 end



% v = VideoWriter('signals.avi','Uncompressed AVI');
% %open(v);
% writeVideo(v,F);
%close(v)








