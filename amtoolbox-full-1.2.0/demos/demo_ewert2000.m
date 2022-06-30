%DEMO_EWERT2000 transfer function of the EPSM-filterbank 
%
%   DEMO_EWERT2000 outputs the transfer function of the EPSM-filterbank 
%   as presented in Ewert & Dau (2000)
%
%   Figure 1: Squared transfer functions of the filter bank
%
%   Url: http://amtoolbox.org/amt-1.2.0/doc/demos/demo_ewert2000.php

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

%   #Author : Clara Hollomey


fm = 50;    % Modulation frequency
l = 2;      % Length of the signal in seconds
fs = 44100; % Sampling frequency
t = 0:1/fs:l;
n = length(t);
noise = 1-2*randn(1,n);
modnoise = noise.*(1+cos(2*pi*t*fm));


[fcs, powers, TFs, freqs] = ewert2000(noise,fs);

figure
fnts = 14;
lw = 2;
% plot(freqs,10*log10(abs(TFs(1,:))),'linewidth',lw), hold on
for k = 1:7
    plot(freqs,10*log10(abs(TFs(k,:))),'linewidth',lw),hold on
end
title('Squared transfer functions of the filterbank')
xlabel('Frequency [Hz]','FontSize',fnts)
ylabel('Filter attenuation [dB]','FontSize',fnts)
set(gca,'XScale','linear','Xtick',fcs,'FontSize',fnts,'FontWeight','b');
xlim([1 79])
ylim([-20 5])
grid on

