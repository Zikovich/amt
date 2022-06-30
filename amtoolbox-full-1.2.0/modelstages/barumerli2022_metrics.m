function [varargout] = barumerli2022_metrics(varargin)
%BARUMERLI2022_METRICS extract localization metrics
%   Usage: metrics = barumerli2022_metrics(m, 'middle_metrics') 
%           metrics = barumerli2022_metrics(m, metric) 
%
%   Input parameters:
%     m       : (matrix) table organized as in localizationerror with actual
%               and predicted directions. The model barumerli2022 can
%               output directly such matrix.
%
%     metric  : (string) string indicating which metric has to be computed.
%
%
%   Output parameters (optional):
%      varagout : output as in localizationerror-m. If 'middle_metrics' is
%                 provided then a struct will be provided.
%
%   BARUMERLI2022_METRICS(...) returns psychoacoustic performance 
%   parameters for experimental response patterns. 
%   This script is a wrapper for localizationerror. This function is also
%   used internally in barumerli2022 which behavior is not here
%   described. 
%   For a complete list of supported metrics, please consider localizationerror. Moreover,
%   if 'middle_metrics' is provided the function returns a struct
%   containing the four metrics used in the paper Middlebrooks (1999).
%   There are: accuracy and root mean squared error for both
%   the lateral and polar dimensions and the quadrant error. 
%
%   See also: demo_barumerli2022 barumerli2022 localizationerror
%
%   References:
%     P. Majdak, M. J. Goupell, and B. Laback. 3-D localization of virtual
%     sound sources: Effects of visual environment, pointing method and
%     training. Atten Percept Psycho, 72:454--469, 2010.
%     
%     J. C. Middlebrooks. Virtual localization improved by scaling
%     nonindividualized external-ear transfer functions in frequency. J.
%     Acoust. Soc. Am., 106:1493--1510, 1999.
%     
%
%   Url: http://amtoolbox.org/amt-1.2.0/doc/modelstages/barumerli2022_metrics.php

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


%   Author: Roberto Barumerli
%   Dept. of Information Engineering, University of Padova

% parameters 
% m, 'middle_metrics'       return middlebrooks metrics as a struct
% doa, doa_real, 'm'        return m matrix
% doa, doa_real, <error>    compute error from `localizationerror`
% m, <error>                as above

if strcmp(varargin{2}, 'middle_metrics')
    assert(size(varargin{1}, 2) == 8, 'Please provide m matrix')
    m = varargin{1};
    % lateral_bias 
    exp.accL = localizationerror(m, 'accL'); 
    % lateral_rms_error
    exp.rmsL = localizationerror(m, 'rmsL'); 
    % elevation_bias
    exp.accP = localizationerror(m, 'accP'); 
    % local_rms_polar
    exp.rmsP = localizationerror(m, 'rmsPmedianlocal'); 
    % quadrant_err
    exp.querr = localizationerror(m, 'querrMiddlebrooks'); 
    varargout{1} = exp;
elseif strcmp(varargin{3}, 'm')
    assert(isfield(varargin{1}, 'estimations') & isa(varargin{2}, 'barumerli2022_coordinates'), 'If looking for m matrix please give doa as a struct and doa_real as barumerli2022_coordinates object(see barumerli2022)')
    varargout{1} = local_returnmatrixlocalizationerror(varargin{1}, varargin{2});
else
    if isfield(varargin{1}, 'estimations') && isa(varargin{2}, 'barumerli2022_coordinates')
        m = local_returnmatrixlocalizationerror(varargin{1}, varargin{2});
        errorflag = varargin{3};
    elseif size(varargin{1}, 2) == 8
        m = varargin{1};
        errorflag = varargin{2};
    else
        error('something went wrong!')
    end

    [varargout{1}, meta, par] = localizationerror(m, errorflag);
    
    if length(varargout) > 1
        varargout{2}=meta;
    end
    if length(varargout) > 2
        varargout{3}=par; 
    end

end 

function m = local_returnmatrixlocalizationerror(doa, doa_real)
    assert(size(doa.estimations, 3) == 3)
   
    doa_est_cart = barumerli2022_coordinates(reshape(doa.estimations, [], 3), 'cartesian');
    
    %% compute the metric relying on `localizationerror`
    doa_real_sph = doa_real.return_positions('spherical');
    doa_est_sph = doa_est_cart.return_positions('spherical');
    doa_real_hor = doa_real.return_positions('horizontal-polar');
    doa_est_hor = doa_est_cart.return_positions('horizontal-polar');
    
    num_rep = size(doa_est_cart.pos, 1)/size(doa_real.pos, 1);
    
    m = zeros(size(doa_real.pos, 1)*num_rep, 8);
    m(:, 1:2) = repmat(doa_real_sph(:, [1 2]), num_rep, 1);
    m(:, 3:4) = doa_est_sph(:, [1 2]);
    m(:, 5:6) = repmat(doa_real_hor(:,[1 2]), num_rep, 1);
    m(:, 7:8) = doa_est_hor(:, [1 2]);

