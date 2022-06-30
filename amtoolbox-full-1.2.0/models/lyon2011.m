function [CF, decim_naps, naps, BM, ohc, agc] = lyon2011(input_waves, varargin)
%LYON2011 Cascade of asymmetric resonators with fast-acting compression (CARFAC) model
%   Usage: [CF, decim_naps, naps, BM, ohc, agc] = lyon2011(CF, input_waves, AGC_plot_fig_num, open_loop);
%
%
%   Input parameters:
%     CF               : optional struct, holds the filterbank design and state
%     input_waves      : input_waves is a column vector if there's just one
%                        audio channel; more generally, it has a row per 
%                        time sample, a column per audio channel. The 
%                        input_waves are assumed to be sampled at the 
%                        same rate as the CARFAC model is designed for. 
%                        A resampling may be needed before calling this.
%
%   Output parameters:
%     CF               : The CF struct holds the filterbank design and 
%                        state; if you want to break the input up into
%                        segments, you need to use the updated CF
%                        to keep the state between segments.
%     decim_naps       : decim_naps is like naps but time-decimated by 
%                        the int CF.decimation.
%     naps             : naps (neural activity patterns) has a row per 
%                        time sample, a column per filterbank channel, 
%                        and a layer per audio channel if `CF, AGC_plot_fig_num, 
%                        open_loop > 1`.
%     BM               : BM is basilar membrane motion (filter outputs before detection).
%     ohc              : optional extra output for diagnosing internals.
%     agc              : optional extra outputs for diagnosing internals.
%
%   LYON2011 runs the CARFAC model. That is, it filters a 1 or more channel sound 
%   input to make one or more neural activity patterns (naps).
%
%   Additional input parameters:
%
%     'CF',CF                    The CF struct holds the filterbank design and 
%                                state; if you want to break the input up into 
%                                segments, you need to use the updated CF 
%                                to keep the state between segments.
%
%     'AGC_plot_fig_num',fn      Plot automatic gain control figure. Default is 0.
%
%   Flags:
%
%     'open_loop'                Use model with open loop. Default is 0.
%
%
%
%   References:
%     R. F. Lyon. Cascades of two-pole–two-zero asymmetric resonators are
%     good models of peripheral auditory function. J. Acoust. Soc. Am.,
%     130(6), 2011.
%     
%
%   See also:   data_lyon2011 demo_lyon2011_impulseresponses demo_lyon2011
%               demo_lyon2011_compressivefunctions lyon2011_init lyon2011_ohcnlf
%               lyon2011_agcstep lyon2011_carstep lyon2011_ihcstep lyon2011_crosscouple
%               lyon2011_detect lyon2011_stageg lyon2011_closeagcloop
%               lyon2011_spatialsmooth lyon2011_design erbest f2erb
%
%   Url: http://amtoolbox.org/amt-1.2.0/doc/models/lyon2011.php

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

%   #StatusDoc: Good
%   #StatusCode: Good
%   #Verification: Unknown
%   #Author: Amin Saremi (2016) adaptations for the AMT (based on <https://github.com/google/carfac>, Richard F. Lyon)
%   #Author: Clara Hollomey (2021) adaptation for the AMT 1.0
%   #License: gpl3
  
definput.keyvals.CF = [];
definput.keyvals.AGC_plot_fig_num = 0;
definput.flags.open_loop = {'open_loop'};
  
[flags,kv,CF]=ltfatarghelper({'CF'},definput,varargin);

[n_samp, n_ears] = size(input_waves);
n_ch = CF.n_ch;

if n_ears ~= CF.n_ears
  error('bad number of input_waves channels passed to lyon2011')
end

BM = zeros(n_samp, n_ch, n_ears);
ohc = zeros(n_samp, n_ch, n_ears);
agc = zeros(n_samp, n_ch, n_ears);


seglen = 441;  % anything should work; this is 20 ms at default fs
n_segs = ceil(n_samp / seglen);

decim_naps = zeros(n_segs, CF.n_ch, CF.n_ears);
naps = zeros(seglen, CF.n_ch, CF.n_ears);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for seg_num = 1:n_segs
  
  if seg_num == n_segs
    % The last segement may be short of seglen, but do it anyway:
    k_range = (seglen*(seg_num - 1) + 1):n_samp;
  else
    k_range = seglen*(seg_num - 1) + (1:seglen);
  end

  detects = zeros(n_ch, n_ears);

  for k = 1:n_samp
    for ear = 1:n_ears
    
      % One sample-time update step for the filter part of the model, including
      % includes OHC feedback
      [car_out, CF.ears(ear).CAR_state] = lyon2011_carstep( ...
        input_waves(k, ear), CF.ears(ear).CAR_coeffs, CF.ears(ear).CAR_state);
    
      % update IHC state & output on every time step, too
      [ihc_out, CF.ears(ear).IHC_state] = lyon2011_ihcstep( ...
        car_out, CF.ears(ear).IHC_coeffs, CF.ears(ear).IHC_state);
    
      % run the AGC update step, decimating internally
      [CF.ears(ear).AGC_state, updated] = lyon2011_agcstep( ...
        ihc_out, CF.ears(ear).AGC_coeffs, CF.ears(ear).AGC_state);
    
      % save some output data:
      seg_naps(k, :, ear) = ihc_out;  % output to neural activity pattern
      
      % write out
      BM(k, :, ear) = car_out;
      state = CF.ears(ear).CAR_state;
      seg_ohc(k, :, ear) = state.zA_memory;
      seg_agc(k, :, ear) = state.zB_memory;

      naps(k, :, ear) = seg_naps(k, :, ear);
      ohc(k, :, ear) = seg_ohc(k, :, ear);
      agc(k, :, ear) = seg_agc(k, :, ear);
      decim_naps(seg_num, :, ear) = CF.ears(ear).IHC_state.ihc_accum / seglen;
      CF.ears(ear).IHC_state.ihc_accum = zeros(n_ch,1);
      
    end
    end
  
    % connect the feedback from AGC_state to CAR_state when it updates;
    if updated 
      if n_ears > 1
        % do multi-aural cross-coupling:
        CF.ears = lyon2011_crosscouple(CF.ears);
        if ~flags.do_open_loop
          CF = lyon2011_closeagcloop(CF);
        end
      end
    end
    
  end


% Copyright 2013 The CARFAC Authors. All Rights Reserved.
% Author: Richard F. Lyon
%
% This file is part of an implementation of Lyon's cochlear model:
% "Cascade of Asymmetric Resonators with Fast-Acting Compression"
%
% Licensed under the Apache License, Version 2.0 (the "License");
% you may not use this file except in compliance with the License.
% You may obtain a copy of the License at
%
%     http://www.apache.org/licenses/LICENSE-2.0
%
% Unless required by applicable law or agreed to in writing, software
% distributed under the License is distributed on an "AS IS" BASIS,
% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
% See the License for the specific language governing permissions and
% limitations under the License.

