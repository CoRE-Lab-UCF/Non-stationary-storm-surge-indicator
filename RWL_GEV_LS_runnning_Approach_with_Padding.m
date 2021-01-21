%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
         %																			                      %
         % Md. Mamunur Rashid, Ph.D. ( Research Associate, CECE, UCF, FL, USA) @ 2018-2019        		  %
         %                                                                                                %
         %  Matlab script to estimate Return Water Level (RWL) from seasonal maximum water level		  %
         %	using non-stationary GEV model following running window approach 							  %												 %  
         %  This also include padding at the edge of the time series to avoid the loosing of data that    %
         %	occur in the running window approach														  %
		 %              Model B( GEV model with time varying location and scale parameters)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% snap to the directory where seasonal maximum water level data are stored
cd('C:\SLI_source_code\Result_RWL');
F = dir('*'); % store all folder information information 
for i=3:length(F);
path=strcat(F(i).folder,'\',F(i).name);
cd(path);
FF = dir('*.txt.mat'); % store information of all .txt.mat file in the folder
load(FF.name); % load the data
disp(strcat('Calculation of Summer season for :',F(i).name,'...'));
%function [RWL_LS,mu_ns_LS,scale_ns_LS,RWL_s_LS]=RWL_GEV_LS_running_padding(EWL,WL,RP,sim)
[RWL_LS,mu_ns_LS,scale_ns_LS,RWL_s_LS]=RWL_GEV_LS_running_padding(s_max,37,100,1000); % Estimate RWL for summer
save('RWL_GEV_LS_summer_running_padding.mat','RWL_LS','RWL_s_LS','mu_ns_LS','scale_ns_LS','s_max','-v7.3','-nocompression');
clearvars RWL_LS mu_ns_LS scale_ns_LS RWL_s_LS
disp(strcat('Calculation of Winter season for :',F(i).name,'...'));
[RWL_LS,mu_ns_LS,scale_ns_LS,RWL_s_LS]=RWL_GEV_LS_running_padding(w_max,37,100,1000);; % Estimate RWL for winter
save('RWL_GEV_LS_winter_running_padding.mat','RWL_LS','RWL_s_LS','mu_ns_LS','scale_ns_LS','w_max','-v7.3','-nocompression');
clearvars RWL_LS mu_ns_LS scale_ns_LS RWL_s_LS
end;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  END OF SCRIPT  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   

    
    
    