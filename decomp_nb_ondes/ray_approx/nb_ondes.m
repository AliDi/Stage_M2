clear all;
close all;

format long

x_elem=[3 5];		%position x des elements en m
z_elem=[1 1];		%position z des elements en m
pt_elem=[x_elem' z_elem'];

nelem=length(x_elem);

pt_obs=[3 5];				%coordonnees par paire des points d'observation en m

npt=rows(pt_obs);

%%%%% Calcul des angles de refraction pour chaque couple emetteur/recepeteur %%%%%


for pos_obs=1:npt
	for i=1:nelem
		for j=i:nelem
			u=pt_elem(i,:)-pt_obs(pos_obs,:)
			v=pt_elem(j,:)-pt_obs(pos_obs,:)
			theta=acos( sum(u.*v) / ( norm(u) * norm(v)) ) *180/pi
		end
	end
end


theta=[0:0.01:2*pi];
y=-2*(cos(theta/2)).^2;
figure
polar(theta,y)

y=-2*(sin(theta/2)).^2;
figure
polar(theta,y)

figure 
polar(theta,sin(theta))








