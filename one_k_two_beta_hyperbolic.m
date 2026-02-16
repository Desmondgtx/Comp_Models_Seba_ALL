function [f] = one_k_two_beta_hyperbolic(p,chosen,effort,reward,agent,stim_props,outtype)% same as in models above in same order


% p(1) = discount
% p(2) = self beta
% p(3) = other beta

%%%%% 1. Assign free parameters:
discount = p(1);

beta = (agent==1).*p(2) + (agent==2).*p(3);

base = 1;


%%%% Model -hyperbolically devalue reward by effort. 1 parameter for both
%%%% conditions


val = reward ./ (1 + (discount.*(effort)));
prob =  exp(val.*beta)./(exp(base*beta) + exp(beta.*val));
prob(~chosen) =  1 - prob(~chosen);
prob = prob(:,1);


%%%% Softmax

% calculate neg-log-likelihood
f=-nansum(log(prob));



end