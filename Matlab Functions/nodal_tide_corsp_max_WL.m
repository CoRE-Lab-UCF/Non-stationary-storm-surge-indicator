%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
         %																			                      %
         % Md. Mamunur Rashid, Ph.D. ( Reserach Associate, CECE, UCF, FL, USA)        %
         %                                                                                                %
         %  Function to find nodal tide correspond to maximum seasonal WL   %  
         %  
         %  Two seasons Summer (May to Oct) Winter (Nov to Apr : Jan to Apr from the next year)                                                                                               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [yhat_s_max,yhat_w_max]=nodal_tide_corsp_max_WL(MSL_R,yhat_hour)
%  s_max = maximum water level time series for Summer season (yearly time step)
%  w_max = maximum water level time series for Winter season (yearly time step)
%  MSL_R = Mean Sea Level (MSL) remove hourly Water Level time series
%  yhat_hour = hourly time series of 18.6 and 4.4 year tide frequencies

%  Find the seasonal maximum for any year then deduct 18.6 amd 4.4 year frequency component 
%  for corresponding time step
%  first seasons are considered as (summer : May to Oct /  Winter : Nov to Apr (next year)
 
u=unique(MSL_R(:,1));


         %% For summer (May to Oct same year)
for i=1:length(u);
%summer1=AA(AA(:,1)==u(i),:);
     idx=find(MSL_R(:,1)==u(i)); % index of all values for any year
     N=[MSL_R(idx,:),idx];
     summer=N(N(:,2)==5|N(:,2)==6|N(:,2)==7|N(:,2)==8|N(:,2)==9|N(:,2)==10,:); %May to Oct (5 - 10)
     
	 %if sum(isnan(summer(:,7)))>=0.75*size(summer,1) % if total no of NaN >= 75% of total data length
	 %  Temp_max=NaN;
	%	else
		Temp_max=max(summer(:,7)); % find the yearly maximum WL
	%end;
     

     if isnan(Temp_max)~=1
         idx_max=summer(summer(:,7)==Temp_max,8); % find index value corresponding to MSL_R hourly data 		 
         yhat_s_max(i,:)=yhat_hour(idx_max(1,1),:); % read 18.6 and 4.4 year frequency tide magnitude correspond to summer max WL
		 
     else
         yhat_s_max(i,:)=repmat(NaN,1,2);
     end;
end;
yhat_s_max=[u,yhat_s_max];

         %% for winter (Nov to Apr :: Nov - Dec --> This year and Jan - Apr --> next year)
for i=1:length(u)-1 
     idx1=find(MSL_R(:,1)==u(i));% (This year): index of all values for any year
	 idx2=find(MSL_R(:,1)==u(i+1));% (Next year): index of all values for any year
	 N1=[MSL_R(idx1,:),idx1];
	 N2=[MSL_R(idx2,:),idx2];
	 w1=N1(N1(:,2)==11|N1(:,2)==12,:);%Nov-Dec of this year
	 w2=N2(N2(:,2)==1|N2(:,2)==2|N2(:,2)==3|N2(:,2)==4,:); % Jan-Apr of next year
	 winter=[w1;w2];
	 
	% if sum(isnan(winter(:,7)))>=0.75*size(winter,1) % if total no of NaN >= total data length
	%   Temp_max=NaN;
    %  else	 
	   Temp_max=max(winter(:,7)); % find the yearly maximum WL
	%end;
		
        	 
	 if isnan(Temp_max)~=1
         idx_max=winter(winter(:,7)==Temp_max,8); % find index value of max WL corresponding to AA(mother hourly data)
         yhat_w_max(i,:)=yhat_hour(idx_max(1,1),:); % estimate 18.6 and 4.4 year frequency free summer max WL
      else
         yhat_w_max(i,:)=repmat(NaN,1,2);
     end;
end;
yhat_w_max=[u,[yhat_w_max;[NaN NaN]]]; % last year of w_max is NaN as it is estimated based on this year (NOV-DEC) and next year (JAN-APR).

%%%%%%%%%%%%%%%%%%  XXXXXX    END  XXXXXXX %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
