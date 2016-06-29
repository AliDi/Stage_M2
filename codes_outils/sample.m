clear all;
close all;


nb_src=64;
nb_recep=256;


%%%%%%%%%% Calcul du nb de point sur le signal temporel
fid=fopen(['fsismos_P0000'],'r','l');
A = fread(fid,'single');
nt=length(A)/nb_recep;


for i=0:nb_src-1

		if (i <= 9)
			fid=fopen(['fsismos_P000' num2str(i)],'r','l');
			A = fread(fid,'single');
			fclose(fid); 
			s(:,:)=reshape(A,nt,nb_recep);
			s_resampl=s(1:2:end,:);
			B=reshape(s_resampl(:,:),nt/2*nb_recep,1);
			fid=fopen(['fsismos_P000' num2str(i)],'w+');
			fwrite(fid, B,'single');
		    fclose(fid);
			
		elseif (i <=99 && i>9) 
			fid=fopen(['fsismos_P00' num2str(i)]);
		    A = fread(fid,'single');
			fclose(fid); 
			s(:,:)=reshape(A,nt,nb_recep);
			s_resampl=s(1:2:end,:);
			B=reshape(s_resampl(:,:),nt/2*nb_recep,1);
			fid=fopen(['fsismos_P00' num2str(i)],'w+');
			fwrite(fid, B,'single');
		    fclose(fid);
		else 
			fid=fopen(['fsismos_P0' num2str(i)]);
		    A = fread(fid,'single');
			fclose(fid); 
			s(:,:)=reshape(A,nt,nb_recep);
			s_resampl=s(1:2:end,:);
			B=reshape(s_resampl(:,:),nt*nb_recep,1);
			fid=fopen(['fsismos_P0' num2str(i)],'w+');
			fwrite(fid, B,'single');
		    fclose(fid);
		end	
end

fid=fopen('fricker');
excitation=fread(fid,'single');
fclose(fid);
excitation=excitation(1:2:end);
fid=fopen('fricker','w+');
fwrite(fid, excitation(:,:),'single');
fclose(fid);



	

