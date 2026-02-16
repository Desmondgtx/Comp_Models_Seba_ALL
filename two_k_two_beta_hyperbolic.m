
function [f] = two_k_two_beta_hyperbolic(p,chosen,effort,reward,agent,stim_props,outtype)% same as in models above in same order
% p(1) = self discount 
% p(2) = other discount
% p(3) = beta self
% p(4) = beta other

%%%%% 1. Assign free parameters and other stuff:
discount = (agent==1).*p(1) + (agent==2).*p(2);
beta = (agent==1).*p(3) + (agent==2).*p(4);

base = 1;


%%%% Model -hyperbolic devalue reward by effort. seperate discount
%%%% parameters

val = reward ./ (1 + (discount.*(effort)));

prob =  exp(val.*beta)./(exp(base*beta) + exp(beta.*val));
prob(~chosen) =  1 - prob(~chosen);
prob = prob(:,1);

% calculate neg-log-likelihood
f=-nansum(log(prob));


end
