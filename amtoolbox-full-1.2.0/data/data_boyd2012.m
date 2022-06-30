function data = data_boyd2012
%DATA_BOYD2012 data from Boyd et al. (JASA-EL, 2012)
%
%   Usage: data = data_boyd2012
%
%   Output parameters:
%     data    : structure
%
%   The 'data' struct has the following fields:
%
%     'ID'               subject ID
%
%     'Resp'             externalization responses 
%
%     'BRIR'             binaural room impulse responses for 4 positions
%
%     'Target'           target stimuli (single and four talker conditions)
%
%     'Reference_1T'     reference stimuli (single talker)
%
%     'Reference_4T'     reference stimuli (four talkers)
%
%     'fs'               sampling rate in Hz
%
%   Mean externalization scores of NH listeners extracted from top panels 
%   (1 talker condition) of Fig. 1 
%
%   References:
%     A. W. Boyd, W. M. Whitmer, J. J. Soraghan, and M. A. Akeroyd. Auditory
%     externalization in hearing-impaired listeners: The effect of pinna cues
%     and number of talkers. J. Acoust. Soc. Am., 131(3):EL268--EL274, 2012.
%     [1]www: ]
%     
%     References
%     
%     1. http://dx.doi.org/10.1121/1.3687015
%     
%
%   Url: http://amtoolbox.org/amt-1.2.0/doc/data/data_boyd2012.php

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

%   AUTHOR: Robert Baumgartner, Acoustics Research Institute, Vienna, Austria

tmp = amt_load('boyd2012','boyd2012.mat');
data = tmp.data;

end

