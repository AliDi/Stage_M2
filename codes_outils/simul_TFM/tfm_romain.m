clear; clc;
dx = 28.571;
x = linspace(0,102,102)*dx;
y = linspace(0,120,120)*dx;

cL_steel = 6000;
cL_weld = 5800;


%fid = fopen('vp_soudure_defect','r','l');
%true_weld = reshape(fread(fid,'float32'),241,481);
%fclose(fid);


%fid = fopen('resultat_200_800Mhz','r','l');
%imaged_weld = reshape(fread(fid,'float32'),241,481);
%fclose(fid);

% figure(1);clf
% subplot(1,2,1)
% imagesc(x,y,true_weld)
% xlabel('x position (mm)')
% ylabel('y position (mm)')
% title('true weld and crack')
% caxis([5200,5800])
% subplot(1,2,2)
% imagesc(x,y,imaged_weld)
% caxis([5200,5800])
% xlabel('x position (mm)')
% ylabel('y position (mm)')
% title('reconstructed weld and crack')

% figure(1);clf
% imagesc(x,y,true_weld);
% axis equal
% xlabel('x position (m)')
% ylabel('y position (m)')
% title('true weld and crack')
% caxis([5200,5800])



Ntr = 32; Nre = 32;
dt = 0.0015;
time = linspace(0,2048,2048)*dt;  %time in ms

nx=102;			    %nb de points d'acqisition
xpos_recep = ceil(nx/2)*dx;
pitch=85.714286; 
sensors = xpos_recep-(32-1)*pitch/2 : pitch : xpos_recep+(32-1)*pitch/2;
% en transmission : 60 mm plus bas


true_data = zeros(Ntr,length(time),2*Nre);
for ii = 1 : 96
    if ii-1<10
        name = ['./data/fsismos_z000',num2str(ii-1)];
    else
        name = ['./data/fsismos_z00',num2str(ii-1)];
    end
    fid = fopen(name,'r','l');
    temp = (fread(fid,'float32'));
    true_data(ii,:,:) = reshape(temp,2048,Nre);
    fclose(fid);
end
reflected = true_data(:,:,1:32);
%transmitted = true_data(:,:,97:192);

%idxtr = 46;
%signals = squeeze(transmitted(idxtr,:,:));

%figure(2);clf
%imagesc(sensors,time,abs(hilbert(signals))); caxis([0,5e-6]);
%xlabel('sensor # ')
%ylabel('time (s)')
%title('true signals')
%colormap('jet')




% fid = fopen('data_reconstruit_src_0000','r','l');
% reconstructed_data = reshape(fread(fid,'float32'),2048,192);
% fclose(fid);

% figure(2);clf
% % subplot(1,2,1)
% imagesc(sensors,time,abs(hilbert(true_data))); caxis([0,5e-6]);
% xlabel('sensor # ')
% ylabel('time (s)')
% title('true signals')
% colormap('jet')
% subplot(1,2,2)
% imagesc(sensors,time,reconstructed_data); caxis([0,5e-6]);
% xlabel('sensor # ')
% ylabel('time (s)')
% title('reconstructed signals')


data = reflected;

x_tr = sensors;
Ntr = length(x_tr);
y_tr = ones(1,Ntr)*0;

x_re = x_tr;
y_re = ones(1,Ntr)*0;




%
% figure(4);clf
% imagesc(x_tr,time*1e3,data_for_SAFT); %caxis([0,5e-6]);
% xlabel('sensor position (mm)')
% ylabel('time (s)')
% title('true signals')
% figure; plot(time*1e3,data_for_SAFT(:,1))


Npix_Y = 50;
Npix_X = 50;

ximg = linspace(x_tr(1),x_tr(end),Npix_X);
yimg = linspace(y(1),y(end),Npix_Y);

IMG = zeros(Npix_X,Npix_Y);
tic
parfor ix = 1 : Npix_X
    ix

    for tr = 1 : Ntr
        dtr = sqrt((ximg(ix)-x_tr(tr))^2+(yimg-y_tr(tr)).^2);
        for re = 1 : Ntr

            dre = sqrt((ximg(ix)-x_re(re))^2+(yimg-y_re(re)).^2);

            tof = (dtr+dre)/((cL_weld+cL_steel)/2);
            intensities = (interp1(time,(abs((squeeze(data(tr,:,re))))),tof));
            intensities(isnan(intensities)) = 0;
            IMG(ix,:) = IMG(ix,:) + intensities;


