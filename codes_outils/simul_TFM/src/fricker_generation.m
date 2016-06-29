function fricker_generation(f,n)
	
	fricker=ricker(f,n);
	
	figure
	plot(fricker,'o');
	
	fid=fopen('fricker','w+');
	fwrite(fid, fricker(:,:,:),'single');
	fclose(fid);
	
end
