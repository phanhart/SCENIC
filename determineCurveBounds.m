function [rl, rh, Dl, Dh] = determineCurveBounds(p)
% Author: Philippe Hanhart (philippe.hanhart@epfl.ch)
% Date: 2014/01/15
%
% Determine the 95% bounds of the fitted R-D curve according to Eq. (10)
% and (11).

Dl = p.a + 0.025*(p.b-p.a);
Dh = p.a + 0.975*(p.b-p.a);
rl = g(p, Dl);
rh = g(p, Dh);
end

function x = g(p, y)
x = -1/p.c * log((p.b-y) ./ (y-p.a)) + p.d;
end
