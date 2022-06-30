function [results] = moore1997(inSig,fs, varargin)
%MOORE1997  Loudness model for stationary signals
%   Usage: [results] = moore1997(inSig,fs);
%
%   Input parameters:
%     insig : input signal
%     fs    : sampling frequency [Hz]
%
%   Output parameters:
%     results: structure containing the excitation pattern
%   
%   Optional parameters:
%
%     'fs',fs     model-internal sampling frequency [Hz]; it is strongly
%                 recommended to use the default of 32 kHz
%
%     'flow',flow   lowest frequency at which to evaluate the outer/middle
%                   ear transfer function
%
%     'fhigh',fhigh   highest frequency at which to evaluate the outer/middle
%                     ear transfer function
%
%     'order',order   order of the FIR filter used for deriving the outer/middle
%                     ear transfer function
%
%     'erbStep',erbStep   spacing between successive excitation patterns [cam]
%
%     'erbFcMin',erbFcMin   lowest center frequency [Hz] at which to calculate the
%                           excitation pattern
%
%     'erbFcMax',erbFcMax   highest center frequency [Hz] at which to calculate the
%                           excitation pattern
%
%   This code calculates the excitation patterns as in moore1997 and the
%   specific loudness.
%
%   Examples:
%
%     fs = 32000; 
%     t = linspace(0,1,fs);
%     sig = sin(2*pi*1000*t).';
%     inSig = scaletodbspl(sig,100);  
%
%
%   See also: data_glasberg2002 exp_moore1997 glasberg2002
%
%   References:
%     B. C. J. Moore, B. R. Glasberg, and T. Baer. A Model for the Prediction
%     of Thresholds, Loudness, and Partial Loudness. J. Audio Eng. Soc,
%     45(4):224--240, 1997.
%     
%
%   Url: http://amtoolbox.org/amt-1.2.0/doc/models/moore1997.php

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

%   #StatusDoc: Satisfactory
%   #StatusCode: Satisfactory
%   #Verification: Untrusted
%   #Requirements: M-Signal
%   #Author: Thomas Deppisch

%% model

definput.import = {'moore1997'};

[~,kv]  = ltfatarghelper({},definput,varargin);

if fs ~= kv.fs
    inSig = resample(inSig, kv.fs, fs);
    fs = kv.fs;
end

fVec = kv.flow:kv.fhigh;   
data = data_glasberg2002('tfOuterMiddle1997','fVec',fVec);

% create FIR filter
tfLinear = 10.^(data.tfOuterMiddle/10);
outerMiddleFilter = fir2(kv.order, linspace(0, 1, length(fVec)), tfLinear);
earSig = filtfilt(outerMiddleFilter,1,inSig);   % why does filter(..) not work?

% compute fft
spect = fft(earSig);
fftLen = length(spect);
oneHz = (fftLen+2)/kv.fs;  % number of frequency bins representing 1Hz

numBins = round(fftLen/2+1);
compInt = 2*abs(spect(1:numBins)).^2/(numBins*fs);  % psd
compFq = linspace(0,fs/2,numBins);
nPoints = length(compFq);

% calculate ERB numbers corresponding to ERB mid frequencies    
erbNMin = fc2erb(kv.erbFcMin);
erbNMax = fc2erb(kv.erbFcMax);

erbN = erbNMin:kv.erbStep:erbNMax;    % numbers of erb bands
erbFc = erb2fc(erbN);               % center frequency of erb bands

erbLoFreq = erb2fc(erbN-0.5); % lower limit of each ERB filter
erbHiFreq = erb2fc(erbN+0.5); % upper limit of each ERB filter

%calculate intensity for each ERB (dB/ERB)
erbInt = zeros(size(erbFc));
for ii=1:length(erbFc)
    range = round(erbLoFreq(ii)*oneHz):round(erbHiFreq(ii)*oneHz);
    erbInt(ii) = sum(compInt(range));   % intensity sum in each erb
end

erbdB = 10*log10(erbInt./(20e-6)^2);   % intensity level in each erb using reference SPL of 20 uPa
p511 = 4*1000/f2erb(1000);    % p for fc=1kHz and a level of 51dB (at 1kHz filters are symmetrical)
erbdB2F = interp1([0 erbFc fs/2], [min(erbdB) erbdB min(erbdB)], compFq);   % map erbFc to compFq

eL = zeros(size(erbN));
for e = 1:length(erbN)
    erb = f2erb(erbFc(e));
    p51 = 4*erbFc(e)/erb;
    intensity = 0;
    for comp = 1:nPoints
        g = (compFq(comp)-erbFc(e))/erbFc(e);
        if g<0
            p = p51 - 0.35*(p51/p511) * (erbdB2F(comp)-51);
        else
            p = p51;
        end
        g = abs(g);
        w = (1+p*g)*exp(-p*g);
        intensity = intensity+w*compInt(comp);  %intensity per erb
    end
    eL(e) = intensity;
end
results.eLdB = 10*log10(eL./(20e-6)^2); % get dB SPL (20uPa reference)
results.erbN = erbN;

%% calculating specific loudness 
dataSL = data_glasberg2002('specLoud','fVec',erbFc);
tQdB = dataSL.tQ;
tQ = 10.^(tQdB./10);
tQdB500 = dataSL.tQ500;
%gdB = dataSL.g;    % low level gain in cochlea amplifier
g = 10.^((tQdB500-tQdB)/10);
a = dataSL.a;    % parameter for linearization around absolute threshold
alpha = dataSL.alpha;    % compressive exponent
c = dataSL.c; % constant to get loudness scale to sone

specLoud = zeros(size(eL));
specLoud1 = c*(2*eL./(eL+tQ)).^1.5 .*((g.* eL + a).^alpha-a.^alpha);
specLoud2 = c * ((g .*eL + a).^alpha - a.^alpha);
specLoud3 = c*(eL./1.04e6).^0.5;
specLoud(eL<tQ) = specLoud1(eL<tQ);
specLoud(eL<=10^10 & eL>tQ) = specLoud2(eL<=10^10 & eL>tQ);
specLoud(eL>10^10) = specLoud3(eL>10^10);

results.monauralLoudness = sum(specLoud,2) * kv.erbStep;     % integrate over the erbs
results.binauralLoudness = 2*results.monauralLoudness;  % use moore2016 (Modeling binaural loudness) for better results

