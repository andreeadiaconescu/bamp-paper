function [iCombPercResp]  = bamp_get_model_space

iCombPercResp = zeros(15,2);
iCombPercResp(1:3,1)   = 1;
iCombPercResp(4:6,1)   = 2;
iCombPercResp(7:9,1)   = 3;
iCombPercResp(10:12,1) = 4;
iCombPercResp(13:15,1) = 5;

iCombPercResp(1:3,2)   = 1:3;
iCombPercResp(4:6,2)   = 4:6;
iCombPercResp(7:9,2)   = 4:6;
iCombPercResp(10:12,2) = 4:6;
iCombPercResp(13:15,2) = 4:6;

end