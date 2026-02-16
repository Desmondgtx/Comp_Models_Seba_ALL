function [modelresults] = run_pats_prosocial_motivation_model(data, pick_sample, modelID)

%INPUT:     - data
%           - sample
%           - modelID: string identifying which model to run
% OUPUT:    - modelresults: fitted model including parameter values, fval, etc.


% some optional settings for fminsearch
max_evals       = 1000000;
options         = optimset('MaxIter', max_evals,'MaxFunEvals', max_evals*100);
%

% How many subjects are you modelling

if pick_sample ==1;
    
    numsubs= 48;
    
elseif pick_sample==2;
        
    numsubs= 45;   
    
elseif pick_sample==3;
    
    numsubs= 45;  
    
elseif pick_sample==4;
    
    numsubs= 84;  
    
end;

num_trials    = 48; % how many trials in total
num_conds     = 2; % number of conditions: 1=self and 2=other
stim_props = [num_trials;num_conds]; % make a new variable that has number of trials and number of conditions (thought I don't think I actually use it!)

modelresults={}; % make an empty variable to store the results


%% Loop through subjects.
for j = 1:numsubs;
clear chosen % clear variables to make sure htye are new for each subject
clear effort
clear reward
clear agent

    %%% 0.) Load information for that subject:    % load in each subjects variables for the experiment
    chosen = data.chosen(:,j); %matrix of choices on each trial. choice 0 = baseline, choice 1 = higher effort 2 = missed
    effort = data.effort(:,j); %matrix of effor t levels for each trial 1-5 for the 5 effort levels
    reward = data.reward(:,j); %matrix of reward levels for each trial 1-5 for the different reward levels
    agent  = data.agent (:,j); %matrix of condition (self or other) for each trial % 1= self, 2 = other
 
    
for i=1:length(chosen);
    
    if chosen(i)==2 %% if its a missed trial chosen = 2 so remove these trials by making them a NaN and removing NaNs from all variables
        
       chosen(i)=NaN;
       reward(i)=NaN;
       effort(i)=NaN;
       agent(i)=NaN;
        
    else chosen(i)=chosen(i);
        reward(i)=reward(i);
        effort(i)=effort(i);
        agent(i)=agent(i);
        
    end

end

chosen = chosen(~isnan(chosen));
reward = reward(~isnan(reward));
effort = effort(~isnan(effort));
agent  = agent(~isnan(agent));

    if strcmp(modelID, 'one_k_one_beta'),
        %%% I.) first fit the model:
        outtype=1;
        lb = [0 0];   %lower bounds on parameters  
        ub = [0.5 100]; %upper bounds on parameters
        
        Parameter=[.1 .1]; % staring values of each parameter.                                                                                                                           % the starting values of the free parameters
        [out.x, out.fval, exitflag] = fmincon(@one_k_one_beta, Parameter,[],[],[],[],lb,ub,[],options,chosen,effort,reward,agent,stim_props,outtype); 
        out.xnames={'discount';'beta';};             % the names of the free parameters (should be the same number as the number of starting values in the 'Parameter'
        out.modelID=modelID;
        %%% II.) Get modeled schedule:
        outtype=2;
        Parameter=out.x; 
        modelout = out;
        modelout=one_k_one_beta(Parameter,chosen,effort,reward,agent,stim_props,outtype); 
        %%% III.) Now save:
        modelresults{j}=out;
        modelresults{j}.info=modelout;
        
       
    elseif strcmp(modelID, 'two_k_one_beta'),
        %%% I.) first fit the model:
        outtype=1;
        
         lb = [0 0 0];   %lower bounds on parameters  
        ub = [0.5 0.5 100]; %upper bounds on parameters
        Parameter=[.1 .1 .1];                                                                                                                            % the starting values of the free parameters
        [out.x, out.fval, exitflag] = fmincon(@two_k_one_beta,Parameter,[],[],[],[],lb,ub,[],options,chosen,effort,reward,agent,stim_props,outtype); 
        out.xnames={'k_self'; 'k_other'; 'beta';};             % the names of the free parameters
        out.modelID=modelID;
        %%% II.) Get modeled schedule:
        outtype=2;
        Parameter=out.x;  
        modelout=two_k_one_beta(Parameter,chosen,effort,reward,agent,stim_props,outtype); 
        %%% III.) Now save:
        modelresults{j}=out;
        modelresults{j}.info=modelout;
        
    elseif strcmp(modelID, 'two_k_two_beta'),
        %%% I.) first fit the model:
        outtype=1;
        
         lb = [0 0 0 0];   %lower bounds on parameters  
        ub = [0.5 0.5 100 100]; %upper bounds on parameters
        Parameter=[.1 .1 .1 .1];                                                                                                                            % the starting values of the free parameters
        [out.x, out.fval, exitflag] = fmincon(@two_k_two_beta, Parameter,[],[],[],[],lb,ub,[],options,chosen,effort,reward,agent,stim_props,outtype); 
        out.xnames={'k_self'; 'k_other'; 'beta_self'; 'beta_other';};             % the names of the free parameters
        out.modelID=modelID;
        %%% II.) Get modeled schedule:
        outtype=2;
        Parameter=out.x;  
        modelout=two_k_two_beta(Parameter,chosen,effort,reward,agent,stim_props,outtype); 
        %%% III.) Now save:
        modelresults{j}=out;
        modelresults{j}.info=modelout;
        
    elseif strcmp(modelID, 'one_k_two_beta'),
        %%% I.) first fit the model:
        outtype=1;
         lb = [0 0 0 0];   %lower bounds on parameters  
        ub = [0.5 100 100]; %upper bounds on parameters
        Parameter=[.1 .1 .1];                                                                                                                            % the starting values of the free parameters
        [out.x, out.fval, exitflag] = fmincon(@one_k_two_beta,Parameter,[],[],[],[],lb,ub,[],options,chosen,effort,reward,agent,stim_props,outtype); 
        out.xnames={'k'; 'beta_self'; 'beta_other';};             % the names of the free parameters
        out.modelID=modelID;
        %%% II.) Get modeled schedule:
        outtype=2;
        Parameter=out.x;  
        modelout=one_k_two_beta(Parameter,chosen,effort,reward,agent,stim_props,outtype); 
        %%% III.) Now save:
        modelresults{j}=out;
        modelresults{j}.info=modelout;
        
