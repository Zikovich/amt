function h = plot_bruce2018(t,CFs,neurogram,varargin)
%PLOT_BRUCE2018 plots the output of the bruce 2018 model
%
%   Usage:
%     h = plot_bruce2018(t,CFs,neurogram)
%
%   Input parameters:
%     t            : time index vector
%     CFs          : characteristic frequencies vector
%     neurogram    : neurogram coefficients [time CF]
%
%   This function provides a framework for plotting neurograms.
%
%   Url: http://amtoolbox.org/amt-1.2.0/doc/plot/plot_bruce2018.php

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

if (nargin > 4)
    error('Too many input arguments')
elseif (nargin > 3)
    hin = varargin{1};
    
    if strncmp(get(hin,'Type'),'figu',4)
        
        figure(hin)
        h = axes;
        
    elseif strncmp(get(hin,'Type'),'axes',4)
        
        h = hin;
        
    else
        error(['Handle type of ' get(hin,'Type') ' not supported'])
    end
    
else
    
    h = axes;
    
end

axes(h)
imagesc(t,log10(CFs/1e3),neurogram')
axis xy
yticks = [0.125 0.5 2 8 16];
set(h,'ytick',log10(yticks))
set(h,'yticklabel',yticks)
ylabel('CF (kHz)')
xlabel('Time (s)')
hcb = colorbar;
set(get(hcb,'ylabel'),'string','spikes')

end


