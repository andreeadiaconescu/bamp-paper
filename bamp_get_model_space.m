function [iCombPercResp]  = bamp_get_model_space

options = bamp_options();
if options.model.RT == true
    
    iCombPercResp = zeros(4,2); % Only integrated models here
    iCombPercResp(1,1)  = 1;
    iCombPercResp(2,1)  = 2;
    iCombPercResp(3,1)  = 3;
    iCombPercResp(4,1)  = 4;
    
    iCombPercResp(1,2) = 1;
    iCombPercResp(2,2) = 1;
    iCombPercResp(3,2) = 1;
    iCombPercResp(4,2) = 1;
    
else
    iCombPercResp = zeros(18,2); % 6 x 3
    iCombPercResp(1:3,1)   = 1;
    iCombPercResp(4:6,1)   = 2;
    iCombPercResp(7:9,1)   = 3;
    iCombPercResp(10:12,1) = 4;
    iCombPercResp(13:15,1) = 5;
    iCombPercResp(16:18,1) = 6;

    iCombPercResp(1:3,2)   = 1:3;
    iCombPercResp(4:6,2)   = 4:6;
    iCombPercResp(7:9,2)   = 4:6;
    iCombPercResp(10:12,2) = 4:6;
    iCombPercResp(13:15,2) = 4:6;
    iCombPercResp(16:18,2) = 4:6;
end

end