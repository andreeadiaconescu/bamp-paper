function [cue, cue_advice_space,y,input_u,takeAdv,take_helpfulAdvice, ...
    perf_acc,against_misleadingAdvice,percentage_against_advice_hiprob,...
    percentage_with_advice_lowprob] =  getBAMPData(details,options,fileBehav)


sub = details.dirSubject;
subjectData = {};
finalBehavMatrix{1,1} = {};
finalCodeMatrix{1,1}     = {};
if ~exist(fileBehav, 'file')
    warning('Behavioral logfile for subject %s not found', sub)
    y = [];
    input_u = [];
    takeAdv = [];
    take_helpfulAdvice = [];
    acc = [];
    perf_acc = [];
    remove_zeros = [];
    against_misleadingAdvice = [];
else
    subjectData = load(fileBehav);
    [behavMatrix,codeMatrix,~] = bamp_get_responses(subjectData.SOC.Session(2).exp_data,options);
    finalBehavMatrix = behavMatrix;
    finalCodeMatrix  = codeMatrix;
    outputMatrix     = finalBehavMatrix;
    outputCodes      = finalCodeMatrix;
    
    y            = outputMatrix(:,3);
    input_u      = [outputMatrix(:,1) outputMatrix(:,2)];
    iValid       = logical(outputMatrix(:,8));

end
save(fullfile(details.behav.pathResults,'behavMatrix.mat'), 'outputMatrix','-mat');

%% Behaviour statistics collected here

% iValid is the row of trials where a response was made; 1 = response made;
%                                                        0 = miss
remove_zeros_input        = (input_u(:,1)+ones(size(y)).*5)./6;
remove_ones_input         = (input_u(:,1)+ones(size(y)).*6)./6;
remove_ones_y             = (y(:,1)+ones(size(y)).*5)./5;

adviceCongruence          = input_u(iValid,1);
cue                       = input_u(iValid,2);
binaryLotteryMax          = double(cue == max(cue)); % Select trials when the cue probability is maximum
binaryLotteryMin          = double(cue == min(cue)); % Select trials when the cue probability is minimum

totalTrials               = size(y(iValid,1),1);
totalHelpfulTrials        = sum(adviceCongruence);
totalMisleadingTrials     = totalTrials-totalHelpfulTrials;

congruenceBehaviourAdvice          = double(y(iValid,1)==input_u(iValid,1));
adviceTakingBehaviour              = double(y(iValid,1)==remove_zeros_input(iValid,1));
adviceRefusalBehaviour             = double(remove_ones_y(iValid,1)==remove_ones_input(iValid,1));


perf_acc                 = sum(congruenceBehaviourAdvice)./totalTrials;
take_helpfulAdvice       = sum(adviceTakingBehaviour)./totalHelpfulTrials;
against_misleadingAdvice = sum(adviceRefusalBehaviour)./totalMisleadingTrials;
takeAdv                  = sum(y(iValid,1))./totalTrials;
go_against_advice        = ((binaryLotteryMax+(ones(size(binaryLotteryMax)).*-1)) == y(iValid,1)); % zeros will match zeros
go_with_advice           = ((binaryLotteryMin+(ones(size(binaryLotteryMin)).*5))./6 == y(iValid,1)); % ones will match ones

percentage_against_advice_hiprob           = sum(go_against_advice)./sum(binaryLotteryMax); % Calculate percentage of going against the advice when cue is 65%
percentage_with_advice_lowprob             = sum(go_with_advice)./sum(binaryLotteryMin);% Calculate percentage of going with the advice when cue is 35%

% Get the pie chart probabilities
cue                    = (outputMatrix(:,4));
cue_advice_space       = (outputMatrix(:,2));

fprintf('Subject took the advice (percent): %d\n', takeAdv);
fprintf('Subject took advice when it was helpful (percent): %d\n', take_helpfulAdvice);
if takeAdv<=0.5
    warning ('Something is wrong, check responses...');
end
end

