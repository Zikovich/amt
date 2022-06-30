function varargout = sig_dizon2004(Obj,varargin)
%SIG_DIZON2004 - Stimulus from Dizon and Litovsky (2004) 
%   Usage: [out,swap] = sig_dizon2004(Obj,leadpos,lagpos,dur)
%
%   Input parameters:
%     Obj     : SOFA object for HRTFs.
%     leadpos : Direction of leading stimulus. Scalar interpreted as
%               elevation. Two-element vector as [azimuth,elevation].
%               Default is +30 deg.
%     lagpos  : Direction of lagging stimulus. Scalar interpreted as
%               elevation. Two-element vector as [azimuth,elevation].
%               Default is -30 deg.
%     dur     : duration of inidvidual noise bursts in ms. Default is 50
%               ms.
%
%   Output parameters:
%     out     : binaural output signal mixture.
%     swap    : binaural output signal mixture with swaped positions.
%
%
%   Train of 4 noise bursts of duration dur ms every 250 ms emitted by 
%   two sources on the midsagittal plane with fixed time lag of 2 ms.
%
%   References:
%     R. M. Dizon and R. Y. Litovsky. Localization dominance in the
%     median-sagittal plane: Effect of stimulus duration. J. Acoust. Soc.
%     Am., 115(3142), 2004.
%     
%
%   Url: http://amtoolbox.org/amt-1.2.0/doc/signals/sig_dizon2004.php

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

% AUTHOR: Robert Baumgartner, Acoustics Research Institute, Vienna, Austria

definput.keyvals.leadpos = 30;
definput.keyvals.lagpos = -30;
definput.keyvals.dur = 50;

[flags,kv]  = ltfatarghelper({'leadpos','lagpos','dur'},definput,varargin);

%% Positions
if length(kv.leadpos) == 2
  leadazi = kv.leadpos(1);
  kv.leadpos = kv.leadpos(2);
else
  leadazi = 0;
end
if length(kv.lagpos) == 2
  lagazi = kv.lagpos(1);
  kv.lagpos = kv.lagpos(2);
else
  lagazi =0;
end

%% Burst trains
lag = 0.002; % fixed time lag in sec
repRate = 0.25; % burst periodicity in sec
Nrep = 4; % # repetitions
fs = Obj.Data.SamplingRate;

burst = noise(kv.dur/1e3*fs,1,'white');
burst = postpad(burst,repRate*fs);
leadTrain = repmat(burst(:),Nrep,1);
lagTrain = circshift(leadTrain,round(lag*fs));

%% Lead-lag pair
leadSig = SOFAspat(leadTrain,Obj,leadazi,kv.leadpos);
lagSig = SOFAspat(lagTrain,Obj,lagazi,kv.lagpos);

varargout{1} = leadSig+lagSig;
if nargout > 1
  leadSwap = SOFAspat(leadTrain,Obj,lagazi,kv.lagpos);
  lagSwap = SOFAspat(lagTrain,Obj,leadazi,kv.leadpos);
  varargout{2} = leadSwap+lagSwap;
end
end

