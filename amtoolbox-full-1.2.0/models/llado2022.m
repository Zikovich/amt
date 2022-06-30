function [y_est] = llado2022(ir,stim,fs,NN_pretrained)
%LLADO2022 Neural network localization
%   Usage: [y_est] = llado2022(ir);
%          [y_est] = llado2022(ir, stim);
%          [y_est] = llado2022(ir, stim, fs);
%          [y_est] = llado2022(ir, stim, fs, NN_pretrained);
%
%   Input parameters:
%     ir       : Impulse response according to the following matrix
%                dimensions [direction x time x channel/ear]
%
%   Output parameters:
%     y_est    : Estimated values for perceived direction and position uncertainty.
%
%   LLADO2022(...) is a model for estimating the effect of head-worn
%   devices on frontal horizontal localisation. A neural network (NN) was
%   trained using binaural features of a dummy head wearing different
%   head-worn devices to predict the data from a perceptual test using the
%   same devices. If you want to use your own data, please find in the
%   script 'demo_llado2022' the whole procedure.
%
%   Optional input parameters:
%
%     'stim'             stimulus. If empty, 250 ms of pink noise
%
%     'fs'               (DEFAULT = 48000)
%
%     'NN_pretrained'    if empty, a pretrained NN is used. 
%
%
%   To see details or to train a new NN, please see the script demo_LLADO2022
%
%   See also: exp_llado2022
%
%   Url: http://amtoolbox.org/amt-1.2.0/doc/models/llado2022.php

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

%   #StatusDoc: Good
%   #StatusCode: Perfect
%   #Verification: Verified
%   #Requirements: MATLAB M - Communication Systems

    %%  DEFAULT OPTIONAL INPUTS
    if nargin<4; load('NN_pretrained.mat'); end % Find an example on how to train the network in 'demo_llado2022'
    if nargin<3; fs=48000; end
    if nargin<2; stim = pinknoise(0.25*fs); end
    
    %% EXTRACT BINAURAL FEATURES
    binauralFeatures = llado2022_binauralFeats(ir,stim,fs);
    
    %% EVALUATE PRETRAINED NETWORK
    y_est = llado2022_evaluateNN(binauralFeatures,NN_pretrained);
end

