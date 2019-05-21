function[r]=ifisherz(z)
%IFISHERZ Inverse Fisher's Z-transform.
%   R = IFISHERZ(Z) re-transforms Z into the correlation coefficient R.

%20080103, Thomas Zoeller (tzo@gmx.de)
r = zeros(size(z));

z=z(:);
rr=(exp(2*z)-1)./(exp(2*z)+1);

r(:) = rr;