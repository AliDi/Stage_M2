clear all; close all;

%%%%%vitesse
fid=fopen('vp_3370k')
data=fread(fid,'single');
fclose(fid)
data=reshape(data,200,400);

figure(2)
imagesc(data)

figure(1)
plot(0:0.25e-3:10e-2-0.25e-3, data(120,:))

fid=fopen('../milieux_ps/vp_true')
data=fread(fid,'single');
fclose(fid)
data=reshape(data,200,400);
figure(1)
hold on
plot(0:0.25e-3:10e-2-0.25e-3, data(120,:),'r')
xlabel('mm');
ylabel('Vitesse en m/s');
legend('Reconstruite','Vraie')
print -dsvg coupe_vp_mono.svg

%%%%%densité
fid=fopen('rho_2200k_mono')
data=fread(fid,'single');
fclose(fid)
data=reshape(data,200,400);

figure(3)
imagesc(data)

figure(4)
plot(0:0.25e-3:10e-2-0.25e-3, data(120,:))

fid=fopen('../milieux_ps/rho_true')
data=fread(fid,'single');
fclose(fid)
data=reshape(data,200,400);
figure(4)
hold on
plot(0:0.25e-3:10e-2-0.25e-3, data(120,:),'r')
xlabel('mm');
ylabel('Masse volumique en kg/m3');
legend('Reconstruite','Vraie')
print -dsvg coupe_rho_mono.svg
