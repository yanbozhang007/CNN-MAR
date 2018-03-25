function dispWin = disWinID(dataID)

% This code is to set ROI of the image
% Input:
% dataID:       ID of the selected sample
% Output:
% dispWin:      display window


if dataID == 1
    % case 1: hip prostheses
    dispWin = [0.12 0.28];
    
elseif dataID == 2
    % case 2: shoulder fixation screws
    dispWin = [0.12 0.25];
    
elseif dataID == 3
    % case 3: dental fillings
    dispWin = [0.0 0.45];
    
else
    % for other data
    dispWin = [0 0.5];
    
end






