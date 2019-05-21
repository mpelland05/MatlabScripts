function NoiseCalib = NoiseCalib(vol,ref,ear),
%enter the volume you want to obtaint in dB SPL, the reference level, which
%would be the maximum input of the hearphone or speaker and the ear that
%you want the sound to be in (right or left), if not ear, simply put 1. 
    y = zeros(441000,2);
    y(:,ear) = wavread('NoiseCalib');
    att = y/(10.^((ref - vol)./20));
    
    sound(att,44100)

end