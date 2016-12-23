function message_out = binary2query(binary)

%  Copyright (c) 2016, 
%  @authors: Amjad Yousef Majid                                                                     %
%            Przemyslaw Pawelczak                                                                   %
%  All rights reserved.                                                                             %
%                                                                                                   %
% Redistribution and use in source and binary forms, with or without                                %
% modification, are permitted provided that the following conditions are met:                       %
%     * Redistributions of source code must retain the above copyright                              %
%       notice, this list of conditions and the following disclaimer.                               %
%     * Redistributions in binary form must reproduce the above copyright                           %
%       notice, this list of conditions and the following disclaimer in the                         %
%       documentation and/or other materials provided with the distribution.                        %
%     * Neither the name of the <organization> nor the                                              %
%       names of its contributors may be used to endorse or promote products                        %
%       derived from this software without specific prior written permission.                       %
%                                                                                                   %
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND                   %
% ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED                     %
% WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE                            %
% DISCLAIMED. IN NO EVENT SHALL <COPYRIGHT HOLDER> BE LIABLE FOR ANY                                %
% DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES                        %
% (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;                      %
% LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND                       %
% ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT                        %
% (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS                     %
% SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.                                      %


    message_in ='Query:';

    if strcmp( binary(5), '0')
        message_in = strcat(message_in,'DR=8-');
    elseif strcmp( num2str( binary(5) ), '1')
        message_in = strcat(message_in, 'DR=64/3-');
    end

    if strcmp( binary(6:7), '00')
        message_in = strcat(message_in, 'M=1-');
    elseif strcmp( binary(6:7), '01')
        message_in = strcat(message_in, 'M=2-');
    elseif strcmp( binary(6:7), '10')
        message_in = strcat(message_in, 'M=4-');
    elseif strcmp( binary(6:7), '11')
        message_in = strcat(message_in, 'M=8-');
    end

    if strcmp( binary(8), '0')
        message_in = strcat(message_in, 'No-pilot-tone-');
    elseif strcmp( binary(8), '1')
        message_in = strcat(message_in, 'Use-pilot-tone-');
    end

    if strcmp( binary(9), '0')
        message_in = strcat(message_in, 'All-');
    elseif strcmp( binary(10), '0')
        message_in = strcat(message_in, '~SL-');
    elseif strcmp( binary(10), '1')
        message_in = strcat(message_in, 'SL-');
    end

    if strcmp( binary(11:12), '00')
        message_in = strcat(message_in, 'S0-');
    elseif strcmp( binary(11:12),'01')
        message_in = strcat(message_in, 'S1-');
    elseif strcmp( binary(11:12), '10')
        message_in = strcat(message_in,'S2-');
    elseif strcmp( binary(11:12),'11')
        message_in = strcat(message_in,'S3-');
    end

    if strcmp( binary(13), '0')
        message_in = strcat(message_in,'A-');
    elseif strcmp( binary(13), '1')
        message_in = strcat(message_in,'B-');
    end
    message_in = strcat(message_in,binary(14:22));

    message_out = message_in ;
end