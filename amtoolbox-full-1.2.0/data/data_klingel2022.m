function data = data_klingel2022
%DATA_KLINGEL2022 Data from of Klingel & Laback (2022)
%   Usage: data = data_klingel2022
%
%   Output parameters:
%     data   : structure containing the data
%
%   Lateralization data with spatially inconsistent ITD and ILD cues
%
%   The field data_exp1 comprises the raw data of experiment 1:
%
%     'dimension1'   trial
%
%     'dimension2'   frequency band (-1 = multi, 1 = low,
%                          2 = mid-low, 3 = mid-high, 4 = high)
%                          ITD azimuth (deg)
%                          ILD azimuth (deg)
%                          response azimuth (deg)
%                          response time (ms)
%                          item repetition
%
%     'dimension3'    testing time (pretest, posttest)
%
%     'dimension4'   subject (odd numbers belong to ITD group,
%                          even numbers belong to ILD group)
%
%   The field data_exp2 comprises the raw data of experiment 2:
%
%     'dimension1'   trial
%
%     'dimension2'   frequency band (2 = mid-low, 3 = mid-high)
%                    ITD azimuth (deg) 
%                    ILD azimuth (deg)
%                    response azimuth (deg)
%                    response time (ms)
%                    item repitition
%
%     'dimension3'    testing time (pretest, posttest)
%
%     'dimension4'   subject (odd numbers belong to ITD group,
%                          even numbers belong to ILD group)
%
%   Url: http://amtoolbox.org/amt-1.2.0/doc/data/data_klingel2022.php

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

% AUTHOR: Maike Klingel, Acoustics Research Institute, Vienna, Austria
% adapted for AMT by Clara Hollomey

x = amt_load('klingel2022', 'data_exp1.mat');
y = amt_load('klingel2022', 'data_exp2.mat');
data.exp1 = x.data_exp1;
data.exp2 = y.data_exp2;

