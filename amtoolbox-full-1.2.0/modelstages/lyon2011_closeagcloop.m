function CF = lyon2011_closeagcloop(CF)
%LYON2011_CLOSEAGCLOOP active gain control loop
%   Usage: [CF, decim_naps, naps, BM, ohc, agc] = lyon2011(CF, input_waves, AGC_plot_fig_num, open_loop);
%
%
%   Input parameters:
%     detects             : The CF struct holds the filterbank design and 
%                           state; if you want to break the input up into
%                           segments, you need to use the updated CF
%                           to keep the state between segments.
%     coeffs              : input_waves is a column vector if there's just one
%                           audio channel; more generally, it has a row per 
%                           time sample, a column per audio channel. The 
%                           input_waves are assumed to be sampled at the 
%                           same rate as the CARFAC is designed for. 
%                           A resampling may be needed before calling this.
%     state               : Plot automatic gain control figure. Default is 0.
%
%   Output parameters:
%     state               : The CF struct holds the filterbank design and 
%                           state; if you want to break the input up into
%                           segments, you need to use the updated CF
%                           to keep the state between segments.
%     update              : decim_naps is like naps but time-decimated by 
%                           the int CF.decimation.
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
%   Url: http://amtoolbox.org/amt-1.2.0/doc/modelstages/lyon2011_closeagcloop.php

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

% fastest decimated rate determines interp needed:
decim1 = CF.AGC_params.decimation(1);

for ear = 1:CF.n_ears
  undamping = 1 - CF.ears(ear).AGC_state(1).AGC_memory; % stage 1 result
  % Update the target stage gain for the new damping:
%  new_g = lyon2011_stageg(CF.ears(ear).CAR_coeffs, undamping);
  % Return the stage gain g needed to get unity gain at DC

  r1 = CF.ears(ear).CAR_coeffs.r1_coeffs;  % at max damping
  a0 = CF.ears(ear).CAR_coeffs.a0_coeffs;
  c0 = CF.ears(ear).CAR_coeffs.c0_coeffs;
  h  = CF.ears(ear).CAR_coeffs.h_coeffs;
  zr = CF.ears(ear).CAR_coeffs.zr_coeffs;
  r  = r1 + zr .* undamping;
  g  = (1 - 2*r.*a0 + r.^2) ./ (1 - 2*r.*a0 + h.*r.*c0 + r.^2);

  % set the deltas needed to get to the new damping:
  CF.ears(ear).CAR_state.dzB_memory = ...
    (CF.ears(ear).CAR_coeffs.zr_coeffs .* undamping - ...
    CF.ears(ear).CAR_state.zB_memory) / decim1;
  CF.ears(ear).CAR_state.dg_memory = ...
    (new_g - CF.ears(ear).CAR_state.g_memory) / decim1;
end