%             figure(1);clf
%             imagesc(x,y,true_weld); axis equal
%             hold on
%             colormap('cool')
%             caxis([5200,5800])
%             plot(ximg(ix),yimg,'r+')
%             plot(x_tr(tr),y_tr(tr),'bo')
%             plot(x_re(re),y_re(re),'bx')
%             xlabel('x position (m)')
%             ylabel('y position (m)')
%             title('true weld and crack')
%             
%             figure(2); clf
%             plot(time,data(tr,:,re)); hold on
%             plot(time,abs(hilbert(data(tr,:,re))),'g');
%             xlabel('time (s)')
%             ylabel('signals')
%             %             ylim([-max(abs(data_for_SAFT(:))),max(abs(data_for_SAFT(:)))]);
%             %                         hold on
%             titi = interp1(time,data(tr,:,re),tof);
%             plot(tof,titi,'r+')





        end
    end
%     figure(10); clf
%     imagesc(ximg,yimg,IMG.'); axis xy
%     drawnow

end




toc

maximg = max(IMG(:));
%figure(10)
% imagesc(ximg,yimg,20*log10(IMG.'/maximg)); axis xy
%imagesc(ximg,yimg,IMG.'/maximg); axis xy

save('savedIMG','IMG','-ascii');

% cpt = 0;

% for sensor_idx = 1:2:192
%     cpt = cpt+1;
%     figure(3); clf
%     plot(time*1e3,true_data(:,sensor_idx)); hold on
%     plot(time*1e3,reconstructed_data(:,sensor_idx),'r--'); hold off
%     xlabel('time (ms)')
%     ylabel('signals (blue = true and red = reconstructed)')
%     title(['sensor pair # ',num2str(sensor_idx)])
%     F(cpt) = getframe(gcf);
% end
%
%
%
% v = VideoWriter('signals.avi','Uncompressed AVI');
% open(v);
% writeVideo(v,F);
% close(v)


% for ix = 35 : Npix_X
%     for iy = 20 : Npix_Y
%         
%         for tr = 10 %: Ntr
%             dtr = sqrt((ximg(ix)-x_tr(tr))^2+(yimg(iy)-y_tr(tr)).^2);
%             for re = 10% : Ntr
%                 
%                 dre = sqrt((ximg(ix)-x_re(re))^2+(yimg(iy)-y_re(re)).^2);
%                 
%                 tof = (dtr+dre)/((cL_weld+cL_steel)/2);
%                 intensities = abs((interp1(time,squeeze(data(tr,:,re)),tof)));
%                 IMG(ix,iy) = IMG(ix,iy) + intensities;
%                 
%                 
%                 figure(1);clf
%                 imagesc(x,y,true_weld); axis equal
%                 hold on
%                 colormap('cool')
%                 caxis([5200,5800])
%                 plot(ximg(ix),yimg(iy),'w+')
%                 plot(x_tr(tr),y_tr(tr),'bo')
%                 plot(x_re(re),y_re(re),'bx')
%                 xlabel('x position (m)')
%                 ylabel('y position (m)')
%                 title('true weld and crack')
%                 
%                 figure(2); clf
%                 plot(time,data(tr,:,re)); hold on
%                 plot(time,abs(hilbert(data(tr,:,re))),'g');
%                 xlabel('time (s)')
%                 ylabel('signals')
%                 %             ylim([-max(abs(data_for_SAFT(:))),max(abs(data_for_SAFT(:)))]);
%                 %                         hold on
%                 titi = interp1(time,data(tr,:,re),tof);
%                 plot(tof,titi,'r+')
%                 
%                 figure(10); clf
%                 imagesc(ximg,yimg,IMG.'); axis xy
%                 drawnow
%                 
%             end
%             
%         end
%     end
%     
%     
%     %       waitbar(ix/Npix_X,hh);
% end
