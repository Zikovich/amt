%DEMO_CULLING2004 Demo for testing culling2004.m
%
%   DEMO_CULLING2004 outputs the binaural masking level difference (BMLD) as 
%   a function of the maximum of the interaural coherence for a target phase
%   of pi.
%
%   Figure 1: Binaural masking level difference as a function of the maximum of the interaural coherence
%
%   Url: http://amtoolbox.org/amt-1.2.0/doc/demos/demo_culling2004.php

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

fc = 1000;
coherence = 0.1:0.1:1;
phase_target = pi;
phase_int = 0;

for ii = 1: length(coherence)
  [bmld_out(ii)] = culling2004(coherence(ii),phase_target,phase_int,fc);
end

figure
plot(coherence, bmld_out)
xlabel('Maximum of IC')
ylabel('Binaural masking level difference [dB]')
