function [fitObject, yhat] = fitLogisticFunction(x, y, umin, umax, gradeSerie)
% Author: Philippe Hanhart (philippe.hanhart@epfl.ch)
% Date: 2014/01/15
%
% Logistic fitting:
%  y = a + (b-a) / (1 + exp(-c*(x-d)))
% x and y must be vectors.

fun = @(p,x) p(1) + (p(2)-p(1)) ./ (1 + exp(-p(3)*(x-p(4))));
f = fittype('a + (b-a) ./ (1 + exp(-c*(x-d)))');

[lowerBounds, upperBounds] = determineBounds(umin, umax, gradeSerie);

% initial values

epsilon = 1e-3;
u = x;
v = log((upperBounds.b - lowerBounds.a + 2*epsilon) ./ (y - lowerBounds.a + epsilon) - 1);
estimatation = polyfit(u, v, 1);

p0.a = max(min(y), lowerBounds.a + epsilon);
p0.b = min(max(y), lowerBounds.b - epsilon);
p0.c = -estimatation(1);
if p0.c < 0
    p0.c = 1;
    p0.d = (min(x) + max(x)) / 2;
else
    p0.d = estimatation(2) / p0.c;
end

% re-arrange data

p0 = cell2mat(struct2cell(p0));
lowerBounds = cell2mat(struct2cell(lowerBounds));
upperBounds = cell2mat(struct2cell(upperBounds));

% fitting

options = optimset('MaxIter', 10000, 'Display', 'off');
p = lsqcurvefit(fun, p0, x, y, lowerBounds, upperBounds, options);
p = num2cell(p);
fitObject = cfit(f, p{:});
yhat = feval(fitObject, x);
