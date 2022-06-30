function [vihc, varargout] = zilany2014_innerhaircells(stim, fc, nrep, tdres, reptime, cohc, cihc, species)
%ZILANY2014_INNERHAIRCELLS Calculates the inner hair cell potential
%
%   Usage: [ANresp,fc] = zilany2014_innerhaircells(stim, fc, nrep, tdres, reptime, cohc, cihc, species);
%
%   Input parameters:
%     stim        : Pressure waveform of stimulus (timeseries)
%     fc          : nerve fiber frequency [Hz]
%     nrep        : Number of repetitions for the mean rate, rate variance 
%                   & psth calculation. Default is 1.
%     tdres       : simulation time resolution, fs_mod^(-1)
%     reptime     : overall repetition time of the stimulus with pauses
%     cohc        : OHC scaling factor: 1 denotes normal OHC function (default);
%                   0 denotes complete OHC dysfunction.
%     cihc        : IHC scaling factor: 1 denotes normal IHC function (default);
%                   0 denotes complete IHC dysfunction.
%     species     : can be human (2) or cat (1)
%
%   Output parameters:
%     vihc       : Output from inner hair cells (IHCs) in Volts
%     c1       : chirp filter output
%     c2       : chirp filter output
%
%   ZILANY2014_INNERHAIRCELLS(...) returns the innerhaircell potential for 
%   one specific frequency/nerve fiber
%
%   Please cite the references below if you use this model.
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
%   Url: http://amtoolbox.org/amt-1.2.0/doc/modelstages/zilany2014_innerhaircells.php

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
% and Clara Hollomey
%   Author: Piotr Majdak (2021): adapted to AMT 1.0

    [vihc, C1, C2] = comp_zilany2014_IHC(stim(:)',fc,nrep,tdres,reptime,cohc,cihc,species);
    vihc=vihc'; % AMT 1.0: time is first dimension
    if nargout >=1
        varargout{1} = C1';
        varargout{2} = C2';
    end
end
