
All source codes/scripts are written in Matlab language. We have provided hourly water level data for a sample tide gauge stored in the "Hourly water level data" folder. Analysis results of the sample tide gauge are stored in a subfolder 
under "Result_RWL" folder. In order to perform analysis for any new tide gauge, corresponding hourly water level data should be included in the "Hourly water level data" folder before running the code. We also provided a folder 
"Matlab Function", where we have stored all user defined functions required to run the source codes. Please follow the instructions below to execute the functions/scripts.

1. Copy and paste the "SLI_source_code" folder in the C drive.
2. Add the path "C:\SLI_source_code" to Matlab by clicking "Add with Subfolders..." in the "Set Path" window of Matlab.
3. Run individual code for analysis.


Below are the names and short descriptions of the individual Matlab scripts used for data processing and ananlysis.


       File name                                                     Short Description 

1. Prepare_seasonal_Max_WL_sereis :                Develop seasonal (sunmmer [May to Oct] and winter [Nov to Apr] half of the year) maximum sea level time series.
2. RWL_GEV_runnning_Approach_with_Padding :        Estimate nonstationary return water level (RWL) time sereis using nonstationary GEV model with time varying location parameter only (Model A) 
3. RWL_GEV_LS_runnning_Approach_with_Padding :     Estimate nonstationary retrun water level (RWL) time sereis using nonstationary GEV model with time varying location and scale parameters (Model B) 
4. Regionalization_Kmean Analysis_RWL :            Identify regions of coherent variability of RWL using K-means clsutering. 
5. Estimate_4.4 and 18.6 year tide_using T tide :  Estimate 4.4 and 18.6 year tide time sereis from T-tide analysis (conducted year-by-year with the standard set of 67 constituents)

Below are the names and short descriptions of the Matlab functions in the "Matlab Function" folder.

     File name                                                     Short Description

1. seasonal_max_Wl :               This function is used to estimate seasonal maximum seal level from hourly water level data from tide gauges. 
2. tide_frequency :                This function is used to estimate 4.4 and 18.6 year tide time sereis from hourly water level data.
3. RWL_running_padding :           This function is used to estimate nonstationary Return Water Levels (RWL) using nonstationary GEV model with time varying location parameter (Model A). 
4. RWL_GEV_LS_running_padding :    This function is used to estimate nonstationary Return Water Levels (RWL) using nonstationary GEV model with time varying location and scale parameters (Model B). 
5. k_mean_test :                   This function is used for K-means analysis.
6. plot_cluster :                  This function generates different plots for the RWL of all tide gauges within a cluster/region identified by K-means cluster analysis. Plots include line plots of RWL time sereis, cross correaltion plot, spatial distribution plot of tide gauges within the cluster/ region
7. nodal_tide_corsp_max_WL:        This function is used to identify and estimate 4.4. and 18.6 year tides correspoding to seasonal maximum water level. 
8. Tide_analysis:                  Thi function is used for T-tide analysis.

Notes on estimation of RWL for any return period of interest:

RWL can be estimated for any return period (we used 100-year RWL in our research). To do so, one need to use the function RWL_running_padding. This function has option to input return period as an integer. Please
see the description of this function bellow.

                function [RWL,mu_ns,RWL_s]=RWL_running_padding(EWL,WL,RP,sim)

                % Output
                        % RWL_LS = Non-stationary Return Water Level
                        % RWL_s_LS= Stationary Return Water Level
                        % mu_ns_LS = Non-stationary location parameter
                        % scale_ns_Ls = Non-stationary scale parameter
                % Input
                        % EWL = seasonal maximum water level (e.g Summer) usually matrix of two column (year | EWL). This could be a matrix with one column as well (EWL only)
                        % WL = window length (37 year for our case twice of 18.6 nodal cycle)
                        % RP = Vector of return period (in year)
                        % sim = no of simulations for monte carlo simulation 
  
To estimate the RWL of any return period of interest value of RP should be changed in the RWL_running_padding function. For example, if one want to estimate RWL for 5 year return period should use '5' for 'RP' and so on. 
