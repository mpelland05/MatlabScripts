function Export2Volume(files_in,files_out),
%This script will take a partitioned volume (result from basc) and filled
%each partition with the relevant t-value. Options allow to use p and fdr
%as masks.
%
%files_in
%       .partition
%       .data
%
%files_out  str, full path to save file.

[hdr, part] = niak_read_vol(files_in.partition);

vol = zeros(size(part));

uni = unique(part); uni(uni == 0) = [];

for pp = 1:length(uni)
    loc = find(part == uni(pp));
    vol(loc) = files_in.data(pp);
end

hdr.file_name = files_out;

niak_write_vol(hdr,vol);

end


