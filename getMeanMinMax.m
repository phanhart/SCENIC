function [meanValue, minValue, maxValue] = getMeanMinMax(values)
% Author: Philippe Hanhart (philippe.hanhart@epfl.ch)
% Date: 2014/01/15
%
% From the set of input values (mean, min|max, max|min), get the set
% (mean, min, max) considering that min < mean < max.

tmp = values(2:3);
meanValue = values(1);
if min(tmp) < meanValue
    minValue = min(tmp);
else
    minValue = NaN;
end
if max(tmp) > meanValue
    maxValue = max(tmp);
else
    maxValue = NaN;
end
