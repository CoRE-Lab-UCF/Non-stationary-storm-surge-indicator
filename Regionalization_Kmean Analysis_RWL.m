
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
         %																			                            %
         % Md. Mamunur Rashid, Ph.D. ( Research Associate, CECE, UCF, FL, USA) @ 2018-2019        		        %
         %                                                                                                      %
         %  Matlab script to identify the coherent regions (stretch of coastlines with coherent RWL variability)%													  %
		 %  Apply kmeans analysis separately for three regions of US coast
		 
         %                      % 1. Pacific coast 															    %
         %                      % 2. Gulf of Mexico 															%
         %                      % 3. Atlantic coast 															%
		 % Corresponding tide gauges for each coherent regions were optimized though several trial using kemans %
         % and cross correlation analysis		 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Read RWL data from the directory files
cd('C:\SLI_source_code\Result_RWL');
F = dir('*'); % store all folder information information 
for i=3:length(F);
path=strcat(F(i).folder,'\',F(i).name);
cd(path);
load('RWL_summer_running_padding.mat'); % load the summer RWL 
s_EWL(:,i-2)=s_max(:,2); % store summer RWL in matirx
load('RWL_winter_running_padding.mat'); % Load winter RWL data
w_EWL(:,i-2)=w_max(:,2); % store winter RWL in matirx
end;
                            %%% Cluster analysis for sub-region

     %%%% Pacific coast
S_S_p=[11:19]; % station number based on region
%S_S=[11:19];
S_W_p=[11:19];
SEWL=s_EWL(:,S_S_p); % subset EWL matrix for sub region
WEWL=w_EWL(:,S_W_p);
rng(4)
[cidx_s_p,r_s_p,p_s_p]=k_mean_test(SEWL,2,0.05,S_S_p);
rng(14)
[cidx_w_p,r_w_p,p_w_p]=k_mean_test(WEWL,2,0.05,S_W_p);

      %%%% Gulf of Maxico %%%%%%%
	%1st sub cluster
S_S_g_1=[20:23]; % station number based on region
S_W_g_1=[20:23];
SEWL=s_EWL(:,S_S_g_1); % subset EWL matrix for sub region
WEWL=w_EWL(:,S_W_g_1);
rng('default')
[cidx_s_g_1,r_s_g_1,p_s_g_1]=k_mean_test(SEWL,1,0.05,S_S_g_1);
cidx_s_g_1(cidx_s_g_1==1)=3;
rng('default')
[cidx_w_g_1,r_w_g_1,p_w_g_1]=k_mean_test(WEWL,1,0.05,S_W_g_1);
cidx_w_g_1(cidx_w_g_1==1)=3;

  %2nd sub cluster
S_S_g_2=[24:25]; % station number based on region
S_W_g_2=[24:25];
SEWL=s_EWL(:,S_S_g_2); % subset EWL matrix for sub region
WEWL=w_EWL(:,S_W_g_2);
rng('default')
[cidx_s_g_2,r_s_g_2,p_s_g_2]=k_mean_test(SEWL,1,0.05,S_S_g_2);
cidx_s_g_2(cidx_s_g_2==1)=4;
rng('default')
[cidx_w_g_2,r_w_g_2,p_w_g_2]=k_mean_test(WEWL,1,0.05,S_W_g_2);
cidx_w_g_2(cidx_w_g_2==1)=4;

%%%%%%%%%%%%%%%%%%  Atlantic coast  %%%%%%%%%%%%%%
  % 1st sub cluster
S_S_a_1=[26:30]; % station number based on region
%S_S=[11:19];
S_W_a_1=[26:30];
SEWL=s_EWL(:,S_S_a_1); % subset EWL matrix for sub region
WEWL=w_EWL(:,S_W_a_1);
rng('default')
[cidx_s_a_1,r_s_a_1,p_s_a_1]=k_mean_test(SEWL,1,0.05,S_S_a_1);
cidx_s_a_1(cidx_s_a_1==1)=5;

rng('default')
[cidx_w_a_1,r_s_a_1,p_s_a_1]=k_mean_test(WEWL,1,0.05,S_W_a_1);
cidx_w_a_1(cidx_w_a_1==1)=5;

 % 2nd sub cluster
S_S_a_2=[31:40]; % station number based on region
S_W_a_2=[31:38];
SEWL=s_EWL(:,S_S_a_2); % subset EWL matrix for sub region
WEWL=w_EWL(:,S_W_a_2);
rng('default')
[cidx_s_a_2,r_s_a_2,p_s_a_2]=k_mean_test(SEWL,1,0.05,S_S_a_2);
cidx_s_a_2(cidx_s_a_2==1)=6;

rng('default')
[cidx_w_a_2,r_s_a_2,p_s_a_2]=k_mean_test(WEWL,1,0.05,S_W_a_2);
cidx_w_a_2(cidx_w_a_2==1)=6;

% 3rd sub cluster
S_S_a_3=[41:45]; % station number based on region
S_W_a_3=[39:45];
SEWL=s_EWL(:,S_S_a_3); % subset EWL matrix for sub region
WEWL=w_EWL(:,S_W_a_3);
rng('default')
[cidx_s_a_3,r_s_a_3,p_s_a_3]=k_mean_test(SEWL,1,0.05,S_S_a_3);
cidx_s_a_3(cidx_s_a_3==1)=7;

rng('default')
[cidx_w_a_3,r_s_a_3,p_s_a_3]=k_mean_test(WEWL,1,0.05,S_W_a_3);
cidx_w_a_3(cidx_w_a_3==1)=7;

                   %%%%%%% Plot the final figure
                  % arranged the cluster group 
idx_s=[(11:45)'];
idx_w=[(11:45)'];
cidx_s=[cidx_s_p;cidx_s_g_1;cidx_s_g_2;cidx_s_a_1;cidx_s_a_2;cidx_s_a_3]; 
cidx_w=[cidx_w_p;cidx_w_g_1;cidx_w_g_2;cidx_w_a_1;cidx_w_a_2;cidx_w_a_3];

% arrange the cluster number 
S=[idx_s,cidx_s];
S(1:4,3)=1;S(5:9,3)=2;S(10:end,3)=S(10:end,2);
W=[idx_w,cidx_w];
W(1:4,3)=1;W(5:9,3)=2;W(10:end,3)=W(10:end,2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%	

                          %%%%%%%  PLot the figure
RWL_s=s_EWL(:,S(:,1));
RWL_w=w_EWL(:,W(:,1));
plot_cluster(S(:,1),7,S(:,3),RWL_s,0.05); %plot_cluster(S,clust_no,cidx_c,RWL,thres)
plot_cluster(S(:,1),7,W(:,3),RWL_w,0.05);



