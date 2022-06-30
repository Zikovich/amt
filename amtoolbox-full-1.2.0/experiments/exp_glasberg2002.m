function exp_glasberg2002(varargin)
%EXP_GLASBERG2002 Figures several papers by Glasberg et al. (2002)
%
%   Usage:
%     exp_glasberg2002(flags)
%
%   The following flags can be specified;
%
%     'fig1'    Reproduce Fig. 1 of glasberg2002.
%
%     'fig1b'   Similar to fig1 but using 2006 revised data for middle ear
%               filter.
%
%     'fig5'    Reproduce Fig. 5 of glasberg2002.
%
%   Examples:
%   ---------
%   To display Fig.1 of Glasberg et al. (2002) use :
%
%     exp_glasberg2002('fig1');
%
%   To display Fig.1b of Glasberg et al. (2002) use :
%
%     exp_glasberg2002('fig1b');
%
%   To display Fig.5 of Glasberg et al. (2002) use :
%
%     exp_glasberg2002('fig5');
%
%   References:
%     B. R. Glasberg and B. C. J. Moore. A Model of Loudness Applicable to
%     Time-Varying Sounds. J. Audio Eng. Soc, 50(5):331--342, 2002.
%     
%
%   Url: http://amtoolbox.org/amt-1.2.0/doc/experiments/exp_glasberg2002.php

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

% AUTHOR: Thomas Deppisch
% 15.05.2020: PM: Tested, renamed from exp_moore2002

%% Retrieve and compute model paramters
    % Set flags

    definput.flags.type = {'missingflag','fig1','fig1b','fig5'};

    [flags,kv]  = ltfatarghelper({},definput,varargin);

    if flags.do_missingflag
           flagnames=[sprintf('%s, ',definput.flags.type{2:end-2}),...
           sprintf('%s or %s',definput.flags.type{end-1},...
           definput.flags.type{end})];
           error('%s: You must specify one of the following flags: %s.',...
                 upper(mfilename),flagnames);
    end



    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Figure 5
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if flags.do_fig5
        fs = 32000;
        t = linspace(0,1,fs);
        inSig = sin(2*pi*1000*t).';
        results = glasberg2002(inSig,fs);
        plot(results.eLdB(500,:))
    end


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Figure 1
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if flags.do_fig1
        fs = 32000;
        fVec = 20:fs/2;
        data = data_glasberg2002('tfOuterMiddle1997','fieldType','free','fVec',fVec);
        figure
        semilogx(fVec, data.tfOuterMiddle)
        grid on
        xlim([20,16000])
        xlabel('Frequency (Hz)')
        ylabel('Relative Transmission (dB)')
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Figure 1b
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if flags.do_fig1b
        fs = 32000;
        fVec = 20:fs/2;
        data = data_glasberg2002('tfOuterMiddle2007','fieldType','free','fVec',fVec);
        figure
        semilogx(fVec, data.tfOuterMiddle)
        grid on
        xlim([20,16000])
        xlabel('Frequency (Hz)')
        ylabel('Relative Transmission (dB)')
    end


end

