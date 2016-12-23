function  [tag_out, backschattered_start, backschattered_end]= tag_signal_decoder( tag_signal )
%FUNCTION tag_signal_decoder takes one argument "tag_signal".
% the input represets an expected backschattered signal

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



tag_out = [];
debug_flag = false;
backschattered_start = 50;
backschattered_end = 0;

%%
if  length(tag_signal) > backschattered_start*2                                               % remove 150 at the beginning,150 from the end and choose the maximum 100 points of a signal
    tag_signal = tag_signal(backschattered_start: end-backschattered_start);

    tag_signal_orig = tag_signal ;
    tag_signal_orig_mean = mean(tag_signal_orig(100: end-100));
    
    hLen = floor(length(tag_signal)/2);
    eLen = floor(length(tag_signal)/14);
    % looking for the location of the signal
    mid_t_sig_l1 = tag_signal(hLen -   eLen : hLen         );              % choose from the middel of the signal
    mid_t_sig_l2 = tag_signal(hLen - 3*eLen : hLen -   2*eLen);              % choose from the middel of the signal
    mid_t_sig_l3 = tag_signal(hLen - 5*eLen : hLen - 4*eLen);              % choose from the middel of the signal
    
    mid_t_sig_r1 = tag_signal(hLen          :hLen + eLen  );               % choose from the middel of the signal
    mid_t_sig_r2 = tag_signal(hLen + 2*eLen   :hLen + 3*eLen);               % choose from the middel of the signal
    mid_t_sig_r3 = tag_signal(hLen + 4*eLen :hLen + 5*eLen);               % choose from the middel of the signal
    
%     std(mid_t_sig_l1)
%     std(mid_t_sig_l2)
%     std(mid_t_sig_l3)
%     std(mid_t_sig_r1)
%     std(mid_t_sig_r2)
%     std(mid_t_sig_r3)
    
    mid_t_sig_l = mid_t_sig_l1;
    if std(mid_t_sig_l2) > std(mid_t_sig_l)
        mid_t_sig_l =  mid_t_sig_l2;
    end
    if std(mid_t_sig_l3) > std(mid_t_sig_l)
        mid_t_sig_l =  mid_t_sig_l3;
    end
    
    mid_t_sig_r = mid_t_sig_r1;
    if std(mid_t_sig_r2) > std(mid_t_sig_r)
        mid_t_sig_r =  mid_t_sig_r2;
    end
    if std(mid_t_sig_r3) > std(mid_t_sig_r)
        mid_t_sig_r =  mid_t_sig_r3;
    end
    
    mid_t_sig = mid_t_sig_r;
    
    if std(mid_t_sig_l) > std(mid_t_sig)
        mid_t_sig = mid_t_sig_l ;
    end
    
    
    max_num = sort(mid_t_sig, 2);
    len_mid_t_sig = length(mid_t_sig);
    max_num = max_num(1: floor(0.2 * len_mid_t_sig) );
    mean_max_num = mean(max_num);
    
    min_num = sort(mid_t_sig, 1);
    min_num = min_num(1:floor(0.2 * len_mid_t_sig));
    mean_min_num = mean(min_num);
    
    if abs( mean_max_num - mean_min_num ) > 0.003
        
        % measure the mean
        %sig_mean = mean(tag_signal); % this is a baised mean because of the extra samples
        sig_mean = mean(mid_t_sig); %[mean_min_num  mean_max_num] );
        add_dif = sig_mean - tag_signal_orig_mean;
            sig_mean_opt = sig_mean + add_dif;

        
        %         figure
        %         plot(mid_t_sig), hold on
        %         plot( [(1:length(mid_t_sig)) *0 +  sig_mean ]  ) , hold off
        %
        %disp(sig_mean)
        % disp(['std TAG' ,  num2str( std(std( [min_num  max_num]) ) ) ])
        % take decision
        tag_signal=(tag_signal < sig_mean);
        tag_signal_dig = tag_signal(2:length(tag_signal)) - tag_signal(1:length(tag_signal)-1);
        
        tag_signal = find(tag_signal_dig);
        first_1 = tag_signal(1);
        for i=(2:length(tag_signal) )
            startSym = (tag_signal(i) - first_1);
            if startSym > 30 && startSym < 50
                backschattered_start = backschattered_start+first_1;
                break
            else
                first_1 = tag_signal(i) ;
            end
        end
        
        end_1 = tag_signal(end);
        for i=(length(tag_signal-1):-1:1)
            endSym = (end_1 - tag_signal(i));
            if  ((endSym > 14) && (endSym < 26)) ||  ((endSym > 30) && (endSym < 50))
                backschattered_end = end_1;
                break
            else
                end_1 = tag_signal(i) ;
            end
        end
        
        tag_signal = tag_signal(2:length(tag_signal)) - tag_signal(1:length(tag_signal)-1);
        %disp(['tag_signal_length ' num2str(length(tag_signal)) ] )
        

        
        % Start and end of the expected backschattered signal
        %         start_index = find(tag_signal == 0, 1);
        %         indices = find(tag_signal == 0);
        %         end_index = indices(length(indices));
        
        
        % remove the samples before and after the expected backschattered signal
        %         tag_signal = tag_signal(start_index:end_index);
        
        %% Plot
