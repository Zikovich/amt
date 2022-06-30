function [f,stat]=urlwrite(webfn,fn)
  
if exist('OCTAVE_VERSION','builtin') ~= 0,
    f=dbstack('-completenames');
    fx=f(2).file;
    if ~strcmp('urlwrite.m', fx(end-9:end))
      [f,stat]=builtin('urlwrite' ,webfn,fn);
    end
else
  f=websave(fn,webfn);
  stat=1;
end

%
%   Url: http://amtoolbox.org/amt-1.2.0/doc/legacy/urlwrite.php

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

