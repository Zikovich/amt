function [state, updated] = lyon2011_agcstep(detects, coeffs, state)
%LYON2011_AGCSTEP active gain control update step
%   Usage: [CF, decim_naps, naps, BM, ohc, agc] = lyon2011(CF, input_waves, AGC_plot_fig_num, open_loop);
%
%
%   Input parameters:
%     detects           : The CF struct holds the filterbank design and 
%                         state; if you want to break the input up into
%                         segments, you need to use the updated CF
%                         to keep the state between segments.
%     coeffs           : input_waves is a column vector if there's just one
%                        audio channel; more generally, it has a row per 
%                        time sample, a column per audio channel. The 
%                        input_waves are assumed to be sampled at the 
%                        same rate as the CARFAC is designed for. 
%                        A resampling may be needed before calling this.
%     state            : Plot automatic gain control figure. Default is 0.
%
%   Output parameters:
%     state            : The CF struct holds the filterbank design and 
%                        state; if you want to break the input up into
%                        segments, you need to use the updated CF
%                        to keep the state between segments.
%     update           : decim_naps is like naps but time-decimated by 
%                        the int CF.decimation.
%
%
%   See also:   lyon2011_agcstep lyon2011_carstep
%               lyon2011_closeagcloop lyon2011_design
%               lyon2011_ihcstep lyon2011_init
%               lyon2011_spatialsmooth
%               demo_lyon2011
%
%   References:
%     R. F. Lyon. Cascades of two-pole–two-zero asymmetric resonators are
%     good models of peripheral auditory function. J. Acoust. Soc. Am.,
%     130(6), 2011.
%     
%
%   Url: http://amtoolbox.org/amt-1.2.0/doc/modelstages/lyon2011_agcstep.php

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


stage = 1;
AGC_in = coeffs(1).detect_scale * detects;

while 1
  decim = coeffs(stage).decimation;
  % decim phase of this stage (do work on phase 0 only):
  decim_phase = mod(state(stage).decim_phase + 1, decim);
  state(stage).decim_phase = decim_phase;

  % accumulate input for this stage from detect or previous stage:
  state(stage).input_accum = state(stage).input_accum + AGC_in;

  % nothing else to do if it's not the right decim_phase
  if decim_phase == 0
    % do lots of work, at decimated rate.
    % decimated inputs for this stage, and to be decimated more for next:
    AGC_in = state(stage).input_accum / decim;
    state(stage).input_accum(:) = 0;  % reset accumulator
    
    if stage >= coeffs(1).n_AGC_stages
      break;
    end
  
    AGC_stage_state = state(stage).AGC_memory;
    % first-order recursive smoothing filter update, in time:
    AGC_stage_state = AGC_stage_state + ...
      coeffs(stage).AGC_epsilon * (AGC_in - AGC_stage_state);
    % spatial smooth:
    AGC_stage_state = ...
      lyon2011_spatialsmooth(coeffs(stage), AGC_stage_state);
    % and store the state back (in C++, do it all in place?)
    state(stage).AGC_memory = AGC_stage_state;
  
    updated = 1;  % bool to say we have new state
  else
    updated = 0;
    break;
  end

end

function stage_state = lyon2011_spatialsmooth(coeffs, stage_state)
% function AGC_state = lyon2011_spatialsmooth( ...
%   n_taps, n_iterations, FIR_coeffs, AGC_state)

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

