% AMT - Common functions
%
%  Signal levels and thresholds
%     DBSPL             - Calculate the SPL (in dB) of a signal
%     SCALETODBSPL      - Scale a signal to have a specific SPL
%     ABSOLUTETHRESHOLD - Absolute threshold of hearing
%
%  Converter
%     ERB2FC - calculates center frequency from a given erb index
%     ERBRATE2F - calculates the erb rate from a given frequency
%     F2ERBRATE - calculates the frequency from the erbrate
%     F2BMDISTANCE - Greenwoods function
%     F2ERB - calculates the widt of 1 Cam in Hz at frequency f in Hz
%     F2SIIWEIGHTINGS - Speech intelligibility weighted by frequency
%     FC2ERB - calculates the ERB index from a given frequency
%     HRTF2DTF - extracts dtf out of hrtf data
%     ITD2ANGLE_LOOKUPTABLE - Create the lookup table
%     ITD2ANGLE - Convert ITD to an angle using a lookup table
%     PHON2SONE - Convert phon to sone
%     SONE2PHON - Convert sone to phon
%     SPH2HORPOLAR - Convert spherical to polar coordinates
%
%  Filters
%     GAMMATONE        - Calculate Gammatone filter coefficients
%     GAMMACHIRP       - Calculate Gammatchirp filter coefficients
%     AUDITORYFILTERBANK - Linear auditory filterbank.
%     IHCENVELOPE        - Inner hair cell envelope extration.
%     ADAPTLOOP          - Adaptation loops.
%     MODFILTERBANK      - Modulation filter bank.
%     HEADPHONEFILTER    - FIR filter to model headphones 
%     MIDDLEEARFILTER    - FIR filter to model the middle ear
%     UFILTERBANKZ     - Apply multiple filters
%     FILTERBANKZ      - Apply multiple filters with non-equidistant downsampling
%
%  Feature extractor
%     LOCALIZATIONERROR - Calculates various localization errors from localization responses
%     ITDESTIMATOR		- Calculates ITD from a binaural pair of signals
%     ERBEST - Estimate the equivalent rectangular bandwidth from an impulse response
%     EXTRACTSP - Extract sagittal plane (SP) HRTFs from measurement data
%     IHCENVELOPE - Inner hair cell envelope extration
%
%  General
%     ADAPTLOOP - Applies non-linear adaptation to an input signal
%     FADE - Add a rise and fall to the end and beginning of a sequence
%     HANNFL - Plots a hann window
%     INFAMPLITUDECLIP - Perform infinite amplitude clipping on singnal
%     INTERPOLATION - Interpolate data
%     OPTIMALDETECTOR - Generic optimal detector for the CASP and Breebaart models
%     BMLD - Calculates the binaural masking level difference
%
%   Url: http://amtoolbox.org/amt-1.2.0/doc/common/Contents.php

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

