function [Loudness, LoudnessLeft, LoudnessRight] = moore2016_binauralloudness( SpecificLoudnessLeftMon, SpecificLoudnessRightMon )
%MOORE2016_BINAURALLOUDNESS Calculate the binaural loudness out of monaural loudness at 0.25-ERB steps
%
%   Input parameters:
%     SpecificLoudnessLeftMon : monaural specific loudness left ear
%     SpecificLoudnessRightMon : monaural specific loudness right ear
%
%   Output parameters:
%     Loudness      : binaural loudness
%     LoudnessLeft  : loudness at left ear
%     LoudnessRight : loudness at right ear
%
%   This code weights the respective monaural loudness taking account binaural
%   inhibition for calculating the binaural loudness in moore2016
%   in the version for TVL 2016 based on ANSI S3.4-2007 and Moore & Glasberg (2007).
%
%   Url: http://amtoolbox.org/amt-1.2.0/doc/modelstages/moore2016_binauralloudness.php

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


g = -18:0.25:18; 
W = exp( -(0.08 .* g) .^2 );

SpecificLoudnessLeftSmoothed  = conv(W,SpecificLoudnessLeftMon)/sum(W);
SpecificLoudnessLeftSmoothed  = SpecificLoudnessLeftSmoothed(73:222);   
SpecificLoudnessRightSmoothed = conv(W,SpecificLoudnessRightMon)/sum(W); 
SpecificLoudnessRightSmoothed = SpecificLoudnessRightSmoothed(73:222);

SpecificLoudnessLeftSmoothed  = SpecificLoudnessLeftSmoothed + 10^-13;
SpecificLoudnessRightSmoothed = SpecificLoudnessRightSmoothed + 10^-13;

p = 1.5978;

InhibLeft = 2 ./ ( 1 + ( sech( SpecificLoudnessRightSmoothed ./ SpecificLoudnessLeftSmoothed ) ) .^ p ); 
InhibRight = 2 ./ ( 1 + ( sech( SpecificLoudnessLeftSmoothed ./ SpecificLoudnessRightSmoothed ) ) .^ p );

SpecificLoudnessLeft = SpecificLoudnessLeftMon ./ InhibLeft; 
SpecificLoudnessRight = SpecificLoudnessRightMon ./ InhibRight;            

LoudnessLeft = sum(SpecificLoudnessLeft) / 4;   
LoudnessRight = sum(SpecificLoudnessRight) / 4;

Loudness = LoudnessLeft + LoudnessRight;  

