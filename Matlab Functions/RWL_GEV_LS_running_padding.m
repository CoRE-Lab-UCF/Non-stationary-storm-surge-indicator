%																			                      %
         % Md. Mamunur Rashid, Ph.D. ( Research Associate, CECE, UCF, FL, USA) @ 2018-2019        		  %
         %                                                                                                %
         % function to estimate non-stationary Return Water Level time series
		 % Non-stationary GEV model following running window approach 
         % Only location parameter varies with time
         % End padding with monte Carlo simulation is used at the edge of the time series to avoid loosing 
		 % of data that happen in running window approach   		 
		 
		 % Return Water Level (RWL) using seasonal maximum water level
                                                                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

             % Non Stationary GEV model with time dependent location and scale parameters
			 
function [RWL,mu_ns,scale_ns,RWL_s]=RWL_GEV_LS_running_padding(EWL,WL,RP,sim)

% RWL_LS = Non-stationary Return Water Level
% RWL_s_LS= Stationary Return Water Level
% mu_ns_LS = Non-stationary location parameter
% scale_ns_Ls = Non-stationary scale parameter

% EWL = extreme water level (e.g Summer) usually matrix of two column (year
% EWL). This could be a matrix with one column (EWL only)
% WL = window length (37 year for our case twise of 18.6 nodal cycle)
% RP = Vector of return period (in year)
% sim = no of simulations for monte carlo simulation 


if size(EWL,2)~=1
    idx=find(isnan(EWL(:,2))~=1);
    EWL=EWL(idx(1):end,:);
    max=EWL(:,2);
else
    idx=find(isnan(EWL)~=1);
    EWL=EWL(idx(1):end,:);;
    max=EWL;
end;
%%
% Estimate GEV Parameters for stationary case using full length of data
[par_s CI_s]=gevfit(max(isnan(max)~=1)); %shape(xi or jhi) scale(sigma) location(mu)

seed=1111;
rng(seed); % seeding for reproducibility of random number
mu_ns_t=cell(sim,1);
scale_ns_t=cell(sim,1);
for i=1:sim; % monte carlo simulation number for padding
     p_dat_F=gevrnd(par_s(1),par_s(2),par_s(3),18,1); % generate 18 data from observed GEV distribution
     p_dat_L=gevrnd(par_s(1),par_s(2),par_s(3),18,1);
     dat=[p_dat_F;max;p_dat_L]; % prepare new data with extra 36 data points at the beginning and end of the series
     [mu_ns_t{i},scale_ns_t{i}]=GEV_window(dat,WL);
	 warning('off','all');
end;

%% Now rake the range of the parameter values (Padding will have effect on the start and end portion (half of window length) of the time series   
%whereas middle portion would be the same as it found without padding case)
for i=1:length(dat)
    for j=1:sim
         mu_ns(i,1)=nanmean(mu_ns_t{j}(i,1));
         mu_ns(i,2)=nanmin(mu_ns_t{j}(i,2));
         mu_ns(i,3)=nanmax(mu_ns_t{j}(i,3));
		 
		 scale_ns(i,1)=nanmean(scale_ns_t{j}(i,1));
		 scale_ns(i,2)=nanmin(scale_ns_t{j}(i,2));
		 scale_ns(i,3)=nanmax(scale_ns_t{j}(i,3));
    end;
end;

mu_ns=mu_ns(isnan(mu_ns(:,1))~=1,:);
scale_ns=scale_ns(isnan(scale_ns(:,1))~=1,:);

%%
% Now estimate return period
% declare cell based on RP to store return period
RWL=cell(1,length(RP)); % Nonstationary RWL
RWL_s=cell(1,length(RP)); % Stationary RWL

for j=1:length(RP) % iteration for different return period
for i=1:length(mu_ns) % iteration for total time steps of mu (for nonstationary);
    if isnan(mu_ns(i))~=1
        RWL{j}(i,1)=gevinv(1-1/RP(j),par_s(1),scale_ns(i,1),mu_ns(i,1)); % 1-1/RP(j) to estimate probability
        RWL{j}(i,2)=gevinv(1-1/RP(j),par_s(1),scale_ns(i,2),mu_ns(i,2)); % 2.5th percentile [uncertainty in location and scale parameter is considered]
        RWL{j}(i,3)=gevinv(1-1/RP(j),par_s(1),scale_ns(i,3),mu_ns(i,3)); % 97.5th percentile [uncertainty in location and scale parameter is considered]
    else
        RWL{j}(i,1)=NaN;
        RWL{j}(i,2)=NaN;
        RWL{j}(i,3)=NaN;
    end;
end;
end;

%%% Estimate stationary RWL_running
for j=1:length(RP) % iteration for different return period
for i=1:length(mu_ns)
    if isnan(mu_ns(i))~=1
        RWL_s{j}(i,1)=gevinv(1-1/RP(j),par_s(1),par_s(2),par_s(3)); % 1-1/RP(j) to estimate probability
        RWL_s{j}(i,2)=gevinv(1-1/RP(j),CI_s(1,1),CI_s(1,2),CI_s(1,3)); % 2.5th percentile [only uncertainty in location parameter is considered]
        RWL_s{j}(i,3)=gevinv(1-1/RP(j),CI_s(2,1),CI_s(2,2),CI_s(2,3)); % 97.5th percentile [only uncertainty in location parameter is considered]
    else
        RWL_s{j}(i,1)=NaN;
        RWL_s{j}(i,2)=NaN;
        RWL_s{j}(i,3)=NaN;
    end;
end;
end;



% rearrange the output (making same lenght of data as input of EWL)
N=NaN(idx(1)-1,3);
mu_ns=[N;mu_ns];
scale_ns=[N;scale_ns];
for i=1:length(RP)
    RWL{j}=[N;RWL{j}];
	RWL_s{j}=[N;RWL_s{j}];
end;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    END OF FUNCTION  %%%%%%%%%%%