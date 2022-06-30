%DEMO_TAKANEN2013 Demo of the binaural model by Takanen, Santala and Pulkki
%
%   This script generates a figure showing the result of the binaural
%   auditory model by Takanen, Santala and Pulkki (2013) for sound source
%   distributions consisting of different number of sound sources simulated
%   with HRTFs to emit incoherent samples of pink noise. The resulting
%   activity map shows that the activation spreads as the width of the
%   distribution increases, which is in accordance with the results of the
%   psychoacoustical experiment by Santala and Pulkki (2011).
%
%   Normall, pre-computed cochlear model outputs can be applied to 
%   significantly reduce the required computation time. 
%
%   Start the AMT in the 'redo' mode to re-calculate the cochlear model
%   (be patient, this might take a few hours)
%
%   Figure 1: Output of the audiory model: the activity map.
%
%   See also: takanen2013
%
%   References:
%     O. Santala and V. Pulkki. Directional perception of distributed sound
%     sources. J. Acoust. Soc. Am., 129:1522 -- 1530, 2011.
%     
%     M. Takanen, O. Santala, and V. Pulkki. Visualization of functional
%     count-comparison-based binaural auditory model output. Hearing
%     research, 309:147--163, 2014. PMID: 24513586.
%     
%     M. Takanen, O. Santala, and V. Pulkki. Perceptually encoded signals and
%     their assessment. In J. Blauert, editor, The technology of binaural
%     listening. Springer, 2013.
%     
%
%   Url: http://amtoolbox.org/amt-1.2.0/doc/demos/demo_takanen2013.php

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

%   #Author: Marko Takanen, Olli Santala, Ville Pulkki (2013): implemented for the AMT


%% Starting of the script
% Use pre-computed cochlear model outputs, otherwise set preComp=0;
flags=amt_configuration;

compType = 1;
printFigs = 0;
printMap = 1;

if flags.do_redo, %use binaural input signals and compute cochlear model
    filename='demo_binsig.mat';
    data=amt_load('takanen2013',filename);
    output= takanen2013(data.tests.insig,data.tests.fs,compType,printFigs,printMap);
    title(data.tests.scenario);
    set(gca,'Ytick',data.tests.ytickPos);set(gca,'YtickLabel',data.tests.ytickLab(end:-1:1));
    ylabel(data.tests.ylab);
else % use pre-computed cochlea model outputs to reduce the computation time
    filename='demo_cochlea.mat';
    data=amt_load('takanen2013',filename);
    output= takanen2013(data.tests.cochlea,data.tests.fs,compType,printFigs,printMap);
    title(data.tests.scenario);
    set(gca,'Ytick',data.tests.ytickPos);set(gca,'YtickLabel',data.tests.ytickLab(end:-1:1));
    ylabel(data.tests.ylab);
end
