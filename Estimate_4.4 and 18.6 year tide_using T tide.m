
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
         %																			                      %
         % Md. Mamunur Rashid, Ph.D. ( Reserach Associate, CECE, UCF, FL, USA)@ 2018-2019        %
         %                                                                                                %
         %  Matlab Script to Estimate tides (18.6 and 4.4 yr) using T-tide analysis
		 %  
         %  %%                                                                                               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% We need latitude of each tide gauges for T-tide analysis
% read latitude for each tide gauges
A= importdata('C:\SLI_source_code\TG details.txt');
%%
% change directory to the stored hourly WL .txt datafiles 
cd('C:\SLI_source_code\Result_RWL');
F = dir('*'); % store all folder information 
for i=3:length(F);
path=strcat(F(i).folder,'\',F(i).name);
cd(path);
FF = dir('*.txt.mat'); % store information of all .txt.mat file in the folder
load(FF.name); % load the mean sea level and long term trend removed water level
disp(strcat('Calculation of Summer season for :',F(i).name,'...'));

% need to subset the MSL_R data because we keep data starting from 1900 (putting NaN) although actual data might be available form ayer later than 1900.  
idx=find(isnan(MSL_R(:,7))~=1); % find the index of nonNaN values
MSL_R_N=MSL_R(idx(1):end,:); %(need to remove long NaN from 1900 to start of 1st data) for estimating tide frequency 

% preapre data for T-Tide analysis
t=datenum(MSL_R_N(:,1:6));
ts=MSL_R_N(:,7);
%% Apply T-Tide to separate the tide from the total water level
[TCa, TCae, TCp, TCpe, Mt, pred, nameu ] = Tide_analysis( t,ts,A.data(i-2,2)); % pred = Predicted tide  % [ TCa, TCae, TCp, TCpe, Mt, pred, nameu ] = Tide_analysis( t, ts, lat)
% lat of Galveston 29.31
 pred=[MSL_R_N(:,1:6),pred];
 
[yhat_hour_N,M_18f_N,M_4f_N]=tide_frequency(pred); % function 

yhat_hour_N=[MSL_R_N(:,1:6),yhat_hour_N];

% Estimate 4.4. and 18.6 nodal tide corresponding to the seasonal maximum WL for each year

yhat=[NaN(idx(1)-1,2);yhat_hour_N(:,7:8)]; % make the yhat_hour same length as MSL_R adding NaN values
[yhat_s_max,yhat_w_max]=nodal_tide_corsp_max_WL(MSL_R,yhat); % function

%%% yhat_s_max and yhat_w_max (seasonal series) might have gap if the seasonal maximum water level series has gap [Need to fill those gap]
idx1=find(isnan(yhat_s_max(:,2))~=1);

 %%%%%%%%%%%%%%%%%  Use Spline to fill the gaps in the 4.4 and 18.6 year nodal tide  %%%%%%%%%

% for summer
aa=yhat_s_max(idx1(1):end,:); % subset data from start of data without NaN
for ii=1:2
  bb=aa;
  bb(isnan(bb(:,ii+1))==1,:)=[]; % % remove 
  ll(:,ii)=interp1(bb(:,1),bb(:,ii+1),aa(:,1),'spline');
 end;
yhat_s_max(idx1:end,2:3)=ll;

% for winter
aa=yhat_w_max(idx1(1):end,:); % subset data from start of data without NaN
for ii=1:2
  bb=aa;
  bb(isnan(bb(:,ii+1))==1,:)=[]; % % remove 
  ll(:,ii)=interp1(bb(:,1),bb(:,ii+1),aa(:,1),'spline');
 end;
yhat_w_max(idx1:end,2:3)=ll;

%% 
% store data
save('nodal_tide by T Tide','yhat_hour_N','M_18f_N','M_4f_N','yhat_s_max','yhat_w_max','-v7.3','-nocompression');
clearvars -except F i A
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  END %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

