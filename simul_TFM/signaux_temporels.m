
clear all; close all;

nb_src=64;
dt=1.45e-8;
nt=2048;
t=(0:2048-1)*dt;

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


 cpt = 0;
 for sensor_idx = 1:2:2*nb_src
     cpt = cpt+1;
     figure; clf
     plot(t,true_data(:,sensor_idx)); hold on
     plot(t,reconstructed_data(:,sensor_idx),'r--'); hold off
     xlabel('time (ms)')
     ylabel('signals (blue = true and red = reconstructed)')
     title(['sensor pair # ',num2str(sensor_idx)])
     F(cpt) = getframe(gcf);
 end



 v = VideoWriter('signals.avi','Uncompressed AVI');
 open(v);
 writeVideo(v,F);
close(v)








