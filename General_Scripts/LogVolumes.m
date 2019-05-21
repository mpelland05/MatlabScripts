function LogVolumes(basePath),
%Will take a volume and transform it into a logarithmic version of it.
%Specifically, will multiply all its numbers by 100, add 1 and then do the
%log. 
fs = filesep;

[hdr vol]=niak_read_vol(basePath);

volp = zeros(size(vol));
voln = zeros(size(vol));

volp(find(vol>0)) = log10(1+(100.*(vol(find(vol>0)))));
voln(find(vol<0)) = -log10(1+(100.*abs(vol(find(vol<0)))));

nvol = volp+voln;

%[pathstr, name, ext, versn] = fileparts(basePath);

hdr.file_name = basePath;

niak_write_vol(hdr,nvol);

end