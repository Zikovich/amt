function [bmld_out] = bmld(coherence,phase_target,phase_int,fc)
%BMLD Returns the binaural masking level difference
%
%   Usage: 
%     [bmld_out] = bmld(coherence,phase_target,phase_int,fc)
%
%
%   Input parameters:
%     coherence     : interaural coherence
%     phase_target  : phase of the target signal
%     phase_int     : phase of the interferer
%     fc            : center frequency [Hz]
%
%   BMLD returns the frequency-dependent binaural masking level
%   difference as a function of the interaural coherence and the target's
%   and interferer's phase relation
%
%   reference to be cited for this bmld formula:
%   J. F. Culling, M. L. Hawley, and R. Y. Litovsky (2005) "Erratum: The role of
%   head-induced interaural time and level differences in the speech reception
%   threshold for multiple interfering sound sources," J. Acoust. Soc. Am. 118(1), 552.
%
%   Url: http://amtoolbox.org/amt-1.2.0/doc/common/bmld.php

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

%   #Author : Matthieu Lavandier


k = (1 + 0.25^2) * exp((2*pi*fc)^2 * 0.000105^2);
bmld_out = 10 * log10 ((k - cos(phase_target-phase_int))/(k - coherence));
if bmld_out < 0;
    bmld_out = 0;
end
%return

