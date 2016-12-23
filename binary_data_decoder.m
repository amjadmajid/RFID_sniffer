function  binary_data_decoder( sub_signal_location,  sub_signal_dif )

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


    for n = 1:length(sub_signal_dif)-1
        sub_signal_location = sub_signal_location + sub_signal_dif(n);
        
        if ( sub_signal_dif(n) > delimiter_limits(1)  ) && ...
                (sub_signal_dif(n) < delimiter_limits(2) );                % TODO meaning of the STEPS all oF THEM!!! 
            
            stat_deli = [stat_deli ; sub_signal_dif(n)+sub_signal_dif(n+1)];
            
            if first_delim
                fprintf(decodedSymbolsFile ,'%s' , 'D' );
                first_delim =  0;
            else
                fprintf(decodedSymbolsFile ,'\n%s' , 'D' );
                delim_location = [delim_location sub_signal_location ];
            end
            
        elseif ( (sub_signal_dif(n)) > Data_1_limits(1) ) && ...
                ((sub_signal_dif(n)) < Data_1_limits(2)    )
            
            stat_data_1 = [stat_data_1   sub_signal_dif(n)];
            fprintf(decodedSymbolsFile ,'%s' , '1' );
            
            data_1_location = [data_1_location sub_signal_location ];
            
            
        elseif ( (sub_signal_dif(n)) > Data_0_limits(1) ) && ...
                ((sub_signal_dif(n)) < Data_0_limits(2)    )
            
            stat_data_0 = [stat_data_0   sub_signal_dif(n)];
            fprintf(decodedSymbolsFile ,'%s' , '0' );
            
            data_0_location = [data_0_location sub_signal_location ];
            
        elseif ( (sub_signal_dif(n)) > RTCal_limits(1) ) && ...
                ((sub_signal_dif(n)) < RTCal_limits(2)    )
            
            stat_rt = [stat_rt  sub_signal_dif(n)+sub_signal_dif(n+1) ];
            fprintf(decodedSymbolsFile ,'%s' , 'RTCal' );
                                                                       
        elseif ( (sub_signal_dif(n)) > TRCal_limits(1) ) && ...
                ((sub_signal_dif(n)) < TRCal_limits(2)    )
            
            stat_tr = [stat_tr sub_signal_dif(n)+sub_signal_dif(n+1)];
            fprintf(decodedSymbolsFile ,'%s' , 'TRCal' );
        end
        
    end
    
    


end

