function CTpara = CTscanpara()

% This code is to set parameters of the equi-angular CT scanning 

CTpara.angsize = 0.001*180/pi;     % angle between two neighbor rays
% CTpara.DetNum = 920;        % number of detector bins
CTpara.AngNum = 984;        % number of projection views
CTpara.SOD = 59.5;          % source-to-origin distance, [cm]

CTpara.imPixNum = 512;      % image pixels along x or y direction
CTpara.imPixScale = 0.08;   % the real size of each pixel, [cm]

% normalize
CTpara.SOD = CTpara.SOD/CTpara.imPixScale;