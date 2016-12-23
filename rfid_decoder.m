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


% rfid_decoder script
clear all;
close all;
clc;
format compact
path = '/home/amjad/Documents/MATLAB/rfid_decoder/';
raw_data = 'data/raw_data/data_mag_08-07-2016.dat';
cd(path);
addpath(genpath(path));

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   variables and data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

signal_start = 42e6;                                                     % [user-selectable] start of the chosen portion of the input data
signal_length = 25e6;                                                     % [user-selectable] length of the chosen portion of the input data

samp_rate = 28e6;                                                          % sampling rate (must match the "samp_rate" variable from GNURadio sniffer file)
tari = 7.140e-6 - 2e-6;                                                    % RFID tag-dependent value (for WISP tari=7.140e-6). Two is subtracted because the power dip (end of symbol) is not considered
delimiter_time = 12.5e-6;                                                  % specified by the EPC C1G2 standard

% Data symbol delimiter sizes (EPC C1G2 specific)
Data_0_limits       = [ceil( 0.75*tari*samp_rate ) ceil(tari*samp_rate*1.1) ]; % Data-0 < 180 for 28MHz sample rate
Data_1_limits       = [ceil( tari * 1.3 *samp_rate) ceil(tari*1.8*samp_rate)];
delimiter_limits    = [(delimiter_time*samp_rate*0.8)  ceil(delimiter_time*samp_rate)];
RTCal_limits        = [tari*samp_rate *1.8 *(7.14/5.14) tari*samp_rate * 3 *(7.14/5.14)];
TRCal_limits        = [RTCal_limits(2)*1.1  RTCal_limits(2)*2 ];


%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   find the start of the signal
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
signal = slice_signal(raw_data, (signal_start),(signal_length));           % the sub_signal of interest

orig_signal = signal;

% figure
% plot(signal, '.');

% pass the signal through lowpass filter
a = fir1(30, 0.06, 'low');
signal = filter(a,1,signal);

figure('Position',[440 378 560 620/3]);
plot(signal);

% check the signal if it is only noice 
if max(signal) < 0.01
    userDis =  input('The signal is only noise! do you want to continue (y/n)? ', 's');
    if userDis == 'n'
        clear
        return
    end
end

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   find the power down borders
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
movingAve =  movmean(signal, 1000);                                        % value of "1000" chosen experimentally to exclude the delimiters
min_movingAve = min(movingAve);
signal_bin_digit = movingAve > (3 * min_movingAve);                        % anything above (3 * min_movingAve ) will be 1; value of "3" chosen experimentally

power_down_borders      = find( signal_bin_digit(2:length(signal_bin_digit)) ...
    - signal_bin_digit(1:length(signal_bin_digit)-1) );                      % deremination of power-up/power-down regions (only when there is a change between 1 and 0 the difference is not zero)
power_down_borders = power_down_borders';
power_down_indices = [1 power_down_borders  length(signal) ];

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   find out if the jumps will be on the even or odd chunck of the signal
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pwrDwnUp_start_point = 1;
if length(power_down_indices) > 2
    odd_mean = mean( signal( power_down_indices(1):power_down_indices(2) ));   % is the signal started like __|NNN  or  NNN|___ % Problem ^^^^NNNNN___
    even_mean= mean( signal( power_down_indices(2):power_down_indices(3) ));
    if even_mean > odd_mean
        pwrDwnUp_start_point = 2;
    end
end

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Go throught the chuncks of the singal
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

decodedSymbolsFile = fopen(strcat(path, ...
    'data/decoded_data/decoded_symbols.txt'), 'w');                        %  overwrite the previous file
fclose(decodedSymbolsFile);

decodedSymbolsFile = fopen(strcat(path, ...
    'data/decoded_data/decoded_symbols.txt'), 'a');                    % append to the previous file

stat_tot_deli = [];                                                        % Total statistics
stat_tot_rt = [];                                                          % TODO meaning of the variables
stat_tot_tr = [];
stat_tot_data_1 = [];
stat_tot_data_0 = [];

first_delim = 1;

delim_location=[];
data_1_location=[];
data_0_location=[];

