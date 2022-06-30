function [Cohc,Cihc,OHC_Loss]=bruce2018_fitaudiogram(FREQUENCIES,dBLoss,species,Dsd_OHC_Loss)
%BRUCE2018_FITAUDIOGRAM Cohc and Cihc values that produce a desired threshold shift 
%
%   Usage:
%     [Cohc,Cihc,OHC_Loss]=bruce2018_fitaudiogram(FREQUENCIES,dBLoss,species,Dsd_OHC_Loss)
%
%   Input parameters:
%     FREQUENCIES : vector containing audiogram frequencies
%     dBLoss      : loss [dB] per frequency in FREQUENCIES
%     species     : model species "1" for cat, "2" for human BM tuning from
%                   Shera et al. (PNAS 2002), or "3" for human BM tuning from Glasberg &
%                   Moore (Hear. Res. 1990)
%     Dsd_OHC_Loss: optional array giving the desired threshold shift in
%                   dB that is caused by the OHC impairment alone (for each frequency in
%                   FREQUENCIES). If this array is not given, then the default desired
%                   threshold shift due to OHC impairment is 2/3 of the entire threshold
%                   shift at each frequency.  This default is consistent with the
%                   effects of acoustic trauma in cats (see Bruce et al., JASA 2003, and
%                   Zilany and Bruce, JASA 2007) and estimated OHC impairment in humans
%                   (see Plack et al., JASA 2004).
%
%   Output parameters:
%     The output variables are arrays with values corresponding to each
%     frequency in the input array FREQUENCIES.
%
%     Cohc     : is the outer hair cell (OHC) impairment factor; a value of 1
%                corresponds to normal OHC function and a value of 0 corresponds to
%                total impairment of the OHCs.
%     Cihc     : is the inner hair cell (IHC) impairment factor; a value of 1
%                corresponds to normal IHC function and a value of 0 corresponds to
%                total impairment of the IHC.
%     OHC_Loss : is the threshold shift in dB that is attributed to OHC
%                impairment (the remainder is produced by IHC impairment). 
%
%   BRUCE2018_FITAUDIOGRAM calculates the Cohc and Cihc values that produce a desired threshold shift 
%   for the cat & human auditory-periphery model of Zilany et
%   al. (J. Acoust. Soc. Am. 2009, 2014) and Bruce, Erfani & Zilany (Hear.Res., 2018).
%
%   Url: http://amtoolbox.org/amt-1.2.0/doc/modelstages/bruce2018_fitaudiogram.php

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

%   #Author: M. S. A. Zilany 
%   #Author: I. C. Bruce (ibruce@ieee.org), 2013

% � M. S. A. Zilany and I. C. Bruce (ibruce@ieee.org), 2013

switch species
    case 1
        disp('Analyzing audiogram for cat AN model')
        data = amt_load('bruce2018', 'THRESHOLD_ALL_CAT.mat');
    case 2
        disp('Analyzing audiogram for human AN model - BM tuning from Shera et al. (2002)')
        data = amt_load('bruce2018', 'THRESHOLD_ALL_HM_Shera.mat');
    case 3
        disp('Analyzing audiogram for human AN model - BM tuning from Glasberg & Moore (1990)')
        data = amt_load('bruce2018', 'THRESHOLD_ALL_HM_GM.mat');
    otherwise
        error(['Species # ' int2str(species) ' not known'])
end
       
CF = data.CF;
CIHC = data.CIHC;
COHC = data.COHC;
THR = data.THR;
% Variables are
% CF: 125 Hz to 10 kHz                   [1*37]
% CIHC: varies from 1.0 to 0.0001        [1*55]
% COHC: varies from 1.0 to 0             [1*56]
% THR : absolute thresholds              [37*55*56]

for k = 1:length(THR(:,1,1))
    dBShift(k,:,:)= THR(k,:,:) - THR(k,1,1);
end

if nargin<4, Dsd_OHC_Loss = 2/3*dBLoss;
end;

for m = 1:length(FREQUENCIES)
    [W,N] = min(abs(CF-FREQUENCIES(m))); n = N(1);
    
    if Dsd_OHC_Loss(m)>dBShift(n,1,end)
        Cohc(m) = 0;
    else
        [a,idx]=sort(abs(squeeze(dBShift(n,1,:))-Dsd_OHC_Loss(m)));
        Cohc(m)=COHC(idx(1));
    end
    OHC_Loss(m) = interp1(COHC,squeeze(dBShift(n,1,:)),Cohc(m),'nearest');
    [mag,ind] = sort(abs(COHC-Cohc(m)));
    
    Loss_IHC(m) = dBLoss(m)-OHC_Loss(m);
    
    if dBLoss(m)>dBShift(n,end,ind(1))
        Cihc(m) = 0;
    else
        [c,indx]=sort(abs(squeeze(dBShift(n,:,ind(1)))-dBLoss(m)));
        Cihc(m)=CIHC(indx(1));
    end
    
end
    
    

