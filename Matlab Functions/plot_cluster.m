%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
         %																			                            %
         % Md. Mamunur Rashid, Ph.D. ( Research Associate, CECE, UCF, FL, USA) @ 2018-2019        		        %
         %                                                                                                      %
         %  Matlab function to plot following for identified coherent regions 
		 %    1. Line plot of RWL time series of each tide within a cluster/ region obtained by Kmeans analysis%
         %    2. Cross correlation plot of RWL time series of tide gauges within the cluster/ region		 
		 %    3. Spatial distribution plot of tide gauges within a cluster/ region
         
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function plot_cluster(S,clust_no,cidx_c,RWL,thres)
% S= index of selected stations 1,2, 10,12,....etc.....
% clust_no = no of cluster
% cidx_c = cluster index
% RWL= RWL of the selected tide gauges.
% thres = threshold for significance of correlation (o.o5 for 95% significance) 

RWL = RWL(all(~isnan(RWL),2),:); % keep only values [remove rows (data at any time step) for which any TG (column) have nan - rows
RWL_N=zscore(RWL); % standardized to remove the effect of values (high or low) on clustering

A= importdata('C:\SLI_source_code\TG details.txt');
L=A.textdata(2:end,2); % store TG name for legend
LL=L(S);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Create Contiguous US Map
figure
ax = usamap('conus');
states = shaperead('usastatehi', 'UseGeoCoords', true,...  % usastatehi for low resolution
    'Selector',...
    {@(name) ~any(strcmp(name,{'Alaska','Hawaii'})), 'Name'});
geoshow(ax, states, 'DisplayType', 'polygon', ...
    'EdgeColor',[0.9 0.9 0.9],'FaceColor',[0.7 0.7 0.7])
framem off; gridm off; mlabel off; plabel off
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
hold on;
x_cord=A.data(S,3);
y_cord=A.data(S,2);

cmap=[0 0.5 1
    0 1 1
    0.5 1 0.5
    0   0  0
    1   0.5 0
    1  0 0
    0.5 0 0];

for i=1:length(y_cord)
l=cidx_c(i);
plotm(y_cord(i),x_cord(i),'o','markersize',6,'MarkerEdgeColor',cmap(l,:),'markerfacecolor',cmap(l,:),'linewidth',1)
end;
textm(52,-102,'Summer','vertical','top','FontSize',14,'fontweight','bold');
colormap(cmap)
labels={'NP','SP','WGOM','EGOM','SA','MA','NA'};
h=lcolorbar({'NP','SP','WGOM','EGOM','SA','MA','NA'},'fontsize',11,'Location','vertical');

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
 set(gca,'XTickLabel',[]);
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
 %set(gca, 'XTickLabel', []); % set x-axis labels
 set(gca, 'XTickLabel', xlabelNames,'FontSize',8); % set x-axis labels
 xtickangle(90)
 end;
 
subplot(a,2,i+1) 
rgb = [ ...

0.550   0.000   0.081
%0.700   0.055   0.130
0.850   0.085   0.187 
%0.970   0.155   0.210 
1.000   0.240   0.240 
%1.000   0.472   0.340  
1.000   0.676   0.460 
%1.000   0.740   0.600 
1.000   0.848   0.750 
%1.000   0.900   0.85  
0.850   1.000   1.000 
%0.740   0.978   1.000 
0.600   0.920   1.000 
%0.460   0.829   1.000 
0.340   0.692   1.000 
%0.240   0.531   1.000
0.160   0.342   1.000 
%0.097   0.112   0.970
0.142   0.000   0.850]; 
%0.222   0.000   0.790];

colormap(rgb);
caxis([0,1])
h=colorbar('Ticks',[0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1.0],...
         'TickLabels',{'0','0.1','0.2','0.3','0.4','0.5','0.6','0.7','0.8','0.9','1.0'},'location','southoutside');
axis off;
set(gca,'fontsize',12);

 
 
 