%This script will launch random atom generation for the modularity study. 
%This is the first script for it! Woo!


%Right short version
files_in.nAtm = 50;
files_in.mask = 'rCalcarineMask.nii';
files_in.part = 'parts.nii';
files_out = 'Atoms_CalcRand_Right.nii';

RandomAtomGen(files_in,files_out);

%Left short version
files_in.nAtm = 50;
files_in.mask = 'lCalcarineMask.nii';
files_in.part = 'parts.nii';
files_out = 'Atoms_CalcRand_Left.nii';

RandomAtomGen(files_in,files_out);