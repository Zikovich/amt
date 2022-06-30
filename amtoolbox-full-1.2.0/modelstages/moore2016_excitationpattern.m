function out = moore2016_excitationpattern( f, in )
%MOORE2016_EXCITATIONPATTERN calculates the excitation pattern 
%
%   Input parameters:
%     f    : frequency at which to calculate the excitation pattern [Hz]
%     in   : input signal
%
%   Output parameters:
%     out  : excitation pattern
%
%   This code calculates the excitation patterns for the binaural loudness model moore2016
%   in the version for TVL 2016 based on ANSI S3.4-2007 and Moore & Glasberg (2007).
%
%   Url: http://amtoolbox.org/amt-1.2.0/doc/modelstages/moore2016_excitationpattern.php

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

InputLevels = InputLevelPerERB(f,in);

ExcitationLevels = outputpower_ERBnumbers(InputLevels, f, in);

out = ExcitationLevels;

end

function out = outputpower_ERBnumbers(InputLevels, f, in)

ERBc = 1.75:0.25:39;
fc = erb2fc(ERBc);
Excitation = zeros( length(in), length(ERBc) ); 

for i=1:length(ERBc)

    pu = get_p(fc(i)) .* ones(1,length(in));
    pl = get_pl(fc(i),InputLevels);
    p  = pu .* ( f >= fc(i) ) + pl .* ( f < fc(i) ); 
    g = ( f - fc(i) ) ./ fc(i); 

    ExcitationOfThisERBc = get_W(p,g) .* (g <= 4 ) .* 10.^(in./10);
    Excitation((1:length(in)),i) = ExcitationOfThisERBc(1:length(in));
end

if ( size(Excitation,1) > 1 ) 
    Excitation = sum(Excitation);
end

Excitation = 10 .* log(Excitation) ./ log(10);

out = Excitation;

end

function out = get_W(p,g)

g = abs(g);
out = ( 1 + p .* g ) .* exp( -1 .* p .* g );

end

function out = get_pl(f,X)

out = get_p(f) - 0.35 .* ( get_p(f) ./ get_p(1000) ) .* ( X - 51 );

end

function out = get_p(f)

% parameter for slope of auditory filter

out = 4 .* f ./ f2erb(f);

end

function InputLevels = InputLevelPerERB(f,in)

ERBw = f2erb(f);

InputLevels = zeros( length(in), length(in) );

for i = 1:length(in)
    p = get_p( f(i) );
    g = ( f - f(i) ) ./ f(i);
    InputLevelsOfThisTone = (g <= 4 ) .* get_W(p,g);
    InputLevelsOfThisTone = InputLevelsOfThisTone .* 10^(in(i)/10);
    InputLevels( i, (1:length(in)) ) = InputLevelsOfThisTone;
end

InputLevels = sum(InputLevels);

InputLevels = 10*log(InputLevels)./log(10);

end

