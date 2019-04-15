function outputmatrix=get_responses(InputFile2)

%read inputfile1 into a matrix
inmatrix = InputFile2;

[rs cs] =size(inmatrix);

outputmatrix=[];

onsets_resp=inmatrix(:,10);onsets_resp(onsets_resp<0) = NaN;

isNotValid = inmatrix(:,11)<0;
RT = inmatrix(:,11);
RT(find(isNotValid))=NaN;
adviceBlue=mod(inmatrix(:,5),2);
outcomeBlue=mod(inmatrix(:,13),2);
isValidTrial = inmatrix(:,9)>=0;
resp = inmatrix(:,9);

respBlue=mod(resp,2); % blue = 1, green = 2
choice_congr  = (adviceBlue == respBlue);
input = (adviceBlue == outcomeBlue);
input_u = double(input);
choice=double(choice_congr);
tmp=inmatrix(:,15);
isWrongButton = inmatrix(:,9)<0;
tmp(find(isWrongButton))=NaN;
correctness=tmp+ones(size(inmatrix,1),1);
when_target=inmatrix(:,14);
when_cue=inmatrix(:,6);
outcome=inmatrix(:,13);
when_resp=when_cue+RT;
advice_outcome=[adviceBlue outcomeBlue input_u choice inmatrix(:,16)];
outputmatrix=[choice when_resp RT.*10^3 correctness./2 input_u when_target outcome when_cue];








