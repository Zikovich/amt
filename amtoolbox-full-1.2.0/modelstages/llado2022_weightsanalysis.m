function [] = llado2022_weightsanalysis(NN_pretrained)
%LLADO2022_WEIGHTSANALYSIS analyses the neural networks' weights
%   Usage: llado2022_weightsanalysis(NN_pretrained);
%
%   Input parameters:
%     NN_pretrained : Pretrained network
%
%   llado2022_weightsAnalysis analyses the weights learnt by the NN and plots
%   them to understand the importance of the training features.
%
%   Url: http://amtoolbox.org/amt-1.2.0/doc/modelstages/llado2022_weightsanalysis.php

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

% NN weights analysis: perceived direction
clear A B T TOTAL TOTALavg
for j = 1:8
    for i = 1:10
        A(:,:) = abs(NN_pretrained.preTrained_dir(1,j,i).net.IW{1}(:,:))';
        B(:) = abs(NN_pretrained.preTrained_dir(1,j,i).net.LW{2}(:,:))';
        T(i,:) = mean((A.*B)');
    end



    TOTAL(j,:) = mean(T);
end
TOTALavg = mean(TOTAL);
TOTALavg = TOTALavg./(sum(TOTALavg));
figure(3);

plot(TOTALavg(1:18),'b');
hold on;
figure(4);

plot(TOTALavg(19:end),'b');
hold on;


% NN weights analysis: position uncertainty
clear A B T TOTAL TOTALavg

for j = 1:8
    for i = 1:10
        A(:,:) = abs(NN_pretrained.preTrained_uncertainty(1,j,i).net.IW{1}(:,:))';
        B(:) = abs(NN_pretrained.preTrained_uncertainty(1,j,i).net.LW{2}(:,:))';
        T(i,:) = mean((A.*B)');

    end

    TOTAL(j,:) = mean(T);
end


TOTALavg = mean(TOTAL);
TOTALavg = TOTALavg./(sum(TOTALavg));
figure(3);
plot(TOTALavg(1:18),'r');
ylim([0.02 0.04])
xlim([0 19])
title("ITD weights")
legend("Perceived direction estimation", "Position uncertainty estimation",'Location','Southeast')
figure(4);
plot(TOTALavg(19:end),'r');
ylim([0.02 0.04])
xlim([0 19])
title("ILD weights")
legend("Perceived direction estimation", "Position uncertainty estimation",'Location','Southeast')
end

