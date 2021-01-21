%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
         %																			                      %
         % Md. Mamunur Rashid, Ph.D. ( Research Associate, CECE, UCF, FL, USA) @ 2018-2019        		  %
         %                                                                                                %
         %  Matlab script to estimate Return Water Level (RWL) from seasonal maximum water level		  %
         %	using non-stationary GEV model following running window approach 							  %												 %  
         %  This also include padding at the edge of the time series to avoid the loosing of data that    %
         %	occur in the running window approach														  %
		 %  
		 %                 Model A( GEV model with time varying location parameter only)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% snap to the directory where seasonal maximum water level data are stored
cd('C:\SLI_source_code\Result_RWL');
F = dir('*'); % store all folder information 
for i=3:length(F);
path=strcat(F(i).folder,'\',F(i).name);
cd(path);
FF = dir('*.txt.mat'); % store information of all .txt.mat file in the folder
load(FF.name); % load the data
%function [RWL,mu_ns,RWL_s]=RWL_running_padding(EWL,WL,RP,sim)
disp(strcat('Calculation of Summer season for :',F(i).name,'...'));
[RWL,mu_ns,RWL_s]=RWL_running_padding(s_max,37,100,1000); % Estimate RWL for summer
save('RWL_summer_running_padding.mat','RWL','RWL_s','mu_ns','s_max','-v7.3','-nocompression');
clearvars RWL RWL_s mu_ns
disp(strcat('Calculation of Winter season for :',F(i).name,'...'));
[RWL,mu_ns,RWL_s]=RWL_running_padding(w_max,37,100,1000); % Estimate RWL for winter
save('RWL_winter_running_padding.mat','RWL','RWL_s','mu_ns','w_max','-v7.3','-nocompression');
clearvars RWL RWL_s mu_ns
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  END OF SCRIPT  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    