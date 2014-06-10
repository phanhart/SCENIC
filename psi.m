function DeltaR = psi(p1, p2, DL, DH)
% Author: Philippe Hanhart (philippe.hanhart@epfl.ch)
% Date: 2014/01/15
%
% Compute the average bit rate difference according to Eq. (28).

DeltaR = 1 / (DH - DL) * ((G(p2, DH) - G(p2, DL)) - (G(p1, DH) - G(p1, DL)));
DeltaR = 100*(10^DeltaR - 1);
end

function x = G(p, y)
x = (p.b-y)/p.c .* (log(p.b-y) - 1) + (y-p.a)/p.c .* (log(y-p.a) - 1) + p.d*y;
end
