function [ANresp,var_rate,psth] = zilany2014_synapse(vihc,fc,nrep,tdres,fiberType,noiseType,implnt)
%ZILANY2014_SYNAPSE Auditory nerve (AN) synapse model
%   Usage: [ANresp,var_rate, psth] = zilany2014_synapse(vihc,fc,nrep,tdres,fiberType,noiseType,implnt);
%
%   Input parameters:
%     vihc       : Output from inner hair cells (IHCs) in Volts
%     fc         : Center frequencies (Hz)
%     nrep       : Number of repetitions for the mean rate, rate variance 
%                  & psth calculation. Default is 1.
%     tdres      : simulation time resolution, fs_mod^(-1)
%     fiberType  : Type of the fiber based on spontaneous rate (SR) in spikes/s
%                  1: Low SR; 2: Medium SR (default); 3: High SR.
%     noiseType  : Fractional Gaussian noise will be different in every
%                  simulation (1), or will be always the same (0, default)
%     implnt     : 0...Use approxiate implementation of the power-law (default). 
%                  1...Use actual implementation of the power-law functions.
%
%   Output parameters:
%     ANresp     : AN response in terms of the estimated instantaneous mean 
%                  spiking rate (incl. refractoriness) in nf different AN 
%                  fibers spaced equally on the BM
%     var_rate   : var rate
%     psth       : Spike histogram
%
%   ZILANY2014_SYNAPSE returns modeled responses of one AN fibers to a specific inner haircell potential.
%
%   Please cite the references below if you use this model.
%
%
%   Demos: demo_zilany2014
%
%   References:
%     M. S. A. Zilany, I. C. Bruce, and L. H. Carney. Updated parameters and
%     expanded simulation options for a model of the auditory periphery. The
%     Journal of the Acoustical Society of America, 135(1):283--286, Jan.
%     2014.
%     
%     M. Zilany, I. Bruce, P. Nelson, and L. Carney. A phenomenological model
%     of the synapse between the inner hair cell and auditory nerve:
%     Long-term adaptation with power-law dynamics. J. Acoust. Soc. Am.,
%     126(5):2390 -- 2412, 2009.
%     
%
%   Url: http://amtoolbox.org/amt-1.2.0/doc/modelstages/zilany2014_synapse.php

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

% AUTHOR: code provided by Muhammad Zilany, AMT compatibility adapted by Robert Baumgartner
%   Author: Piotr Majdak (2021): adapted to AMT 1.0


      [ANresp,var_rate,psth] = comp_zilany2014_synapse(vihc(:)',fc,nrep,tdres,fiberType,noiseType,implnt);
      ANresp=ANresp';
      var_rate=var_rate';
      psth=psth';
    
end

