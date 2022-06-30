function out = relanoiborra2019_drnl(insig,CF,fs,subj)
%RELANOIBORRA2019_DRNL DRNL filter used in relanoiborra2019
%
%   Usage: out = relanoiborra2019_drnl(insig,CF,fs,subj)
%
%   Input parameters:
%     insig : input signal
%     CF    : center frequency [Hz]
%     fs    : sampling frequency [Hz]
%     subj  : subject ID
%
%   Output parameters:
%     out   : filtered signal
%
%
%   DRNL model as parametrized in Relano-Iborra et al. 2019
%
%   Url: http://amtoolbox.org/amt-1.2.0/doc/modelstages/relanoiborra2019_drnl.php

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

[N,idx_major_dim] = min(size(insig)); % Adding compatibility for column-
    % and row-wise processing

[linDRNLpar,nlinDRNLpar] = local_getDRNLparam_NH(CF,subj);

[GTlin_b,GTlin_a] = local_coefGtDRNL(linDRNLpar(1).vals,linDRNLpar(3).vals,1,fs); %get GT filter coeffs
[LPlin_b,LPlin_a] = local_coefLPDRNL(linDRNLpar(5).vals,fs); % get LP filter coeffs

% linDRNLpar(4).vals
% size(x)
% CF
y_lin = insig.*linDRNLpar(4).vals; % Apply linear gain

% Now filtering
for n = 1:linDRNLpar(2).vals % Gammatone filtering multiple times for cascading
    y_lin = real(filter(GTlin_b,GTlin_a,y_lin));  
end
for n = 1:linDRNLpar(6).vals % cascade of lowpass filters
    y_lin = filter(LPlin_b,LPlin_a,y_lin);           
end
% end of linear part %%%%%%%%%%%%%%%%%%%%%%%

% Non-linear part%%%%%%%%%%%%%%%%%%%%%%%%%%%
[GTnlin_b,GTnlin_a] = local_coefGtDRNL(nlinDRNLpar(1).vals,nlinDRNLpar(3).vals,1,fs); %get GT filter coeffs
[LPnlin_b,LPnlin_a] = local_coefLPDRNL(nlinDRNLpar(7).vals,fs); % get LP filter coeffs

y_nlin = insig;

% Now GT filtering
for n = 1:nlinDRNLpar(2).vals % Gammatone filtering multiple times for cascading
    y_nlin = filter(GTnlin_b,GTnlin_a,y_nlin);  
end

% Broken stick nonlinearity
a = nlinDRNLpar(4).vals;
b = nlinDRNLpar(5).vals;
c = nlinDRNLpar(6).vals;
% pause

%%% Correction by AO:
% % Old code: y_nlin is always a column vector, by generating y_decide in this
% %    way you generate a y_decide variable that is twice as long as the input
% %    signal (maybe related to the 'prepanne'?) and this means that the broken
% %    stick non-linearity does not work as expected, because the minimum of
% %    a column array is a single value, and very low, so probably the whole
% %    nonlinear path was being inhibited:
% y_decide = [a*abs(y_nlin); b*(abs(y_nlin)).^c];

y_factor_a = a*abs(y_nlin);
y_factor_b = b*(abs(y_nlin)).^c;

switch idx_major_dim
    case 1
        y_decide = min([y_factor_a; y_factor_b],[],idx_major_dim); 
    case 2
        y_decide = min([y_factor_a y_factor_b],[],idx_major_dim); 
end
% figure; plot(y_factor_a,'b-'); hold on; plot(y_factor_b,'r--'); plot(y_decide,'k-')
y_nlin = sign(y_nlin).* y_decide;

% Now GT filtering again
for n = 1:nlinDRNLpar(2).vals % Gammatone filtering multiple times for cascading
    y_nlin = filter(GTnlin_b,GTnlin_a,y_nlin);  
end

% then LP filtering
for n = 1:nlinDRNLpar(8).vals % cascade of lowpass filters
    y_nlin = filter(LPnlin_b,LPnlin_a,y_nlin);           
end

out = (y_lin + y_nlin);
end 
% -------------------------------------------------------------------------
% Get Gammatone filter coef for DRNL implementation
% Morten Loeve Jepsen
function [b,a]=local_coefGtDRNL(fc,BW,n,fs);
theta = 2*pi*fc/fs; phi   = 2*pi*BW/fs; alpha = -exp(-phi)*cos(theta);

b1 = 2*alpha; b2 = exp(-2*phi); 
a0 = abs( (1+b1*cos(theta)-i*b1*sin(theta)+b2*cos(2*theta)-i*b2*sin(2*theta)) / (1+alpha*cos(theta)-i*alpha*sin(theta))  );
a1 = alpha*a0;

