function [iacc,iacc_fc,fc] = baumgartner2017_iacc(binsig,varargin)
%BAUMGARTNER2017_IACC calculates the IACC
%   Usage:     [iacc,iacc_fc,fc] = baumgartner2017_iacc(binsig)
%
%   Input parameters:
%     binsig  : binaural time-domain signal (dimensions: time x channel)
%
%   Output parameters:
%     iacc    : normalized interaural cross-correlation coefficient (IACC)
%     iacc_fc : frequency-specific IACC
%     fc      : center frequencies
%
%   BAUMGARTNER2017_IACC calculates the interaural cross correlation
%   coefficient from a binaural signal.
%
%   See also: baumgartner2017
%
%   Url: http://amtoolbox.org/amt-1.2.0/doc/modelstages/baumgartner2017_iacc.php

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

definput.import={'baumgartner2017'};
definput.keyvals.maxlag = 0.001; % in sec

[flags,kv]=ltfatarghelper({},definput,varargin);

[mp,fc] = auditoryfilterbank(binsig(:,:),kv.fs,'flow',kv.flow,'fhigh',kv.fhigh);
if flags.do_ihc
  mp = ihcenvelope(mp,kv.fs,'ihc_dau1996');
end

maxlagn = round(kv.maxlag*kv.fs);
iacc_fc = nan(length(fc),1);
intens_fc = nan(length(fc),1);
for ifreq = 1:length(fc)
  intens_fc(ifreq) = sqrt(prod(sum(mp(:,ifreq,:).^2,1),3));
  iacnorm = xcorr(mp(:,ifreq,1),mp(:,ifreq,2),maxlagn,'coeff');
  iacc_fc(ifreq) = max(abs(iacnorm));
end
intWeight = intens_fc/sum(intens_fc); % intensity weighting
iacc = iacc_fc'*intWeight; % weighted average

end

