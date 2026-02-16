
function [f] = two_k_one_beta_linear(p,chosen,effort,reward,agent,stim_props,outtype)% same as in models above in same order

% p(1) = self discount
% p(2) = other discount
% p(3) = beta

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


%%%% Model -linear devalue reward by effort. 2 discount parameters 

val = reward - (discount.*(effort));
prob =  exp(val.*beta)./(exp(base*beta) + exp(beta.*val));
prob(~chosen) =  1 - prob(~chosen);
prob = prob(:,1);

% calculate neg-log-likelihood
f=-nansum(log(prob));



end