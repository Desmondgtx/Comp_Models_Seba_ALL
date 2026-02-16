
function [f] = two_k_one_beta(p,chosen,effort,reward,agent,stim_props,outtype)% same as in models above in same order


%%%%% 1. Assign free parameters and other stuff:
base = 1;
discount = (agent==1).*p(1) + (agent==2).*p(2);

beta = p(3);

num_trials=stim_props(1);%24
num_conds=stim_props(2);%3

all_prob = [];
self_prob = [];
other_prob = [];

V_self  =  [];
V_other =  [];
V_all   =  [];


%%%% Model -parabolically devalue reward by effort. 1 parameter for both
%%%% conditions

%discount = p(1) +(cond*2-1).*p(2)

val = reward - (discount.*(effort.^2));
prob =  exp(val.*beta)./(exp(base*beta) + exp(beta.*val));
% newprob = prob.*(1-2*epsilon) + epsilon;
prob(~chosen) =  1 - prob(~chosen);

prob = prob(:,1);

% calculate neg-log-likelihood
f=-nansum(log(prob));



end