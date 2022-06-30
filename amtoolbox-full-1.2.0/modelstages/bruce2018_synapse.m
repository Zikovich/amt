function [psth, meanrate, varrate, synout, trd_vector, trel_vector] = bruce2018_synapse(vihc, fc, nrep, dt, noisetype, implnt, spont, tabs, trel)
%BRUCE2018_SYNAPSE synapse model proposed by Bruce et al. (2018)
%
%   Usage:
%     [psth, meanrate, varrate, synout, trd_vector, trel_vector] = bruce2018_synapse(vihc, fc, nrep, dt, noisetype, implnt, spont, tabs, trel)
%
%   Input parameters:
%     vihc      : the inner hair cell (IHC) relative transmembrane potential [V]
%     fc        : vector of center frequencies [Hz]
%     nrep      : number of stimulus repetitions (about 10 - 200)
%     dt        : discrete time distance, 1/sampling frequency, needs to be either 100, 200, or 500 kHz
%     noiseType : "variable" or "fixed (frozen)" fGn: 1 for variable fGn and 0 for fixed (frozen) fGn
%     implnt    : "approxiate" or "actual" implementation of the power-law functions: "0" for approx. and "1" for actual implementation
%     spont     : nerve fibres
%     tabs      : absolute timing info
%     trel      : relative timing info
%
%   Output parameters:
%     psth        : the peri-stimulus time histogram (PSTH) (or a spike train if nrep = 1)
%     meanrate    : mean spiking rate
%     varrate     : variable spiking rate
%     synout      : synapse output
%     trd_vector  : refractory period
%     trel_vector : relative refractory period
%
%   BRUCE2018_SYNAPSE calculates the output of the synapse model by Bruce et al. (2018) and several associated parameters
%
%   Url: http://amtoolbox.org/amt-1.2.0/doc/modelstages/bruce2018_synapse.php

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

%   #Author: Ian Bruce


 [psth, meanrate, varrate, synout, trd_vector, trel_vector] = ...
        comp_bruce2018_Synapse(vihc(:)',fc,nrep,dt,noisetype,implnt,spont,tabs,trel);
      
  meanrate=meanrate';
  varrate=varrate';
  psth=psth';
  synout=synout';
end

