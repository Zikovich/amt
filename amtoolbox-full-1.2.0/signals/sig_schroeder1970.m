function sig = sig_schroeder1970(f0,n,C,fs,D)
%SIG_SCHROEDER1970 generates a Schroeder-phase harmonic complex tone
%   Usage: sig = sig_schroeder1970(f0,n,C,fs,D)
%
%   Input parameters:
%     f0 : fundamental frequency (Hz)
%     n : index vector specifying the contained harmonics
%     C : phase curvature, [-1,1]
%     fs : sampling rate (Hz)
%     D : signal duration (sec)
%
%   SIG_SCHROEDER1970 generates the Schroeder-signal with modified phase of the overtones
%
%   Url: http://amtoolbox.org/amt-1.2.0/doc/signals/sig_schroeder1970.php

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

%   References: 
%     M. R. Schroeder (1970). Synthesis of low-peak-factor signals and binary 
%     sequences with low autocorrelation. IEEE TIT, 16, 85-89.

% AUTHOR: Robert Baumgartner

t = 0:(1/fs):D;
phi = C*pi*n.*(n+1)/length(n);
f = f0*n;
sig = mean(repmat(f(end)./f(:),1,length(t)).*sin(2*pi*n'*f0*t + repmat(phi',1,length(t))),1);

end

