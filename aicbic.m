function [aic, bic] = aicbic(logL, numParam, numObs)
% AICBIC - Replacement function for Econometrics Toolbox aicbic
%
% Syntax: [aic, bic] = aicbic(logL, numParam, numObs)
%
% Inputs:
%    logL - Log-likelihood value
%    numParam - Number of estimated parameters
%    numObs - Number of observations
%
% Outputs:
%    aic - Akaike Information Criterion
%    bic - Bayesian Information Criterion

aic = -2 * logL + 2 * numParam;
bic = -2 * logL + numParam * log(numObs);

end