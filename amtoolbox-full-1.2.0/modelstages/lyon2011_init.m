function CF = lyon2011_init(CF)
%LYON2011_INIT initializes the CARFAC model
%
%   Usage:
%     CF = lyon2011_init(CF)
%
%   LYON2011_INIT allocates the state vector storage in the CF struct for one or more ears of CF
%
%   Url: http://amtoolbox.org/amt-1.2.0/doc/modelstages/lyon2011_init.php

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


n_ears = CF.n_ears;

for ear = 1:n_ears
  % for now there's only one coeffs, not one per ear
  CF.ears(ear).CAR_state = carinitstate(CF.ears(ear).CAR_coeffs);
  CF.ears(ear).IHC_state = ihcinitstate(CF.ears(ear).IHC_coeffs);
  CF.ears(ear).AGC_state = agcinitstate(CF.ears(ear).AGC_coeffs);
end


function state = carinitstate(coeffs)
n_ch = coeffs.n_ch;
state = struct( ...
  'z1_memory', zeros(n_ch, 1), ...
  'z2_memory', zeros(n_ch, 1), ...
  'zA_memory', zeros(n_ch, 1), ...
  'zB_memory', coeffs.zr_coeffs, ...
  'dzB_memory', zeros(n_ch, 1), ...
  'zY_memory', zeros(n_ch, 1), ...
  'g_memory', coeffs.g0_coeffs, ...
  'dg_memory', zeros(n_ch, 1) ...
  );


function state = agcinitstate(coeffs)
n_ch = coeffs(1).n_ch;
n_AGC_stages = coeffs(1).n_AGC_stages;
state = struct([]);
for stage = 1:n_AGC_stages
  % Initialize state recursively...
  state(stage).AGC_memory = zeros(n_ch, 1);
  state(stage).input_accum = zeros(n_ch, 1);
  state(stage).decim_phase = 0;  % integer decimator phase
end


function state = ihcinitstate(coeffs)
n_ch = coeffs.n_ch;
if coeffs.just_hwr
  state = struct('ihc_accum', zeros(n_ch, 1), ...
                 'ac_coupler', zeros(n_ch, 1));
else
  if coeffs.one_cap
    state = struct( ...
      'ihc_accum', zeros(n_ch, 1), ...
      'cap_voltage', coeffs.rest_cap * ones(n_ch, 1), ...
      'lpf1_state', coeffs.rest_output * ones(n_ch, 1), ...
      'lpf2_state', coeffs.rest_output * ones(n_ch, 1), ...
      'ac_coupler', zeros(n_ch, 1) ...
      );
  else
    state = struct( ...
      'ihc_accum', zeros(n_ch, 1), ...
      'cap1_voltage', coeffs.rest_cap1 * ones(n_ch, 1), ...
      'cap2_voltage', coeffs.rest_cap2* ones(n_ch, 1), ...
      'lpf1_state', coeffs.rest_output * ones(n_ch, 1), ...
      'lpf2_state', coeffs.rest_output * ones(n_ch, 1), ...
      'ac_coupler', zeros(n_ch, 1) ...
      );
  end
end




