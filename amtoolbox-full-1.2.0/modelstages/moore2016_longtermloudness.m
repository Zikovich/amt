function Nlt = moore2016_longtermloudness( Nst )
%MOORE2016_LONGTERMLOUDNESS calculates the long term loudness
%
%   Usage: Nlt = moore2016_longtermloudness( Nst )
%
%   Input parameters:
%     Nst : short term loudness
%
%   Output parameters:
%     Nlt : long term loudness
%
%   This code calculates the long term loudness by assemling successive short term
%   loudness frames and applying the corresponding AGC stage. It is part of the binaural 
%   loudness model moore2016 in the version for TVL 2016 based on ANSI S3.4-2007 and Moore & Glasberg (2007).
%
%   Url: http://amtoolbox.org/amt-1.2.0/doc/modelstages/moore2016_longtermloudness.php

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

aA = 0.01;
aR = 0.00133;

Nlt = zeros( size(Nst) );

Nlt(1) = moore2016_agcnextframe( 0, Nst(1), aA, aR );
for i=2:length(Nst)
    Nlt(i) = moore2016_agcnextframe( Nlt(i-1), Nst(i), aA, aR );
end