%         figure('Position',[440 378 560 620/3]);
%         plot([1:length(tag_signal_orig)],tag_signal_orig, [1:length(tag_signal_orig)],tag_signal_orig*0+sig_mean ), hold on
%         plot(tag_signal_orig*0+tag_signal_orig_mean, 'k.' ), hold on
%          plot(tag_signal_orig*0+sig_mean_opt, 'r-.' ), hold off

        
        %% decoding
        %         digits = find(tag_signal==0);
        %         backschattered_start = digits(1) + 190; % the index of the start of backschatters within the input signal
        
        i=1;
        tag_out_num=[];
%         disp('--------------------------------')
%         length(tag_signal)
%         disp(tag_signal)
%          disp('--------------------------------')
        while i <= length(tag_signal)
            tag_out_num = [tag_out_num tag_signal(i)];
            if  tag_signal(i) > 14 && tag_signal(i) < 26
                
                if i < length(tag_signal)
                    if tag_signal(i+1) > 14 && tag_signal(i+1) < 26
                        tag_out = [tag_out '0'];
                        i=i+2;
                    elseif tag_signal(i+1) > 54 && tag_signal(i+1) < 72
                        tag_out = [tag_out '0v'];
                        i=i+2;
                    else
                         i=i+1;
                    end
                else
                    break
                end 
                
            elseif tag_signal(i) > 30 && tag_signal(i) < 50
                
                tag_out = [tag_out '1'];
                i=i+1;
                
            else
                i=i+1;
            end
        end
               
%         tag_out_num
%         tag_out
        
        %{
                counter = 0 ;
           for val= tag_signal_dig
            %             val = digits(i+1)-digits(i);
            
            %             if val == 1
                             counter =  counter +  1;
            
            if val > 26
                
                if counter <  12*2.8
                    tag_out = [tag_out '0'];
                elseif counter <  20*2.8
                    tag_out = [tag_out '1'];
                elseif counter <  30*2.8
                    tag_out = [tag_out 'v'];
                else
                    if debug_flag
                        tag_out = [tag_out '?'];
                    end
                end
                if val < 20*2.8
                    tag_out = [tag_out '1'];
                elseif val < 30*2.8
                    tag_out = [tag_out 'v'];
                else
                    if debug_flag
                        tag_out = [tag_out '-'];
                    end
                end
                counter = 0;
                
            else
                if counter <  12*2.8
                    tag_out = [tag_out '0'];
                elseif counter <  20*2.8
                    tag_out = [tag_out '1'];
                elseif counter <  40*2.8 || (val > 20*2.8 && val < 40*2.8)
                    tag_out = [tag_out 'v'];
                else
                    if debug_flag
                        tag_out = [tag_out 'x'];
                    end
                end
                counter = 0;
                
            end
            
        end
    end
        %}
    end
end

