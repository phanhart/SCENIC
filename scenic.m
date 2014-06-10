function [DeltaR, DeltaRmin, DeltaRmax, DeltaD, DeltaDmin, DeltaDmax, confidenceIndex] = scenic(R1, u1, delta1, R2, u2, delta2, umin, umax)
%SCENIC Subjective Comparison of ENcoders based on fItted Curves
%   Compute the average MOS difference and average bit rate difference
%   between two sets of subjective results (bit rate, MOS, and CI)
%   corresponding to two different codecs based on the model proposed in
%
%   Philippe Hanhart and Touradj Ebrahimi, "Calculation of average coding
%   efficiency based on subjective quality scores", Journal of Visual
%   Communication and Image Representation, 2013.
%   http://dx.doi.org/10.1016/j.jvcir.2013.11.008
%
%   Input parameters:
%    - R1: bit rate values for codec A
%    - u1: MOS values for codec A
%    - delta1: error values for codec A (CI = [u1-delta1,u1+delta1])
%    - R2: bit rate values for codec B
%    - u2: MOS values for codec B
%    - delta2: error values for codec B (CI = [u2-delta2,u2+delta2])
%    - umin: lower boundary of the rating scale
%    - umax: upper boundary of the rating scale
%   R, u, and delta must be vectors of the same length containing at
%   least 4 values.
%
%   Output parameters:
%    - DeltaR: average bit rate difference
%    - DeltaRmin: lower endpoint of the 95% CI on bit rate difference
%    - DeltaRmax: upper endpoint of the 95% CI on bit rate difference
%    - DeltaD: average MOS difference
%    - DeltaDmin: lower endpoint of the 95% CI on MOS difference
%    - DeltaDmax: upper endpoint of the 95% CI on MOS difference
%    - confidenceIndex: confidence index
%
%   Author: Philippe Hanhart (philippe.hanhart@epfl.ch)
%   Date: 2014/01/15 

if (size(R1,1) > 1 && size(R1,2) > 1) || (size(u1,1) > 1 && size(u1,2) > 1) || (size(delta1,1) > 1 && size(delta1,2) > 1) || (size(R2,1) > 1 && size(R2,2) > 1) || (size(u2,1) > 1 && size(u2,2) > 1) || (size(delta2,1) > 1 && size(delta2,2) > 1)
    error('Error: R, u, and delta must be vectors');
end
if length(R1) < 4 || length(u1) < 4 || length(delta1) < 4 || length(R2) < 4 || length(u2) < 4 || length(delta2) < 4
    error('Error: at least 4 values are required for each R-D curve');
end
if any(size(R1)~=size(u1)) || any(size(R1)~=size(delta1)) || any(size(R2)~=size(u2)) || any(size(R2)~=size(delta2))
    error('Error: R, u, and delta must have the same size');
end
if umax <= umin
    error('Error: umax must be greater than umin');
end

R1 = R1(:);
u1 = u1(:);
delta1 = delta1(:);
R2 = R2(:);
u2 = u2(:);
delta2 = delta2(:);

% compute the average bit rate difference and its corresponding estimated
% 95% confidence interval, average MOS difference and its corresponding
% estimated 95% confidence interval, and confidence index

r1 = log10(R1);
r2 = log10(R2);

gradeSeries = {'mean', 'min', 'max' ; 'mean', 'max', 'min'};
D1 = {u1, u1-delta1, u1+delta1};
D2 = {u2, u2+delta2, u2-delta2};

S = size(gradeSeries, 2);
DeltaD = zeros(S, 1);
DeltaR = zeros(S, 1);
fitObject1 = cell(S, 1);
fitObject2 = cell(S, 1);
D1hat = cell(S, 1);
D2hat = cell(S, 1);

for i=1:S
    [fitObject1_, D1hat_] = fitLogisticFunction(r1, D1{i}, umin, umax, gradeSeries{1,i});
    [fitObject2_, D2hat_] = fitLogisticFunction(r2, D2{i}, umin, umax, gradeSeries{2,i});
    fitObject1{i} = fitObject1_;
    fitObject2{i} = fitObject2_;
    D1hat{i} = D1hat_;
    D2hat{i} = D2hat_;
    
    if i==1
        confidenceIndex = computeConfidenceIndex(D1{i}, D1hat{i}, D2{i}, D2hat{i}, umin, umax);
    end
    
    [rL, rH, DL, DH] = determineIntegrationBounds(r1, D1hat{i}, fitObject1{i}, r2, D2hat{i}, fitObject2{i});
    
    if rH > rL
        DeltaD(i) = phi(fitObject1{i}, fitObject2{i}, rL, rH);
    else
        DeltaD(i) = NaN;
    end
    if DH > DL
        DeltaR(i) = psi(fitObject1{i}, fitObject2{i}, DL, DH);
    else
        DeltaR(i) = NaN;
    end
end

[DeltaD, DeltaDmin, DeltaDmax] = getMeanMinMax(DeltaD);
[DeltaR, DeltaRmin, DeltaRmax] = getMeanMinMax(DeltaR);

% plot R-D curves on a semi-logarithmic graph

N = 201;
x1 = linspace(min(r1), max(r1), N);
x2 = linspace(min(r2), max(r2), N);
X1 = 10.^x1;
X2 = 10.^x2;

xmin = min(min(R1), min(R2));
xminExp = 10^floor(log10(xmin));
xmin = floor(xmin / xminExp)*xminExp;
xmax = max(max(R1), max(R2));
xmaxExp = 10^floor(log10(xmax));
xmax = ceil(xmax / xmaxExp)*xmaxExp;

figure
xlabel('R', 'fontsize', 14);
ylabel('D', 'fontsize', 14);
set(gca,'xscale','log');
xlim([xmin xmax]);
ylim([umin umax]);
grid on;
hold on;
h = errorbar(R1, u1, delta1, delta1, 'bx');
set(h, 'markersize', 10, 'linewidth', 2);
h = errorbar(R2, u2, delta2, delta2, 'rx');
set(h, 'markersize', 10, 'linewidth', 2);
errorbarlogx();

for i=1:S
    if i==1
        h(2*i-1) = plot(X1, feval(fitObject1{i}, x1), 'b-');
        set(h(2*i-1), 'linewidth', 2);
        h(2*i) = plot(X2, feval(fitObject2{i}, x2), 'r-');
        set(h(2*i), 'linewidth', 2);
    else
        plot(X1, feval(fitObject1{i}, x1), 'b--');
        plot(X2, feval(fitObject2{i}, x2), 'r--');
    end
end
legend(h(1:2), {'$\hat D_1$','$\hat D_2$'}, 'Location', 'SouthEast', 'FontSize', 14, 'interpreter', 'latex')
