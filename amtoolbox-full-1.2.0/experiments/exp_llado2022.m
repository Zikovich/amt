function varargout = exp_llado2022(varargin)
%EXP_LLADO2022 Experiments of Llado et al. (2022)
%
%   Usage: [] = exp_llado2022(flag) 
%
%   EXP_LLADO2022(flag) reproduces figures and results of the study  
%   from LLado et al. (2022).
%
%
%   To display Fig.5 use :
%
%     exp_llado2022('fig5');
%
%   To display Fig.6 use :
%
%     exp_llado2022('fig6');
%
%
%   See also: llado2022
%
%   Url: http://amtoolbox.org/amt-1.2.0/doc/experiments/exp_llado2022.php

% Copyright (C) 2009-2022 Piotr Majdak, Clara Hollomey, and the AMT team.
% This file is part of Auditory Modeling Toolbox (AMT) version 1.2.0
%
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <http://www.gnu.org/licenses/>.

%   Authors:
%   Pedro Lladó, Petteri Hyvärinen, Ville Pulkki.
%   Correspondence to pedro.llado@aalto.fi
%   adapted for AMT by Clara Hollomey


definput.flags.type = {'missingflag', 'fig5', 'fig6'};

[flags,~]  = ltfatarghelper({},definput,varargin);

if flags.do_missingflag
  flagnames=[sprintf('%s, ',definput.flags.type{2:end-2}),...
             sprintf('%s or %s',definput.flags.type{end-1},...
             definput.flags.type{end})];
  error('%s: You must specify one of the following flags: %s.', ...
      upper(mfilename),flagnames);
end

%% Load precomputed binaural estimates

    % Load pretrained model
    x = amt_load('llado2022', 'NN_pretrained.mat');
    NN_pretrained = x.NN_pretrained;
    
if flags.do_fig5
    % Load extracted binaural features itd and ild features
    x_input = [NN_pretrained.x_itd;NN_pretrained.x_ild];
    
    %% Training set: all devices but the test device
    testDevice = 'F-Gecko';
    
    % Getting the test subset
    angle_id = NN_pretrained.angle_id;
    nAngles = NN_pretrained.nAngles;
    device_id = NN_pretrained.device_id;
    nDevices = NN_pretrained.nDevices;
    y_output = NN_pretrained.y';
    testDevice_id = find(device_id == testDevice);

    testDevicePos = nAngles*(testDevice_id-1)+1:nAngles*(testDevice_id);

    x_test = x_input(:,testDevicePos);
    y_test = y_output(testDevicePos,:);
    
    %% evaluate pretrained model
    y_hat = llado2022_evaluatenn(x_test,NN_pretrained);    
    y_est_dir = y_hat(:,1);
    y_est_uncertainty = y_hat(:,2);


    if (isvector(y_est_dir) == 1 )
        y_est_dir = y_est_dir;
        y_est_uncertainty = y_est_uncertainty;
    else
        y_est_dir = mean(y_est_dir);
        y_est_uncertainty = mean(y_est_uncertainty);
    end

    plot_llado2022(y_est_dir,y_est_uncertainty,angle_id,y_test);
end

if flags.do_fig6
    llado2022_weightsanalysis(NN_pretrained);
end