%     elseif strcmp(modelID, 'one_k_one_beta_linear'),
%         %%% I.) first fit the model:
%         outtype=1;
%         Parameter=[.1 .1 ];                                                                                                                            % the starting values of the free parameters
%         [out.x, out.fval, exitflag] = fminsearch(@one_k_one_beta_linear,Parameter,options,chosen,effort,reward,agent,stim_props,outtype); 
%         out.xnames={'k'; 'beta'};             % the names of the free parameters
%         out.modelID=modelID;
%         %%% II.) Get modeled schedule:
%         outtype=2;
%         Parameter=out.x;  
%         modelout=one_k_one_beta_linear(Parameter,chosen,effort,reward,agent,stim_props,outtype); 
%         %%% III.) Now save:
%         modelresults{j}=out;
%         modelresults{j}.info=modelout;
%         
%     elseif strcmp(modelID, 'two_k_one_beta_linear'),
%         %%% I.) first fit the model:
%         outtype=1;
%         Parameter=[.1 .1 .1 ];                                                                                                                            % the starting values of the free parameters
%         [out.x, out.fval, exitflag] = fminsearch(@two_k_one_beta_linear,Parameter,options,chosen,effort,reward,agent,stim_props,outtype); 
%         out.xnames={'k_self'; 'k_other'; 'beta'};             % the names of the free parameters
%         out.modelID=modelID;
%         %%% II.) Get modeled schedule:
%         outtype=2;
%         Parameter=out.x;  
%         modelout=two_k_one_beta_linear(Parameter,chosen,effort,reward,agent,stim_props,outtype); 
%         %%% III.) Now save:
%         modelresults{j}=out;
%         modelresults{j}.info=modelout;
%         
%     elseif strcmp(modelID, 'two_k_two_beta_linear'),
%         %%% I.) first fit the model:
%         outtype=1;
%         Parameter=[.1 .1 .1 .1 ];                                                                                                                            % the starting values of the free parameters
%         [out.x, out.fval, exitflag] = fminsearch(@two_k_two_beta_linear,Parameter,options,chosen,effort,reward,agent,stim_props,outtype); 
%         out.xnames={'k_self'; 'k_other'; 'beta_self'; 'beta_other'};             % the names of the free parameters
%         out.modelID=modelID;
%         %%% II.) Get modeled schedule:
%         outtype=2;
%         Parameter=out.x;  
%         modelout=two_k_two_beta_linear(Parameter,chosen,effort,reward,agent,stim_props,outtype); 
%         %%% III.) Now save:
%         modelresults{j}=out;
%         modelresults{j}.info=modelout;
%         
%     elseif strcmp(modelID, 'one_k_two_beta_linear'),
%         %%% I.) first fit the model:
%         outtype=1;
%         Parameter=[.1 .1 .1 ];                                                                                                                            % the starting values of the free parameters
%         [out.x, out.fval, exitflag] = fminsearch(@one_k_two_beta_linear,Parameter,options,chosen,effort,reward,agent,stim_props,outtype); 
%         out.xnames={'k'; 'beta_self'; 'beta_other'};             % the names of the free parameters
%         out.modelID=modelID;
%         %%% II.) Get modeled schedule:
%         outtype=2;
%         Parameter=out.x;  
%         modelout=one_k_two_beta_linear(Parameter,chosen,effort,reward,agent,stim_props,outtype); 
%         %%% III.) Now save:
%         modelresults{j}=out;
%         modelresults{j}.info=modelout;
%    
%     elseif strcmp(modelID, 'one_k_one_beta_hyperbolic'),
%         %%% I.) first fit the model:
%         outtype=1;
%         Parameter=[.1 .1 ];                                                                                                                            % the starting values of the free parameters
%         [out.x, out.fval, exitflag] = fminsearch(@one_k_one_beta_hyperbolic,Parameter,options,chosen,effort,reward,agent,stim_props,outtype); 
%         out.xnames={'k'; 'beta'};             % the names of the free parameters
%         out.modelID=modelID;
%         %%% II.) Get modeled schedule:
%         outtype=2;
%         Parameter=out.x;  
%         modelout=one_k_one_beta_hyperbolic(Parameter,chosen,effort,reward,agent,stim_props,outtype); 
%         %%% III.) Now save:
%         modelresults{j}=out;
%         modelresults{j}.info=modelout;
%         
%     elseif strcmp(modelID, 'two_k_one_beta_hyperbolic'),
%         %%% I.) first fit the model:
%         outtype=1;
%         Parameter=[.1 .1 .1 ];                                                                                                                            % the starting values of the free parameters
%         [out.x, out.fval, exitflag] = fminsearch(@two_k_one_beta_hyperbolic,Parameter,options,chosen,effort,reward,agent,stim_props,outtype); 
%         out.xnames={'k_self'; 'k_other'; 'beta'};             % the names of the free parameters
%         out.modelID=modelID;
%         %%% II.) Get modeled schedule:
%         outtype=2;
%         Parameter=out.x;  
%         modelout=two_k_one_beta_hyperbolic(Parameter,chosen,effort,reward,agent,stim_props,outtype); 
%         %%% III.) Now save:
%         modelresults{j}=out;
%         modelresults{j}.info=modelout;
%         
%    elseif strcmp(modelID, 'two_k_two_beta_hyperbolic'),
%         %%% I.) first fit the model:
%         outtype=1;
%         Parameter=[.1 .1 .1 .1 ];                                                                                                                            % the starting values of the free parameters
%         [out.x, out.fval, exitflag] = fminsearch(@two_k_two_beta_hyperbolic,Parameter,options,chosen,effort,reward,agent,stim_props,outtype); 
%         out.xnames={'k_self'; 'k_other'; 'beta_self'; 'beta_other'};             % the names of the free parameters
%         out.modelID=modelID;
%         %%% II.) Get modeled schedule:
%         outtype=2;
%         Parameter=out.x;  
%         modelout=two_k_two_beta_hyperbolic(Parameter,chosen,effort,reward,agent,stim_props,outtype); 
%         %%% III.) Now save:
%         modelresults{j}=out;
%         modelresults{j}.info=modelout;
%         
%    elseif strcmp(modelID, 'one_k_two_beta_hyperbolic'),
%         %%% I.) first fit the model:
%         outtype=1;
%         Parameter=[.1 .1 .1 ];                                                                                                                            % the starting values of the free parameters
%         [out.x, out.fval, exitflag] = fminsearch(@one_k_two_beta_hyperbolic,Parameter,options,chosen,effort,reward,agent,stim_props,outtype); 
%         out.xnames={'k'; 'beta_self'; 'beta_other'};             % the names of the free parameters
%         out.modelID=modelID;
%         %%% II.) Get modeled schedule:
%         outtype=2;
%         Parameter=out.x;  
%         modelout=one_k_two_beta_hyperbolic(Parameter,chosen,effort,reward,agent,stim_props,outtype); 
%         %%% III.) Now save:
%         modelresults{j}=out;
%         modelresults{j}.info=modelout;
        
 
       
    end;
    
    

    
end;
