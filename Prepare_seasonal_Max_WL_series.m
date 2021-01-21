
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%																			                      %
% Md. Mamunur Rashid, Ph.D. ( Research Associate, CECE, UCF, FL, USA) @ 2018-2019        		  %
%                                                                                                %
%  Master Script to Estimate MSL and tide frequencies (18.6 and 4.4 yr) removed seasonal
%  maximum WL (summer and winter) from hourly WL data obtained from tide gauge																					 %
%
%  %%                                                                                            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% % Estimation of seasonal (Summer [May to Oct] and Winter [Nov to Apr]) maximum WL (sea level) form hourly WL data obtained from tide gauges (TG)
% Estimation steps:

%   1. Read TG hourly WL data from txt file store in HTD(Hourly Tide Data)
%   2. Replace all missing and data for years (with less that 75% available data) by NAN.
%   3. Remove MSL using 30 day median (product: MSL_R)
%   4. Estimate 18.6 and 4.4 year frequency component(product: yhat_hour, M_18f,M_4f) [function used: t_frequency]
%   5. Estimate Summer and Winter maximum WL removing 18.6 and 4.4 year frequency component (Product: s_max, w_max) [function used: seasonal_max_WL]
%   6. Save all required data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% change directory to the stored hourly WL .txt data files
cd('C:\SLI_source_code\Hourly water level data');
F = dir('*txt'); % stored files information

mkdir c:/SLI_source_code/Sesonal_Max_WL %output_folder_name % create the folder
folderdestination='c:/SLI_source_code\Sesonal_Max_WL'; % data storage path
%%

for i=1:length(F);
    cd('C:\SLI_source_code\Hourly water level data');
    output_file_name=strcat(F(i).name,'.mat');% define data stored folder name
    matfile = fullfile(folderdestination, output_file_name);
    %%
    
    HTD=importdata(F(i).name); % read data from .txt files
    MSL_R=R_MSL(HTD); % function R_MSL -> remove MSL from hourly WL data
    %%
    
    % need to subset the MSL_R data because we make dataTable starting from 1900 (putting NaN) although actual data might be available form ayer later than 1900.
    idx=find(isnan(MSL_R(:,7))~=1); % find the index of nonNaN values
    MSL_R_N=MSL_R(idx(1):end,:); %(need to remove long NaN from 1900 to start of 1st data) for estimating tide frequency
    
    %%
    [yhat_hour,M_18f,M_4f]=tide_frequency(MSL_R_N); % use function
    yhat_hour=[NaN(idx(1)-1,2);yhat_hour]; % make the yhat_hour same length as MSL_R adding NaN values
    [s,w]=seasonal_max_WL(MSL_R,yhat_hour); % use function
    
    %%
    % arrange data for period 1900 - 2017
    U=unique(MSL_R(:,1));
    s_max=[U,NaN(length(U),1)];
    w_max=[U,NaN(length(U),1)];
    
    s_max(find(s_max(:,1)==s(1,1)):end,2)=s(:,2); % summer max WL
    w_max(find(w_max(:,1)==w(1,1)):end,2)=w(:,2); % summer max WL
    
    %%
    % store data
    save(matfile,'HTD','MSL_R','yhat_hour','M_18f','M_4f','s_max','w_max','-v7.3','-nocompression');
    clearvars HTD MSL_R yhat_hour M_18f M_4f s_max w_max idx MSL_R_N
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  END %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


