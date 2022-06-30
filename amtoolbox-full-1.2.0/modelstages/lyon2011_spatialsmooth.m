function stage_state = lyon2011_spatialsmooth(coeffs, stage_state)
%LYON2011_SPATIALSMOOTH spatial smoothing over FIR coefficients
%
%   Usage: stage_state = lyon2011_spatialsmooth(coeffs, stage_state)
%
%   Input parameters:
%     coeffs      : struct containing coeffs from AGC stage
%     stage_state : smoothed coefficients
%
%   Output parameters:
%     stage_state : smoothed coefficients
%
%   See also: lyon2011
%
%   Url: http://amtoolbox.org/amt-1.2.0/doc/modelstages/lyon2011_spatialsmooth.php

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

%   #Author: Amin Saremi (2016) adaptations for the AMT (based on <https://github.com/google/carfac>, Richard F. Lyon)
%   #Author: Clara Hollomey (2021) adaptation for the AMT 1.0
%   #License: gpl3

n_iterations = coeffs.AGC_spatial_iterations;

use_FIR = n_iterations < 4;  % or whatever condition we want to try

if use_FIR
  FIR_coeffs = coeffs.AGC_spatial_FIR;
  switch coeffs.AGC_spatial_n_taps
    case 3
      for iter = 1:n_iterations
        stage_state = ...
          FIR_coeffs(1) * stage_state([1, 1:(end-1)], :) + ...
          FIR_coeffs(2) * stage_state + ...
          FIR_coeffs(3) * stage_state([2:end, end], :);
      end
    case 5  % 5-tap smoother duplicates first and last coeffs:
      for iter = 1:n_iterations
        stage_state = ...
          FIR_coeffs(1) * (stage_state([1, 2, 1:(end-2)], :) + ...
          stage_state([1, 1:(end-1)], :)) + ...
          FIR_coeffs(2) *  stage_state + ...
          FIR_coeffs(3) * (stage_state([2:end, end], :) + ...
          stage_state([3:end, end, end-1], :));
      end
    otherwise
      error('Bad AGC_spatial_n_taps in lyon2011_spatialsmooth');
  end
else
  % use IIR method, back-and-forth first-order smoothers:
%  stage_state = SmoothDoubleExponential(stage_state,...
%    coeffs.AGC_polez1(stage), coeffs.AGC_polez2(stage));

  npts = size(stage_state, 1);
  state = zeros(size(stage_state, 2));
  for index = npts-10:npts
    input = stage_state(index, :);
    state = state + (1 - coeffs.AGC_polez1(stage)) * (input - state);
  end
  % smooth backward with polez2, starting with state from above:
  for index = npts:-1:1
    input = stage_state(index, :);
    state = state + (1 - coeffs.AGC_polez2(stage)) * (input - state);
    stage_state(index, :) = state;
  end
  % smooth forward with polez1, starting with state from above:
  for index = 1:npts
    input = stage_state(index, :);
    state = state + (1 - coeffs.AGC_polez1(stage)) * (input - state);
    stage_state(index, :) = state;
  end

end

