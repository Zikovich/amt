function [ShortTermSpecificLoudness, ShortTermLoudness] = moore2016_shorttermspecloudness( InstantaneousSpecificLoudness )
%MOORE2016_SHORTTERMSPECLOUDNESS calculates the short-term specific loudness
%   
%
%   Input parameters:
%     InstantaneousSpecificLoudness : monaural instantaneous specific loudness
%
%   Output parameters:
%     ShortTermSpecificLoudness : short term specific loudness
%     ShortTermLoudness         : short term loudness
%
%   This code calculates the short term specific loudness for the binaural 
%   loudness model moore2016 in the version for TVL 2016 based on ANSI S3.4-2007 and Moore & Glasberg (2007).
%
%   Url: http://amtoolbox.org/amt-1.2.0/doc/modelstages/moore2016_shorttermspecloudness.php

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


aA = 0.045;
aR = 0.033;

ShortTermSpecificLoudness = zeros( size(InstantaneousSpecificLoudness) );

ShortTermSpecificLoudness(1,:) = moore2016_agcnextframeofvector( zeros(1,150) , InstantaneousSpecificLoudness(1,:), aA, aR );
for i=2:size( InstantaneousSpecificLoudness, 1 )
    ShortTermSpecificLoudness(i,:) = moore2016_agcnextframeofvector( ShortTermSpecificLoudness(i-1,:), InstantaneousSpecificLoudness(i,:), aA, aR );
end

ShortTermLoudness = sum( ShortTermSpecificLoudness, 2 ) / 4;

end

function out = moore2016_agcnextframeofvector( vLastFrame, vThisInput, aA, aR )

outThisIsLarger = aA * vThisInput + ( 1 - aA ) * vLastFrame;   % attack
outLastIsLarger = aR * vThisInput + ( 1 - aR ) * vLastFrame;   % release

out = ( vThisInput > vLastFrame ) .* outThisIsLarger + ( vThisInput <= vLastFrame ) .* outLastIsLarger;

end

