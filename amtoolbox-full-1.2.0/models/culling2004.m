function [bmld_out] = culling2004(coherence,phase_target,phase_int,fc)
%CULLING2004  Binaural speech intelligibility
%   Usage: [bmld_out] = culling2004(coherence,phase_target,phase_int,fc)
%
%   Input parameters:
%      coherence    : Maximum of the interaural cross-correlation, the
%                     value should be between 0 and 1.
%      phase_target : Interaural phase difference of target signal,
%                     between 0 and 2pi
%      phase_int    : Interaural phase difference of the interfering
%                     source, between 0 and 2pi
%      fc           : Centre frequency of the frequency channel
%
%   Output parameters:
%      bmld_output  : improvement in predicted signal threshold when 
%                     phase_target and phase_int differ compared to 
%                     when they are the same.
%
%   CULLING2004(coherence,phase_target,phase_int,fc) calculates the
%   binaural masking level difference for a signal in broadband noise. 
%   The input noise coherence and phase must be pre-calculated for the 
%   frequency channel bearing the signal. See JELFS2011 for an example on
%   how to calculate these.
% 
%   See also: jelfs2011
% 
%   References:
%     J. F. Culling, M. L. Hawley, and R. Y. Litovsky. The role of
%     head-induced interaural time and level differences in the speech
%     reception threshold for multiple interfering sound sources. J. Acoust.
%     Soc. Am., 116(2):1057--1065, august 2004.
%     
%     J. F. Culling, M. L. Hawley, and R. Y. Litovsky. Erratum: The role of
%     head-induced interaural time and level differences in the speech
%     reception threshold for multiple interfering sound sources. J. Acoust.
%     Soc. Am., 118(1):552--552, July 2005.
%     
%
%   Url: http://amtoolbox.org/amt-1.2.0/doc/models/culling2004.php

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

%   #StatusDoc: Good
%   #StatusCode: Perfect
%   #Verification: Unknown
%   #Author: J.Culling (1997): primary implementation
%   #Author: P. Majdak (2010): adaptations

 
k = (1 + 0.25^2) * exp((2*pi*fc)^2 * 0.000105^2);
bmld_out = 10 * log10 ((k - cos(phase_target-phase_int))/(k - coherence));

bmld_out = max(bmld_out,0);


