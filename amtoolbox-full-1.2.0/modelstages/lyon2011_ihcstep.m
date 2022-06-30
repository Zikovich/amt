function [ihc_out, state] = lyon2011_ihcstep(filters_out, coeffs, state)
%LYON2011_IHCSTEP update of inner-hair-cell (IHC) model
%
%   Usage: [CF, decim_naps, naps, BM, ohc, agc] = lyon2011(CF, input_waves, AGC_plot_fig_num, open_loop);
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
%   LYON2011_IHCSTEP updates the inner-hair-cell (IHC) model, including the
%   detection nonlinearity and one or two capacitor state variables.
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
%   Url: http://amtoolbox.org/amt-1.2.0/doc/modelstages/lyon2011_ihcstep.php

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



% AC couple the filters_out, with 20 Hz corner
ac_diff = filters_out - state.ac_coupler;
state.ac_coupler = state.ac_coupler + coeffs.ac_coeff * ac_diff;

if coeffs.just_hwr
  ihc_out = min(2, max(0, ac_diff));  % limit it for stability
else
  %conductance = lyon2011_detect(ac_diff);
  % An IHC-like sigmoidal detection nonlinearity for the CARFAC.
  % Resulting conductance is in about [0...1.3405]
  a = 0.175;   % offset of low-end tail into neg x territory
  % this parameter is adjusted for the book, to make the 20% DC
  % response threshold at 0.1

  set = ac_diff > -a;
  z = ac_diff(set) + a;

  % zero is the final answer for many points:
  conductance = zeros(size(ac_diff));
  conductance(set) = z.^3 ./ (z.^3 + z.^2 + 0.1);
    
  if coeffs.one_cap
    ihc_out = conductance .* state.cap_voltage;
    state.cap_voltage = state.cap_voltage - ihc_out .* coeffs.out_rate + ...
      (1 - state.cap_voltage) .* coeffs.in_rate;
  else
    % change to 2-cap version more like Meddis's:
    ihc_out = conductance .* state.cap2_voltage;
    state.cap1_voltage = state.cap1_voltage - ...
      (state.cap1_voltage - state.cap2_voltage) .* coeffs.out1_rate + ...
      (1 - state.cap1_voltage) .* coeffs.in1_rate;

    state.cap2_voltage = state.cap2_voltage - ihc_out .* coeffs.out2_rate + ...
      (state.cap1_voltage - state.cap2_voltage) .* coeffs.in2_rate;
  end

  % smooth it twice with LPF:

  ihc_out = ihc_out * coeffs.output_gain;
  state.lpf1_state = state.lpf1_state + coeffs.lpf_coeff * ...
    (ihc_out - state.lpf1_state);
  state.lpf2_state = state.lpf2_state + coeffs.lpf_coeff * ...
    (state.lpf1_state - state.lpf2_state);
  ihc_out = state.lpf2_state - coeffs.rest_output;
end

state.ihc_accum = state.ihc_accum + ihc_out;  % for where decimated output is useful


