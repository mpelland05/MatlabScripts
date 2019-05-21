%This script will launch random atom generation for the modularity study. 
%This is the first script for it! Woo!


%Right short version
files_in.nAtm = 100;
files_in.mask = 'Mask_AAL_Occ_wBASC6_Right.nii';
files_in.part = 'roi_aal_3mm.nii';
files_out = 'Atoms_AAL_Occ_wBASC6_Right.nii';

%RandomAtomGen(files_in,files_out);

%Left short version
files_in.nAtm = 100;
files_in.mask = 'Mask_AAL_Occ_wBASC6_Left.nii';
files_in.part = 'roi_aal_3mm.nii';
files_out = 'Atoms_AAL_Occ_wBASC6_Left.nii';

RandomAtomGen(files_in,files_out);


%Right Long version
files_in.nAtm = 100;
files_in.mask = 'Mask_AAL_Occ_Right.nii';
files_in.part = 'roi_aal_3mm.nii';
files_out = 'Atoms_AAL_Occ_Right.nii';

RandomAtomGen(files_in,files_out);

%Left Long version
files_in.nAtm = 100;
files_in.mask = 'Mask_AAL_Occ_Left.nii';
files_in.part = 'roi_aal_3mm.nii';
files_out = 'Atoms_AAL_Occ_Left.nii';

RandomAtomGen(files_in,files_out);