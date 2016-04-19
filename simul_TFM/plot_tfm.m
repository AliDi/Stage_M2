clear all; close all;

nz=120;
nx=204;
h=50;


data=load('savedIMG2');

imagesc([0 nx*h],[0 nz*h],data');
colorbar


%inclusion reelle
centre_x=5072;
centre_z=4800;

r=150;

theta=0:0.001:2*pi;

hold on
plot(r*cos(theta)+centre_x, r*sin(theta)+centre_z);
