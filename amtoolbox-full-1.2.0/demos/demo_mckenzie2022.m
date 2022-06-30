% demo_mckenzie2022 demonstrates the use of the mckenzie2022 model: 
%   Predicting the Colouration between Binaural Signals.
%
%   Read in reference and test stimuli from the following paper:
%   McKenzie, T., Murphy, D. T., & Kearney, G. C. (2018). Diffuse-Field
%   Equalisation of Binaural Ambisonic Rendering. Applied Sciences, 8(10).
%   https://doi.org/10.3390/app8101956
%   The test compares binaural Ambisonic renders with and without
%   diffuse-field equalisation to HRTF convolutions.
%
%   This script also includes an example of a way to plot perceptual spectral 
%   difference values.
%
%   Figure 1: Spectral difference for all stimuli single values
%
%   Figure 2: Spectral difference for all stimuli
%
%   Figure 3: Spectral difference for all stimuli single values
%
%
%
%   References:
%     T. McKenzie, C. Armstrong, L. Ward, D. Murphy, and G. Kearney.
%     Predicting the colouration between binaural signals. Appl. Sci.,
%     12(2441), 2022.
%     
%
%   Url: http://amtoolbox.org/amt-1.2.0/doc/demos/demo_mckenzie2022.php

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
%   Thomas McKenzie, Cal Armstrong, Lauren Ward, Damian Murphy, Gavin Kearney
%   Correspondence to thomas.mckenzie@aalto.fi (happy to answer any questions
%   if you're having trouble!)


dbstop if error
clear variables; close all; clc

%% Read in listening test stimuli from McKenzie 2018 paper.
data = amt_load('mckenzie2022', 'sig_mckenzie2022.mat');
% data = load('sig_mckenzie2022.mat');

fs = data.fs;
rsH = data.rsH;
testDirections = data.testDirections;
tsA1 = data.tsA1;
tsA3 = data.tsA3;
tsA5 = data.tsA5;
tsD1 = data.tsD1;
tsD3 = data.tsD3;
tsD5 = data.tsD5;
% combine stimuli into one matrix
ts = cat(3,tsA1,tsA3,tsA5,tsD1,tsD3,tsD5);
rs = cat(3,rsH,rsH,rsH,rsH,rsH,rsH);
tsP = permute(ts,[1 3 2]);
rsP = permute(rs,[1 3 2]);

%% Run spectral difference calculation
%- simple example

% Parameters
domFlag = 0; % specify that inputs are time-domain signals
freqRange = [20 20000]; % calculate spectral difference between 20Hz and 20kHz
nfft = length(rs(:,1,1)); % fft window size same as signal length
f.fs = fs;f.nfft = nfft;f.minFreq = freqRange(1); f.maxFreq = freqRange(2);
datasetNormalisation = 0; % blank vector for using iterative dataset normalisation. if an int, then that fixes the dataset normalisation in dB. Thus for no normalisation, set to 0.

% Calculate perceptual spectral difference
[~,PSpecDiff] = mckenzie2022(tsP,rsP,domFlag,f,datasetNormalisation);
PSpecDiff = squeeze(PSpecDiff);

% get single values of spectral difference for all stimuli
PavgSpecDiffS = mean(PSpecDiff,2);

% plot values
plot_mckenzie2022(PavgSpecDiffS,testDirections);

%% Run spectral difference calculation
%- with normalisation, alternative frequency range, pre-model FFT calculation

% Parameters
domFlag = 2; % specify that inputs are frequency-domain signals in dB
freqRange = [1000 10000]; % this time for a 1kHz - 10kHz frequency range
nfft = length(rs(:,1,1));
%[tsF,f] = fftmatrix(tsP, fs, nfft, freqRange); % this time using an FFT calculation before spectral difference model
%rsF = fftmatrix(rsP, fs, nfft, freqRange);
%calculate fftmatrix-------------------------------------------------------
%--------------------------------------------------------------------------

% Take FFT of matrices
fft_matrix_input = fft(tsP, nfft); % Get Fast Fourier transform

% Compute freq bins for x-axis limits
fr_low = round(freqRange(1)*nfft/fs);
fr_high = round(freqRange(2)*nfft/fs);

% Get absolute values for frequency bins
fft_abs_matrix_input = abs(fft_matrix_input(fr_low:fr_high,:,:));

% Get values in dB
tsF = 20*log10(fft_abs_matrix_input);

% Frequency vector for plotting
%f = 0:fs/nfft:fs-(fs/nfft);
%f = f(fr_low:fr_high);
%--------------------------------------------------------------------------
% Take FFT of matrices
fft_matrix_input = fft(rsP, nfft); % Get Fast Fourier transform

% Compute freq bins for x-axis limits
fr_low = round(freqRange(1)*nfft/fs);
fr_high = round(freqRange(2)*nfft/fs);

% Get absolute values for frequency bins
fft_abs_matrix_input = abs(fft_matrix_input(fr_low:fr_high,:,:));

% Get values in dB
rsF = 20*log10(fft_abs_matrix_input);

% Frequency vector for plotting
f = 0:fs/nfft:fs-(fs/nfft);
f = f(fr_low:fr_high);


%--------------------------------------------------------------------------


datasetNormalisation = []; % blank vector for using iterative dataset normalisation. if an int, then that fixes the dataset normalisation in dB. Thus for no normalisation, set to 0.
w = 1; % for sample weighting. If input signals correspond to irregularly spaced points on a sphere, such as a gaussian quadrature, w could be a vector of solid angle weights, which is then used in the spectral difference calculation.
normalisationPlotFlag = 1; % show dataset normalisation curve
normalisationResolution = 0.001; % choose resolution of dataset normalisation - smaller number for finer resolution.

% Calculate perceptual spectral difference
[~,PSpecDiff] = mckenzie2022(tsF,rsF,domFlag,f,datasetNormalisation,w,normalisationPlotFlag,normalisationResolution);
PSpecDiff = squeeze(PSpecDiff);

% get single values of spectral difference for all stimuli
PavgSpecDiffS = mean(PSpecDiff,2);

% plot values
plot_mckenzie2022(PavgSpecDiffS,testDirections);


