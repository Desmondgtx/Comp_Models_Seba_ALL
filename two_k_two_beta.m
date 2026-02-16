
function [f] = two_k_two_beta(p,chosen,effort,reward,agent,stim_props,outtype)% same as in models above in same order
% p(1) = self discount 
% p(2) = other discount
% p(3) = beta self
% p(4) = beta other

%%%%% 1. Assign free parameters and other stuff:
discount = (agent==1).*p(1) + (agent==2).*p(2);% agent ==1 & win ==1
beta = (agent==1).*p(3) + (agent==2).*p(4);


base = 1;

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

val = reward - (discount.*(effort.^2));
prob =  exp(val.*beta)./(exp(base*beta) + exp(beta.*val));
prob(~chosen) =  1 - prob(~chosen);
prob = prob(:,1);

% calculate neg-log-likelihood
f=-nansum(log(prob));



end