for pwrUpDwn = (pwrDwnUp_start_point:2:length(power_down_indices)-1)
    
    sub_signal=signal(power_down_indices(pwrUpDwn):power_down_indices(pwrUpDwn+1));                             % TODO extract the sub_singals TODO "5" explain
    sub_singal_len = length(sub_signal);
    
    sub_signal_max      = sort(sub_signal, 2);                             % sort the sub_signal descending
    sub_signal_max      = mean(sub_signal_max(1: floor(0.1* sub_singal_len)) );                   % choose the max 10000 symbol TODO "100000"
    sub_signal_mean_1   = sub_signal_max/2;                                % choose the midpoint
    sub_signal_mean     = sub_signal_mean_1 * ones(1, sub_singal_len ) ;   % make a vector of the same length of the sub_signal
    
    sub_signal_digit = sub_signal > sub_signal_mean_1;                     % binary sub_signal for ploting
    
    ssd = sub_signal_digit( 2:length(sub_signal_digit) ) - sub_signal_digit( 1:length(sub_signal_digit)-1 );
    sub_signal_cross_points = find(ssd );
    
    if pwrUpDwn ~= 1 && pwrUpDwn ~= length(power_down_indices)
        power_down_indices(pwrUpDwn) = power_down_indices(pwrUpDwn) + sub_signal_cross_points(1); % the power down/up edges timings are not exact: a side effect of using moving averge
        % therefore i need to calibrate for that
    end
    
    sub_signal_dif=sub_signal_cross_points(2:length(sub_signal_cross_points...
        ))-sub_signal_cross_points(1:length(sub_signal_cross_points)-1);   % TODO explain this step
    
    %%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %   Decode Binary data
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    % TODO meaning of the variables
    stat_deli = [];
    stat_rt = [];
    stat_tr = [];
    stat_data_1 = [];
    stat_data_0 = [];
    start_message_time  =  -1;
    end_message_time  =  -1;
    sub_signal_location=power_down_indices(pwrUpDwn);
    
    %     binary_data_decoder( sub_signal_location,  sub_signal_dif );
    
    for n = 1:length(sub_signal_dif)-1
        sub_signal_location = sub_signal_location + sub_signal_dif(n);
        
        if ( sub_signal_dif(n) > delimiter_limits(1)  ) && ...
                (sub_signal_dif(n) < delimiter_limits(2) );                % TODO meaning of the STEPS all oF THEM!!!
            
            stat_deli = [stat_deli ; sub_signal_dif(n)];
            
            if first_delim
                fprintf(decodedSymbolsFile ,'%s' , 'D' );
                delim_location = [delim_location sub_signal_location ];
                start_message_time = sub_signal_location;
                first_delim =  0;
            else
                fprintf(decodedSymbolsFile ,'\n%d:%d' , start_message_time,end_message_time  );
                %%%%%%%%%%%%%%%%%%%%%%%%%%% Backscatter %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                reader_mes_end =   sub_signal_location - (sub_signal_dif(n) + sub_signal_dif(n-1)) ;
                [tag_out, backschattered_start, backschattered_end] =  tag_signal_decoder(signal( ( sub_signal_location - sub_signal_dif(n) - sub_signal_dif(n-1) ) : sub_signal_location - sub_signal_dif(n) ));
                %                 if strncmpi(tag_out, '1010v', 5) || strncmpi(tag_out, '0000000000001010v', 17)
                
                longPreamble = strfind(tag_out, '0000000000001010v');
                
                if ~isempty(longPreamble)
                    tag_out = tag_out(longPreamble:end);
                else
                    shortPreamble = strfind(tag_out, '1010v');
                    if ~isempty(shortPreamble)
                        tag_out = tag_out(shortPreamble:end);
                    end
                end
                
                if ~isempty(longPreamble) || ~isempty(shortPreamble)
                    tag_out = strcat('TAG:' , tag_out );
                    fprintf(decodedSymbolsFile ,'\n%s\n%d:%d' , tag_out,reader_mes_end+backschattered_start, reader_mes_end+backschattered_start+backschattered_end  );
                    %                     fprintf(file_h ,'%d\n' ,edge_index(j-1) + backschattered_start)
                    
                end
                longPreamble=[];
                shortPreamble=[];
                %%%%%%%%%%%%%%%%%%%%%%%%%%% Backscatter %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                
                fprintf(decodedSymbolsFile ,'\n%s', 'D' );
                delim_location = [delim_location sub_signal_location ];
                start_message_time = sub_signal_location;
            end
            
        elseif ( (sub_signal_dif(n)) > Data_1_limits(1) ) && ...
                ((sub_signal_dif(n)) < Data_1_limits(2)    )
            end_message_time = sub_signal_location;
            
            stat_data_1 = [stat_data_1   sub_signal_dif(n)+sub_signal_dif(n+1)];
            fprintf(decodedSymbolsFile ,'%s' , '1' );
            
            data_1_location = [data_1_location sub_signal_location ];
            
            
        elseif ( (sub_signal_dif(n)) > Data_0_limits(1) ) && ...
                ((sub_signal_dif(n)) < Data_0_limits(2)    )
            end_message_time = sub_signal_location;
            
            stat_data_0 = [stat_data_0   sub_signal_dif(n)+sub_signal_dif(n+1) ];
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
    
    % Statistics
    stat_deli_ave = sum(stat_deli) / length(stat_deli);
    %disp([ 'delimiter average: ' num2str(stat_deli_ave) ])
    
    stat_tot_deli =  [stat_tot_deli ; stat_deli];                           % TODO meaning of the STEPS all oF THEM!!
    
    if ~isempty(stat_rt)
        stat_rt_ave = sum(stat_rt) / length(stat_rt);
      %  disp([ 'RTcal average: ' num2str(stat_rt_ave) ])
        stat_tot_rt = [stat_tot_rt   stat_rt];
    end
    
    
    if ~isempty(stat_tr)
        stat_tr_ave = sum(stat_tr) / length(stat_tr);
       % disp([ 'TRcal average: ' num2str(stat_tr_ave) ])
        stat_tot_tr = [stat_tot_tr  stat_tr];
    end
    
    
    stat_data_1_ave = sum(stat_data_1) / length(stat_data_1);
    %disp([ 'data_1 average: ' num2str(stat_data_1_ave) ])
    stat_tot_data_1 = [stat_tot_data_1   stat_data_1];
    
    
    stat_data_0_ave = sum(stat_data_0) / length(stat_data_0);
   % disp([ 'data_0 average: ' num2str(stat_data_0_ave) ])
    stat_tot_data_0 = [stat_tot_data_0  stat_data_0];
    
    %    x= 1:sub_singal_len;                            % for plotting
    %    figure('Position',[440 378 560 620/3]);
    %    plot(x,sub_signal , x , sub_signal_digit , x , sub_signal_mean )
