function [weighted_BE_Aud_SNR, BESNR_perFB] = ...
    vicente2020_betterearsnrframe(fs, fc, MaskerSig, targ_left,targ_right, InternalNoise_L, InternalNoise_R, ceiling, weightings)
%VICENTE2020_BETTEREARSNRFRAME calculates the better ear SNR
%   Usage: [weighted_BE_Aud_SNR, BESNR_perFB] = vicente2020_betterearsnrframe(fs, fc, MaskerSig, targ_left,targ_right, InternalNoise_L, InternalNoise_R, ceiling, weightings)
%
%   VICENTE2020_BETTEREARSNRFRAME computes the better ear SNR
%   in all frequency bands centered at fc, considering the audiogram.
%
%   Url: http://amtoolbox.org/amt-1.2.0/doc/modelstages/vicente2020_betterearsnrframe.php

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


BESNR_perFB = zeros(1,length(fc));

for n = 1:length(fc)
    % Get the filtered signals 
    LeftMasker = auditoryfilterbank(MaskerSig(:,1),fs,fc(n), 'lavandier2022');        
    RightMasker = auditoryfilterbank(MaskerSig(:,2),fs,fc(n), 'lavandier2022');
    % Compute the effective masker
    EffectiveLeftMasker = max(20*log10(rms(LeftMasker)), InternalNoise_L(n));
    EffectiveRightMasker = max(20*log10(rms(RightMasker)), InternalNoise_R(n));
    % Compute the left and right SNR
    LeftSNR = targ_left(n) - EffectiveLeftMasker;
    RightSNR = targ_right(n) - EffectiveRightMasker;
    % Compute better-ear SNR
    BESNR_perFB(n) = min(ceiling,max(LeftSNR,RightSNR));
end
%SII weightings+integreation across frequency
weighted_BE_Aud_SNR = sum(BESNR_perFB.*weightings');

end

