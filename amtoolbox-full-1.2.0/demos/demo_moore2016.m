%DEMO_MOORE2016 calculates binaural loudness
%
%   Url: http://amtoolbox.org/amt-1.2.0/doc/demos/demo_moore2016.php

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

t = 1:32000;
s = sind(1000 * t).';
s = scaletodbspl(s, 100, 100);
%be careful when comparing to sone, scaletodbspl scales to rms
%so a 40 dBSPL sine set here will not lead exactly to 1 sone
Fs = 32000;
dBMax = 100;


filenameFilter = 'ff_32000.mat';

%calculate the outer/middleear filtering
s = moore2016_cochlea(s, filenameFilter);

%calculate the short term loudness
[InstantaneousSpecificLoudnessLeft, InstantaneousSpecificLoudnessRight] = moore2016_monauralinstspecloudness( s, Fs, dBMax );

%remove NAs (only necessary because the first value tends to be one, at least in Octave,
%and then, by successive summing, everything gets messed up)
InstantaneousSpecificLoudnessLeft(find(isnan(InstantaneousSpecificLoudnessLeft ))) = 0;
InstantaneousSpecificLoudnessRight(find(isnan(InstantaneousSpecificLoudnessRight ))) = 0;


ShortTermSpecificLoudnessLeft  = moore2016_shorttermspecloudness( InstantaneousSpecificLoudnessLeft );
ShortTermSpecificLoudnessRight = moore2016_shorttermspecloudness( InstantaneousSpecificLoudnessRight );

ShortTermLoudnessLeft  = zeros( size( ShortTermSpecificLoudnessLeft, 1 ), 1 );
ShortTermLoudnessRight = zeros( size( ShortTermSpecificLoudnessRight, 1 ), 1 );

%calculate the binaural loudness
for i = 1:size( ShortTermSpecificLoudnessLeft, 1 )
    [monauralShortTermLoudness(i), ShortTermLoudnessLeft(i), ShortTermLoudnessRight(i)] = moore2016_binauralloudness( ShortTermSpecificLoudnessLeft(i,:), ShortTermSpecificLoudnessRight(i,:) );
end

%calculate the long term loudness
LongTermLoudnessLeft   = moore2016_longtermloudness( ShortTermLoudnessLeft );
LongTermLoudnessRight  = moore2016_longtermloudness( ShortTermLoudnessRight );

LongTermLoudness = LongTermLoudnessLeft + LongTermLoudnessRight;

Loudness = max(LongTermLoudness);

ShortTermLoudness = ShortTermLoudnessLeft + ShortTermLoudnessRight;

% plot the results
out = plot_moore2016(ShortTermLoudness, LongTermLoudness);
