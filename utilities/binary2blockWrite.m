function message_out = binary2blockWrite(binary)

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


    message_out = 'BlockWrite:';

    if strcmp( binary(9:10), '00')
        disp('Reserved-')
        message_out = strcat(message_out, 'Reserved-');
    elseif strcmp( binary(9:10),'01')
        message_out = strcat(message_out, 'EPC-');
    elseif strcmp( binary(9:10), '10')
        message_out = strcat(message_out, 'TID-');
    elseif strcmp( binary(9:10),'11')
        message_out = strcat(message_out, 'User-');
    end

    WordPtr     =   binary(11:18) ;
    WordCounter =   binary(19:26) ;

    WordPtr_num = bin2dec(WordPtr);
    message_out = strcat( message_out, num2str(WordPtr_num));
    message_out = strcat( message_out, '-');
    
    WordCounter_num = bin2dec(WordCounter);
    message_out = strcat(message_out , num2str(WordCounter_num));
    message_out = strcat(message_out , '-');
    
    data = dec2hex( bin2dec( binary(27:42)));
    message_out = strcat(message_out , num2str(data));
    message_out = strcat(message_out , '-');
    
    message_out = strcat(message_out , binary(43:74));

end