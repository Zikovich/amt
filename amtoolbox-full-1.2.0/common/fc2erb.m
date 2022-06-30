function erb = fc2erb(fc)
%FC2ERB calculates the ERB index from a given frequency
%
%   Usage: erb = fc2erb(fc)
%
%   FC2ERB accepts a vector of center frequencies
%   fc as an input and converts them to their index
%   on the ERB scale in [cam].
%
%   Url: http://amtoolbox.org/amt-1.2.0/doc/common/fc2erb.php

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

    erb = 21.366*log10(0.004368.*fc + 1);
end

