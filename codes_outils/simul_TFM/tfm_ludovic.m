clear, clc; %close all
tic
%% paramètres du signal
fc = 1e6;
omeg = 2*pi*fc;
fe = 10*fc;
Tmax = 0.4e-3;
t = 0:1/fe:Tmax;
T = 2.5/fc;
Ne = 64;
SNR = 250;
cL = 5900;
lambda = cL/fc;
p = 1*lambda/2;%1.5e-3;%0.63e-3;

 

 
%% paramètres du réseau d'éléments
Ntarget = 1;
xe = 0:p:(Ne-1)*p; xr = xe;
ye = zeros(size(xe)); yr = ye;
xtarget(1) = mean(xe)-1*lambda/2; %60e-3;
xtarget(2) = mean(xe)+1*lambda/2;
ytarget = ones(1,2)*5e-2;%xtarget(1);%40e-3;

 

 
tic
%% simulation de la matrice d'acquisitions
signals = zeros(Ne,Ne,length(t));
for nt = 1 : Ntarget
for ne = 1 : Ne
    d_e_t = sqrt((xe(ne)-xtarget(nt))^2+(ye(ne)-ytarget(nt)).^2);
    for nr = ne : Ne
        d_r_t = sqrt((xr(nr)-xtarget(nt))^2+(yr(nr)-ytarget(nt)).^2);
        t0 = (d_e_t + d_r_t)/cL;
%         signals(ne,nr,:) = pulse(fc,t,t0,T,SNR);
        signals(nr,ne,:) = squeeze(signals(nr,ne,:)).' + pulse(fc,t,t0,T,omeg/cL,d_e_t + d_r_t,SNR);
        %         plot(t,squeeze(signals(ne,nr,:)))
        %         drawnow
    end
end
end
toc

 

 

 
% figure(3); clf
% plot(t,1*squeeze(signals(10,10,:))+1*squeeze(signals(14,14,:)))
% xlim([0.5e-5,0.15e-4])
% xlabel('time (s)','fontsize',18)
% ylabel('reflected signals','fontsize',18)

 

 

 

 
%% algorithme TFM

 
% paramètres de l'image
pixel_size = lambda/2;

 
largeur_img = 0.1858;%xe(end)-xe(1);%4*50e-3;
hauteur_img = largeur_img;%2*50e-3;
centre_img = [(xe(1)+xe(end))/2,hauteur_img/2];

 
X_img = centre_img(1)-largeur_img/2 : pixel_size : centre_img(1)+largeur_img/2;
Y_img = centre_img(2)-hauteur_img/2 : pixel_size : centre_img(2)+hauteur_img/2;
Npix_X = length(X_img);
Npix_Y = length(Y_img);

 

 

 
tic
img2 = zeros(Npix_X,Npix_Y);
% hh = waitbar(0,'generating image');
parfor xpix = 1 : Npix_X

    
    for ne = 1 : Ne
        d_e_pix2 = sqrt( (xe(ne)-X_img(xpix))^2 + (ye(ne)-Y_img).^2 );

        

        
        for nr = ne : Ne
            d_r_pix2 = sqrt( (xr(nr)-X_img(xpix))^2 + (yr(nr)-Y_img).^2 );

            

            
            times2 = (d_e_pix2 + d_r_pix2)/cL;
            intensities2 = interp1(t,squeeze(signals(nr,ne,:)),times2);

            
            img2(xpix,:) = img2(xpix,:) + (intensities2);

            

            
%             figure(2)
%             subplot(1,2,2)
%             plot(t,squeeze(signals(nr,ne,:))); hold on
%             plot(times2,intensities2,'r+')
%             hold off
%             
%             
%             subplot(1,2,1)
%             plot(xe,ye,'bo'); hold on
%             plot(xtarget,ytarget,'r+')
%             plot(xtarget,ytarget,'ro')
%             plot(xe(ne),ye(ne),'c+');
%             plot(xr(nr),yr(nr),'g+');
%             plot(ones(1,Npix_X)*X_img(xpix),Y_img,'ms')
%             hold off
%             axis([X_img(1),X_img(end),Y_img(1),Y_img(end)])
%             drawnow
%             

            

            

            

            

            
        end

        
    end
%     figure(5);
%     imagesc(X_img,Y_img,(abs(img2)).'); hold on
%     plot(xtarget,ytarget,'w+')
%     plot(xe,ye,'ws')
%     axis equal
%      drawnow

    
%     waitbar(xpix/Npix_X,hh);

    
end
% close(hh)
toc
img_smooth = zeros(size(img2));
for ii = 1 : Npix_X
    img_smooth(ii,:) = abs(hilbert(img2(ii,:)) );
end

 
% img_smooth2 = zeros(size(img2));

 
img_smooth2 = abs(hilbert(img2) );

 

 
% max_img = max(max(abs(img_smooth)));
% figure;
% subplot(1,3,1)
% imagesc(X_img,Y_img,(abs(img_smooth/max_img)).'); hold on
% plot(xtarget,ytarget,'w+')
% plot(xe,ye,'ws')
% axis equal
% subplot(1,3,2)
% imagesc(X_img,Y_img,(abs(img_smooth2/max_img)).'); hold on
% plot(xtarget,ytarget,'w+')
% plot(xe,ye,'ws')
% axis equal
% subplot(1,3,3)
% imagesc(X_img,Y_img,(abs(img2/max_img)).'); hold on
% plot(xtarget,ytarget,'w+')
% plot(xe,ye,'ws')
% axis equal
toc

 

 

 
figure%(14);clf
imagesc(X_img,Y_img,(abs(img2)).'); hold on
plot(xtarget(1:Ntarget),ytarget(1:Ntarget),'k+')
plot(xtarget(1:Ntarget),ytarget(1:Ntarget),'ko')
plot(xe,ye,'ws')
axis equal
xlabel('X position (mm)','fontsize',18)
ylabel('Z position (mm)','fontsize',18)

 

 

 
% 
% figure(13); plot((abs(img_smooth(21,:))).')

 







