%Will take two volumes with probabilities and finds those parts which are 
%statistically different.

%%%% Input
v1 = 'F:\MyStudies\Modularity\Modularity_OC_2016\Results\CBvsSC\CmpMaps\Right_OccTip\OccTip_sci21_scf21_CBxxx.nii';
v2 = 'F:\MyStudies\Modularity\Modularity_OC_2016\Results\CBvsSC\CmpMaps\Right_OccTip\OccTip_sci21_scf21_SCxxx.nii';
n1 = 14;
n2 = 17;

crit = 3.88;%critical value over which the chi square is significant
%%% end input

[hdr, vol1] = niak_read_vol(v1);
[hdr, vol2] = niak_read_vol(v2);

pvol1 = vol1.*n1;
pvol2 = vol2.*n2;

nvol1 = n1-pvol1;
nvol2 = n2-pvol2;

ntot = n1+n2;
pvoltot = pvol1 + pvol2;
nvoltot = nvol1+nvol2;

pExpe1 = (pvoltot.*n1)./ntot;%Expected value
nExpe1 = (nvoltot.*n1)./ntot;

pExpe2 = (pvoltot.*n2)./ntot;%Expected value
nExpe2 = (nvoltot.*n2)./ntot;


o1 = ((pvol1 -pExpe1).^2)./pExpe1;
o2 = ((pvol2 -pExpe2).^2)./pExpe2;
o3 = ((nvol1 -nExpe1).^2)./nExpe1;
o4 = ((nvol2 -nExpe2).^2)./nExpe2;

oChi = o1+o2+o3+o4;

oChi(find(oChi < -1000000)) = 0;
oChi(find(oChi > 1000000)) = 0;

oChi = oChi.*(oChi > crit);