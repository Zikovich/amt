%demo_llado2022 shows the use of the llado2022 model. The detailed
%   procedure can be found in:
%   P. Lladó, P. Hyvärinen, V. Pulkki: Auditory model -based estimation of
%   the effect of head-worn devices on frontal horizontal localisation.
%
%   You can use this demo to train your own network.
%   Feel free to experiment with different conditions, subjective data,
%   parameters of the NN, or even for different purposes.
%   (Let me know if you are going to try this option and I will help you to
%   make it work).
%
%   Figure 1: Estimated direction (left) and position uncertainty (right) in the horizontal plane
%
%   Url: http://amtoolbox.org/amt-1.2.0/doc/demos/demo_llado2022.php

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

clear all



%% Run binaural auditory model to extract ITD and ILD from HRIR

% HRIR sofa folder
%mySofaFolder = 'SOFAfolder/';
train_lateral_angles=[0,10,30,50,70,290,310,330,350];
aux_angle = find(train_lateral_angles > 180);
angle_id = train_lateral_angles;
angle_id(aux_angle) = train_lateral_angles(aux_angle) - 360;
angle_id = sort(angle_id);

%Generate stimulus
fs = 48000;
stim = pinknoise(0.25*fs);

% Extract IRs from sofa files
%mySofaFiles = dir(mySofaFolder+"/*.sofa");
mySofaFiles(1).name = '00-OpenEars.sofa';
mySofaFiles(2).name = 'A-AKGk702-DIY.sofa';
mySofaFiles(3).name = 'B-AKGk702-Original.sofa';
mySofaFiles(4).name = 'C1-SavoxNoiseCom200-Default.sofa';
mySofaFiles(5).name = 'C2-SavoxNoiseCom200-Balanced.sofa';
%mySofaFiles = dir(mySofaFolder+"/*.sofa");
mySofaFiles(6).name = 'D-PeltorProTacII.sofa';
mySofaFiles(7).name = 'E1-BullardMagma-VisorDown.sofa';
mySofaFiles(8).name = 'E2-BullardMagma-VisorUp.sofa';
mySofaFiles(9).name = 'F-GeckoMK11.sofa';

nDevices = length(mySofaFiles); 

for file_id = 1:nDevices
    %sofaFile_name = strcat(mySofaFolder, mySofaFiles(file_id).name);
    sofaFile_name = mySofaFiles(file_id).name;
    ir_sofa = llado2022_extractirs(sofaFile_name,train_lateral_angles,fs);
    if file_id == 1
        ir = ir_sofa;
    else
        ir = [ir;ir_sofa];
    end
end

% Extract binaural features (ITD and ILD)
[x_train] = llado2022_binauralfeats(ir,stim,fs);
%     X_binaural_feats = binauralAuditoryModel(mySofaFolder,...
%         train_lateral_angles,stim,fs,1);


% Load subjective test data
y = amt_load('llado2022', 'Y_listeningTest_labels.mat');
Y_listeningTest_labels = y.Y_listeningTest_labels;
% Col1 : device
% Col2 : sound source lateral angle
% Col3 : perceived lateral angle (average)
% Col4 : position uncertainty (average)
y_train = Y_listeningTest_labels(:,3:4);

sofaFile_name_test = 'exampleTest.sofa';
test_ir = llado2022_extractirs(sofaFile_name_test,train_lateral_angles,fs);
x_test = llado2022_binauralfeats(test_ir,stim,fs);

% NN variables
hiddenLayerSize_dir = 22;
hiddenLayerSize_uncertainty = 16;
augmentation_ratio = 10;
SNR = 60;
nIter = 2; % number of iterations to train,evaluate the model (results are averaged)

for iter = 1:nIter
    %% Train NN: direction
    [net_dir,tr_dir] = llado2022_trainnn(x_train',y_train(:,1),hiddenLayerSize_dir,augmentation_ratio,SNR);

    %% Train NN: uncertainty
    [net_uncertainty,tr_uncertainty] = llado2022_trainnn(x_train',y_train(:,2),hiddenLayerSize_uncertainty,augmentation_ratio,SNR);

    %% Evaluate a new HWD
    y_est_dir(iter,:) = net_dir(x_test);
    y_est_uncertainty(iter,:) = net_uncertainty(x_test);
end


if (isvector(y_est_dir) == 1 )
    y_est_dir = y_est_dir;
    y_est_uncertainty = y_est_uncertainty;
else
    y_est_dir = mean(y_est_dir);
    y_est_uncertainty = mean(y_est_uncertainty);
end


plot_llado2022(y_est_dir,y_est_uncertainty,angle_id);



