function message_out =  message_details(message_in, binary, file_word, time )

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


    if strcmpi( message_in, 'QueryRep')   
        message_out = binary2queryRep(binary);
        
    elseif strcmpi( message_in, 'ACK')
        message_out = binary2ack(binary);
        
    elseif strcmpi( message_in, 'Query')  
         message_out = binary2query(binary);

    elseif strcmpi( message_in, 'QueryAdjust')  
         message_out = binary2queryAdjust(binary);
        
    elseif  strcmpi( message_in, 'Select')  
        message_out = binary2select(binary);
        
    elseif strcmpi( message_in, 'NAK')   
        message_out = binary2nak(binary);
        
    elseif strcmpi( message_in, 'Req_RN')
        message_out = binary2reqRn(binary);
        
    elseif strcmpi( message_in, 'Read')
         message_out = binary2read(binary);
        
    elseif strcmpi( message_in, 'Write')
        message_out = binary2write(binary);
        
    elseif strcmpi( message_in, 'BlockWrite')
        message_out = binary2blockWrite(binary);
     elseif strcmpi( message_in, 'Tag')
        message_out = binary2tag(binary);
        
    end
    message_out = strcat(message_out, 'smap_num:');
    message_out = strcat(message_out, num2str(time));
    message_out = strcat(message_out,'\n');
    fprintf(file_word, message_out);
    
end
