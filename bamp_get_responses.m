function [behavMatrix,codeMatrix,timingMatrix]=bamp_get_responses(InputFile,options)

%read inputfile1 into a matrix
inmatrix = InputFile;

onsets_resp=inmatrix(:,10);onsets_resp(onsets_resp<0) = NaN;
stimulusCodes = inmatrix(:,4);
videoCodes    = inmatrix(:,5);
outcomeCodes  = inmatrix(:,13);
subjectChoice = inmatrix(:,9);
subjectRT     = inmatrix(:,11);
isNotValid    = inmatrix(:,11)<0;
subjectRT(find(isNotValid))=NaN;
iValid        = inmatrix(:,11)>0;
responseCorrectness = inmatrix(:,15);
cumulativeScore     = inmatrix(:,16);

adviceBlue    = mod(videoCodes,2);
outcomeBlue   = mod(outcomeCodes,2);
choiceBlue    = mod(subjectChoice,2);
adviceCongruency   = double(adviceBlue == outcomeBlue);
choiceCongruency   = double(adviceBlue == choiceBlue);
choiceCongruency(find(isNotValid))=NaN;

% Transform pie chart into advice space
keySet        = options.task.cueCodes;
valueSet      = options.task.cueProbs;
M = containers.Map(keySet,valueSet);
for iTrial = 1:numel(stimulusCodes)
    probabilityCueBlue(iTrial,1) = M(stimulusCodes(iTrial,:));
    if adviceBlue(iTrial,1)==1
        pieChart(iTrial,1)=probabilityCueBlue(iTrial,1);
    else
        pieChart(iTrial,1)=1-probabilityCueBlue(iTrial,1);
    end
end

behavMatrix=[adviceCongruency pieChart choiceCongruency probabilityCueBlue subjectRT ...
            responseCorrectness cumulativeScore iValid];

codeMatrix = [stimulusCodes videoCodes outcomeCodes];

% Timing 
timeCue = inmatrix(:,6);
timeResponse = inmatrix(:,11);
timeTarget   = inmatrix(:,15);

timingMatrix=[timeCue timeResponse timeTarget];





