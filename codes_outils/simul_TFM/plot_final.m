R=1;
h=0.25e-3;				%pas de discrétisation : en fdtd o(4), respecter 5 pts par longueur d'onde

nz=200				%nb de points en z
nx=400				%nb de points en x

dt=1.5e-8/R;

dg=load('img_tfm2');
dd=load('img_tfm');

data=dg+dd;

%data=data(66:132,30:60);

figure
imagesc([0 nz*h]*R,[0 nx*h]*R,(data));
colorbar


xpos_center=0.048000;
zpos_center=0.030000;
r=7.5000e-04;
theta=0:0.0001:2*pi;
hold on
plot( (r*sin(theta)+(zpos_center))*R,(r*cos(theta)+(xpos_center))*R,'r');

title('TFM')
xlabel('m')
ylabel('m')

figure
imagesc([0 nz*h]*R,[0 nx*h]*R,(dg));
colorbar
hold on
plot( (r*sin(theta)+(zpos_center))*R,(r*cos(theta)+(xpos_center))*R,'r');

figure
imagesc([0 nz*h]*R,[0 nx*h]*R,(dd));
colorbar
hold on
plot( (r*sin(theta)+(zpos_center))*R,(r*cos(theta)+(xpos_center))*R,'r');
