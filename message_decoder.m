function  message_decodder(path, in_file, out_file )

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


cd(path);

file_digit = fopen(in_file, 'r');
file_word = fopen(out_file, 'w'); 
detail = strcat('detail_',out_file) ;
detail_out_file = fopen(detail, 'w');

line = fgetl(file_digit); % read a line
 
while isempty(line) % to remove any blank lines at the top
    line = fgetl(file_digit);
end

while ~isempty(line) && ischar(line)
    
    l_index = strfind(line, 'l');
   
    if l_index
         l_index = l_index(end);
        line = line(l_index+1: end);
    end 
    if strncmpi( line, '00', 2)           && length(line) >= 4
        fprintf(file_word, 'QueryRep\n');
        time = fgetl(file_digit); % read a line
        message_details('QueryRep', line, detail_out_file, time );
        
    elseif strncmpi( line, '01', 2)       && length(line) >= 18
        fprintf(file_word,'ACK\n');
        time = fgetl(file_digit); % read a line
         message_details('ACK', line, detail_out_file,time );
         
    elseif strncmpi( line, '1000', 4)     && length(line) >= 22
        fprintf(file_word,'Query\n');
        time = fgetl(file_digit); % read a line
        message_details('Query', line, detail_out_file,time );
        
    elseif strncmpi( line, '1001', 4)     && length(line) >= 9
        fprintf(file_word,'QueryAdjust\n');
        time = fgetl(file_digit); % read a line
        message_details('QueryAdjust', line, detail_out_file,time );
        
        
    elseif strncmpi( line, '1010', 4)     && length(line) >= 44
        fprintf(file_word,'Select\n');
        time = fgetl(file_digit); % read a line
        message_details('Select', line, detail_out_file,time );
        
        
    elseif strncmpi( line, '11000000', 8) && length(line) >= 8
        fprintf(file_word,'NAK\n');
        time = fgetl(file_digit); % read a line
        message_details('NAK', line, detail_out_file,time );
        
    elseif strncmpi( line, '11000001', 8) && length(line) >= 40
        fprintf(file_word,'Req_RN\n');
        time = fgetl(file_digit); % read a line
        message_details('Req_RN', line, detail_out_file,time );
        
    elseif strncmpi( line, '11000010', 8) && length(line) >= 57
        fprintf(file_word,'Read\n');
        time = fgetl(file_digit); % read a line
        message_details('Read', line, detail_out_file,time );
        
    elseif strncmpi( line, '11000011', 8) && length(line) >= 58
        fprintf(file_word,'Write\n');
        time = fgetl(file_digit); % read a line
        message_details('Write', line, detail_out_file, time );
        
    elseif strncmpi( line, '11000111', 8) && length(line) >= 57
        fprintf(file_word,'blockwrite\n');
        time = fgetl(file_digit); % read a line
        message_details('BlockWrite', line, detail_out_file,time );
    elseif strncmpi( line, 'TAG', 3) && length(line) >= 5
        fprintf(file_word,'TAG\n');
        time = fgetl(file_digit); % read a line
        message_details('TAG', line, detail_out_file,time );    
    end
    
    line = fgetl(file_digit);
end

end