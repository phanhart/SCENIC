function DeltaD = phi(p1, p2, rL, rH)
% Author: Philippe Hanhart (philippe.hanhart@epfl.ch)
% Date: 2014/01/15
%
% Compute the average MOS difference according to Eq. (26).

DeltaD = 1 / (rH - rL) * ((F(p2, rH) - F(p2, rL)) - (F(p1, rH) - F(p1, rL)));
end

function y = F(p, x)
y = (p.b-p.a)/p.c * log(1 + exp(-p.c*(x-p.d))) + p.b*x + (p.a-p.b)*p.d;
end