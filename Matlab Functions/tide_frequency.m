%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
         %																			                      %
         % Dr. Thomas Whal, PhD (Assistant Professor) and Md. Mamunur Rashid, Ph.D. ( Research Associate) %
         %		 CECE, UCF, FL, USA) @ 2018 - 2019        												  %
         %                                                                                                %
         %  Function to estimate 18.6 and 4.4 year tide frequency from yearly stdev. of hourly tide data  %  
         %  Estimate annual stdev and fit 18.6 and 4.4 harmonics   %
         %                                                                                                %
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [yhat_hour,M_18f,M_4f]=tide_frequency(MSL_R)

% function to estimate 18.6 and 4.4 year tide frequency from yearly stdev. of hourly tide data   

%  yhat_hour = Estimated 18.6 and 4.4 year tide frequency time series in hour(col1 = 18.6 and col 2 = 4.4)
%  M_18f = Magnitude of 18.6 year frequency
%  M_4f = Magnitude of 4.4 year frequency
%  MSL_R = Mean Sea Level removed hourly tide data  

     % get annual STD
U = unique(MSL_R(:,1));
L = length(U);
for ii = 1:L
    f = find(MSL_R(:,1) == U(ii,1));
    na = find(~isnan(MSL_R(f,7)));
    if length(na) > 365.25*24/2
        STD(ii,1) = nanstd(MSL_R(f,7));
         P99(ii,1) = prctile(MSL_R(f,7),99);
    else
        STD(ii,1) = NaN;
         P99(ii,1) = NaN;
    end
end

% spline interpolation for missing data
t = [1:length(STD)]';
ff = find(isnan(STD));
STD2 = STD; t2 = t;
STD2(ff) = []; t2(ff) = [];

STD2 = spline(t2,STD2,t);

% remove first and last value if they were NaN, because interpolation
% doesn't make sense

if isnan(STD(1))
    STD2(1) = []; t(1) = [];
end

if isnan(STD(end))
    STD2(end) = []; t(end) = [];
end

% get 18.6 and 4.4 year sine/cosine fits
Le = length(unique(MSL_R(:,1)));
period = [18.6,4.4]; % tw selected frequencies

for ii = 1:2
    no = Le/period(ii);
    di = ceil(length(STD2)/no);
    
    % create model
    X = ones(length(STD2),3);
    X(:,2) = cos((2*pi)/di*t);
    X(:,3) = sin((2*pi)/di*t);
    
    % OLS fit
    beta(:,ii) = X\STD2;
    
    % reconstruction
    yhat(:,ii) = beta(1,ii)+beta(2,ii)*cos((2*pi)/di*t)+beta(3,ii)*sin((2*pi)/di*t);
end

%% Create hourly time series
di(1) = 18.6*365.25*24;
di(2) = 4.4*365.25*24;
tt = [1:length(MSL_R)]';

for ii = 1:2
    yhat_hour(:,ii) = beta(1,ii)+beta(2,ii)*cos((2*pi)/di(ii)*tt)+beta(3,ii)*sin((2*pi)/di(ii)*tt);
end
% make mean removed yhat_hour
yhat_hour(:,1)=yhat_hour(:,1)-nanmean(yhat_hour(:,1));
yhat_hour(:,2)=yhat_hour(:,2)-nanmean(yhat_hour(:,2));
% Find magnitude of frequencies
M_18f=[max(yhat_hour(:,1)),min(yhat_hour(:,1))];
M_4f=[max(yhat_hour(:,2)),min(yhat_hour(:,2))];
 

       %%%%%%%%%%%%%%%%%%%%  END  OF FUNCTION %%%%%%%%%%%%%%%%%%%%%%%%%%
