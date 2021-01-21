
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
         %																			                            %
         % Md. Mamunur Rashid, Ph.D. ( Research Associate, CECE, UCF, FL, USA) @ 2018-2019        		        %
         %                                                                                                      %
         %  Matlab function for kmeans analysis
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [cidx_c,cmeans_c,r,p]=k_mean_test(RWL,clust_no,thres,S)
% function to estimate k-mean clustering and plot the result
% RWL is the matrix of variables column represent values of variables as the time series and  row represent each stations
% clust_no = total number of cluster 
% thres = = threshold for significance level 
% S = index number of stations based on the region

% cidx_c = cluster index
% r = correlation matrix for each clustering
% p = statistical significance matrix for each cluster

RWL = RWL(all(~isnan(RWL),2),:); 
RWL_N=zscore(RWL); 
out=RWL_N';
 opts = statset('Display','final');
 [cidx_c,cmeans_c] = kmeans(out,clust_no,'dist','correlation','Replicates',100,'Options',opts);
 % Plot figure
A= importdata('C:\Users\MD508867\University of Central Florida\Thomas Wahl - 6_NOAA_COM\Data\TG_Details\TG details_sorted_Lon.txt');
L=A.textdata(2:end,2); % store TG name for legend
LL=L(S);

figure
load coastlines
plot(coastlon,coastlat,'k','Linewidth',1)

%%%%%%%%%%%%%%%%%%%
xlim([-180 -50])
ylim([10 60])
%%%%%%%%%%%%%%%%%%%
hold on;

x_cord=A.data(S,3);
y_cord=A.data(S,2);
scatter(x_cord,y_cord,[],cidx_c,'filled')
%scatter(A.data(S(1):S(end),3),A.data(S(1):S(end),2),[],cidx_c,'filled')
colormap(jet(clust_no))
labels=cell(1,clust_no);
for i=1:clust_no
    labels{i}=strcat('C',num2str(i));
end;
lcolorbar(labels,'fontsize',10,'Location','vertical');

%% Plot RWL for each cluster
figure
if rem(clust_no,2)==0;
a=clust_no/2;
else
a=floor(clust_no/2)+1;
end;

for i=1:clust_no
 subplot(a,2,i)   
 plot(RWL_N(:,find(cidx_c==i)));
 t=title(labels{i});
 idx_L=LL(find(cidx_c==i)); % subset the TG name to use as legend for each different cluster
 legend(idx_L);
 t.FontSize=12; 
end;

% Now estimate correlation matrix for each clustering
r=cell(1,clust_no);
p=cell(1,clust_no);
for i=1:clust_no;
[r{i},p{i}]=corr(RWL_N(:,find(cidx_c==i)),'Type','Spearman');
end;

%%%%%%%%%%  Plot cross correlation among the TG within each cluster  %%%%%%%%%%%
figure
for i=1:clust_no
 subplot(a,2,i) 
 fig_corr(r{i},p{i},thres);
 t=title(labels{i});
 xlabelNames=LL(find(cidx_c==i));
 lim=numel(xlabelNames)+0.5;
 set(gca, 'xTick', 1.5:1:lim); % center x-axis ticks on bins
 set(gca, 'yTick', 1.5:1:lim); % center y-axis ticks on bins
 set(gca, 'YTickLabel', xlabelNames,'FontSize',8); % set y-axis labels
 set(gca, 'XTickLabel', xlabelNames); % set x-axis labels
 xtickangle(90)
 end;
 
%%%%%%  End function  %%%%%%%%%%%%%%

