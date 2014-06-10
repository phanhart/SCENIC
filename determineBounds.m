function [lowerBounds, upperBounds] = determineBounds(umin, umax, gradeSerie)
% Author: Philippe Hanhart (philippe.hanhart@epfl.ch)
% Date: 2014/01/15
% 
% Determine the lower and upper bounds for parameters a, b, c, and d
% according to Table 2.

Deltau = umax-umin;

switch gradeSerie
    case 'mean'
        lowerBounds.a = umin;
        upperBounds.a = umin+1/5*Deltau;

        lowerBounds.b = umax-1/5*Deltau;
        upperBounds.b = umax;

        lowerBounds.c = 0;
        upperBounds.c = Inf;

        lowerBounds.d = -Inf;
        upperBounds.d = Inf;
    case 'min'
        lowerBounds.a = umin-1/10*Deltau;
        upperBounds.a = umin+1/5*Deltau;

        lowerBounds.b = umax-3/10*Deltau;
        upperBounds.b = umax;

        lowerBounds.c = 0;
        upperBounds.c = Inf;

        lowerBounds.d = -Inf;
        upperBounds.d = Inf;
    case 'max'
        lowerBounds.a = umin;
        upperBounds.a = umin+3/10*Deltau;

        lowerBounds.b = umax-1/5*Deltau;
        upperBounds.b = umax+1/10*Deltau;

        lowerBounds.c = 0;
        upperBounds.c = Inf;

        lowerBounds.d = -Inf;
        upperBounds.d = Inf;
    otherwise
        error('Error: grade serie "%s" unknown', gradeSerie);
end
