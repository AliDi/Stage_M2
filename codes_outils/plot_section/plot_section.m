clear all; close all;

%%%%%vitesse
fid=fopen('param_vp_final')
data=fread(fid,'single');
fclose(fid)
data=reshape(data,200,400);

figure(2)
imagesc(data)

figure(1)
plot((0:0.25:100-0.25),data(120,:))

fid=fopen('vp_true')
data=fread(fid,'single');
fclose(fid)
data=reshape(data,200,400);
figure(1)
hold on
plot((0:0.25:100-0.25),data(120,:),'r')
xlabel('mm');
ylabel('Vitesse en m/s');
legend('Reconstruite','Vraie')
print -dsvg vp.svg

%%%%%densité
fid=fopen('param_rho_final')
data=fread(fid,'single');
fclose(fid)
data=reshape(data,200,400);

figure(3)
imagesc(data)

figure(4)
plot(data(:,200),-(0:0.25:50-0.25))

fid=fopen('rho_true')
data=fread(fid,'single');
fclose(fid)
data=reshape(data,200,400);
figure(4)
hold on
plot(data(:,200),-(0:0.25:50-0.25),'r')
xlabel('mm');
ylabel('Masse volumique en kg/m3');
legend('Reconstruite','Vraie')
print -dsvg density.svg