end

% Statistics
disp(['The overall average of the delimiters: ' num2str( mean(stat_tot_deli)/25.0 )])
disp(['The overall standard deviation  of the delimiters: ' num2str( std(stat_tot_deli)/25.0 )])
disp(['The overall average of the RTcal: ' num2str( mean(stat_tot_rt)/25.0 )]);
disp(['The overall standard deviation  of the RTcal: ' num2str( std(stat_tot_rt)/25.0 )])
if ~isempty(stat_tot_tr)
    disp(['The overall average of the TRcal: ' num2str( mean(stat_tot_tr)/25.0  )]);
    disp(['The overall standard deviation  of the TRcal: ' num2str( std(stat_tot_tr)/25.0 )])
end
disp(['The overall average of the Data-1: ' num2str( mean(stat_tot_data_1)/25.0)]);
disp(['The overall standard deviation  of the Data-1: ' num2str( std(stat_tot_data_1)/25.0 )])
disp(['The overall average of the Data-0: ' num2str(mean(stat_tot_data_0)/25.0 )]);
disp(['The overall standard deviation  of the Data-0: ' num2str( std(stat_tot_data_0)/25.0 )])

% Statistics: Ploting
figure('name', 'Data-1/0')
subplot(2,1,1)
hist(stat_tot_data_1,50)
title( 'Data-1')
subplot(2,1,2)
hist(stat_tot_data_0,50)
title ('Data-0')

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Decode data/information
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

message_decoder(strcat(path,'/data/decoded_data/') , 'decoded_symbols.txt', 'messages.txt' )



%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Ploting
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
sLen = 1:length(signal);

s = signal;
s(delim_location) = 100;
s(s<100) = 0;
s(s==100) = 1;

s_data_1 = signal;
s_data_1(data_1_location) = 100;
s_data_1(s_data_1<100) = 0;
s_data_1(s_data_1==100) = 1;

s_data_0 = signal;
s_data_0(data_0_location) = 100;
s_data_0(s_data_0<100) = 0;
s_data_0(s_data_0==100) = 1;

s_pow = signal;

s_pow(power_down_indices) = 100;
s_pow(s_pow<100) = 0;
s_pow(s_pow==100) = 1;

figure
plot(sLen, [signal s s_data_1 s_data_0  s_pow])

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Backscatter signal decoding
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%{
backScatter_locations = s+s_data_1+s_data_0;

del_loc = find(s);                                                         % delimiter locations
symbol_before_del = find(backScatter_locations);                           % delimiter, Data-1 and Data-0 locations

tot_tag_out=[];
backScatter_sig=[];
for d=1:length(del_loc)
     disp('----')
%       disp(del_loc(d))

      dl = symbol_before_del( find(symbol_before_del== del_loc(d) )-1 );
%      sbd = symbol_before_del(dl-1);
%    figure
%      plot(signal(dl : del_loc(d)))
backScatter_sig = [backScatter_sig;  [dl del_loc(d)] ];
     [tag_out, backschattered_start] =  tag_signal_decoder(signal( dl: del_loc(d) ));
     
%      tot_tag_out=[tot_tag_out tag_out];
     
     if strncmpi(tag_out, '1010v', 5) || strncmpi(tag_out, '0000000000001010v', 17)
                    tag_out = strcat('TAG:' , tag_out );
                                        fprintf(file_h , strcat(tag_out,'\n'));
                                        fprintf(file_h ,'%d\n' ,edge_index(j-1) + backschattered_start);
                end
end

%}



