function extract_data_run_inversion_Inti(iTask)

if nargin <1
    iTask='ioio'; % choose between wager or ioio
end


% Invert responses? If yes, set to true
doFitModel = true;

% Modify: Your Paths
datapath    = 'D:\Data SL';
modelpath   ='D:\Data SL\Scripts';
toolboxpath = 'G:\Tapas_V3.0\HGF'; % Christoph's Toolbox
addpath(datapath);
addpath(modelpath);
addpath(toolboxpath);

subjects={'A1701','A1702','A1703','A1704','A1705','A1706','A1708','A1709','A1710','A1711','A1712','A1713','A1714','A1715','A1716','A1717','A1718','P1701_retake','P1702','P1703','P1704','P1705',...   'P1706','P1707','P1708','P1709','P1710','P1711','P1712','P1713','P1714','P1715','P1716','P1717','P1718','P1720','P1721', 'P1722', 'P1721','V1701','V1702','V1703','V1704','V1705','V1706','V1707',...    'V1708','V1709','V1710','V1711','V1712','V1713-2','V1714','V1715','V1716'};

switch iTask
    case 'wager'
        rp_model = {'softmax_additiveprecision_reward_social'}; % Current Response Model
        prc_model= 'hgf_binary3l_reward_social'; % Current Perceptual Model
        run='7';
        input_u = load(fullfile(modelpath, 'final_inputs_advice_reward.txt'));% Input structure
        
        for i=1:numel(subjects)
            sub=subjects{i};
            load(fullfile(datapath, [sub , 'perblock_IOIO_run',run,'.mat']));
            outputmatrix =SOC.Session(2).exp_data;
            adviceBlue   =mod(outputmatrix(:,4),2);
            resp         = outputmatrix(:,8);
            respBlue     =mod(resp,2); % blue = 1, green = 2
            choice_congr = (adviceBlue == respBlue);
            choice       =double(choice_congr);
            takeAdv      =sum(choice)./160.*100;
            fprintf('Subject took the advice (percent): %d\n', takeAdv);
            y            =[choice outputmatrix(:,17)]; % Subject Choices: categorical wager
            % Get responses, performance accuracy, cumulative score
            acc          = sum(y(:,1)==input_u(:,1)); % Count the times when the decision and input was equal (i.e., go with the advice when helpful, go against the advice when misleading
            perf_acc     = (sum(nansum(acc)))/size(input_u,1); % Select all the accurate responses that are not NaNs
            RT_wager     = outputmatrix(:,16);
            RS_wager     = 1./RT_wager.*10^3; % response speed in seconds
            mean_RT      = mean(RT_wager);
            fprintf('Performance accuracy: %d\n', perf_acc);
            fprintf('Mean RT for wager: %d\n', mean_RT);
            %% Run Inversion
            if doFitModel==true;
                for iRsp=1:numel(rp_model)
                    disp(sub)
                    est  =tapas_fitModel(y,input_u,[prc_model,'_config'],[rp_model{iRsp},'_config']);
                    est.perf_acc=perf_acc;
                    est.cScore = SOC.cscore;
                    est.takeAdv = takeAdv;
                    save(fullfile(datapath, [sub '_' prc_model '_' rp_model{iRsp} '.mat']),'est','-mat');
                    hgf_plotTraj_reward_social(est);
                end
            else
                fullFileName=fullfile(datapath, [sub '_' prc_model '_' rp_model{iRsp} '.mat']);
                if exist(fullFileName, 'file')
                    disp(sub)
                    load(fullfile(datapath, [sub '_' prc_model '_' rp_model{iRsp} '.mat']),'est','-mat');
                    %% Compute learning trajectories
                    x_r                         =est.traj.muhat_r(:,1);
                    sa_r                        = x_r.*(1-x_r);
                    computationalTrajectory.Epsilon2_r     = abs(est.traj.sa_r(:,2).*est.traj.da_r(:,1));
                    computationalTrajectory.Epsilon3_r     = est.traj.sa_r(:,3).*est.traj.da_r(:,2);
                    computationalTrajectory.LearningRate_r = sa_r.*est.traj.sa_r(:,2);
                    computationalTrajectory.Wager          = (est.y(:,2)-mean(est.y(:,2),1));
                    x_a=est.traj.muhat_a(:,1);
                    sa_a = x_a.*(1-x_a);
                    computationalTrajectory.Epsilon2_a     = est.traj.sa_a(:,2).*est.traj.da_a(:,1);
                    computationalTrajectory.Epsilon3_a     = est.traj.sa_a(:,3).*est.traj.da_a(:,2);
                    computationalTrajectory.LearningRate_a = sa_a.*est.traj.sa_a(:,2);
                    computationalTrajectory.Wager          = (est.y(:,2)-mean(est.y(:,2),1));
                    hgf_plotTraj_reward_social(est);
                    %% Plot Learning Trajectories
                    figure;
                    % Subplots
                    subplot(5,1,1);
                    % Wager Amount and Response Speed
                    plot(computationalTrajectory.Wager, 'm', 'LineWidth', 4);
                    hold on;
                    plot(RS_wager,'k','LineWidth', 2);
                    
                    subplot(5,1,2);
                    % Epsilon 2 and Learning Rate for Reward
                    plot(computationalTrajectory.Epsilon2_r , 'r', 'LineWidth', 4);
                    hold on;
                    plot(computationalTrajectory.LearningRate_r,'k','LineWidth', 2);
                    
                    subplot(5,1,3);
                    plot(computationalTrajectory.Epsilon3_r, 'c', 'LineWidth', 4);
                    
                    subplot(5,1,4);
                    % Epsilon 2 and Learning Rate for Advice
                    plot(abs(computationalTrajectory.Epsilon2_a), 'b', 'LineWidth', 4);
                    hold on;
                    plot(computationalTrajectory.LearningRate_a,'k','LineWidth',2);
                    
                    subplot(5,1,5);
                    plot(computationalTrajectory.Epsilon3_a, 'g', 'LineWidth', 4);
                    xlabel('Trial number');
                    hold on;
                    
                    subplot(5,1,1);
                    title([sprintf('cscore = %d', SOC.cscore), ' with \zeta=', ...
                        num2str(est.p_obs.ze1), ...
                        ' for subject ', sub], ...
                        'FontWeight', 'bold');
                end
            end
        end
    case 'ioio'
        rp_model      = {'ioio_constant_voltemp_exp_config'}; % Current Response Model
        prc_model     = 'tapas_hgf_binary_free_initvalues';  % Current Perceptual Model
        run           ='7_EEG';
        cue           =load('DMPAD_N189_cue.txt');
        for i=1:numel(subjects)
            sub=subjects{i};
            load(fullfile(datapath, [sub, 'perblock_IOIO_run',run, '.mat']));
            outputmatrix  =get_responses(SOC.Session(2).exp_data);
            y             =outputmatrix(:,1);
            input_u       =outputmatrix(:,5);
            temp          =double(input_u==y);
            takeAdv       =sum(y)/size(temp,2);
            fprintf('Subject took the advice (percent): %d\n', takeAdv);
            input_u       = [input_u cue];
            %% Nonmodel-based metrics
            % Get responses, performance accuracy, cumulative score
            acc      = sum(y==input_u(:,1)); % Count the times when the decision and input was equal (i.e., go with the advice when helpful, go against the advice when misleading
            perf_acc = (sum(nansum(acc)))/size(input_u,1); % Select all the accurate responses that are not NaNs
            temp1    = (y==input_u(:,1)).*2; % Code correct responses with 1 and incorrect ones with -1 for cumulative score
            cScore   = sum((temp1+(ones(size(y)).*-1)));
            fprintf('Performance accuracy: %d\n', perf_acc);
            fprintf('Cumulative Score: %d\n', cScore);
            for iRsp=1:numel(rp_model)
                %%
                if doFitModel
                    disp(sub)
                    est=tapas_fitModel(y,input_u,[prc_model,'_config'],[rp_model{iRsp}]);
                    est.perf_acc=perf_acc;
                    est.cScore = cScore;
                    est.takeAdv = takeAdv;
                    hgf_plotTraj_ioio(est);
                    save(fullfile(datapath, [sub '_' prc_model '_' rp_model{iRsp} '.mat']),'est','-mat');
                else
                    fullFileName=fullfile(datapath, [sub '_' prc_model '_' rp_model{iRsp} '.mat']);
                    
                    if exist(fullFileName, 'file')
                        disp(sub)
                        disp(iRsp)
                        load(fullfile(datapath, [sub '_' prc_model '_' rp_model{iRsp} '.mat']),'est','-mat');
                        %% Compute learning trajectories
                        x=est.traj.muhat(:,1);
                        ze1=est.p_obs.ze1;
                        px = 1./(x.*(1-x));
                        pc = 1./(cue.*(1-cue));
                        wx = ze1.*px./(ze1.*px + pc);
                        wc = pc./(ze1.*px + pc);
                        computationalTrajectory.Delta1   = abs(est.traj.da(:,1));
                        computationalTrajectory.Delta2   = est.traj.da(:,2);
                        computationalTrajectory.LearningRate = px.*est.traj.sa(:,2);
                        b = wx.*x + wc.*cue;
                        computationalTrajectory.OutcomePE= abs(input_u(:,1) - b);
                        computationalTrajectory.CuePE    = abs(input_u(:,1) - cue_new);
                        %% Plot Learning Trajectories
                        figure;
                        % Subplots
                        subplot(7,1,1);
                        plot([1:210]', 'k', 'LineWidth', 4);
                        hold all;
                        plot(ones(250,1).*0,'k','LineWidth', 1,'LineStyle','-.');
                        
                        subplot(7,1,2);
                        plot(est.traj.sa(:,3), 'm', 'LineWidth', 4);
                        hold on;
                        plot(ones(250,1).*0,'k','LineWidth', 1,'LineStyle','-.');
                        
                        subplot(7,1,3);
                        plot(computationalTrajectory.Delta2, 'r', 'LineWidth', 4);
                        hold on;
                        plot(ones(250,1).*0,'k','LineWidth', 1,'LineStyle','-.');
                        
                        subplot(7,1,4);
                        plot(computationalTrajectory.LearningRate, 'c', 'LineWidth', 4);
                        hold on;
                        plot(ones(250,1).*2.5,'k','LineWidth', 1,'LineStyle','-.');
                        
                        subplot(7,1,5);
                        plot(computationalTrajectory.Delta1, 'b', 'LineWidth', 4);
                        hold on;
                        plot(ones(250,1).*0.5,'k','LineWidth', 1,'LineStyle','-.');
                        
                        subplot(7,1,6);
                        plot(computationalTrajectory.OutcomePE, 'g', 'LineWidth', 4);
                        hold on;
                        plot(ones(250,1).*0.5,'k','LineWidth', 1,'LineStyle','-.');
                        
                        subplot(7,1,7);
                        plot(computationalTrajectory.CuePE,'y', 'LineWidth', 4);
                        hold on;
                        plot(ones(250,1).*0.5,'k','LineWidth', 1,'LineStyle','-.');
                        xlabel('Trial number');
                        hold off;
                    else
                        disp('Responses have not been inverted');
                    end
                    
                end
                
            end
        end
end


return;