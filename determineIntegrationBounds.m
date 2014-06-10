function [rL, rH, DL, DH] = determineIntegrationBounds(r1, D1hat, p1, r2, D2hat, p2)
% Author: Philippe Hanhart (philippe.hanhart@epfl.ch)
% Date: 2014/01/15
%
% Determine the integration bounds for the computation of average MOS
% difference and average bit rate difference according to Eq. (15) and
% (19), respectively.

[rl1, rh1, Dl1, Dh1] = determineCurveBounds(p1);
[rl2, rh2, Dl2, Dh2] = determineCurveBounds(p2);

rL = max([min(r1) min(r2) min(rl1, rl2)]);
rH = min([max(r1) max(r2) max(rh1, rh2)]);
DL = max([min(D1hat) min(D2hat) min(Dl1, Dl2)]);
DH = min([max(D1hat) max(D2hat) max(Dh1, Dh2)]);
