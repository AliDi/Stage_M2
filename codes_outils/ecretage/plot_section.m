clear all; close all;

%%%%%vitesse
fid=fopen('vp_true')
data=fread(fid,'single');
fclose(fid)
data=reshape(data,200,400);


figure(1)
plot((0:0.25:100-0.25),data(120,:))

fid=fopen('vp_5M')
data=fread(fid,'single');
fclose(fid)
data=reshape(data,200,400);
figure(1)
hold on
plot((0:0.25:100-0.25),data(120,:),'r')

xlabel('mm');
ylabel('Vitesse en m/s');
legend('Vitesse vraie','Vitesse reconstruite')
print -dsvg coupe_vp_multi_InitEcrete.svg

%%%%%densité
fid=fopen('rho_true')
data=fread(fid,'single');
fclose(fid)
data=reshape(data,200,400);


figure(2)
plot((0:0.25:100-0.25),data(120,:))

fid=fopen('rho_5M')
data=fread(fid,'single');
fclose(fid)
data=reshape(data,200,400);
figure(2)
hold on
plot((0:0.25:100-0.25),data(120,:),'r')

xlabel('mm');
ylabel('Vitesse en m/s');
legend('Masse volumique vraie','Masse volumique reconstruite')
print -dsvg coupe_vp_multi_InitEcrete.svg
