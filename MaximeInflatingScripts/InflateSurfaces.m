function InflateSurfaces(files_in,files_out),
%This script takes a all surface objects within a folder and inflates them 
%to the demanded percentage.
%This script uses functions from the surfstat toolbox to do this.
%
%files_in
%           .path   string, full path to folder containing the .obj files
%                   to be inflated.
%           .perc   int or vec, portion of inflation to do (from 0 to 1), 0 being not
%                   inflated at all.
%
%files_out          string, full path to output folder (must be created
%                   first).
%
%Notes: Do not forget to add SurfStat to the matlab path. 

fs = filesep;

%%%%%%%%
%find list of participants names using  files_in.path
%%%%%%%%
tdir = dir(files_in.path);
tnam = find(vertcat(tdir.isdir) == 0);

for tt = 1:length(tnam),
    tpnames{tt} = tdir(tnam(tt)).name;
end

%%%%
% Create Output directory if does not exist
%%%%
if ~isdir(files_out),
    mkdir(files_out);
end

%%%%
% Main script
%%%%
for pp = 1:length(tpnames),
    [surf ab] = SurfStatReadSurf(strcat( files_in.path, tpnames{pp} ));
    
    for ii = 1:length(files_in.perc),
        surf = SurfStatInflate( surf , files_in.perc(ii) );
    
        if files_in.perc(ii) == 1, Sperc = num2str(1);else, Sperc = num2str(files_in.perc(ii)); Sperc(2) = []; end %Create string of inflated portion.
        OutName = strcat( files_out, 'Inflated_', Sperc, '_', tpnames{pp} );
    
        SurfStatWriteSurf1( OutName, surf ,ab );
    end
end

end
%files_in.path ='G:\Connectivity\glm_connectome_aout_2013\Surface_plotting\Models\Inflate\'
%files_in.perc = 0.25;
%files_out='G:\Connectivity\glm_connectome_aout_2013\Surface_plotting\Models\Inflate\Inflated\'