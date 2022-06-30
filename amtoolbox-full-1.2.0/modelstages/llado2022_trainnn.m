function [net,tr] = llado2022_trainnn(x,y,hiddenLayerSize,augmentation_ratio,SNR)
%LLADO2022_TRAINNN trains the neural network
%   Usage: [net,tr] = llado2022_trainnn(x,y,hiddenLayerSize,augmentation_ratio,SNR);
%
%   Input parameters:
%     x                  : Features of the train subset
%     y                  : Labels for training the network
%     hiddenLayerSize    : Size of the hidden layer
%     augmentation_ratio : Ratio for data augmentation stage
%     SNR                : SNR of the augmented data
%
%   Output parameters:
%     net                : trained network
%     tr                 : training history
%
%   LLADO2022_TRAINNN trains the neural network
%
%   Url: http://amtoolbox.org/amt-1.2.0/doc/modelstages/llado2022_trainnn.php

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
clear net;
net = fitnet(hiddenLayerSize);

net.divideParam.trainRatio = 70/100;
net.divideParam.valRatio = 30/100;
net.divideParam.testRatio = 0/100;

%% Training data augmentation

Y_output_aug = y;
for aug_iter = 1:augmentation_ratio
    for id_col = 1:length(y(1,:))
        aux= y(:,id_col);
        Y_output_aug((aug_iter)*length(y(:,1))+1:(1+aug_iter)*length(y(:,1)),id_col) = aux;
    end
end

clear X_input_aug;
X_input_aug(:,:) = x(:,:);
for aug_iter = 1:augmentation_ratio
    for id_col = 1:length(x(1,:))
        aux= awgn(x(:,id_col),SNR,'measured');
        X_input_aug((aug_iter)*length(x(:,1))+1:(1+aug_iter)*length(x(:,1)),id_col) = aux;
    end
end

[net, tr] = train(net,X_input_aug',Y_output_aug');

end