% adapt to matlab filter terminology
b=[a0, a1];
a=[1, b1, b2];
end 
% -------------------------------------------------------------------------
% rev Morten L�ve Jepsen, 2.nov 2005
function [b,a]=local_coefLPDRNL(fc,fs)

    theta = pi*fc/fs;
    
    C = 1/(1+sqrt(2)*cot(theta)+(cot(theta))^2);
    D = 2*C*(1-(cot(theta))^2);
    E = C*(1-sqrt(2)*cot(theta)+(cot(theta))^2);

    b = [C, 2*C, C]; a = [1, D, E];

% script for getting the (DRNL) filter parameters (Lopez-Poveda, meddis 2001)
% Author: Morten L?ve Jepsen, 2.nov 2005, rev. 15 feb 2006, 19 feb 2007
%
% usage:  [linDRNLparOut,nlinDRNLparOut] = getDRNLparam(CF);
%
% The returned DRNLparam is a strucures containing the parameter name and
% values
end 
% ------------------------ %
% v 2.0 by Borys K. 23rd April 2015
% v 3.0 by Helia Rela�o-Iborra December, 2018

% -------------------------------------------------------------------------
function [linDRNLparOut,NlinDRNLparOut] = local_getDRNLparam_NH(CF,subj)
%% DRNL for normal hearing, Morten 2007

%% Initialize the parameter structures
linDRNLstruct  = struct('parname',{},'vals',{}); % initialize linear paramater vector
NlinDRNLstruct = struct('parname',{},'vals',{}); % initialize nonlinear paramater vector
% linDRNLparOut  = struct('parname',{},'vals',{});  
% NlinDRNLparOut = struct('parname',{},'vals',{});

linDRNLstruct(1).parname = 'CF_lin';  linDRNLstruct(2).parname = 'nGTfilt_lin';
linDRNLstruct(3).parname = 'BW_lin';  linDRNLstruct(4).parname = 'g';
linDRNLstruct(5).parname = 'LP_lin_cutoff';  linDRNLstruct(6).parname = 'nLPfilt_lin';
linDRNLparOut=linDRNLstruct;

NlinDRNLstruct(1).parname = 'CF_nlin';  NlinDRNLstruct(2).parname = 'nGTfilt_nlin';
NlinDRNLstruct(3).parname = 'BW_nlin';  NlinDRNLstruct(4).parname = 'a';
NlinDRNLstruct(5).parname = 'b';  NlinDRNLstruct(6).parname = 'c';
NlinDRNLstruct(7).parname = 'LP_nlin_cutoff';  NlinDRNLstruct(8).parname = 'nLPfilt_nlin';
NlinDRNLparOut = NlinDRNLstruct;

%% Common parameters not subject to immediate change by HI
linDRNLstruct(1).vals = 10^(-0.06762+1.01679*log10(CF)); % Hz, CF_lin,
linDRNLstruct(2).vals = 3; % number of cascaded gammatone filters
linDRNLstruct(3).vals = 10^(.03728+.75*log10(CF)); % Hz, BW_lin.
linDRNLstruct(5).vals = 10^(-0.06762+1.01*log10(CF)); % Hz, LP_lin cutoff
linDRNLstruct(6).vals = 4; % no. of cascaded LP filters,
NlinDRNLstruct(1).vals = 10^(-0.05252+1.01650*log10(CF)); % Hz, CF_nlin
NlinDRNLstruct(2).vals = 3; % number of cascaded gammatone filters,
NlinDRNLstruct(3).vals = 10^(-0.03193+.77*log10(CF)); % Hz, BW_nlin
NlinDRNLstruct(7).vals = 10^(-0.05252+1.01650*log10(CF)); % LP_nlincutoff
NlinDRNLstruct(8).vals = 3; % no. of cascaded LP filters in nlin path,

switch subj
    case 'NH' % Model for normal-hearing CASP
        %%  NH PARAMETERS
        linDRNLstruct(4).vals = 10^(4.20405 -.47909*log10(CF)); %g
        if CF<=1000
            NlinDRNLstruct(4).vals = 10^(1.40298+.81916*log10(CF)); % a,
            NlinDRNLstruct(5).vals = 10^(1.61912-.81867*log10(CF)); % b [(m/s)^(1-c)]
        else
            NlinDRNLstruct(4).vals = 10^(1.40298+.81916*log10(1500)); % a,
            NlinDRNLstruct(5).vals = 10^(1.61912-.81867*log10(1500)); % b [(m/s)^(1-c)]
        end
        NlinDRNLstruct(6).vals = 10^(-.60206); % c, compression coeff
        
    case 'HIx'
        %% %% Example HI listener with no compression
        linDRNLstruct(4).vals = 10^(4.20405 -.47909*log10(CF)); %g
        NlinDRNLstruct(4).vals = 0; % a,
        NlinDRNLstruct(5).vals = 10^(1.61912-.81867*log10(CF)); % b [(m/s)^(1-c)]
        NlinDRNLstruct(6).vals = .25; % c, compression coeff
end

%% Other params
for k=1:6
    linDRNLparOut(k).vals = linDRNLstruct(k).vals;
end
for k=1:8
    NlinDRNLparOut(k).vals = NlinDRNLstruct(k).vals;
end
end
%% EOF

