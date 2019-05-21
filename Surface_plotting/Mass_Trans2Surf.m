function Mass_Trans2Surf(ppath),
%This function will take a folder and run niak_brick_vol2surf on each file within the folder

%%%%%%%%
%find list of participants names using the .path
%%%%%%%%
tdir = dir(ppath);

for tt = 3:length(tdir),
    tpnames{tt-2} = tdir(tt).name;
end

for ii = 1:length(tpnames),
	
	files_in.vol = strcat(ppath,'/',tpnames{ii});
	niak_brick_vol2surf(files_in);
	
	tnam = 	strcat(ppath,'/',regexprep(tpnames{ii},'.mnc','_surf.mat'));
	load(tnam);
	save("-mat4-binary", tnam,"data")

end

end
