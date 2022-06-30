function [s,fs]=sig_competingtalkers(varargin)
%SIG_COMPETINGTALKERS  Load one of several test signals
%   Usage:  s=sig_competingtalkers(signame);
%           [s,fs]=sig_competingtalkers(signame);
%
%   SIG_COMPETINGTALKERS(signame) loads one of several test signals consisting
%   of competing talkers. All the talkers are taken from the TIMIT speech
%   corpus https://doi.org/10.35111/17gk-bn40>`
%   and filtered by HRTFs recorded in the Oldenburg lab with a 
%   Bruel and Kjaer Type 4128C head and torso simulator (Kayser et al., 2009).
%   An exception is 'one_speaker_reverb', see description below.
%
%   The signals have 2 channels and are provided with a sampling rate of
%   16 kHz.
%
%   [sig,fs]=SIG_COMPETINGTALKERS(signame) additionally returns the sampling
%   frequency fs.
%
%   The parameter signame can be:
%
%     'one_of_three'    Talker spatialized at the azimuth angle of 30 degrees. 
%
%     'two_of_three'    Talker spatialized at the azimuth angle of 0 degrees. 
%
%     'three_of_three'  Talker spatialized at the azimuth angle of -30 degrees. 
%
%     'one_speaker_reverb' Talker spatialized at horizontal position of 45 degrees 
%                          by applying a binaural set of room impulse responses (BRIR)
%                          of an office room from a database recorded with hearing-aid 
%                          microphones behind the ear.
%
%     'two_speakers'    Two simultanous talkers spatialized at the azimuth angles
%                       of -30 and 30 degrees.
%
%     'five_speakers'   Five simultanous talkers spatialized at the azimuth angles
%                       of -80, -30, 0, 30, and 80 degrees. 
%
%     'bnoise'          Speech-shaped binaural noise.
%
%   Examples:
%   ---------
%
%   The following plot shows an estimate of the power spectral density of
%   the first channels of the speech shaped noise:
%
%      s=sig_competingtalkers('bnoise');
%      pwelch(s(:,1),hamming(150));
%
%   See also: exp_dietz2011 dietz2011
%
%   Url: http://amtoolbox.org/amt-1.2.0/doc/signals/sig_competingtalkers.php

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

%   #AUTHOR: Peter L. Soendergaard
%   #Author: Piotr Majdak (2022): information for the documentation assembled


definput.flags.sigtype={'missingflag','one_of_three','two_of_three',...
                    'three_of_three','one_speaker_reverb',...
                    'two_speakers','five_speakers','bnoise'};

[flags,kv]=ltfatarghelper({},definput,varargin);

if flags.do_missingflag
  flagnames=[sprintf('%s, ',definput.flags.sigtype{2:end-2}),...
             sprintf('%s or %s',definput.flags.sigtype{end-1},definput.flags.sigtype{end})];
  error('%s: You must specify one of the following flags: %s.',upper(mfilename),flagnames);
end;


% fs = 16000;
[s,fs]=amt_load('sig_competingtalkers',[flags.sigtype '.wav']);

