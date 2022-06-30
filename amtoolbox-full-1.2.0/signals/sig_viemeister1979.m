function intervals = sig_viemeister79(trackvar,modfreq,bandwidth)
  
fs=44100;
  
lowercutoff = 4000 - bandwidth;
uppercutoff = 4000;

siglen=22050;

nintervals=3;

intervals=randn(siglen,nintervals);

% Transform to frequency domain, and bandpass by cutting.
%
%   Url: http://amtoolbox.org/amt-1.2.0/doc/signals/sig_viemeister1979.php

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
fint=fftreal(intervals);

cutvec=zeros(siglen/2+1,nintervals);
sp=round(lowercutoff/2);
up=round(uppercutoff/2);
cutvec(sp:up,:)=ones(up-sp+1,nintervals);

fint=fint.*cutvec;

intervals=ifftreal(fint,siglen);

% Amplitude modulate the target
intervals(:,1)=intervals(:,1).*(1 + (10^(trackvar/20)*sin(2*pi*modfreq/fs*(0:siglen-1)')));

% Apply starting and ending ramps.
intervals=rampsignal(intervals,round(siglen*.05));

% Adjust level for presentation
intervals=setdbspl(intervals,70);
  
