function [perf_acc,cScore,take_adv_helpful,go_against_adv_misleading,choice_with, ...
                choice_against,choice_with_chance,go_with_stable_helpful_advice,...
                adviceTakingSwitch,...
                go_with_volatile_advice, go_against_volatile_advice,...
                go_with_stable_helpful_advice1,go_with_stable_helpful_advice2,...
                take_adv_overall,RTStable,RTVolatile,AccuracyStable,AccuracyVolatile,RTStableAdvice1, RTStableAdvice2,...
                adviceBlock1, RTBlock1,adviceBlock2, RTBlock2,adviceBlock3,RTBlock3,adviceBlock4,RTBlock4,adviceBlock5,RTBlock5]...
                = getBAMPData(input_u,y,RT,iValid,options)

remove_zeros_input        = (input_u(:,1)+ones(size(y)).*5)./6;
remove_ones_input         = (input_u(:,1)+ones(size(y)).*6)./6;
remove_ones_y             = (y(:,1)+ones(size(y)).*5)./5;

% iValid is the row of trials where a response was made; 1 = response made;
%                                                        0 = miss
% logical array
adviceCongruence          = input_u(iValid,1);
cue                       = input_u(iValid,2);
binaryLotteryMax          = double(cue == max(cue)); % Select trials when the cue probability is maximum
binaryLotteryMin          = double(cue == min(cue)); % Select trials when the cue probability is minimum
binaryLotteryChance       = double(cue==0.55|cue==0.50); % Select trials when the cue probability is around 50%

totalTrials               = size(y(iValid,1),1);
totalHelpfulTrials        = sum(adviceCongruence);
totalMisleadingTrials     = totalTrials-totalHelpfulTrials;

congruenceBehaviourAdvice          = double(y(iValid,1)==input_u(iValid,1));
adviceTakingBehaviour              = double(y(iValid,1)==remove_zeros_input(iValid,1));
adviceRefusalBehaviour             = double(remove_ones_y(iValid,1)==remove_ones_input(iValid,1));


perf_acc                 = sum(congruenceBehaviourAdvice)./totalTrials; % percentage of correct trials, disregarding misses
take_adv_helpful         = sum(adviceTakingBehaviour)./totalHelpfulTrials;
go_against_adv_misleading= sum(adviceRefusalBehaviour)./totalMisleadingTrials;
take_adv_overall         = sum(y(iValid,1))./totalTrials;
go_against_advice        = ((binaryLotteryMax+(ones(size(binaryLotteryMax)).*-1)) == y(iValid,1)); % zeros will match zeros
choice_against           = sum(go_against_advice)./sum(binaryLotteryMax); % Calculate percentage of going against the advice when cue is 65%
go_with_advice           = ((binaryLotteryMin+(ones(size(binaryLotteryMin)).*5))./6 == y(iValid,1)); % ones will match ones
choice_with              = sum(go_with_advice)./sum(binaryLotteryMin);% Calculate percentage of going with the advice when cue is 35%
go_with_advice_chance    = ((binaryLotteryChance+(ones(size(binaryLotteryChance)).*5))./6 == y(iValid,1)); % ones will match ones
choice_with_chance       = sum(go_with_advice_chance)./sum(binaryLotteryChance);% Calculate percentage of going with the advice when cue is 35% 
temp1                    = (congruenceBehaviourAdvice).*2; % Code correct responses with 1 and incorrect ones with -1 for cumulative score
cScore                   = sum((temp1+(ones(size(y(iValid,1),1),1).*-1)));

% Advice taking in particular phases of the task
helpfulPhases                  = options.task.helpfulPhase1 + options.task.helpfulPhase2;
StableTrials                   = logical(iValid.*logical(helpfulPhases));
go_with_stable_helpful_advice  = sum(y(StableTrials))./sum(StableTrials); % go with advice in stable helpful phases
RTStable                       = mean(RT(StableTrials));
tempAccuracy                   = double(y(:,1)==input_u(:,1));
AccuracyStable                 = sum(tempAccuracy(StableTrials))./sum(StableTrials);
SwitchtoHelpfulTrials                        ...
                               = logical(iValid.*logical(options.task.switchHelpful));
adviceTakingSwitch ...
                               = sum(y(SwitchtoHelpfulTrials))./sum(SwitchtoHelpfulTrials);

VolatileTrials                 = logical(iValid.*logical(options.task.volatilePhase));
go_with_volatile_advice        = sum(y(VolatileTrials))./sum(VolatileTrials); % go with advice in volatile phases
go_against_volatile_advice     = 1 - go_with_volatile_advice;
RTVolatile                     = mean(RT(VolatileTrials));

AccuracyVolatile               = sum(tempAccuracy(VolatileTrials))./sum(VolatileTrials);

%new
StableH1Trials                 = logical(iValid.*logical(options.task.helpfulPhase1));
go_with_stable_helpful_advice1 = sum(y(StableH1Trials))./sum(StableH1Trials); % go with advice in stable helpful 1
RTStableAdvice1                = mean(RT(StableH1Trials));
%new2
StableH2Trials                 = logical(iValid.*logical(options.task.helpfulPhase2));
go_with_stable_helpful_advice2 = sum(y(StableH2Trials))./sum(StableH2Trials); % go with advice in stable helpful 2
RTStableAdvice2                = mean(RT(StableH2Trials));

%% Fine-combing of RT and Advice-Taking Behaviour (Block-analysis)
Block1_StableHelpful1 = logical(iValid.*logical(options.task.helpfulPhase1));
Block2_Chance1        = logical(iValid.*(logical(vertcat(zeros(42,1),ones(42,1),zeros(105,1)))));
Block3_Misleading     = logical(iValid.*logical(vertcat(zeros(84,1),ones(21,1),zeros(84,1))));
Block4_Chance2        = logical(iValid.*logical(vertcat(zeros(105,1),ones(42,1),zeros(42,1))));
Block5_StableHelpful2 = logical(iValid.*logical(options.task.helpfulPhase2));

adviceBlock1         = sum(y(Block1_StableHelpful1)./sum(Block1_StableHelpful1));
RTBlock1             = mean(RT(Block1_StableHelpful1));

adviceBlock2         = sum(y(Block2_Chance1)./sum(Block2_Chance1));
RTBlock2             = mean(RT(Block2_Chance1));

adviceBlock3         = sum(y(Block3_Misleading)./sum(Block3_Misleading));
RTBlock3             = mean(RT(Block3_Misleading));

adviceBlock4         = sum(y(Block4_Chance2)./sum(Block4_Chance2));
RTBlock4             = mean(RT(Block4_Chance2));

adviceBlock5        = sum(y(Block5_StableHelpful2)./sum(Block5_StableHelpful2));
RTBlock5             = mean(RT(Block5_StableHelpful2));
end

