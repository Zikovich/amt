function [y_est] = llado2022_evaluatenn(x_test,NN_pretrained)
%LLADO2022_EVALUATENN evaluate the neural network
%   Usage: [y_est] = llado2022_evaluatenn(x_test,NN_pretrained)
%
%   Input parameters:
%     x_test             : Features of the test subset
%     NN_pretrained      : Pretrained network
%     hiddenLayerSize    : Size of the hidden layer
%
%   Output parameters:
%     y_est              : Estimated data
%
%   LLADO2022_EVALUATENN gives the estimation uncertainty of the neural
%   network
%
%   Url: http://amtoolbox.org/amt-1.2.0/doc/modelstages/llado2022_evaluatenn.php

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

for iter = 1:NN_pretrained.nIter
    net_dir = NN_pretrained.preTrained_dir(1,end,iter).net;
    net_uncertainty = NN_pretrained.preTrained_uncertainty(1,end,iter).net;

    y_hat_dir(iter,:) = net_dir(x_test);
    y_hat_uncertainty(iter,:) = net_uncertainty(x_test);

end
clear clipPos;
clipPos = find(y_hat_dir < -90);
y_hat_dir(clipPos) = -90;
clear clipPos;
clipPos = find(y_hat_dir > 90);
y_hat_dir(clipPos) = 90;

y_est(:,1) = mean(y_hat_dir);
y_est(:,2) = mean(y_hat_uncertainty);
end

