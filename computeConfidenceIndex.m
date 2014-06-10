function confidenceIndex = computeConfidenceIndex(D1, D1hat, D2, D2hat, umin, umax)
% Author: Philippe Hanhart (philippe.hanhart@epfl.ch)
% Date: 2014/01/15
%
% Compute the confidence index according to Eq. (31).

Deltau1 = max(D1) - min(D1);
Deltau2 = max(D2) - min(D2);
rho1 = corr(D1, D1hat, 'type', 'Pearson');
rho2 = corr(D2, D2hat, 'type', 'Pearson');
confidenceIndex = min(1, max(Deltau1, Deltau2) / (0.8*(umax - umin)) * rho1 * rho2);
