%DEMO_ADAPTLOOP  Show the effect of adaptation
%
%   This script demonstrates the effect of adaptation applied to a test
%   signal with and without noise.
%
%   The test signal is made of a sinosoidal ramp up and down between 0
%   and 1.
%
%   Figure 1: Clean test signal
%
%      This figure shows the effect of adaptation on the clean test signal with and
%      without overshoot limiting.
%
%   Figure 2: Noisy test signal
%
%      This figure shows the effect of adaptation on the noisy test signal
%      with and without overshoot limiting. Notice that in the second plot,
%      the initial spike at the beginning of the signal caused from the sharp
%      transition from complete silence to noise is magnitudes larger than
%      the values in the rest of the output.
%
%   See also: adaptloop
%
%   Url: http://amtoolbox.org/amt-1.2.0/doc/demos/demo_adaptloop.php

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


fs=10000;
siglen=4500;
part=siglen/6;

insig=[zeros(part,1); rampup(part); ones(2*part,1); rampdown(part); zeros(part,1)];
x=(0:siglen-1)/fs;

figure;
subplot(2,1,1);
plot(x,20*log10(insig+eps));
title('Input signal (clean)');
ylabel('Level (dB)');
axis([xlim -100 0]);

subplot(2,1,2); hold on;
plot(x,adaptloop(insig,fs,0));
plot(x,adaptloop(insig,fs),'r');
legend({'No overshoot limit','With overshoot limit'});
ylabel('Level (model units)');
xlabel('Time (s)');
axe=axis;

% Add a low level of noise
insig=abs(insig+0.001*randn(siglen,1));

figure;
subplot(2,1,1);
plot(x,20*log10(insig+eps));
title('Input signal (with Gaussian noise)');
ylabel('Level (dB)');
axis([xlim -100 0]);

subplot(2,1,2); hold on;
plot(x,adaptloop(insig,fs,0));
plot(x,adaptloop(insig,fs),'r');
legend({'No overshoot limit','With overshoot limit'});
ylabel('Level (model units)');
xlabel('Time (s)');
axis(axe); 
