function [modelresults] = run_pats_prosocial_motivation_model_con(data, pick_sample, modelID)

% INPUT:     - data: struct with fields .chosen, .effort, .reward, .agent
%           - pick_sample: integer specifying which sample (1-4)
%           - modelID: string identifying which model to run
% OUTPUT:    - modelresults: fitted model including parameter values, fval, etc.
%
% All models use fmincon with parameter bounds:
%   k parameters:    [0, 1.5]
%   beta parameters: [0, 100]

max_evals = 1000000;
options = optimset('MaxIter', max_evals, 'MaxFunEvals', max_evals*100);

% Number of subjects per sample
if pick_sample == 1
    numsubs = 48;
elseif pick_sample == 2
    numsubs = 45;
elseif pick_sample == 3
    numsubs = 45;
elseif pick_sample == 4
    numsubs = 84;
end

num_trials = 48;
num_conds  = 2;
stim_props = [num_trials; num_conds];

modelresults = {};

%% Loop through subjects
for j = 1:numsubs
    clear chosen effort reward agent

    chosen = data.chosen(:,j);
    effort = data.effort(:,j);
    reward = data.reward(:,j);
    agent  = data.agent(:,j);

    % Remove missed trials (chosen == 2)
    for i = 1:length(chosen)
        if chosen(i) == 2
            chosen(i) = NaN;
            reward(i) = NaN;
            effort(i) = NaN;
            agent(i)  = NaN;
        end
    end

    chosen = chosen(~isnan(chosen));
    reward = reward(~isnan(reward));
    effort = effort(~isnan(effort));
    agent  = agent(~isnan(agent));

    %% ==================== PARABOLIC ====================

    if strcmp(modelID, 'one_k_one_beta')
        lb = [0 0];
        ub = [1.5 100];
        Parameter = [.1 .1];
        outtype = 1;
        [out.x, out.fval, exitflag] = fmincon(@one_k_one_beta, Parameter,[],[],[],[],lb,ub,[],options,chosen,effort,reward,agent,stim_props,outtype);
        out.xnames = {'discount'; 'beta'};
        out.modelID = modelID;
        outtype = 2;
        modelout = one_k_one_beta(out.x,chosen,effort,reward,agent,stim_props,outtype);
        modelresults{j} = out;
        modelresults{j}.info = modelout;

    elseif strcmp(modelID, 'two_k_one_beta')
        lb = [0 0 0];
        ub = [1.5 1.5 100];
        Parameter = [.1 .1 .1];
        outtype = 1;
        [out.x, out.fval, exitflag] = fmincon(@two_k_one_beta, Parameter,[],[],[],[],lb,ub,[],options,chosen,effort,reward,agent,stim_props,outtype);
        out.xnames = {'k_self'; 'k_other'; 'beta'};
        out.modelID = modelID;
        outtype = 2;
        modelout = two_k_one_beta(out.x,chosen,effort,reward,agent,stim_props,outtype);
        modelresults{j} = out;
        modelresults{j}.info = modelout;

    elseif strcmp(modelID, 'two_k_two_beta')
        lb = [0 0 0 0];
        ub = [1.5 1.5 100 100];
        Parameter = [.1 .1 .1 .1];
        outtype = 1;
        [out.x, out.fval, exitflag] = fmincon(@two_k_two_beta, Parameter,[],[],[],[],lb,ub,[],options,chosen,effort,reward,agent,stim_props,outtype);
        out.xnames = {'k_self'; 'k_other'; 'beta_self'; 'beta_other'};
        out.modelID = modelID;
        outtype = 2;
        modelout = two_k_two_beta(out.x,chosen,effort,reward,agent,stim_props,outtype);
        modelresults{j} = out;
        modelresults{j}.info = modelout;

    elseif strcmp(modelID, 'one_k_two_beta')
        lb = [0 0 0];
        ub = [1.5 100 100];
        Parameter = [.1 .1 .1];
        outtype = 1;
        [out.x, out.fval, exitflag] = fmincon(@one_k_two_beta, Parameter,[],[],[],[],lb,ub,[],options,chosen,effort,reward,agent,stim_props,outtype);
        out.xnames = {'k'; 'beta_self'; 'beta_other'};
        out.modelID = modelID;
        outtype = 2;
        modelout = one_k_two_beta(out.x,chosen,effort,reward,agent,stim_props,outtype);
        modelresults{j} = out;
        modelresults{j}.info = modelout;

    %% ==================== LINEAR ====================

    elseif strcmp(modelID, 'one_k_one_beta_linear')
        lb = [0 0];
        ub = [1.5 100];
        Parameter = [.1 .1];
        outtype = 1;
        [out.x, out.fval, exitflag] = fmincon(@one_k_one_beta_linear, Parameter,[],[],[],[],lb,ub,[],options,chosen,effort,reward,agent,stim_props,outtype);
        out.xnames = {'k'; 'beta'};
        out.modelID = modelID;
        outtype = 2;
        modelout = one_k_one_beta_linear(out.x,chosen,effort,reward,agent,stim_props,outtype);
        modelresults{j} = out;
        modelresults{j}.info = modelout;

    elseif strcmp(modelID, 'two_k_one_beta_linear')
        lb = [0 0 0];
        ub = [1.5 1.5 100];
        Parameter = [.1 .1 .1];
        outtype = 1;
        [out.x, out.fval, exitflag] = fmincon(@two_k_one_beta_linear, Parameter,[],[],[],[],lb,ub,[],options,chosen,effort,reward,agent,stim_props,outtype);
        out.xnames = {'k_self'; 'k_other'; 'beta'};
        out.modelID = modelID;
        outtype = 2;
        modelout = two_k_one_beta_linear(out.x,chosen,effort,reward,agent,stim_props,outtype);
        modelresults{j} = out;
        modelresults{j}.info = modelout;

    elseif strcmp(modelID, 'two_k_two_beta_linear')
        lb = [0 0 0 0];
        ub = [1.5 1.5 100 100];
        Parameter = [.1 .1 .1 .1];
        outtype = 1;
        [out.x, out.fval, exitflag] = fmincon(@two_k_two_beta_linear, Parameter,[],[],[],[],lb,ub,[],options,chosen,effort,reward,agent,stim_props,outtype);
        out.xnames = {'k_self'; 'k_other'; 'beta_self'; 'beta_other'};
        out.modelID = modelID;
        outtype = 2;
        modelout = two_k_two_beta_linear(out.x,chosen,effort,reward,agent,stim_props,outtype);
        modelresults{j} = out;
        modelresults{j}.info = modelout;

    elseif strcmp(modelID, 'one_k_two_beta_linear')
        lb = [0 0 0];
        ub = [1.5 100 100];
        Parameter = [.1 .1 .1];
        outtype = 1;
        [out.x, out.fval, exitflag] = fmincon(@one_k_two_beta_linear, Parameter,[],[],[],[],lb,ub,[],options,chosen,effort,reward,agent,stim_props,outtype);
        out.xnames = {'k'; 'beta_self'; 'beta_other'};
        out.modelID = modelID;
        outtype = 2;
        modelout = one_k_two_beta_linear(out.x,chosen,effort,reward,agent,stim_props,outtype);
        modelresults{j} = out;
        modelresults{j}.info = modelout;

    %% ==================== HYPERBOLIC ====================

    elseif strcmp(modelID, 'one_k_one_beta_hyperbolic')
        lb = [0 0];
        ub = [1.5 100];
        Parameter = [.1 .1];
        outtype = 1;
        [out.x, out.fval, exitflag] = fmincon(@one_k_one_beta_hyperbolic, Parameter,[],[],[],[],lb,ub,[],options,chosen,effort,reward,agent,stim_props,outtype);
        out.xnames = {'k'; 'beta'};
        out.modelID = modelID;
        outtype = 2;
        modelout = one_k_one_beta_hyperbolic(out.x,chosen,effort,reward,agent,stim_props,outtype);
        modelresults{j} = out;
        modelresults{j}.info = modelout;

    elseif strcmp(modelID, 'two_k_one_beta_hyperbolic')
        lb = [0 0 0];
        ub = [1.5 1.5 100];
        Parameter = [.1 .1 .1];
        outtype = 1;
        [out.x, out.fval, exitflag] = fmincon(@two_k_one_beta_hyperbolic, Parameter,[],[],[],[],lb,ub,[],options,chosen,effort,reward,agent,stim_props,outtype);
        out.xnames = {'k_self'; 'k_other'; 'beta'};
        out.modelID = modelID;
        outtype = 2;
        modelout = two_k_one_beta_hyperbolic(out.x,chosen,effort,reward,agent,stim_props,outtype);
        modelresults{j} = out;
        modelresults{j}.info = modelout;

    elseif strcmp(modelID, 'two_k_two_beta_hyperbolic')
        lb = [0 0 0 0];
        ub = [1.5 1.5 100 100];
        Parameter = [.1 .1 .1 .1];
        outtype = 1;
        [out.x, out.fval, exitflag] = fmincon(@two_k_two_beta_hyperbolic, Parameter,[],[],[],[],lb,ub,[],options,chosen,effort,reward,agent,stim_props,outtype);
        out.xnames = {'k_self'; 'k_other'; 'beta_self'; 'beta_other'};
        out.modelID = modelID;
        outtype = 2;
        modelout = two_k_two_beta_hyperbolic(out.x,chosen,effort,reward,agent,stim_props,outtype);
        modelresults{j} = out;
        modelresults{j}.info = modelout;

    elseif strcmp(modelID, 'one_k_two_beta_hyperbolic')
        lb = [0 0 0];
        ub = [1.5 100 100];
        Parameter = [.1 .1 .1];
        outtype = 1;
        [out.x, out.fval, exitflag] = fmincon(@one_k_two_beta_hyperbolic, Parameter,[],[],[],[],lb,ub,[],options,chosen,effort,reward,agent,stim_props,outtype);
        out.xnames = {'k'; 'beta_self'; 'beta_other'};
        out.modelID = modelID;
        outtype = 2;
        modelout = one_k_two_beta_hyperbolic(out.x,chosen,effort,reward,agent,stim_props,outtype);
        modelresults{j} = out;
        modelresults{j}.info = modelout;

    end

end
