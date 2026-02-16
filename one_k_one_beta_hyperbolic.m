
function [f] = one_k_one_beta_hyperbolic(p,chosen,effort,reward,agent, stim_props,outtype)% same as in models above in same order
% p(1) = k 
% p(2) = beta

%%%%% 1. Assign free parameters and other stuff:
discount = p(1); % discounting paraemter
beta = p(2);     % beta in the softmax
base = 1;

%%%% Model -hyperbolic devalue reward by effort. 1 parameter for both
%%%% conditions

val = reward ./ (1 + (discount.*(effort)));

%%%% Softmax
prob =  exp(val.*beta)./(exp(base*beta) + exp(beta.*val));
prob(~chosen) =  1 - prob(~chosen);
prob = prob(:,1);
% calculate neg-log-likelihood
f=-nansum(log(prob));



