clear all; close all;

%%%%%vitesse
fid=fopen('vp_multi_6000k')
data=fread(fid,'single');
fclose(fid)
data=reshape(data,200,400);

figure(2)
imagesc(data)

figure(1)
plot(data(:,200),-(0:0.25:50-0.25))

fid=fopen('../milieux_ps/vp_true')
data=fread(fid,'single');
fclose(fid)
data=reshape(data,200,400);
figure(1)
hold on
plot(data(:,200),-(0:0.25:50-0.25),'r')
ylabel('mm');
xlabel('Vitesse en m/s');
legend('Reconstruite','Vraie')
print -dsvg coupe_vp_mono_vert.svg

%%%%%densité
fid=fopen('rho_6000k')
data=fread(fid,'single');
fclose(fid)
data=reshape(data,200,400);

figure(3)
imagesc(data)

figure(4)
plot(data(:,200),-(0:0.25:50-0.25))

fid=fopen('../milieux_ps/rho_true')
data=fread(fid,'single');
fclose(fid)
data=reshape(data,200,400);
figure(4)
hold on
plot(data(:,200),-(0:0.25:50-0.25),'r')
ylabel('mm');
xlabel('Masse volumique en kg/m3');
legend('Reconstruite','Vraie')
print -dsvg coupe_rho_mono_vert.svg
