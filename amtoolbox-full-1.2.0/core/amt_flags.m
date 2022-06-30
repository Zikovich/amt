function [flags,kv]=amt_flags(varargin)
%AMT_FLAGS Returns the start-up flags of the AMT
%
%   Usage: amt_flags;
%
%   This function returns the current display- and
%   cachemode of the AMT.
%
%   Url: http://amtoolbox.org/amt-1.2.0/doc/core/amt_flags.php

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

%   #Author : Piotr Majdak 
%   #Author : Clara Hollomey

[flags,kv]=amt_configuration;


