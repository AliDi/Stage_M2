%d est une masse volumique en kg/m3
function []=rho_generation(d,nz, nx)

	for i=1:nx
		for j=1:nz
			rho(i,j)=d;
		end
	end

	fid=fopen('rho_uniforme','w+');
	fwrite(fid, rho(:,:,:),'single');
	fclose(fid);

end
