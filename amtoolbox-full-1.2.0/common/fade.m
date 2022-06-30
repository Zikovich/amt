function [ y ] = fade( x,t_fade,Fs )
%FADE smoothen a signals on- and offset
%
%   Input parameters:
%     x     : input signal
%     t_fade: fading time
%     Fs: sampling frequency
%
%   Output parameters:
%     y   : output signal
%
%     takes a sequency and adds a rise and fall to its begining
%     and its end to minimize the pectral splatter.
%
%   See also: sig_whitenoiseburst
%
%   Url: http://amtoolbox.org/amt-1.2.0/doc/common/fade.php

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


%%  Create the 'fade in' and 'fade out'
t_max=(length(x)-1)/Fs;
t_in=0:1/Fs:t_fade;

f_fade=(0.01*25)/t_fade; % the best fading frequency for t_fade=0.01s turns to be 26 Hz. Find the appropriate f_fade for other t_fade values.

%%
fade_in=(sin(2*pi*f_fade.*t_in)).^2;
%t_out=t_max:-1/Fs:(t_max-t_fade);
t_out=t_fade:-1/Fs:0;
fade_out=(sin(2*pi*f_fade.*t_out)).^2;
%% multiply with the original signal
y=zeros(size(x));y=x;
y(1:length(t_in))=fade_in.*x(1:length(t_in));
y(length(y)-length(t_out)+1:length(y))=fade_out.*x(length(x)-length(t_out)+1:length(x));
%% display
% figure(2)
% plot(t_in,fade_in);
% figure(3)
% plot(length(y)-length(t_out)+1:length(y),fade_out);
% figure(4)
% plot(0:1/Fs:(length(y)-1)/Fs, y);

end

